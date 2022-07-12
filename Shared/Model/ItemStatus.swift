//
//  ItemStatus.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Foundation

enum ItemStatus: String, CaseIterable {

    case new
    case nextAction
    case inProgress
    case waitFor
    case done
    case deleted

}
