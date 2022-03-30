//
//  AddItemToProjectVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 27/03/2022.
//

import Foundation

final class AddItemToProjectVM: PopoverVM {

    enum Action {
        case onAppear
        case onDisappear
        case backgroundTapped
        case addACTapped
        case addDescriptionTapped
        case addNoteTapped
        case okButtonTapped
    }

    enum InputType {
        case ac
        case description
        case note
    }

    @Published var isTextInputVisible = false
    @Published var text = ""
    let actionSubject = MYPassthroughSubject<Action>()

    private var inputType: InputType = .note
    private let interactor: ProjectDetailsInteractor
    private let appstate: ProjectDetailsAppState
    private let projectID: UUID
    private var project: ProjectDTO?

    init(id: UUID,
         interactor: ProjectDetailsInteractor,
         appstate: ProjectDetailsAppState) {
        self.interactor = interactor
        self.appstate = appstate
        self.projectID = id

        super.init(screenType: .addItem)
        bindAction()
        bindAppState()
    }

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)
    }

    private func bindAppState() {
        appstate.projectDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] project in
                self?.project = project
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
        case .onAppear:
            interactor.fetchProject(id: projectID)
        case .onDisappear:
            interactor.fetchProject(id: projectID)
        case .backgroundTapped:
            GlobalRouter.shared.popOverType.send(nil)
        case .addACTapped:
            isTextInputVisible = true
            inputType = .ac
        case .addDescriptionTapped:
            isTextInputVisible = true
            inputType = .description
        case .addNoteTapped:
            isTextInputVisible = true
            inputType = .note
        case .okButtonTapped:
            project?.itemDescription = text
            if let project = project {
                interactor.editProject(id: projectID, project)
            }
            GlobalRouter.shared.popOverType.send(nil)
        }
    }
    
}
