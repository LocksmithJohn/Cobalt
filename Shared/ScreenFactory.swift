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
        case .tasks:
            return AnyView(TasksListView(viewModel: VMFactory.tasksList(dependency: dependency)))
        default:
            return AnyView(Text("tutaj screen"))
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
