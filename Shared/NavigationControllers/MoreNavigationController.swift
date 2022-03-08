//
//  MoreNavigationController.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 06/03/2022.
//

import SwiftUI
import Foundation

struct MoreNavigationController: NavigationController {

    @EnvironmentObject var dependency: Dependency

    func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
        snapShotStackView(navigationController: navigationController,
                          dependency: dependency,
                          router: dependency.moreRouter)
    }

    func setInitialView() {
//        dependency.notesRouter.route(from: nil, to: .notes)
    }

}
