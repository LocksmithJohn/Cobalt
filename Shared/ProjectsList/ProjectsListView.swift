//
//  ProjectsListView.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import SwiftUI

struct ProjectsListView: View {
    var body: some View {
        scrollView
            .padding(.horizontal)
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

    private var scrollView: some View {
        ScrollView {
            ForEach(viewModel.projects) { project in
                ProjectRowView(project: project) {
                    viewModel.actionSubject.send(.goToProject(id: project.id))
                }
            }
        }
    }
}

struct ProjectRowView: View { // tutaj to przeniesc

    let project: ProjectDTOReduced
    let tapAction: () -> Void

    var body: some View {
        HStack(spacing: 40) {
            Text(project.name).padding()
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .onTapGesture { tapAction() }
    }
}
