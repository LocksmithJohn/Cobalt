//
//  TaskDTO.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Foundation
import UIKit

struct TaskDTO: ItemProtocol, Identifiable {

    var id: UUID
    var name: String
    var taskDescription: String?
    var type: ItemType
    var status: ItemStatus
    var relatedItems: Relations

    init(id: UUID,
         name: String,
         taskDescription: String?,
         type: ItemType,
         status: ItemStatus,
         relatedItems: Relations) {
        self.id = id
        self.name = name
        self.taskDescription = taskDescription
        self.type = type
        self.status = status
        self.relatedItems = relatedItems
    }

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? ""
        self.taskDescription = itemObject.itemDescriptionLong
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .task
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.relatedItems = itemObject.relatedItemsData?.relations() ?? Relations()
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.taskDescription = ""
        self.type = .task
        self.status = .new
        self.relatedItems = Relations()
    }
}
