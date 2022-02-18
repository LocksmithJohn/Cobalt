//
//  NoteDTO.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import UIKit

struct NoteDTO: Identifiable {

    let id: UUID
    var name: String
    var itemDescription: String?
    var type: ItemType

    init(id: UUID,
         name: String,
         itemDesrciption: String?,
         type: ItemType) {
        self.id = id
        self.name = name
        self.itemDescription = itemDesrciption
        self.type = type
    }

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? ""
        self.itemDescription = itemObject.itemDescription
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .note
    }

    init(newID: UUID) {
        self.id = newID
        self.name = ""
        self.itemDescription = ""
        self.type = .note
    }
}
