//
//  ProjectDTO.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Foundation

struct ProjectDTO: ItemProtocol, Identifiable {

    var id: UUID
    var name: String
    var itemDescription: String?
    let type: ItemType
    var status: ItemStatus
    var relatedItems: Relations

    init(id: UUID,
         name: String?,
         itemDesrciption: String?,
         type: ItemType,
         status: ItemStatus,
         relatedItems: Relations) {
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
        self.relatedItems = itemObject.relatedItemsData?.relations() ?? Relations()
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.itemDescription = ""
        self.type = .project
        self.status = .new
        self.relatedItems = Relations()
    }
}
