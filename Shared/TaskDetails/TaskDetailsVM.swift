//
//  TaskDetailsVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Combine
import Foundation

final class TaskDetailsVM: BaseVM {

    enum Action {
        case onAppear
        case back
        case cancel
        case saveTask
        case deleteTask
        case fetchParentProject(id: UUID)
        case showDeleteAlert
        case toggleDone // tutaj nieużywane
        case toggleWaitingFor
        case toggleNextAction
        case updateParentProject(id: UUID)
        case deleteParentProject
        case changeStatus(status: ItemStatus)
        case changeTag(tag: String)
        case showTransform
    }

    @Published var taskName: String = ""
    @Published var taskDescription: String = ""
    @Published var taskStatus: ItemStatus = .new
    @Published var taskTag: String = ""
    @Published var isDone: Bool = false
    @Published var taskType: ItemType = .task
    @Published var projects: [ProjectDTOReduced] = []
    @Published var relatedProject: ProjectDTOReduced?
    @Published var isDeleteAlertVisible = false

    let actionSubject = MYPassthroughSubject<Action>()
    let isEditing: Bool

    private let appstate: TaskDetailsAppState
    private let interactor: TaskDetailsInteractor
    private let id: UUID
    private var parentProjectID: UUID? {
        didSet {
            print("filter parentProjectID: \(parentProjectID)")
        }
    }
    private var relations = Relations() {
        didSet {
            print("filter relations: \(relations)")
        }
    }
    private var tags = ItemTags()

    init(id: UUID?,
         parentProjectID: UUID?,
         interactor: TaskDetailsInteractor,
         appstate: TaskDetailsAppState) {
        self.isEditing = id != nil
        self.interactor = interactor
        self.appstate = appstate
        self.id = id ?? UUID()
        self.parentProjectID = parentProjectID
        super.init(screenType: .taskDetails(id: id, projectID: parentProjectID))

        updateRelatedProject()
        bindAppState()
        bindAction()
    }

    //MARK: - Bind methods

    private func bindAppState() {
        appstate.taskDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] task in
                self?.taskName = task.name
                self?.taskDescription = task.taskDescription ?? ""
                self?.taskStatus = task.status
                self?.isDone = task.status == .done
                self?.taskType = task.type
                self?.tags = task.tags
                self?.relations = task.relations
                self?.parentProjectID = task.relations.getParentProjectId()
                
//                self?.updateRelatedProject()
            }
            .store(in: &cancellableBag)

        appstate.projectsReducedSubject
            .compactMap { $0 }
            .sink { [weak self] projects in
                self?.projects = projects
            }
            .store(in: &cancellableBag)

        appstate.projectReducedSubject
            .sink { [weak self] relatedProject in
                self?.relatedProject = relatedProject
            }
            .store(in: &cancellableBag)
    }

    private func updateRelatedProject() {
        if let projectID = parentProjectID {
            interactor.fetchProjectReduced(id: projectID)
            updateParentProjectAction(projectID)
        } else {
            relatedProject = nil
        }
    }

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
        case .onAppear: onAppearAction()
        case .saveTask: saveTaskAction()
        case .back: backAction()
        case .deleteTask: deleteTaskAction()
        case let .updateParentProject(id): updateParentProjectAction(id)
        case .deleteParentProject: deleteParentProjectAction()
        case .toggleDone: toggleDoneAction()
        case .toggleWaitingFor: toggleWaitingForAction()
        case .toggleNextAction: toggleNextAction()
        case .cancel: cancelAction()
        case .showDeleteAlert: isDeleteAlertVisible = true
        case let .fetchParentProject(id): fetchParentProject(id)
        case let .changeStatus(status): changeStatus(status: status)
        case let .changeTag(tag): changeTag(tag: tag)
        case .showTransform: GlobalRouter.shared.popOverType.send(.itemTransform(id: id))
        }
    }

    //MARK: - Actions

    private func onAppearAction() {
        interactor.fetchProjectsReduced()

        if !isEditing {
            interactor.saveTask(temporaryTask)
        }

        if let projectID = parentProjectID {
            interactor.fetchProjectReduced(id: projectID)
        }

        if isEditing {
            interactor.fetchTask(id: id)
        }
    }

    private func saveTaskAction() {
        guard !taskName.isEmpty else {
            backAction()
            return
        }

        if let projectID = parentProjectID {
            relations.addRelation(is: .sbt, for: projectID)
            interactor.editItem(id: id, item: Item(temporaryTask))
            interactor.fetchRelatedItems(id: projectID)
        } else {
            interactor.fetchTasks()
            interactor.editItem(id: id, item: Item(temporaryTask))
        }

        if let projectID = parentProjectID {
            interactor.route(from: screenType, to: .projectDetails(id: projectID))
        } else {
            interactor.route(from: screenType, to: .tasks)
        }
    }

    private func backAction() {
        if let projectID = parentProjectID {
            interactor.route(from: screenType, to: .projectDetails(id: projectID))
        } else {
            interactor.route(from: screenType, to: .tasks)
        }
        if taskName.isEmpty {
            interactor.deleteTask(id: id)
        }
        interactor.fetchTasks()
    }

    private func deleteTaskAction() {
        interactor.deleteTask(id: id)

        if let projectID = parentProjectID {
            interactor.fetchRelatedItems(id: projectID)
        }

        interactor.route(from: screenType, to: .tasks)
    }

    private func updateParentProjectAction(_ projectID: UUID?) {
        if let projectID = projectID {
            relations.addRelation(is: .sbt, for: projectID)
        }
        interactor.editItem(id: id, item: Item(temporaryTask))
        interactor.fetchTask(id: id)
    }

    private func deleteParentProjectAction() {
        if let previousProjectID = parentProjectID {
            relations.removeRelation(is: .sbt, for: previousProjectID)
        }
        interactor.editItem(id: id, item: Item(temporaryTask))
        interactor.fetchTask(id: id)
    }

    private func toggleDoneAction() {
        Haptic.impact(.medium)
        taskStatus = taskStatus == .new ? .done : .new

        interactor.editItem(id: id, item: Item(temporaryTask))
        interactor.fetchTask(id: id)
    }

    private func toggleWaitingForAction() {
        if taskStatus != .waitFor {
            taskStatus = .waitFor
        } else {
            taskStatus = .new
        }
        interactor.editItem(id: id, item: Item(temporaryTask))
        interactor.fetchTask(id: id)
    }

    private func toggleNextAction() {
        if taskStatus != .nextAction {
            taskStatus = .nextAction
        } else {
            taskStatus = .new
        }

        interactor.editItem(id: id, item: Item(temporaryTask))
        interactor.fetchTask(id: id)
    }

    private func cancelAction() {
        interactor.deleteTask(id: id)
        interactor.route(from: screenType, to: .tasks)
        interactor.fetchTasks()
    }

    private func fetchParentProject(_ id: UUID) {
        interactor.fetchProjectReduced(id: id)
    }

    private func changeStatus(status: ItemStatus) {
        interactor.updateStatus(id: id, status: status)
        interactor.fetchTask(id: id)
    }

    private func changeTag(tag: String) {
        interactor.updateTag(tag: tag)
        interactor.fetchTask(id: id)
    }

    //MARK: - Other

    private var temporaryTask: TaskDTO {
        let newTask = TaskDTO(id: id,
                              name: taskName,
                              taskDescription: taskDescription,
                              type: taskType,
                              status: taskStatus,
                              relatedItems: relations,
                              tags: tags)
        return newTask
    }

}
