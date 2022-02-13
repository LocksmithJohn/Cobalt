//
//  TaskDTO.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

class Item: Identifiable {
    let id: UUID
    let name: String
    let itemDesrciption: String
    let type: ItemType
    let status: ItemStatus
    
    init(id: UUID,
         name: String,
         itemDesrciption: String,
         type: ItemType,
         status: ItemStatus) {
        self.id = id
        self.name = name
        self.itemDesrciption = itemDesrciption
        self.type = type
        self.status = status
    }

    convenience init(itemObject: ItemObject) {
        self.init(id: itemObject.id,
                  name: itemObject.name ?? "tutaj176",
                  itemDesrciption: itemObject.itemDescription ?? "tutaj765",
                  type: ItemType(rawValue: itemObject.type ?? "") ?? .task,
                  status: ItemStatus(rawValue: itemObject.state ?? "") ?? .new)
    }
}

enum ItemType: String {
    case task
    case project
    case note
    case waitFor
}

enum ItemStatus: String {
    case new
    case inProgress
    case done
}

class TaskDTO: Item {}

class ProjectDTO: Item {}
