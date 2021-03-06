//
//  CoreDataManager+Saving.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 19/02/2022.
//

import Foundation

extension CoreDataManager {
    func saveItem(item: Item) {
        let itemObject = ItemObject(context: managedContext)
        itemObject.name = item.name
        itemObject.itemDescriptionShort = item.itemDescriptionShort
        itemObject.itemDescriptionLong = item.itemDescriptionLong
        itemObject.id = item.id
        itemObject.state = item.status.rawValue
        itemObject.type = item.type.rawValue
        itemObject.relatedItemsData = item.relatedItems.textData()
        saveContext()
    }

    func saveAreas(focusAreas: FocusAreas) {
        let areasObject = AreasObject(context: managedContext)
        areasObject.areas = focusAreas.textData()
        saveContext()
    }

}
