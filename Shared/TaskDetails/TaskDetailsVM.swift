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
        case saveTask
        case deleteTask
        case selectedProject(id: UUID)
        case toggleDone
        case toggleWaitingFor
        case toggleNextAction
    }

    @Published var taskName: String = ""
    @Published var taskDescription: String = ""
    @Published var isDone: Bool = false
    @Published var taskType: ItemType = .task {
        didSet {
            print("filter: \(taskType.rawValue)")
        }
    }

    @Published var projects: [ProjectDTOReduced] = []
    @Published var relatedProject: ProjectDTOReduced?

    let actionSubject = PassthroughSubject<Action, Never>()

    private var taskStatus: ItemStatus = .new
    private let appstate: TaskDetailsAppState
    private let interactor: TaskDetailsInteractor
    private let id: UUID
    private var projectID: UUID?
    private let isCreating: Bool

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

    private func bindAppState() {
        appstate.taskDetailsSubject // TODO: - czemu ten subject leci 2 razy
            .compactMap { $0 }
            .sink { [weak self] task in
                self?.taskName = task.name
                self?.taskDescription = task.itemDescription ?? ""
                self?.taskStatus = task.status
                self?.isDone = task.status == .done
                self?.taskType = task.type
                if let projectID = task.relatedItems?.getUUIDs().first?.id { // TODO: - ta operacje nie moze byc tutaj
                    self?.projectID = projectID
                    self?.interactor.fetchProjectReduced(id: projectID) // TODO: - interactor musi byc w akcjach
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
            .compactMap { $0 }
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
        case .onAppear:
            interactor.fetchTask(id: id)
            interactor.fetchProjectsReduced()
        case .saveTask:
            if isCreating {
                interactor.saveTask(newTask)
            } else {
                interactor.editItem(id: id, item: Item(newTask))
            }
            if let projectID = projectID {
                interactor.fetchRelatedItems(id: projectID)
            }
            interactor.fetchTasks()
            interactor.route(from: screenType, to: .tasks)
        case .back:
            if let projectID = projectID {
                interactor.route(from: screenType, to: .projectDetails(id: projectID))
            } else {
                interactor.route(from: screenType, to: .tasks)
            }
            interactor.fetchTasks()
        case .deleteTask:
            interactor.deleteTask(id: id)
            interactor.route(from: screenType, to: .tasks)
        case let .selectedProject(id):
            projectID = id
        case .toggleDone:
            Haptic.impact(.medium)
            interactor.toggleDone(item: newTask)
            interactor.fetchTask(id: id)
        case .toggleWaitingFor:
            if taskType != .waitFor {
                interactor.updateType(item: newTask, type: .waitFor)
            } else {
                interactor.updateType(item: newTask, type: .task)
            }
            interactor.fetchTask(id: id)
        case .toggleNextAction:
            if taskType != .nextAction {
                interactor.updateType(item: newTask, type: .nextAction)
            } else {
                interactor.updateType(item: newTask, type: .task)
            }
            interactor.fetchTask(id: id)
        }
    }

    private var newTask: TaskDTO {
        var newTask = TaskDTO(id: id,
                              name: taskName,
                              itemDesrciption: taskDescription,
                              type: .task,
                              status: taskStatus,
                              relatedItems: "")

        if let projectIDString = projectID?.uuidString {
            newTask.relatedItems = ItemRelation.sbt.rawValue + projectIDString + "," // tutaj przeniesc tworzenie relacji gdzie indziej
        }
        return newTask
    }

}
