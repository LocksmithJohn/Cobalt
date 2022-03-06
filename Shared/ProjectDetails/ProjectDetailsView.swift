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
                .padding(.horizontal, 24)
            ScrollView {
                addTaskButton
                    .padding(.horizontal, 24)
                if !viewModel.nextActions.isEmpty {
                    tasksView(viewModel.nextActions, title: "Next actions:")
                        .padding(.horizontal, 24)
                }
                if !viewModel.waitFors.isEmpty {
                    tasksView(viewModel.waitFors, title: "Wait fors:")
                        .padding(.horizontal, 24)
                }
                if !viewModel.subtasks.isEmpty {
                    tasksView(viewModel.subtasks, title: "Tasks:")
                        .padding(.horizontal, 24)
                }
                if !viewModel.doneTasks.isEmpty {
                    tasksView(viewModel.doneTasks, title: "Done:")
                        .padding(.horizontal, 24)
                }
                descriptionView
                    .padding(.horizontal, 24)
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
        UITextView.appearance().isScrollEnabled = false
    }

    private func tasksView(_ tasks: [TaskDTOReduced], title: String) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.bottom, 8)
            VStack(spacing: 10) {
                ForEach(tasks) { task in
                    TaskRowView(task: task) {
                        viewModel.actionSubject.send(.toggleDoneTask(task: task))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.actionSubject.send(.taskSelected(id: task.id))
                    }
                }
            }
        }
    }

    private var addTaskButton: some View {
        HStack {
            Button { viewModel.actionSubject.send(.showAddingTask) } label: {
                Text("Add Task")
                    .font(.system(size: 18))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .foregroundColor(.white)
                    .background(Color("object"))
                    .cornerRadius(6)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    private var descriptionView: some View {
        VStack {
            HStack {
                Text("Notes:").foregroundColor(.gray)
                Spacer()
            }
            ZStack {
                TextEditor(text: $viewModel.projectDescription)
                Text(viewModel.projectDescription)
                    .opacity(0)
                    .padding(.all, 8)
            }
            .background(Color("background"))
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            Image(systemName: viewModel.isDone ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture { viewModel.actionSubject.send(.toggleDoneProject) }
                .padding(.top, 5)
            VStack(alignment: .leading) {
                ZStack {
                    TextField(viewModel.projectName, text: $viewModel.projectName)
                        .font(.title)
                        .lineLimit(2)
                }
                StatusView(status: viewModel.projectStatus)
            }
        }
    }

    private var bottomButtons: some View {
        VStack {
            HStack {
                Button { viewModel.actionSubject.send(.deleteProject) } label:
                { Text("Delete").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
                Button { viewModel.actionSubject.send(.saveProject) } label:
                { Text("Save").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: .green.opacity(0.4)))
            }
            Button { viewModel.actionSubject.send(.back) } label:
            {
                ZStack {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
            }
            .buttonStyle(CustomButtonStyle(color: Color("object")))
        }
    }
}
