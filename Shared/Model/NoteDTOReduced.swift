//
//  NoteDTOReduced.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Foundation

struct NoteDTOReduced: Identifiable {

    let id: UUID
    let name: String

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj118"
    }

    init(item: Item) {
        self.id = item.id
        self.name = item.name
    }
}
