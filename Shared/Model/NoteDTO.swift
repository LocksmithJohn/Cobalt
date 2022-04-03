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

    init(id: UUID,
         name: String,
         noteDescription: String?,
         type: ItemType) {
        self.id = id
        self.name = name
        self.noteDescription = noteDescription
        self.type = type
        self.status = .new
    }

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? ""
        self.noteDescription = itemObject.itemDescriptionLong
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .note
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.noteDescription = ""
        self.type = .note
        self.status = .new
    }
}
