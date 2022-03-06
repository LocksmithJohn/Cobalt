//
//  NoteDetailsView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import SwiftUI

struct NoteDetailsView: View {

    @State var transformViewVisible = false // tutaj to do vm
    @FocusState private var focus: FocusableField?

    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.note)
                        .font(.system(size: 32))
                        .padding()
                        .focused($focus, equals: .name)
                    Text(viewModel.note)
                        .font(.system(size: 32))
                        .opacity(0)
                        .padding(.all, 8)
                    if viewModel.note.isEmpty {
                        Text("What's on your mind? ...")
                            .font(.system(size: 32))
                            .foregroundColor(.gray)
                            .padding()
                            .offset(x: 12, y: 8)
                    }
                }

                Spacer()
                bottomButtons
                    .padding()
            }
        }
        .onAppear {
            viewModel.actionSubject.send(.onAppear)
            if viewModel.isCreating {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focus = .name }
            }
        }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject var viewModel: NoteDetailsVM

    init(viewModel: NoteDetailsVM) {
        self.viewModel = viewModel
        UITextView.appearance().backgroundColor = .clear
    }

    private var bottomButtons: some View {
        HStack {
            if viewModel.isCreating {
                Button { viewModel.actionSubject.send(.cancel) } label:
                { Text("Cancel").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
            } else {
                Button { viewModel.actionSubject.send(.deleteNote) } label:
                { Text("Delete").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
                Button { viewModel.actionSubject.send(.showTransform) } label:
                { Text("Change to").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: .yellow.opacity(0.4)))
            }
            Button { viewModel.actionSubject.send(.saveNote) } label:
            { Text("Save").foregroundColor(.white) }
            .buttonStyle(CustomButtonStyle(color: .yellow.opacity(0.4)))
        }
    }

}
