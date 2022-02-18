//
//  ProjectDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct ProjectDetailsView: View {
    var body: some View {
        VStack {
            Label {
                TextField(viewModel.projectName, text: $viewModel.projectName)
                    .font(.title)
            } icon: {
                Image(systemName: "square.fill")
                    .foregroundColor(.green)
            }.padding(.horizontal)
            TextField(viewModel.projectDescription, text: $viewModel.projectDescription)
                .padding(.horizontal)
            Form {
                // TODO: - wrzucic nowe inity textfieldow dla ios15
                Section {
                    ForEach(viewModel.subtasks) { relatedItem in
                        Label {
                            Text(relatedItem.name)
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "square.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    Button {
                        viewModel.actionSubject.send(.showAddingTask)
                    } label:
                    { Text("Add Task").foregroundColor(.gray) }
                } header: {
                    Text("Tasks:")
                }

                Section {
                    Button { viewModel.actionSubject.send(.deleteProject) } label:
                    { Text("Delete").foregroundColor(.gray) }
                    Button { viewModel.actionSubject.send(.saveProject) } label:
                    { Text("Save").foregroundColor(.gray) }
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

    @ObservedObject var viewModel: ProjectDetailsVM

    init(viewModel: ProjectDetailsVM) {
        self.viewModel = viewModel
    }
}
