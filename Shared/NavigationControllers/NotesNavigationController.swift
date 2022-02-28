//
//  InboxNavigationController.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import SwiftUI
import Foundation

struct NotesNavigationController: NavigationController {

    @EnvironmentObject var dependency: Dependency

    func updateUIViewController(_ navigationController: UINavigationController, context: Context) {
        snapShotStackView(navigationController: navigationController,
                          dependency: dependency,
                          router: dependency.notesRouter)
    }

    func setInitialView() {
//        dependency.notesRouter.route(from: nil, to: .notes)
    }

}
