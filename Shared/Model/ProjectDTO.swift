//
//  ProjectDTO.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Foundation

struct ProjectDTO: Identifiable {

    var id: UUID
    let name: String
    let itemDescription: String?
    let type: ItemType
    let status: ItemStatus
    var relatedItems: String?

    init(id: UUID,
         name: String?,
         itemDesrciption: String?,
         type: ItemType,
         status: ItemStatus,
         relatedItems: String?) {
        self.id = id
        self.name = name ?? ""
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
        self.type = .project
        self.status = .new
        self.relatedItems = ""
    }
}
