//
//  ProjectsListVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//
import Combine
import Foundation

final class ProjectsListVM: BaseVM {

    enum Action {
        case onAppear
        case addProject
        case goToProject(id: UUID)
    }

    @Published var projects: [ProjectDTOReduced] = []

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: ProjectsListAppState
    private let interactor: ProjectsListInteractor

    init(interactor: ProjectsListInteractor,
         appstate: ProjectsListAppState) {
        self.interactor = interactor
        self.appstate = appstate
        super.init(screenType: .projects)

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.projectsListSubject
            .sink { [weak self] projects in
                self?.projects = projects
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
            interactor.fetchProjects()
        case .addProject:
            interactor.route(from: screenType, to: .projectDetails(id: nil))
        case let .goToProject(id):
            interactor.route(from: screenType, to: .projectDetails(id: id))
        }
    }
}
