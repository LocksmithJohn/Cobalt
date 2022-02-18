//
//  AppState+Notes.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Combine
import Foundation

extension AppState: NotesListAppState,
                    NoteDetailsAppState {
    var notesListSubject: PassthroughSubject<[NoteDTOReduced], Never> {
        coreDataManager.notesSubject
    }

    var noteDetailsSubject: PassthroughSubject<NoteDTO?, Never> {
        coreDataManager.noteSubject
    }

}

protocol NotesListAppState {
    var notesListSubject: PassthroughSubject<[NoteDTOReduced], Never> { get }
}

protocol NoteDetailsAppState {
    var noteDetailsSubject: PassthroughSubject<NoteDTO?, Never> { get }
}
