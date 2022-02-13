//
//  TasksNavigationController.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI
import Foundation

struct TasksNavigationController: NavigationController {

    @EnvironmentObject var dependency: Dependency

    func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
        snapShotStackView(navigationController: navigationController,
                          dependency: dependency,
                          router: dependency.tasksRouter)
    }

    func setInitialView() {
        dependency.tasksRouter.route(from: nil, to: .tasks)
    }

}
