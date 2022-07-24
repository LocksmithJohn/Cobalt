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
    var relations: Relations
    var tags: ItemTags
    var areas: FocusAreas

    init(id: UUID,
         name: String,
         taskDescription: String?,
         type: ItemType,
         status: ItemStatus,
         relatedItems: Relations,
         tags: ItemTags,
         areas: FocusAreas) {
        self.id = id
        self.name = name
        self.taskDescription = taskDescription
        self.type = type
        self.status = status
        self.relations = relatedItems
        self.tags = tags
        self.areas = areas
    }

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? ""
        self.taskDescription = itemObject.itemDescriptionLong
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .task
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.relations = itemObject.relatedItemsData?.relations() ?? Relations()
        self.tags = itemObject.tags?.tags() ?? ItemTags()
        self.areas = itemObject.areas?.areas() ?? FocusAreas()
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.taskDescription = ""
        self.type = .task
        self.status = .new
        self.relations = Relations()
        self.tags = ItemTags()
        self.areas = FocusAreas()
    }
}
