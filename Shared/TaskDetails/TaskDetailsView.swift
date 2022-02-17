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
            // TODO: ponizej wrzucic nowe inity textfieldow dla ios15
            Section {
                TextField(viewModel.taskName, text: $viewModel.taskName)
                TextField(viewModel.taskDescription, text: $viewModel.taskDescription)
            } header: { Text("Task details") }

            Section {
                Button { projectListVisible.toggle() } label:
                { Text("Choose project").foregroundColor(.gray) }
                Text("Parent project: \(viewModel.relatedProject?.name ?? "-")")
                if projectListVisible {
                    projectsView
                }
            } header: { Text("Parent project") }
            Section {
                Button { viewModel.actionSubject.send(.saveTask) } label:
                { Text("Save").foregroundColor(.green) }
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
