//
//  TaskDTOReduced.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 15/02/2022.
//

import Foundation

struct TaskDTOReduced: ItemProtocol, Identifiable {

    var id: UUID
    var name: String
    var status: ItemStatus
    var type: ItemType

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj538"
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
