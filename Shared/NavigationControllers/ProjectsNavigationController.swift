//
//  ProjectsNavigationController.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI
import Foundation

struct ProjectsNavigationController: NavigationController {

    @EnvironmentObject var dependency: Dependency

    func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
        snapShotStackView(navigationController: navigationController,
                          dependency: dependency,
                          router: dependency.projectsRouter)
    }

    func setInitialView() {
//        dependency.projectsRouter.route(from: nil, to: .projects)
    }

}
