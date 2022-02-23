//
//  SwiftUIView.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

struct TasksListView: View {
    var body: some View {
        Form {
            ForEach(viewModel.tasks.reversed()) { task in
                Label { Text(task.name) }
            icon: { Image(systemName: "square.fill").foregroundColor(.blue) }
                .onTapGesture { viewModel.actionSubject.send(.goToTask(id: task.id)) }

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
