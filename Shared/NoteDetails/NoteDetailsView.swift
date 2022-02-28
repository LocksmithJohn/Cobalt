//
//  NoteDetailsView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import SwiftUI

struct NoteDetailsView: View {

    @State var transformViewVisible = false // tutaj to do vm

    var body: some View {
        ZStack {
            VStack {
                TextEditor(text: $viewModel.note)
                    .padding()
                    .frame(height: 100)
                Form {
                    Section {
                        Button { viewModel.actionSubject.send(.saveNote) } label:
                        { Text("Save").foregroundColor(.white) }
                        if !viewModel.isCreating {
                            Button { viewModel.actionSubject.send(.deleteNote) } label:
                            { Text("Delete").foregroundColor(.white) }
                            Button { viewModel.actionSubject.send(.showTransform) } label:
                            { Text("Change to:").foregroundColor(.white) }
                        }
                    }
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
