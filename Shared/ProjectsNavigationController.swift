//
//  ProjectsNavigationController.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

struct ProjectsNavigationController: NavigationController {

    @EnvironmentObject var dependency: Dependency

    func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
        snapShotStackView(navigationController: navigationController,
                          container: dependency,
                          router: dependency.routerProjects)
    }

    func setInitialView() {
        container.routerProjects.setInitial(.projects)
    }

}
