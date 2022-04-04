//
//  ProjectDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct ProjectDetailsView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack {
                    header
                        .padding(.horizontal, 16)
                    textSectionView(title: "Acceptance criteria",
                                    text: $viewModel.projectAC)
                        .padding(.horizontal, 24)
                    addTaskButton
                        .padding(.leading, 23)
                    if !viewModel.nextActions.isEmpty {
                        tasksView(viewModel.nextActions, title: "Next actions")
                            .padding(.horizontal, 24)
                    }
                    if !viewModel.waitFors.isEmpty {
                        tasksView(viewModel.waitFors, title: "Wait fors")
                            .padding(.horizontal, 24)
                    }
                    if !viewModel.subtasks.isEmpty {
                        tasksView(viewModel.subtasks, title: "Tasks")
                            .padding(.horizontal, 24)
                    }
                    textSectionView(title: "Notes",
                                    text: $viewModel.projectNotes)
                        .padding(.horizontal, 24)
                    if !viewModel.doneTasks.isEmpty {
                        tasksView(viewModel.doneTasks, title: "Done")
                            .padding(.horizontal, 24)
                    }
                    Spacer()
                }
                .padding(.top, 50)
                .animation(.easeIn(duration: 0.05))
            }
            bottomButtons
                .padding()
        }
        .background(Color("background"))
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            "Project",
            leftImageView: AnyView(Image(systemName: "chevron.backward")),
            leftButtonAction: { viewModel.actionSubject.send(.back) },
            rightImageView: AnyView(Image(systemName: "plus")),
            rightButtonAction: { viewModel.actionSubject.send(.showAddingItem) },
            mainColor: Color.green)
        )
        .alert("Delete?", isPresented: $viewModel.isDeleteAlertVisible) {
            Button("Yes", role: .destructive) {
                viewModel.actionSubject.send(.deleteProject)
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    @ObservedObject var viewModel: ProjectDetailsVM

    init(viewModel: ProjectDetailsVM) {
        self.viewModel = viewModel
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().isScrollEnabled = false
    }

    private func tasksView(_ tasks: [TaskDTOReduced], title: String) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            VStack(spacing: 0) {
                ForEach(tasks) { task in
                    TaskRowView(task: task, smallIcon: true) {
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
            Button {
                viewModel.actionSubject.send(.showAddingTask)
            } label: {
                Text("Add task")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .foregroundColor(Color("background"))
                    .background(Color.green)
                    .cornerRadius(6)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func textSectionView(title: String,
                                 text: Binding<String>) -> some View {
        if text.wrappedValue.isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                HStack {
                    Text(title)
                        .foregroundColor(.gray)
                    Spacer()
                }
                ZStack {
                    TextEditor(text: text)
                    Text(viewModel.projectAC)
                        .opacity(0)
                        .padding(.all, 8)
                }
                .padding(.leading, 30)
                .background(Color("background"))
            }
        }
    }

    private var header: some View {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Text(viewModel.projectName.isEmpty ? "Project name..." : viewModel.projectName)
                        .font(.title)
                        .opacity(viewModel.projectName.isEmpty ? 0.5 : 0)
                        .padding(.all, 5)
                        .multilineTextAlignment(.leading)
                    TextEditor(text: $viewModel.projectName)
                        .font(.title)
                }
                StatusView(status: viewModel.projectStatus,
                           selectAction: { status in
                    viewModel.actionSubject.send(.changeStatus(status: status))
                })
                .padding(.leading, 6)
            }
    }

    private var bottomButtons: some View {
        VStack {
            HStack {
                Button { viewModel.actionSubject.send(.showDeleteAlert) } label:
                { Text("Delete").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
                Button { viewModel.actionSubject.send(.saveProject) } label:
                { Text("Save").foregroundColor(.green) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
            }
            .padding(8)
            .cornerRadius(8)
            .background(Color("background"))
        }
    }
}
