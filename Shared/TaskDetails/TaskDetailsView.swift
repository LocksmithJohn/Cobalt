//
//  TaskDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

enum FocusableField: Hashable { // tutaj przeniesc
    case name
}

struct TaskDetailsView: View {

    @FocusState private var focus: FocusableField?

    var body: some View {
            VStack(spacing: 8) {
                header
                    .padding(.horizontal)
                    .padding(.bottom, 22)
                if projectViewVisible {
                    projectsView
                        .padding(.horizontal)
                }
                taskTypeView
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                descriptionView
                    .padding(.horizontal)
                Spacer()
                bottomButtons
                    .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focus = .name }
            viewModel.actionSubject.send(.onAppear)
        }
        .focused($focus, equals: .name)
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject private var viewModel: TaskDetailsVM
    @State private var projectListExpanded = false
    @State private var projectViewVisible = true

    init(viewModel: TaskDetailsVM) {
        self.viewModel = viewModel
        UITextView.appearance().backgroundColor = .clear
    }

    private var header: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.isDone ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture { viewModel.actionSubject.send(.toggleDone) }
            TextField(viewModel.taskName, text: $viewModel.taskName, prompt: Text("Task name ..."))
                .foregroundColor(.blue)
                .font(.title)
        }
    }

    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Notes:")
                .foregroundColor(.gray)
                .offset(y: 3)
            TextEditor(text: $viewModel.taskDescription)
                .foregroundColor(.gray)
                .frame(height: 200)
                .background(Color("background"))
                .offset(x: -4)
        }
    }

    private var bottomButtons: some View {
        HStack {
            if viewModel.isCreating {
                Button { viewModel.actionSubject.send(.cancel) } label:
                { Text("Cancel").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
            } else {
                Button { viewModel.actionSubject.send(.deleteTask) } label:
                { Text("Delete").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
            }
            Button { viewModel.actionSubject.send(.saveTask) } label:
            { Text("Save").foregroundColor(.white) }
            .buttonStyle(CustomButtonStyle(color: .blue.opacity(0.4)))
        }
    }

    private func typeView(text: String, type: ItemType) -> some View {
        var isSelected: Bool {
            viewModel.taskType == type
        }
        return Text(text)
            .font(.system(size: 14))
            .foregroundColor(isSelected ? .white : .gray)
            .padding(4)
            .padding(.horizontal, 8)
            .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1))
    }

    private var taskTypeView: some View {
        HStack {
            typeView(text: "Next action", type: .nextAction)
                .onTapGesture {
                    viewModel.actionSubject.send(.toggleNextAction)
                    Haptic.impact(.medium)
                }
            typeView(text: "Wait for", type: .waitFor)
                .onTapGesture {
                    viewModel.actionSubject.send(.toggleWaitingFor)
                    Haptic.impact(.medium)
                }
            Spacer()
        }
    }

    private var projectsView: some View {
        VStack {
            HStack {
                Text(viewModel.relatedProject?.name ?? " ... ")
                    .font(.system(size: 14))
                    .padding(.horizontal, 8)
                    .padding(4)
                    .foregroundColor(Color.green)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.green, lineWidth: 1))
                    .onTapGesture {
                        projectListExpanded.toggle()
                    }
                Spacer()
            }
            if projectListExpanded {
                projectsList
            }
        }
    }

    private var projectsList: some View {
        ScrollView {
            VStack(spacing: 6) {
                ForEach(viewModel.projects) { project in
                    HStack {
                        Text(project.name)
                            .padding(.leading, 8)
                            .onTapGesture {
                                viewModel.actionSubject.send(.selectedProject(id: project.id))
                                projectListExpanded = false
                            }
                            .foregroundColor(project.id == viewModel.relatedProject?.id ? .white : .gray)
                        Spacer()
                    }
                }
                Spacer()
            }
        }
    }
}
