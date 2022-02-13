//
//  ProjectDetailsVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Combine
import Foundation

final class ProjectDetailsVM: BaseVM {

    enum Action {
        case onAppear
        case back
        case saveProject
        case deleteProject
    }

    @Published var projectName: String = ""
    @Published var projectDescription: String = ""

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: ProjectDetailsAppState
    private let interactor: ProjectDetailsInteractor
    private let id: UUID?
    private var newProject: ProjectDTO {
        ProjectDTO(id: UUID(),
                name: projectName,
                itemDesrciption: projectDescription,
                type: .project,
                status: .new)
    }

    init(id: UUID?,
         interactor: ProjectDetailsInteractor,
         appstate: ProjectDetailsAppState) {
        self.interactor = interactor
        self.appstate = appstate
        self.id = id
        super.init(screenType: .projectDetails(id: id))

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.projectDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] project in
                self?.projectName = project.name
                self?.projectDescription = project.itemDesrciption
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
            guard let id = id else { return }

            interactor.fetchProject(id: id)
        case .saveProject:
            interactor.saveProject(newProject)
            interactor.route(from: screenType, to: .projects)
            interactor.fetchProjects()
        case .back:
            interactor.route(from: screenType, to: .projects)
            interactor.fetchProjects()
        case .deleteProject:
            guard let id = id else { return }

            interactor.deleteProject(id: id)
            interactor.route(from: screenType, to: .projects)
        }
    }

}

