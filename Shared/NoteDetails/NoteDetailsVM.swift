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
        case cancel
        case saveNote
        case deleteNote
        case showDeleteAlert
        case showTransform
    }

    @Published var note: String = ""
    @Published var isDeleteAlertVisible = false

    var transformItemVM: TransformItemVM?
    let actionSubject = PassthroughSubject<Action, Never>()
    let id: UUID
    let isCreating: Bool

    private let appstate: NoteDetailsAppState
    private let interactor: NoteDetailsInteractor
    private var newNote = NoteDTO(newID: UUID())

    init(id: UUID?,
         interactor: NoteDetailsInteractor,
         appstate: NoteDetailsAppState) {
        self.isCreating = id == nil
        self.interactor = interactor
        self.appstate = appstate
        self.id = id ?? UUID()
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
            interactor.fetchNote(id: id)
        case .saveNote:
            newNote.name = note
            if isCreating {
                if !newNote.name.isEmpty {
                    interactor.saveNote(newNote)
                }
            } else {
                interactor.editItem(id: id, item: Item(newNote))
            }
            actionSubject.send(.back)
        case .back:
            interactor.route(from: screenType, to: .notes)
            interactor.fetchNotes()
        case .deleteNote:
            interactor.deleteNote(id: id)
            interactor.route(from: screenType, to: .tasks)
        case .showTransform:
            GlobalRouter.shared.popOverType.send(.itemTransform(id: id))
            Haptic.impact(.light)
        case .cancel:
            cancelAction()
        case .showDeleteAlert:
            isDeleteAlertVisible = true
        }
    }

    private func cancelAction() {
        interactor.deleteNote(id: id)
        interactor.route(from: screenType, to: .notes)
        interactor.fetchNotes()
    }

}
