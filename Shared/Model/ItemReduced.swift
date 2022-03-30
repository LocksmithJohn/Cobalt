//
//  ItemReduced.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 13/03/2022.
//

import Foundation

struct ItemReduced: ItemProtocol, Identifiable {
    var id: UUID
    var name: String
    var status: ItemStatus
    var type: ItemType

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj975"
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .task
    }

    init(item: Item) {
        self.id = item.id
        self.name = item.name
        self.status = item.status
        self.type = item.type
    }
    
}
