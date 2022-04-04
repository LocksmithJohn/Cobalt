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
                rightButtonAction: { viewModel.actionSubject.send(.addProject) },
                mainColor: Color.green)
            )
    }

    @ObservedObject var viewModel: ProjectsListVM

    init(viewModel: ProjectsListVM) {
        self.viewModel = viewModel
    }

    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.notDoneProjects) { project in
                    ProjectRowView(project: project) {
                        viewModel.actionSubject.send(.goToProject(id: project.id))
                    }
                }
                if !viewModel.doneProjects.isEmpty {
                    Text("Done")
                }
                ForEach(viewModel.doneProjects) { project in
                    ProjectRowView(project: project) {
                        viewModel.actionSubject.send(.goToProject(id: project.id))
                    }
                }
            }.padding(.top, 50)
        }
    }
}
