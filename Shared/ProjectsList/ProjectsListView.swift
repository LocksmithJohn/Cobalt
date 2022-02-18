//
//  ProjectsListView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct ProjectsListView: View {
    var body: some View {
        Form {
            ForEach(viewModel.projects) { project in
                Label { Text(project.name) }
            icon: { Image(systemName: "square.fill").foregroundColor(.green) }
                .onTapGesture { viewModel.actionSubject.send(.goToProject(id: project.id)) }

            }
        }
        .onAppear { viewModel.actionSubject.send(.onAppear) }
        .modifier(NavigationBarModifier(
            viewModel.screenType.title,
            rightImageView: AnyView(Image(systemName: "plus")),
            rightButtonAction: { viewModel.actionSubject.send(.addProject) })
        )
    }

    @ObservedObject var viewModel: ProjectsListVM

    init(viewModel: ProjectsListVM) {
        self.viewModel = viewModel
    }
}
