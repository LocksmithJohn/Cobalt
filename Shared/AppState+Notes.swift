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
    var notesListSubject: MYPassthroughSubject<[NoteDTOReduced]> {
        coreDataManager.notesSubject
    }

    var noteDetailsSubject: MYPassthroughSubject<NoteDTO?> {
        coreDataManager.noteSubject
    }

}

protocol NotesListAppState {
    var notesListSubject: MYPassthroughSubject<[NoteDTOReduced]> { get }
}

protocol NoteDetailsAppState {
    var noteDetailsSubject: MYPassthroughSubject<NoteDTO?> { get }
}
