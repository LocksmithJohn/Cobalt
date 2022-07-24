//
//  MoreVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/03/2022.
//

import Foundation

final class MoreVM: BaseVM {

    enum Action {
        case showSearch
        case showAreas
        case showExport

    }

    let actionSubject = MYPassthroughSubject<Action>()

    private let appstate: MoreAppState
    private let interactor: NotesListInteractor

    init(interactor: NotesListInteractor,
         appstate: MoreAppState) {
        self.interactor = interactor
        self.appstate = appstate
        super.init(screenType: .more)

        bindAction()
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
        case .showSearch:
            interactor.route(from: screenType, to: .search)
        case .showAreas:
            interactor.route(from: screenType, to: .areas)
        case .showExport:
            interactor.route(from: screenType, to: .export)
        }
    }
}
