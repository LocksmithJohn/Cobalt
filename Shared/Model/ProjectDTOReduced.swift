//
//  ProjectDTOReduced.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 16/02/2022.
//

import Foundation

struct ProjectDTOReduced: Identifiable {

    let id: UUID
    let name: String

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj538"
    }
}
