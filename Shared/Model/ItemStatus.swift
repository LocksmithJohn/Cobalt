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
    case done
    case deleted
    case someDay
}

enum ItemType: String, Equatable {

    case task
    case nextAction
    case waitFor
    case project
    case note
    case reference

}

enum ItemRelation: String {
    case sbt // subtask
    case ppr // parent project
}
