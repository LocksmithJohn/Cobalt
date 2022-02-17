//
//  TaskDTOReduced.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 15/02/2022.
//

import Foundation

struct TaskDTOReduced: Identifiable {

    let id: UUID
    let name: String

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj538"
    }

    init(item: Item) {
        self.id = item.id
        self.name = item.name ?? "tutaj789"
    }
}
