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
            Button { projectListVisible.toggle() } label:
            { Text("Choose project").foregroundColor(.gray) }

            if projectListVisible {
                projectsView
            }

            HStack {
                Button { viewModel.actionSubject.send(.saveTask) } label:
                { Text("Save").foregroundColor(.green) }
                Spacer()
                Button { viewModel.actionSubject.send(.deleteTask) } label:
                { Text("Delete").foregroundColor(.red) }
            }

        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject var viewModel: TaskDetailsVM
    @State private var projectListVisible = false

    init(viewModel: TaskDetailsVM) {
        self.viewModel = viewModel
    }
    
    private var projectsView: some View {
        ForEach(viewModel.projects) { project in
            Text(project.name)
                .padding(.leading, 8)
        }
    }
}
