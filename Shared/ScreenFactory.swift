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
            return AnyView(Text("s Notes"))
        case let .noteDetails(id):
            return AnyView(Text("s Note Details"))
        }
    }

    static func handleTabbarVisibility(sType: ScreenType, dependency: Dependency) {
        var visible: Bool {
            switch sType {
            case .tasks, .projects, .notes:
                return true
            default:
                return false
            }
        }
        dependency.appState.isTabbarVisibleSubject.send(visible)
    }
}
