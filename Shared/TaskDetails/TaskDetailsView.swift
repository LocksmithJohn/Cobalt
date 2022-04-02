//
//  TaskDetailsView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct TaskDetailsView: View {

    @FocusState private var focus: FocusableField?
    @State var textEditorHeight : CGFloat = 20

    var body: some View {
        VStack(spacing: 10) {

            ExpandingTextView(text: $viewModel.taskName,
                              charsLimit: 100)
                .padding(.horizontal)
                .padding(.top, 10)
            taskDetails
                .padding(.horizontal, 20)
            taskTypeView
                .padding(.horizontal, 21)
            descriptionView
                .padding(.horizontal, 18)
            Spacer()
            bottomButtons
                .padding()
        }
        .padding(.top, 50)
        .onAppear {
            viewModel.actionSubject.send(.onAppear)
            if viewModel.isCreating {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focus = .first }
            }
        }
        .alert("Delete?", isPresented: $viewModel.isDeleteAlertVisible) {
            Button("Yes", role: .destructive) {
                viewModel.actionSubject.send(.deleteTask)
            }
            Button("Cancel", role: .cancel) {}
        }
        .focused($focus, equals: .first)
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            leftImageView: AnyView(Image(systemName: "plus")),
            leftButtonAction: { viewModel.actionSubject.send(.back) })
        )
    }

    @ObservedObject private var viewModel: TaskDetailsVM
    @State private var projectListExpanded = false

    init(viewModel: TaskDetailsVM) {
        self.viewModel = viewModel
        UITextView.appearance().backgroundColor = .clear
        UIScrollView.appearance().isScrollEnabled = false
    }

    private func customTextEdit(fonSize: CGFloat) -> some View {
            ZStack(alignment: .topLeading) {
                Text(viewModel.taskName)
                    .font(.system(size: fonSize))
                    .foregroundColor(.white)
                    .opacity(0.3)
                    .padding(0)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: $0.frame(in: .local).size.height)
                    })
                TextEditor(text: $viewModel.taskName)
                    .padding(0)
                    .font(.system(size: fonSize))
                    .focused($focus, equals: .first)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
                    .frame(height: max(40,textEditorHeight))

//                if viewModel.taskName.isEmpty {
//                    Text("Task name...")
//                        .font(.system(size: 32))
//                        .foregroundColor(.gray)
//                        .padding()
//                        .offset(x: 12, y: 8)
//                }
            }
//            .frame(maxHeight: 100)
            .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }    }

    private var taskDetails: some View {
        HStack(alignment: .top) {
            StatusView(status: viewModel.taskStatus)
            parentProject
        }
    }

    private var descriptionView: some View {
        ZStack(alignment: .topLeading) {
            if viewModel.taskDescription.isEmpty {
                Text("Notes:")
                    .foregroundColor(.gray)
                    .offset(x: 5, y: 8)
            }
            TextEditor(text: $viewModel.taskDescription)
                .foregroundColor(.white)
                .frame(height: 200)
        }
    }

    private var bottomButtons: some View {
        HStack {
            if viewModel.isCreating {
                Button { viewModel.actionSubject.send(.cancel) } label:
                { Text("Cancel").foregroundColor(.white) }
                .buttonStyle(CustomButtonStyle(color: Color("object")))
            } else {
                Button { viewModel.actionSubject.send(.showDeleteAlert) } label:
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
        return HStack {
            checkCircle(isSelected)
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(4)
                .padding(.horizontal, 8)
        }
    }

    private var taskTypeView: some View {
        HStack {
            VStack(alignment: .leading) {
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
            }
            Spacer()
        }
    }

    private var parentProject: some View {
        VStack {
            HStack {
                Text(viewModel.relatedProject?.name ?? " ... ")
                    .modifier(SmallObjectModifier())
                    .cornerRadius(6)
                    .onTapGesture {
                        projectListExpanded.toggle()
                        Haptic.impact(.medium)
                    }
                Spacer()
            }
            if projectListExpanded {
                projectsList
                    .modifier(SmallObjectModifier())
                    .frame(minHeight: 60)
            }
        }
    }

    private func checkCircle(_ isChecked: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("inactive"))
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 5)
                .fill(isChecked ? Color.gray : Color("background"))
                .frame(width: 14, height: 14)
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
                                Haptic.impact(.medium)
                            }
                            .foregroundColor(project.id == viewModel.relatedProject?.id ? .white : .gray)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
