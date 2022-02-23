//
//  ItemStatus.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Foundation

enum ItemStatus: String {
    case new
    case inProgress
    case waitFor
//    case delegated
    case done
    case deleted
}

enum ItemType: String {
    case task
    case project
    case note
    case reference
}

enum ItemRelation: String {
    case sbt // subtask
    case ppr // parent project
}
