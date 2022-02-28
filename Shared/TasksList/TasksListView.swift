//
//  SwiftUIView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct TasksListView: View {

    @State var doneVisible = false // tutaj do vm

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Picker("What is your favorite color?", selection: $viewModel.filterTab) {
                    Text("Actions").tag(0)
                    Text("Waiting for").tag(1)
                    Text("All").tag(2)
                }
                .pickerStyle(.segmented)
                ForEach(viewModel.visibleTasks.reversed()) { task in
                    TaskRowView(task: task, tapAction: {
                        viewModel.actionSubject.send(.toggleDone(task: task))
                    })
                        .onTapGesture { viewModel.actionSubject.send(.goToTask(id: task.id)) }
                }
                HStack {
                    Button { doneVisible.toggle() } label: { Text("Done Tasks") }
                    Spacer()
                }
//                if doneVisible {
//                    ForEach(viewModel.visibleTasks.reversed()) { task in
//                        TaskRowView(task: task, tapAction: {
//                            viewModel.actionSubject.send(.toggleDone(task: task))
//                        })
//                            .onTapGesture { viewModel.actionSubject.send(.goToTask(id: task.id)) }
//                    }
//                }
            }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            rightImageView: AnyView(Image(systemName: "plus")),
            rightButtonAction: { viewModel.actionSubject.send(.addTask) })
        )
    }

    @ObservedObject var viewModel: TasksListVM

    init(viewModel: TasksListVM) {
        self.viewModel = viewModel
    }
}

struct TaskRowView: View { // tutaj to przeniesc

    let task: TaskDTOReduced
    let tapAction: () -> Void

    var body: some View {
        HStack(spacing: 40) {
            Image(systemName: task.status == .done ? "checkmark.square.fill" : "square")
                .padding()
                .onTapGesture { tapAction() }
            Text(task.name)
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}
