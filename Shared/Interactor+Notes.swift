//
//  Interactor+Notes.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Foundation

extension Interactor: NotesListInteractor,
                      NoteDetailsInteractor {

    func fetchNotes() {
        coreDataManager.actionSubject.send(.fetchNotes)
    }
    func fetchNote(id: UUID) {
        coreDataManager.actionSubject.send(.fetchNote(id: id))
    }
    func deleteNote(id: UUID) {
        coreDataManager.actionSubject.send(.deleteItem(id: id))
    }
    func saveNote(_ note: NoteDTO) {
        coreDataManager.actionSubject.send(.saveNote(note: note))
    }
    
}


protocol NotesListInteractor: InteractorProtocol {
    func fetchNotes()
}
protocol NoteDetailsInteractor: InteractorProtocol {
    func fetchNote(id: UUID)
    func fetchNotes()
    func deleteNote(id: UUID)
    func saveNote(_ note: NoteDTO)
}
