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
            itemObject.itemDescriptionLong = newItem.itemDescriptionLong
            itemObject.itemDescriptionShort = newItem.itemDescriptionShort
            itemObject.id = id
            itemObject.state = newItem.status.rawValue
            itemObject.type = newItem.type.rawValue
            itemObject.areas = newItem.areas.textData()
            print("filter areas 2: \(itemObject.areas)")
            itemObject.relatedItemsData = newItem.relatedItems.textData()
            saveContext()
        }
    }

    func editAreas(id: UUID, areas: String) {
        editItem(id: id, areas: areas)
    }

    func editItem(id: UUID,
                  status: ItemStatus? = nil,
                  type: ItemType? = nil,
                  tags: String? = nil,
                  areas: String? = nil) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let itemObject = try? managedContext.fetch(request).first {
            itemObject.id = id
            if let status = status {
                itemObject.state = status.rawValue
            }
            if let type = type {
                itemObject.type = type.rawValue
            }
            if let tags = tags {
                itemObject.tags = tags
            }
            if let areas = areas {
                itemObject.areas = areas
            }
            saveContext()
        }
    }

    func deleteArea(name: String) {
        var focusAreas = FocusAreas()
        let request: NSFetchRequest<AreasObject> = AreasObject.fetchRequest()

        if let areasObject = try? managedContext.fetch(request).first {
            focusAreas = FocusAreas(areasObject: areasObject)
            focusAreas.deleteArea(areaName: name)

            areasObject.areas = focusAreas.textData()
            saveContext()
        }
    }

    func addArea(name: String) {
        var focusAreas = FocusAreas()
        let request: NSFetchRequest<AreasObject> = AreasObject.fetchRequest()

        if let areasObject = try? managedContext.fetch(request).first {
            focusAreas = FocusAreas(areasObject: areasObject)
            focusAreas.addArea(area: name)

            areasObject.areas = focusAreas.textData()
            saveContext()
        }
    }

}

