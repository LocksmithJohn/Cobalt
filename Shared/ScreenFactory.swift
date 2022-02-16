//
//  ScreenFactory.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI

class ScreenFactory {
    static func make(type: ScreenType, dependency: Dependency) -> AnyView {
        handleTabbarVisibility(sType: type, dependency: dependency)
        switch type {
        case let .taskDetails(id, relatedProjectID):
            return AnyView(TaskDetailsView(viewModel: VMFactory.taskDetails(dependency, id: id, relatedProjectID: relatedProjectID)))
        case .tasks:
            return AnyView(TasksListView(viewModel: VMFactory.tasksList(dependency)))
        case let .projectDetails(id):
            return AnyView(ProjectDetailsView(viewModel: VMFactory.projectDetails(dependency, id: id)))
        case .projects:
            return AnyView(ProjectsListView(viewModel: VMFactory.projectsList(dependency)))
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
        //    TODO: - obsluzyc tabbar jak bedzie czas
//        container.appState.isTabbarVisibleSubject.send(visible)
    }
}
