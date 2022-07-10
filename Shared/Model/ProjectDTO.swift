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
    var projectAC: String?
    var projectNotes: String?
    let type: ItemType
    var status: ItemStatus
    var relatedItems: Relations
    var tags: ItemTags

    init(id: UUID,
         name: String?,
         itemDesrciption: String?,
         projectNotes: String?,
         type: ItemType,
         status: ItemStatus,
         relatedItems: Relations,
         tags: ItemTags) {
        self.id = id
        self.name = name ?? ""
        self.projectAC = itemDesrciption
        self.type = type
        self.status = status
        self.relatedItems = relatedItems
        self.tags = tags
    }

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? ""
        self.projectNotes = itemObject.itemDescriptionLong
        self.projectAC = itemObject.itemDescriptionShort
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .task
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.relatedItems = itemObject.relatedItemsData?.relations() ?? Relations()
        self.tags = itemObject.tags?.tags() ?? ItemTags()
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.projectAC = ""
        self.type = .project
        self.status = .new
        self.relatedItems = Relations()
        self.tags = ItemTags()
    }
}
