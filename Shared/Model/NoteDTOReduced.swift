//
//  NoteDTOReduced.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Foundation

struct NoteDTOReduced: ItemProtocol, Identifiable {

    var id: UUID
    var name: String
    var status: ItemStatus
    var type: ItemType

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj118"
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .note
    }

    init(item: ItemProtocol) {
        self.id = item.id
        self.name = item.name
        self.status = item.status
        self.type = item.type

    }
}
