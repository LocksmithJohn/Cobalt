//
//  NoteDetailsView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import SwiftUI

struct NoteDetailsView: View {

    @FocusState private var focus: FocusableField?

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 30)
                inputText
                areas
                Spacer()
                bottomButtons
                    .padding()
            }
        }
        .onAppear {
            viewModel.actionSubject.send(.onAppear)
            if viewModel.isCreating {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focus = .first }
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

    private var inputText: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.noteValue)
                .font(.system(size: 32))
                .padding()
                .focused($focus, equals: .first)
            Text(viewModel.noteValue)
                .font(.system(size: 32))
                .opacity(0)
                .padding(.all, 8)
            if viewModel.noteValue.isEmpty {
                Text("What's on your mind? ...")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                    .padding()
                    .offset(x: 12, y: 8)
            }
        }
    }

    private var areas: some View { // ten widok przeniesc jako generycnzy
        HStack {
            VStack(spacing: 6) {
                HStack {
                    Text("Focus Area")
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .onTapGesture { viewModel.actionSubject.send(.toggleAreasVisibility) }
                    Spacer()
                }
                if viewModel.isAreasViewVisible {
                    ForEach(viewModel.focusAreasForDisplay, id: \.name) { area in
                        HStack {
                            Text(area.name)
                                .foregroundColor(area.exists ? .white : .gray)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.actionSubject
                                        .send(.toggleArea(name: area.name))
                                }
                                .padding(6)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            Spacer()
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
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
