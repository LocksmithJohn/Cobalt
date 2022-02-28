//
//  TaskDTO.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation
import UIKit

protocol ItemProtocol {
    var id: UUID { get set }
    var name: String { get set }
    var status: ItemStatus { get set }
}

struct Item: ItemProtocol, Identifiable {
    var id: UUID
    var name: String
    let itemDesrciption: String
    var type: ItemType
    var status: ItemStatus
    var relatedItems: String // tutaj zmienic na slownik
    
    init(id: UUID,
         name: String,
         itemDesrciption: String,
         type: ItemType,
         status: ItemStatus,
         relatedItems: String) {
        self.id = id
        self.name = name
        self.itemDesrciption = itemDesrciption
        self.type = type
        self.status = status
        self.relatedItems = relatedItems
    }

    init(itemObject: ItemObject) {
        self.init(id: itemObject.id,
                  name: itemObject.name ?? "tutaj176",
                  itemDesrciption: itemObject.itemDescription ?? "tutaj765",
                  type: ItemType(rawValue: itemObject.type ?? "") ?? .task,
                  status: ItemStatus(rawValue: itemObject.state ?? "") ?? .new,
                  relatedItems: itemObject.relatedItemsData ?? "tutaj987654")
    }

    init(_ taskDTO: TaskDTO) {
        self.id = taskDTO.id
        self.name = taskDTO.name
        self.itemDesrciption = taskDTO.itemDescription ?? ""
        self.type = taskDTO.type
        self.status = taskDTO.status
        self.relatedItems = taskDTO.relatedItems ?? ""
    }

    init(_ projectDTO: ProjectDTO) {
        self.id = projectDTO.id
        self.name = projectDTO.name
        self.itemDesrciption = projectDTO.itemDescription ?? ""
        self.type = projectDTO.type
        self.status = projectDTO.status
        self.relatedItems = projectDTO.relatedItems ?? ""
    }

    init(_ noteDTO: NoteDTO) {
        self.id = noteDTO.id
        self.name = noteDTO.name
        self.itemDesrciption = noteDTO.itemDescription ?? ""
        self.type = noteDTO.type
        self.status = .new
        self.relatedItems = ""
    }

}
