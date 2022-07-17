//
//  StackAction.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

enum StackAction {
    /// Clears stack and hard sets new array of screens
    case set([ScreenType])
    /// Push new screen if there is none of this type
    case pushIfNotExists(ScreenType)
    /// Clear this type if exists and push new one
    case clearAndPush(ScreenType)
    /// Remove last screen
    case pop
    /// Remove last modal screen
    case dismiss
    /// Remove all screens but first one
    case backToHome
    /// Remove all modal screens
    case dismissAll
    /// Add new modal screen
    case present(ScreenType)
}
