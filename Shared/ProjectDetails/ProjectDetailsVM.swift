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
    //    private var newProject = ProjectDTO(newID: UUID())

    init(id: UUID?,
         interactor: ProjectDetailsInteractor,
         appstate: ProjectDetailsAppState) {
        self.interactor = interactor
        self.appstate = appstate
        self.id = id ?? UUID() // DOC: If this is creating project flow (not editing), create new project id here
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

        appstate.relatedItemsSubject
            .compactMap { $0 }
            .sink { [weak self] relatedItems in
                self?.subtasks = relatedItems
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

            //            let projectRelations = ItemRelation.ppr.rawValue + taskID.uuidString + ","

            interactor.saveProject(newProject)
            interactor.route(from: screenType, to: .projects)
            interactor.fetchProjects()
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
                   relatedItems: <#T##String?#>)
    }

}

