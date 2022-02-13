//
//  TaskDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct TaskDetailsView: View {
    var body: some View {
        Form {
            // tutaj ponizej wrzucic nowe inity textfieldow dla ios15
            TextField(viewModel.taskName, text: $viewModel.taskName)
            TextField(viewModel.taskDescription, text: $viewModel.taskDescription)
            Button { viewModel.actionSubject.send(.saveTask) } label:
            { Text("Save").foregroundColor(.red) }
            Button { viewModel.actionSubject.send(.deleteTask) } label:
            { Text("Delete").foregroundColor(.red) }

        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject var viewModel: TaskDetailsVM

    init(viewModel: TaskDetailsVM) {
        self.viewModel = viewModel
    }
}
