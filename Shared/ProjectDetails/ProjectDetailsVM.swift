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
        case cancel
        case saveProject
        case deleteProject
        case toggleDoneProject
        case showDeleteAlert
        case showAddingTask
        case showAddingItem
        case showTransform
        case taskSelected(id: UUID)
        case toggleDoneTask(task: TaskDTOReduced)
        case changeStatus(status: ItemStatus)
        case changeTag(tag: String)
    }

    @Published var projectName: String = ""
    @Published var projectAC: String = ""
    @Published var projectNotes: String = ""
    @Published var projectStatus: ItemStatus = .new
    @Published var projectTag: String = ""

    @Published var nextActions: [TaskDTOReduced] = []
    @Published var waitFors: [TaskDTOReduced] = []
    @Published var subtasks: [TaskDTOReduced] = []
    @Published var doneTasks: [TaskDTOReduced] = []
    @Published var isDone: Bool = false
    @Published var isDeleteAlertVisible = false

    let isEditing: Bool
    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: ProjectDetailsAppState
    private let interactor: ProjectDetailsInteractor
    private let id: UUID
    private var tags = ItemTags()

    init(id: UUID?,
         interactor: ProjectDetailsInteractor,
         appstate: ProjectDetailsAppState) {
        self.isEditing = id != nil
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
        case .onAppear: onAppearAction()
        case .saveProject: saveProjectAction()
        case .back: backAction()
        case .cancel: cancelAction()
        case .deleteProject: deleteProjectAction()
        case .showAddingTask: showAddingTaskAction()
        case .toggleDoneProject: toggleDoneProjectAction()
        case let .taskSelected(taskId): taskSelectedAction(taskId: taskId)
        case let .toggleDoneTask(task): toggleDoneTaskAction(task: task)
        case .showAddingItem: showAddingItemAction()
        case let .changeStatus(status): changeStatusAction(status: status)
        case .showDeleteAlert: isDeleteAlertVisible = true
        case let .changeTag(tag): changeTagAction(tag: tag)
        case .showTransform: GlobalRouter.shared.popOverType.send(.itemTransform(id: id))
        }
    }

    //MARK: - Actions

    private func changeStatusAction(status: ItemStatus) {
        interactor.updateStatus(id: id, status: status)
        interactor.fetchProject(id: id)
    }

    private func showAddingItemAction() {
        Haptic.impact(.medium)
        GlobalRouter.shared.popOverType.send(.addItemToProject(id: id) )
    }

    private func toggleDoneTaskAction(task: TaskDTOReduced) {
        interactor.toggleDone(id: task.id, status: task.status)
        interactor.fetchRelatedItems(id: id)
    }

    private func taskSelectedAction(taskId: UUID) {
        interactor.route(from: screenType, to: .taskDetails(id: taskId, projectID: id))
    }

    private func toggleDoneProjectAction() {
        Haptic.impact(.medium)
        interactor.toggleDone(id: temporaryProject.id, status: temporaryProject.status)
        interactor.fetchProject(id: id)
    }

    private func showAddingTaskAction() {
        Haptic.impact(.medium)
        interactor.route(from: screenType, to: .taskDetails(id: nil, projectID: id))
    }

    private func deleteProjectAction() {
        interactor.deleteProject(id: id)
        interactor.route(from: screenType, to: .projects)
    }

    private func backAction() {
        interactor.route(from: screenType, to: .projects)
        interactor.fetchProjects()
    }

    private func saveProjectAction() {
        guard !projectName.isEmpty else {
            backAction()
            return
        }

        interactor.editProject(id: id, temporaryProject)
        backAction()
    }

    private func onAppearAction() {
        if !isEditing {
            interactor.saveProject(temporaryProject)
        }

        if isEditing {
            interactor.fetchProject(id: id)
        }

        interactor.fetchRelatedItems(id: id)
    }

    private func cancelAction() {
        interactor.deleteProject(id: id)
        interactor.route(from: screenType, to: .projects)
        interactor.fetchProjects()
    }

    private func changeTagAction(tag: String) {
//        interactor.updateStatus(id: <#T##UUID#>, status: <#T##ItemStatus#>)
    }

    private var temporaryProject: ProjectDTO {
        ProjectDTO(id: id,
                   name: projectName,
                   itemDesrciption: projectAC,
                   projectNotes: projectNotes,
                   type: .project,
                   status: projectStatus,
                   relatedItems: Relations(), // tutaj zrobic tak jak w tasku
                   tags: tags)
    }

}

