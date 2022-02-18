//
//  NotesListView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import SwiftUI
import Foundation

struct NotesListView: View {
    var body: some View {
        Form {
            ForEach(viewModel.notes) { note in
                Section {
                    Text(note.name)
                }
                .onTapGesture { viewModel.actionSubject.send(.goToNote(id: note.id)) }
            }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            rightImageView: AnyView(Image(systemName: "plus")),
            rightButtonAction: { viewModel.actionSubject.send(.addNote) })
        )
    }

    @ObservedObject var viewModel: NotesListVM

    init(viewModel: NotesListVM) {
        self.viewModel = viewModel
    }
}
