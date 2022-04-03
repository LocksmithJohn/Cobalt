//
//  ProjectDTOReduced.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 16/02/2022.
//

import Foundation

struct ProjectDTOReduced: ItemProtocol, Identifiable {

    var id: UUID
    var name: String
    var status: ItemStatus

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj538"
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
    }

    init() {
        self.id = UUID()
        self.name = "Znaleźć ofertę internetu mobilnego dla kart sim oraz esim tutaj"
        self.status = .inProgress
    }
}
