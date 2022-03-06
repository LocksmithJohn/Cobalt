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
        VStack {
            segmentedPicker
                .padding(.horizontal)
            ScrollView {
                VStack(spacing: 8) {
                    activeTasksList
                        .padding()
                    doneTasksList
                        .padding()
                }
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

    private var segmentedPicker: some View {
        Picker("What is your favorite color?", selection: $viewModel.filterTab) {
            Text("All").tag(0)
            Text("Waiting for").tag(1)
            Text("Actions").tag(2)
        }
        .pickerStyle(.segmented)
    }

    private var activeTasksList: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.allActiveTasks.reversed()) { task in
                TaskRowView(task: task, switchAction: {
                    viewModel.actionSubject.send(.toggleDone(task: task))
                })
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.actionSubject.send(.goToTask(id: task.id)) }
            }
        }
    }

    private var doneTasksList: some View {
        VStack(spacing: 8) {
            if !viewModel.allDoneTasks.isEmpty {
                doneButtonRow
            }
            if doneVisible {
                ForEach(viewModel.allDoneTasks.reversed()) { task in
                    TaskRowView(task: task, switchAction: {
                        viewModel.actionSubject.send(.toggleDone(task: task))
                    })
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.actionSubject.send(.goToTask(id: task.id)) }
                }
            }
        }
    }

    private var doneButtonRow: some View {
        HStack {
            Button { doneVisible.toggle() } label:
            { Text("Done Tasks") }
            .padding(3)
            .background(Color("object"))
            .cornerRadius(6)
            .foregroundColor(.white)
            Spacer()
        }
        .padding(.leading, 8)
    }
}
