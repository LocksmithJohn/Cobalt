//
//  ScreenFactory.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

class ScreenFactory {
    static func make(type: ScreenType, dependency: Dependency, router: Router) -> AnyView {
        handleTabbarVisibility(sType: type, dependency: dependency)
        switch type {
        case let .taskDetails(id, projectID):
            return AnyView(
                TaskDetailsView(viewModel: VMFactory.taskDetails(dependency, id: id, projectID: projectID, router: router))
            )
        case .tasks:
            return AnyView(
                TasksListView(viewModel: VMFactory.tasksList(dependency, router: router))
            )
        case let .projectDetails(id):
            return AnyView(
                ProjectDetailsView(viewModel: VMFactory.projectDetails(dependency, id: id, router: router))
            )
        case .projects:
            return AnyView(
                ProjectsListView(viewModel: VMFactory.projectsList(dependency, router: router))
            )
        case .notes:
            return AnyView(
                NotesListView(viewModel: VMFactory.notesList(dependency, router: router))
            )
        case let .noteDetails(id):
            return AnyView(
                NoteDetailsView(viewModel: VMFactory.noteDetails(dependency, id: id, router: router))
            )
        case .more:
            return AnyView(
                MoreView(viewModel: VMFactory.more(dependency, router: router))
                    .background(Color.red.ignoresSafeArea())
            )
        case .search:
            return AnyView(
                SearchView(viewModel: VMFactory.search(dependency, router: router))
            )
        case .areas:
            return AnyView(
                AreasView(viewModel: VMFactory.areas(dependency, router: router))
            )
        case .export:
            return AnyView(
                Text("tutaj 9875")
            )
        case .transformView, .addItem:
            print("factory not allowed view")
            return AnyView(EmptyView())
        }
    }

    static func handleTabbarVisibility(sType: ScreenType, dependency: Dependency) {
        var visible: Bool {
            switch sType {
            case .tasks, .projects, .notes, .more:
                return true
            default:
                return false
            }
        }
        GlobalRouter.shared.tabbarVisible.send(visible)
    }
}
