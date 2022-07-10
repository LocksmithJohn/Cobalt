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
                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 17)
                    capsulesView
                        .padding(17)
                        .background(Color("backgroundDark"))
                    textSectionView(title: "Acceptance criteria:",
                                    text: $viewModel.projectAC)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                        .background(Color("backgroundDark"))
                    Group {
                    if !viewModel.nextActions.isEmpty {
                        tasksView(viewModel.nextActions, title: "Next actions:")
                            .padding(.horizontal, 23)
                            .padding(.vertical, 16)
                    }
                    if !viewModel.waitFors.isEmpty {
                        tasksView(viewModel.waitFors, title: "Wait fors:")
                            .padding(.horizontal, 23)
                            .padding(.vertical, 16)
                    }
                    if !viewModel.subtasks.isEmpty {
                        tasksView(viewModel.subtasks, title: "Tasks:")
                            .padding(.horizontal, 23)
                            .padding(.vertical, 16)
                    }
                    addTaskButton
                        .padding(.leading, 24)
                        .padding(.vertical, 16)

                    }
                    textSectionView(title: "Notes:",
                                    text: $viewModel.projectNotes)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                    if !viewModel.doneTasks.isEmpty {
                        tasksView(viewModel.doneTasks, title: "Done:")
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                    }
                    Spacer()
                    bottomButtons
                        .padding()
                }
                .padding(.top, 50)
                .animation(.easeIn(duration: 0.05))
            }

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
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.gray)
                Spacer()
            }
            VStack(spacing: 10) {
                ForEach(tasks) { task in
                    TaskRowViewSmall(task: task) {
                        viewModel.actionSubject.send(.toggleDoneTask(task: task))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.actionSubject.send(.taskSelected(id: task.id))
                    }
                }
            }
            .padding(.leading, 2)
        }
    }

    private var addTaskButton: some View {
        HStack {
            Button {
                viewModel.actionSubject.send(.showAddingTask)
            } label: {
                Text("Add task")
                    .font(.system(size: 14))
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
                        .font(.system(size: 16, weight: .light))
                    Spacer()
                }
                ExpandingTextView(text: text,
                                  fontSize: 18,
                                  charsLimit: 80)
                .offset(x: -5)
                .background(Color("backgroundDark"))
            }
        }
    }

    private var header: some View {
                ExpandingTextView(text: $viewModel.projectName,
                                  fontSize: 30,
                                  charsLimit: 100)
    }

    private var capsulesView: some View {
        HStack(spacing: 6) {
            StatusView(status: viewModel.projectStatus,
                       selectAction: { status in
                viewModel.actionSubject.send(.changeStatus(status: status))
            })
            TagView(tag: viewModel.projectTag) { tag in
                viewModel.actionSubject.send(.changeTag(tag: tag))
            }
            Spacer()
        }
        .padding(.leading, 6)

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
