//
//  AddItemToProjectView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 27/03/2022.
//

import SwiftUI

struct AddItemToProjectView: View {

    @FocusState private var focus: FocusableField?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea().opacity(0.4)
                .onTapGesture {
                    viewModel.actionSubject.send(.backgroundTapped)
                }
            VStack {
                form
                if viewModel.isTextInputVisible {
                    TextEditor(text: $viewModel.text)
                        .focused($focus, equals: .first)
                        .font(.system(size: 30))
                    Button {
                        viewModel.actionSubject.send(.okButtonTapped)
                    } label: {
                        Text("ok")
                    }
                    .buttonStyle(CustomButtonStyle())
                }
            }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .onDisappear { viewModel.actionSubject.send(.onDisappear) }
    }

    private var form: some View {
        VStack {
            row(title: "Add notes", imageName: "plus", tapAction: {
                viewModel.actionSubject.send(.addNoteTapped)
                focus = .first
            })
            row(title: "Add description", imageName: "plus", tapAction: {
                viewModel.actionSubject.send(.addDescriptionTapped)
                focus = .first
            })
            row(title: "Add acceptance criteria", imageName: "plus", tapAction: {
                viewModel.actionSubject.send(.addACTapped)
                focus = .first
            })
        }
        .frame(width: 200, height: 200)
    }

    private func row(title: String,
                     imageName: String? = nil,
                     tapAction: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
            Spacer()
            if let imageName = imageName {
                Image(systemName: imageName)
            }
        }
        .padding()
        .background(Color.gray)
        .contentShape(Rectangle())
        .onTapGesture { tapAction() }
    }

    @ObservedObject var viewModel: AddItemToProjectVM

    init(viewModel: AddItemToProjectVM) {
        self.viewModel = viewModel
    }

}
