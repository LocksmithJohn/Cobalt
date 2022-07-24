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
    var type: ItemType

    init(itemObject: ItemObject) {
        self.id = itemObject.id
        self.name = itemObject.name ?? "tutaj538"
        self.status = ItemStatus(rawValue: itemObject.state ?? "") ?? .new
        self.type = ItemType(rawValue: itemObject.type ?? "") ?? .project
    }

    init(item: ItemProtocol) {
        self.id = item.id
        self.name = item.name
        self.status = item.status
        self.type = item.type
    }

    init(name: String) { // tutaj do poprawy
        self.id = UUID()
        self.name = name
        self.status = .new
        self.type = .project
    }
    
    init() {
        self.id = UUID()
        self.name = "Znaleźć ofertę internetu mobilnego dla kart sim oraz esim tutaj"
        self.status = .inProgress
        self.type = .project
    }
}
