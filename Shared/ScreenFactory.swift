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
        print("route - make type: \(type)")

        switch type {
        case let .taskDetails(id):
            return AnyView(TaskDetailsView(viewModel: VMFactory.taskDetails(dependency, id: id)))
        case .tasks:
            return AnyView(TasksListView(viewModel: VMFactory.tasksList(dependency)))
        case let .projectDetails(id):
            return AnyView(Text("s Project Details"))
        case .projects:
            return AnyView(Text("s Projects"))
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
