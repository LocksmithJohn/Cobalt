//
//  ItemType.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import CoreData
import Foundation

public enum ItemObjectType {
    case item

    public var type: NSManagedObject.Type {
        switch self {
        case .item:
            return ItemObject.self
        }
    }

    var mainAttributeName: String {
        switch self {
        case .item:
            return "name"
        }
    }
}
