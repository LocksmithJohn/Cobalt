//
//  StackScreenViewController.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation
import SwiftUI

class StackScreenViewController: UIHostingController<AnyView> {
    var dependency: Dependency
    var router: Router
    var type: ScreenType { didSet {
        rootView = ScreenFactory.make(type: type, dependency: dependency, router: router)
    } }

    init(dependency: Dependency, type: ScreenType, router: Router) {
        self.dependency = dependency
        self.router = router
        self.type = type
        super.init(rootView: ScreenFactory.make(type: type, dependency: dependency, router: router))
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.title = type.title
    }

    required init?(coder aDecoder: NSCoder) { nil }
}

class Screen: Equatable, Hashable {

    var isModal = false
    var type = ScreenType.tasks

    init(type: ScreenType) {
        self.type = type
    }

    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(type.title)
    }

}
