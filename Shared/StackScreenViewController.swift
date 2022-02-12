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
    var type: ScreenType { didSet {
        rootView = ScreenFactory.make(type: type, dependency: dependency)
    } }

    init(dependency: Dependency, type: ScreenType) {
        self.dependency = dependency
        self.type = type
        super.init(rootView: ScreenFactory.make(type: type, dependency: dependency))
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.title = type.title
    }

    required init?(coder aDecoder: NSCoder) { nil }
}

class Screen: Equatable {

    var isModal = false
    var type = ScreenType.tasks

    init(type: ScreenType) {
        self.type = type
    }

    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.type == rhs.type
    }

}
