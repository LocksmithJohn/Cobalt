//
//  TaskDTO.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation
import UIKit

class Item: Identifiable { // tutaj zmeinic na strukture
    let id: UUID
    let name: String
    let itemDesrciption: String
    let type: ItemType
    let status: ItemStatus
    var relatedItems: ItemIDs
    
    init(id: UUID,
         name: String,
         itemDesrciption: String,
         type: ItemType,
         status: ItemStatus,
         relatedItems: ItemIDs) {
        self.id = id
        self.name = name
        self.itemDesrciption = itemDesrciption
        self.type = type
        self.status = status
        self.relatedItems = relatedItems
    }

    convenience init(itemObject: ItemObject) {
        self.init(id: itemObject.id,
                  name: itemObject.name ?? "tutaj176",
                  itemDesrciption: itemObject.itemDescription ?? "tutaj765",
                  type: ItemType(rawValue: itemObject.type ?? "") ?? .task,
                  status: ItemStatus(rawValue: itemObject.state ?? "") ?? .new,
                  relatedItems: dataToItemsID(data: itemObject.relatedItemsData))
    }

    func updateRelatedItems(itemIDs: ItemIDs) {
        guard let id = itemIDs.ids.first else {
            return
        }
        self.relatedItems.ids.append(id)
        print("")
    }
}

enum ItemType: String {
    case task
    case project
    case note
    case waitFor
}