//
//  NotesListVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Combine
import Foundation

final class NotesListVM: BaseVM {

    enum Action {
        case onAppear
        case addNote
        case goToNote(id: UUID)
        case deleteAll
    }

    @Published var notes: [NoteDTOReduced] = []

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: NotesListAppState
    private let interactor: NotesListInteractor

    init(interactor: NotesListInteractor,
         appstate: NotesListAppState) {
        self.interactor = interactor
        self.appstate = appstate
        super.init(screenType: .notes)

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.notesListSubject
            .sink { [weak self] notes in
                self?.notes = notes
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
            interactor.fetchNotes()
        case .addNote:
            interactor.route(from: screenType, to: .noteDetails(id: nil))
        case let .goToNote(id):
            interactor.route(from: screenType, to: .noteDetails(id: id))
        case .deleteAll:
            interactor.deleteAll()
        }
    }
}
