//
//  CoreDataManager+Editing.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 19/02/2022.
//

import CoreData
import Foundation

extension CoreDataManager {
    func editItem(id: UUID, newItem: Item) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let itemObject = try? managedContext.fetch(request).first {
            itemObject.name = newItem.name
            itemObject.itemDescription = newItem.itemDesrciption
            itemObject.id = id
            itemObject.state = newItem.status.rawValue
            itemObject.type = newItem.type.rawValue
            itemObject.relatedItemsData = newItem.relatedItems
            saveContext()
        }
    }

}

