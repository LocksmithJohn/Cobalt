//
//  ProjectDetailsVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Combine
import Foundation
import UIKit

final class ProjectDetailsVM: BaseVM {

    enum Action {
        case onAppear
        case back
        case saveProject
        case deleteProject
        case toggleDoneProject
        case showAddingTask
        case showAddingItem
        case taskSelected(id: UUID)
        case toggleDoneTask(task: TaskDTOReduced)
        case changeStatus(status: ItemStatus)
    }

    @Published var projectName: String = ""
    @Published var projectAC: String = ""
    @Published var projectNotes: String = ""
    @Published var projectStatus: ItemStatus = .new

    @Published var nextActions: [TaskDTOReduced] = []
    @Published var waitFors: [TaskDTOReduced] = []
    @Published var subtasks: [TaskDTOReduced] = []
    @Published var doneTasks: [TaskDTOReduced] = []
    @Published var isDone: Bool = false

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: ProjectDetailsAppState
    private let interactor: ProjectDetailsInteractor
    private let id: UUID
    private let isCreating: Bool

    init(id: UUID?,
         interactor: ProjectDetailsInteractor,
         appstate: ProjectDetailsAppState) {
        self.isCreating = id == nil
        self.interactor = interactor
        self.appstate = appstate
        self.id = id ?? UUID()
        super.init(screenType: .projectDetails(id: id))

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.projectDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] project in
                self?.projectName = project.name
                self?.projectAC = project.projectAC ?? ""
                self?.projectNotes = project.projectNotes ?? ""
                self?.isDone = project.status == .done
                self?.projectStatus = project.status
            }
            .store(in: &cancellableBag)

        appstate.relatedItemsSubject
            .compactMap { $0 }
            .sink { [weak self] tasks in
                tasks.forEach { task in
                    print("task: \(task.name) - \(task.type.rawValue) - \(task.status.rawValue)")
                }
                self?.nextActions = tasks.filter { $0.type == .nextAction && $0.status != .done }
                self?.waitFors = tasks.filter { $0.type == .waitFor && $0.status != .done }
                self?.subtasks = tasks.filter { $0.type == .task && $0.status != .done }
                self?.doneTasks = tasks.filter { $0.status == .done }
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
            interactor.fetchProject(id: id)
            interactor.fetchRelatedItems(id: id)
        case .saveProject:
            if isCreating {
                interactor.saveProject(newProject)
            } else {
                interactor.editProject(id: id, newProject)
            }
            actionSubject.send(.back)
        case .back:
            interactor.route(from: screenType, to: .projects)
            interactor.fetchProjects()
        case .deleteProject:
            interactor.deleteProject(id: id)
            interactor.route(from: screenType, to: .projects)
        case .showAddingTask:
            Haptic.impact(.medium)
            interactor.route(from: screenType, to: .taskDetails(id: nil, projectID: id))
        case .toggleDoneProject:
            Haptic.impact(.medium)
            interactor.toggleDone(id: newProject.id, status: newProject.status)
            interactor.fetchProject(id: id)
        case let .taskSelected(taskId):
            interactor.route(from: screenType, to: .taskDetails(id: taskId, projectID: id))
        case let .toggleDoneTask(task):
            interactor.toggleDone(id: task.id, status: task.status)
            interactor.fetchRelatedItems(id: id)
        case .showAddingItem:
            Haptic.impact(.medium)
            GlobalRouter.shared.popOverType.send(.addItemToProject(id: id) )
        case let .changeStatus(status): changeStatus(status: status)
        }
    }

    //MARK: - Actions

    private func changeStatus(status: ItemStatus) {
        interactor.updateStatus(id: id, status: status)
        interactor.fetchProject(id: id)
    }

    private var newProject: ProjectDTO {
        ProjectDTO(id: id,
                   name: projectName,
                   itemDesrciption: projectAC,
                   projectNotes: projectNotes,
                   type: .project,
                   status: projectStatus,
                   relatedItems: Relations()) // tutaj nie czyszcza sie relacje?
    }

}

