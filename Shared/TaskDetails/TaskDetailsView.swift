//
//  TaskDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct TaskDetailsView: View {

    @State var nameFocused = true

    enum FocusableField: Hashable {
        case name
        case description
    }

    @FocusState private var focus: FocusableField?

    var body: some View {
        VStack {
            header
            descriptionView
            taskTypeView
            if projectViewVisible {
                projectsView
                    .padding()
            }
            Spacer()
            bottomButtons
                .padding()
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject var viewModel: TaskDetailsVM
    @State private var projectListExpanded = false
    @State private var projectViewVisible = true

    init(viewModel: TaskDetailsVM) {
        self.viewModel = viewModel
    }
    private var descriptionView: some View {
        TextEditor(text: $viewModel.taskDescription)
            .padding(.horizontal)
            .frame(height: 60)
            .focused($focus, equals: .description)
            .background(Color("background"))
    }

    private var bottomButtons: some View {
        HStack {
            Button { viewModel.actionSubject.send(.saveTask) } label:
            { Text("Save").foregroundColor(.white) }
            .buttonStyle(CustomButtonStyle(color: .gray.opacity(0.4)))
            Button { viewModel.actionSubject.send(.deleteTask) } label:
            { Text("Delete").foregroundColor(.white) }
            .buttonStyle(CustomButtonStyle(color: .gray.opacity(0.4)))
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: viewModel.isDone ? "checkmark.square.fill" : "square")
                .padding()
            //                .padding(.horizontal, 20)
                .onTapGesture { viewModel.actionSubject.send(.toggleDone) }
            TextField(viewModel.taskName, text: $viewModel.taskName)
                .font(.title)
                .focused($focus, equals: .name)
                .onAppear {
                    focus = .description
                }
        }
    }

    private var taskTypeView: some View {
        HStack {
            Spacer()
            HStack {
                Image(systemName: viewModel.taskType == .nextAction ? "checkmark.square.fill" : "square")
                    .padding()
                Text("Next action")
            }
            .onTapGesture {
                viewModel.actionSubject.send(.toggleNextAction)
                Haptic.impact(.medium)
            }
            Spacer()
            HStack {
                Image(systemName: viewModel.taskType == .waitFor ? "checkmark.square.fill" : "square")
                    .padding()
                Text("Wait for")
            }
            .onTapGesture {
                viewModel.actionSubject.send(.toggleWaitingFor)
                Haptic.impact(.medium)
            }
            Spacer()
        }
    }

    private var projectsView: some View {
        VStack {
            Text("Project: \(viewModel.relatedProject?.name ?? "-")")
                .foregroundColor(Color.gray)
                .onTapGesture {
                    projectListExpanded.toggle()
                }
            if projectListExpanded {
                projectsList
            }
        }
    }

    private var projectsList: some View {
        HStack {
            ForEach(viewModel.projects) { project in
                Text(project.name)
                    .padding(.leading, 8)
                    .onTapGesture {
                        viewModel.actionSubject.send(.selectedProject(id: project.id))
                        projectListExpanded = false
                    }
            }
            Spacer()
        }
    }
}
