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
    let itemDescriptionShort: String
    let itemDescriptionLong: String
    var type: ItemType
    var status: ItemStatus
    var relatedItems: Relations
    
    init(id: UUID,
         name: String,
         itemDescriptionShort: String,
         itemDescriptionLong: String,
         type: ItemType,
         status: ItemStatus,
         relatedItems: Relations?) {
        self.id = id
        self.name = name
        self.itemDescriptionShort = itemDescriptionShort
        self.itemDescriptionLong = itemDescriptionLong
        self.type = type
        self.status = status
        self.relatedItems = relatedItems ?? Relations()
    }

    init(itemObject: ItemObject) {
        self.init(id: itemObject.id,
                  name: itemObject.name ?? "tutaj176",
                  itemDescriptionShort: itemObject.itemDescriptionShort ?? "tutaj765",
                  itemDescriptionLong: itemObject.itemDescriptionLong ?? "tutaj765",
                  type: ItemType(rawValue: itemObject.type ?? "") ?? .task,
                  status: ItemStatus(rawValue: itemObject.state ?? "") ?? .new,
                  relatedItems: itemObject.relatedItemsData?.relations())
    }

    init(_ taskDTO: TaskDTO) {
        self.id = taskDTO.id
        self.name = taskDTO.name
        self.itemDescriptionLong = taskDTO.taskDescription ?? ""
        self.itemDescriptionShort = ""
        self.type = taskDTO.type
        self.status = taskDTO.status
        self.relatedItems = taskDTO.relatedItems
    }

    init(_ projectDTO: ProjectDTO) {
        self.id = projectDTO.id
        self.name = projectDTO.name
        self.itemDescriptionLong = projectDTO.projectNotes ?? ""
        self.itemDescriptionShort = projectDTO.projectAC ?? ""
        self.type = projectDTO.type
        self.status = projectDTO.status
        self.relatedItems = projectDTO.relatedItems
    }

    init(_ noteDTO: NoteDTO) {
        self.id = noteDTO.id
        self.name = noteDTO.name
        self.itemDescriptionShort = noteDTO.noteDescription ?? ""
        self.itemDescriptionLong = ""
        self.type = noteDTO.type
        self.status = .new
        self.relatedItems = Relations()
    }

}
