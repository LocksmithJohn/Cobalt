//
//  StackAction.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

enum StackAction {
    case set([ScreenType])
    case push(ScreenType)
    case pushExisting(ScreenType)
    case pop
    case dismiss
    case present(ScreenType)
}
