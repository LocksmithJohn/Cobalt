//
//  RouterType.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 16/07/2022.
//

import Foundation

enum RouterType: String {
    case notes
    case tasks
    case projects
    case more

    var initialScreen: ScreenType {
        switch self {
        case .notes:
            return .notes
        case .tasks:
            return .tasks
        case .projects:
            return .projects
        case .more:
            return .more
        }
    }
}
