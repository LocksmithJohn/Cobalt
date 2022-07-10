//
//  SwiftUIView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct TasksListView: View {

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 8) {
                    activeTasksList
                    doneTasksList
                }
                .padding(.top, 90)
            }
            segmentedPicker
                .padding(.horizontal)
                .padding(.top, 50)
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            rightImageView: AnyView(Image(systemName: "plus")),
            rightButtonAction: { viewModel.actionSubject.send(.addTask) },
            mainColor: Color.blue)
        )
    }

    @ObservedObject var viewModel: TasksListVM

    init(viewModel: TasksListVM) {
        self.viewModel = viewModel
    }

    private var segmentedPicker: some View {
        Picker("What is your favorite color?", selection: $viewModel.filterTab) {
            Text("Waiting for").tag(0)
            Text("Actions").tag(1)
            Text("All").tag(2)
        }
        .pickerStyle(.segmented)
    }

    private var activeTasksList: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.allActiveTasks.reversed()) { task in
                TaskRowViewBig(task: task,
                               switchAction: {
                    viewModel.actionSubject.send(.toggleDone(id: task.id, status: task.status))
                })
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.actionSubject.send(.goToTask(id: task.id)) }
                    .padding(.leading, 28)
            }
        }
    }

    private var doneTasksList: some View {
        VStack(spacing: 8) {
            if !viewModel.allDoneTasks.isEmpty {
                doneButtonRow
                    .padding(.leading, 28)
            }
            if viewModel.doneVisible {
                ForEach(viewModel.allDoneTasks.reversed()) { task in
                    TaskRowViewBig(task: task,
                                   switchAction: {
                        viewModel.actionSubject.send(.toggleDone(id: task.id, status: task.status))
                    })
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.actionSubject.send(.goToTask(id: task.id)) }
                        .padding(.leading, 28)
                }
            }
        }
    }

    private var doneButtonRow: some View {
        HStack {
            Button { viewModel.doneVisible.toggle() } label:
            { Text("Done") }
            .foregroundColor(.white)
            Spacer()
        }
    }
}
