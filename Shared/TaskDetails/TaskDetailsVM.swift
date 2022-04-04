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
        case selectedProject(id: UUID?)
        case fetchParentProject(id: UUID)
        case showDeleteAlert
        case toggleDone
        case toggleWaitingFor
        case toggleNextAction
        case changeStatus(status: ItemStatus)
    }

    @Published var taskName: String = ""
    @Published var taskDescription: String = ""
    @Published var taskStatus: ItemStatus = .new
    @Published var isDone: Bool = false
    @Published var taskType: ItemType = .nextAction
    @Published var projects: [ProjectDTOReduced] = []
    @Published var relatedProject: ProjectDTOReduced?
    @Published var isDeleteAlertVisible = false

    let actionSubject = MYPassthroughSubject<Action>()
    let isCreating: Bool

    private let appstate: TaskDetailsAppState
    private let interactor: TaskDetailsInteractor
    private let id: UUID
    private var projectID: UUID?
    private var relatedItems = Relations()

    init(id: UUID?,
         projectID: UUID?,
         interactor: TaskDetailsInteractor,
         appstate: TaskDetailsAppState) {
        self.isCreating = id == nil
        self.interactor = interactor
        self.appstate = appstate
        self.id = id ?? UUID()
        self.projectID = projectID
        super.init(screenType: .taskDetails(id: id, projectID: projectID))

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
                if let projectID = task.relatedItems.getParentProjectId() {
                    self?.projectID = projectID
                    self?.actionSubject.send(.fetchParentProject(id: projectID))
                }
            }
            .store(in: &cancellableBag)

        appstate.projectsReducedSubject
            .compactMap { $0 }
            .sink { [weak self] projects in
                self?.projects = projects
            }
            .store(in: &cancellableBag)

        appstate.projectReducedSubject
//            .compactMap { $0 }
            .sink { [weak self] relatedProject in
                self?.relatedProject = relatedProject
            }
            .store(in: &cancellableBag)
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
        case let .selectedProject(id): selectedProjectAction(id)
        case .toggleDone: toggleDoneAction()
        case .toggleWaitingFor: toggleWaitingForAction()
        case .toggleNextAction: toggleNextAction()
        case .cancel: cancelAction()
        case .showDeleteAlert: isDeleteAlertVisible = true
        case let .fetchParentProject(id): fetchParentProject(id)
        case let .changeStatus(status): changeStatus(status: status)
        }
    }

    //MARK: - Actions

    private func onAppearAction() {
        interactor.fetchTask(id: id)
        interactor.fetchProjectsReduced()
        if isCreating {
            interactor.saveTask(temporaryTask)
        }
        if let projectID = projectID {
            interactor.fetchProjectReduced(id: projectID)
        }
    }

    private func saveTaskAction() {
        guard !taskName.isEmpty else {
            backAction()
            return
        }

        interactor.editItem(id: id, item: Item(temporaryTask))
        if let projectID = projectID {
            interactor.fetchRelatedItems(id: projectID)
        }
        interactor.fetchTasks()
        interactor.route(from: screenType, to: .tasks)
    }

    private func backAction() {
        if let projectID = projectID {
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
        interactor.route(from: screenType, to: .tasks)
    }

    private func selectedProjectAction(_ id: UUID?) {
        projectID = id
        interactor.fetchProjectReduced(id: projectID ?? UUID())
    }

    private func toggleDoneAction() {
        Haptic.impact(.medium)
        interactor.editItem(id: id, item: Item(temporaryTask))
        interactor.toggleDone(id: temporaryTask.id, status: temporaryTask.status)
        interactor.fetchTask(id: id)
    }

    private func toggleWaitingForAction() {
        interactor.editItem(id: id, item: Item(temporaryTask))
        if taskType != .waitFor {
            interactor.updateType(id: id, type: .waitFor)
        } else {
            interactor.updateType(id: id, type: .task)
        }
        interactor.fetchTask(id: id)
    }

    private func toggleNextAction() {
        interactor.editItem(id: id, item: Item(temporaryTask))
        if taskType != .nextAction {
            interactor.updateType(id: id, type: .nextAction)
        } else {
            interactor.updateType(id: id, type: .task)
        }
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

    //MARK: - Other

    private var temporaryTask: TaskDTO {
        if let projectID = projectID {
            relatedItems.addRelation(is: .sbt, of: projectID)
        }
        let newTask = TaskDTO(id: id,
                              name: taskName,
                              taskDescription: taskDescription,
                              type: taskType,
                              status: taskStatus,
                              relatedItems: relatedItems)
        return newTask
    }

}
