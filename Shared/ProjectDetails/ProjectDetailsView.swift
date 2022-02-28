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
            header
            ScrollView {
                descriptionView
                tasksView(viewModel.nextActions, title: "Next actions:")
                tasksView(viewModel.waitFors, title: "Wait fors:")
                tasksView(viewModel.subtasks, title: "Tasks:")
                Button { viewModel.actionSubject.send(.showAddingTask) } label: {
                    Text("Add Task").foregroundColor(.gray)
                }
                Spacer()
            }
            bottomButtons
                .padding()
        }
        .background(Color("background"))
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
        UITextView.appearance().backgroundColor = .clear
    }

    private func tasksView(_ tasks: [TaskDTOReduced], title: String) -> some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(.gray)
                Spacer()
            }
            ForEach(tasks) { task in
                HStack {
                    Label {
                        Text(task.name)
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    } icon: {
                        Image(systemName: "square.fill")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }.padding(5)
            }
        }
        .padding()
    }

    private var descriptionView: some View {
        TextEditor(text: $viewModel.projectDescription)
            .padding(.horizontal)
            .frame(height: 60)
            .background(Color("background"))
    }

    private var header: some View {
        HStack(alignment: .top) {
            Image(systemName: viewModel.isDone ? "checkmark.square.fill" : "square")
                .padding(.top, 10)
                .padding(.leading, 16)
                .padding(.trailing, 8)
                .onTapGesture { viewModel.actionSubject.send(.toggleDone) }
            VStack(alignment: .leading) {
                TextField(viewModel.projectName, text: $viewModel.projectName)
                    .font(.title)
                StatusView(status: viewModel.projectStatus)
                    .padding(.trailing, 8)
            }
        }
    }

    private var bottomButtons: some View {
        HStack {
            Button { viewModel.actionSubject.send(.saveProject) } label:
            { Text("Save").foregroundColor(.white) }
            .buttonStyle(CustomButtonStyle(color: .gray.opacity(0.4)))
            Button { viewModel.actionSubject.send(.deleteProject) } label:
            { Text("Delete").foregroundColor(.white) }
            .buttonStyle(CustomButtonStyle(color: .gray.opacity(0.4)))
        }
    }
}
