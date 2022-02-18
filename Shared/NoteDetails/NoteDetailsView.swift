//
//  NoteDetailsView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import SwiftUI

struct NoteDetailsView: View {
    var body: some View {
        VStack {
            TextEditor(text: $viewModel.note)
                .padding()
            Form {
                Section {
                    Button { viewModel.actionSubject.send(.saveNote) } label:
                    { Text("Save").foregroundColor(.gray) }
                    Button { viewModel.actionSubject.send(.deleteNote) } label:
                    { Text("Delete").foregroundColor(.gray) }
                }
            }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject var viewModel: NoteDetailsVM

    init(viewModel: NoteDetailsVM) {
        self.viewModel = viewModel
    }

}
