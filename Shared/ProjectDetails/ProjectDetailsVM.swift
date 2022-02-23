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
    // tutaj musi byc mozliwosc zapisu nowego projektu oraz updatu istniejącego
    // itemy powiązane nie są zapisywane tutaj, ale na swoich ekranach z przekazanym ID z tego projektu

    enum Action {
        case onAppear
        case back
        case saveProject
        case deleteProject
        case showAddingTask
    }

    @Published var projectName: String = ""
    @Published var projectDescription: String = ""
    @Published var subtasks: [TaskDTOReduced] = []

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
                self?.projectDescription = project.itemDescription ?? ""
            }
            .store(in: &cancellableBag)

        appstate.relatedTasksSubject
            .compactMap { $0 }
            .sink { [weak self] tasks in
                self?.subtasks = tasks
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
            interactor.route(from: screenType, to: .taskDetails(id: nil, projectID: id))
        }
    }

    private var newProject: ProjectDTO {
        ProjectDTO(id: id,
                   name: projectName,
                   itemDesrciption: projectDescription,
                   type: .project,
                   status: .new,
                   relatedItems: "")
    }

}

