//
//  NoteDetailsVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Combine
import Foundation

final class NoteDetailsVM: BaseVM {

    enum Action {
        case onAppear
        case back
        case saveNote
        case deleteNote
        case showTransform
    }

    @Published var note: String = ""

    var transformItemVM: TransformItemVM?
    let actionSubject = PassthroughSubject<Action, Never>()
    let id: UUID?

    private let appstate: NoteDetailsAppState
    private let interactor: NoteDetailsInteractor
    private var newNote = NoteDTO(newID: UUID())

    init(id: UUID?,
         interactor: NoteDetailsInteractor,
         appstate: NoteDetailsAppState) {
        self.interactor = interactor
        self.appstate = appstate
        self.id = id
        super.init(screenType: .noteDetails(id: id))

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.noteDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] note in
                self?.note = note.name
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
            if let id = id {
                interactor.fetchNote(id: id)
            }
        case .saveNote:
            newNote.name = note
            interactor.saveNote(newNote)
            actionSubject.send(.back)
        case .back:
            interactor.route(from: screenType, to: .notes)
            interactor.fetchNotes()
        case .deleteNote:
            guard let id = id else { return }

            interactor.deleteNote(id: id)
            interactor.route(from: screenType, to: .tasks)
        case .showTransform:
            guard let id = id else { return }
            print("filter 2 \(id) ")
            GlobalRouter.shared.popOverType.send(.itemTransform(id: id))
            Haptic.impact(.light)
        }
    }


}
