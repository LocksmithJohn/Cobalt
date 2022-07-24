//
//  NoteDTO.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import UIKit

struct NoteDTO: ItemProtocol, Identifiable {

    var id: UUID
    var name: String
    var noteDescription: String?
    var type: ItemType
    var status: ItemStatus
    var tags: ItemTags?
    var areas: FocusAreas?

    init(id: UUID,
         name: String,
         noteDescription: String?,
         type: ItemType,
         tags: ItemTags?,
         areas: FocusAreas?) {
        self.id = id
        self.name = name
        self.noteDescription = noteDescription
        self.type = type
        self.status = .new
        self.tags = tags
        self.areas = areas
    }

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? ""
        self.noteDescription = itemObject.itemDescriptionLong
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .note
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.tags = itemObject.tags?.tags() ?? ItemTags()
        self.areas = itemObject.areas?.areas() ?? FocusAreas()
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.noteDescription = ""
        self.type = .note
        self.status = .new
        self.tags = ItemTags()
        self.areas = FocusAreas()
    }
}
