//
//  ProjectDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct ProjectDetailsView: View {
    var body: some View {
        Form {
            Section {
                TextField(viewModel.projectName, text: $viewModel.projectName)
                TextField(viewModel.projectDescription, text: $viewModel.projectDescription)
            } header: {
                Text("Project details")
            }

            // tutaj ponizej wrzucic nowe inity textfieldow dla ios15
            Section {
                ForEach(viewModel.relatedItems) { relatedItem in
                    Text(relatedItem.name).font(.system(size: 18)).foregroundColor(.gray)
                }
                Button {
                    viewModel.actionSubject.send(.showAddingTask)

                } label:
                { Text("Add Task").foregroundColor(.blue) }
            } header: {
                Text("Tasks")
            }

            Section {
                Button { viewModel.actionSubject.send(.deleteProject) } label:
                { Text("Delete").foregroundColor(.red) }
                Button { viewModel.actionSubject.send(.saveProject) } label:
                { Text("Save").foregroundColor(.green) }
            } header: {
                Text("Project actions")
            }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject var viewModel: ProjectDetailsVM

    init(viewModel: ProjectDetailsVM) {
        self.viewModel = viewModel
    }
}
