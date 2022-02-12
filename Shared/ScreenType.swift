//
//  ScreenType.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

enum ScreenType: Equatable {
    case tasks
    case taskDetails(id: UUID?)
    case projects
    case projectDetails(id: UUID?)
    case notes
    case noteDetails(id: UUID?)

    var title: String {
        return "Tytuł"
    }
}
