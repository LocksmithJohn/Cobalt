//
//  CoreDataManager+Deleting.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 19/02/2022.
//

import CoreData
import Foundation

extension CoreDataManager {

    func deleteItem(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let task_cd = try? managedContext.fetch(request).first {
            managedContext.delete(task_cd)
            saveContext()
        }
    }

    func deleteAllTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemObject")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                managedContext.delete(item)
            }

            try managedContext.save()

        } catch {
        }
    }

}
