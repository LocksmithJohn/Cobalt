//
//  ScreenType.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

enum ScreenType: Equatable {
    case tasks
    case taskDetails(id: UUID?, relatedProjectID: UUID?)
    case projects
    case projectDetails(id: UUID?)
    case notes
    case noteDetails(id: UUID?)

    var title: String {
        switch self {
        case .tasks:
            return "Tasks"
        case .taskDetails:
            return "Task"
        case .projects:
            return "Projects"
        case .projectDetails:
            return "Project"
        case .notes:
            return "Notes"
        case .noteDetails:
            return "Note"
        default:
            return "Error screen"
        }
    }
}
