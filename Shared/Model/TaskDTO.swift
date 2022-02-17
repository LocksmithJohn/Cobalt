//
//  TaskDTO.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Foundation
import UIKit

struct TaskDTO: Identifiable {

    let id: UUID
    var name: String
    var itemDescription: String?
    var type: ItemType
    var status: ItemStatus
    var relatedItems: String?

    init(id: UUID,
         name: String,
         itemDesrciption: String?,
         type: ItemType,
         status: ItemStatus,
         relatedItems: String?) {
        self.id = id
        self.name = name
        self.itemDescription = itemDesrciption
        self.type = type
        self.status = status
        self.relatedItems = relatedItems
    }

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? ""
        self.itemDescription = itemObject.itemDescription
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .task
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.relatedItems = itemObject.relatedItemsData
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.itemDescription = ""
        self.type = .task
        self.status = .new
        self.relatedItems = ""
    }
}
