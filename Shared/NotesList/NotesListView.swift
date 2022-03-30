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
        VStack {
            notesScrollView
                .padding(.horizontal)
            Text("What's on your mind? ...")
                .font(.system(size: 32))
                .foregroundColor(.gray)
                .padding()
                .onTapGesture { viewModel.actionSubject.send(.addNote) }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "square.lefthalf.filled")),
            leftButtonAction: {
                GlobalRouter.shared.settingsVisible.send(true)
            },
            rightImageView: AnyView(Image(systemName: "plus")),
            rightButtonAction: { viewModel.actionSubject.send(.addNote) },
            mainColor: Color.yellow)
        )
    }

    @ObservedObject var viewModel: NotesListVM

    init(viewModel: NotesListVM) {
        self.viewModel = viewModel
    }

    private var notesScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 6) {
                ForEach(viewModel.notes) { note in
                    NoteRowView(note: note, tapAction: {
                        viewModel.actionSubject.send(.goToNote(id: note.id))
                    })
                }
            }
        }.padding(.top, 50)
    }
}
