//
//  CoreDataManager+Fetching.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import CoreData
import Foundation

extension CoreDataManager { // tutaj te rozszerzenia powinny byc prywatne

    func fetchItem(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let itemObject = try? managedContext.fetch(request).first {
            itemSubject.send(Item(itemObject: itemObject))
        }
    }

    func fetchItemsReduced() {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()

        if let itemObjects = try? managedContext.fetch(request) {
            itemsReducedSubject.send(itemObjects.map { ItemReduced(itemObject: $0) })
        }
    }

    func fetchItemsFiltered(phrase: String) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()

        let predicate1 = NSPredicate(format: "name CONTAINS[c] %@", phrase)
        let predicate2 = NSPredicate(format: "areas CONTAINS[c] %@", phrase)
        let predicate3 = NSPredicate(format: "itemDescriptionLong CONTAINS[c] %@", phrase)
        let predicate4 = NSPredicate(format: "itemDescriptionShort CONTAINS[c] %@", phrase)

        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates:
                                                    [predicate1, predicate2, predicate3, predicate4])

        if let itemObjects = try? managedContext.fetch(request) {
            itemsFilteredSubject.send(itemObjects.map { ItemReduced(itemObject: $0) })
        }
    }

    func fetchTask(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let itemObject = try? managedContext.fetch(request).first {
            taskSubject.send(TaskDTO(itemObject: itemObject))
        }
    }

    func fetchNote(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let itemObject = try? managedContext.fetch(request).first {
            noteSubject.send(NoteDTO(itemObject: itemObject))
        }
    }

    func fetchProject(id: UUID, reduced: Bool) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if reduced {
            if let itemObject = try? managedContext.fetch(request).first {
                projectReducedSubject.send(ProjectDTOReduced(itemObject: itemObject))
            } else {
                projectReducedSubject.send(nil)
            }
        } else {
            if let itemObject = try? managedContext.fetch(request).first {
                projectSubject.send(ProjectDTO(itemObject: itemObject))
            }
        }
    }

    func fetchTasks() {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        let predicate1 = NSPredicate(format: "type == %@", ItemType.task.rawValue)
        let predicate2 = NSPredicate(format: "type == %@", ItemType.waitFor.rawValue)
        let predicate3 = NSPredicate(format: "type == %@", ItemType.nextAction.rawValue)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3])

        if let itemObjects = try? managedContext.fetch(request) {
            tasksSubject.send(itemObjects.map { TaskDTOReduced(itemObject: $0) })
        }
    }

    func fetchNotes() {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", ItemType.note.rawValue)

        if let itemObjects = try? managedContext.fetch(request) {
            notesSubject.send(itemObjects.map { NoteDTOReduced(itemObject: $0) })
        }
    }

    func fetchAreasFor(id: UUID) { // tutaj sciagan obszary dla konkretnego itema
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "areas CONTAINS %@", id.uuidString)

        if let itemObjects = try? managedContext.fetch(request) {
            //            areasSubject.send(itemObjects.map { FocusAreas( })
            relatedItemsSubject.send(itemObjects.map { Item(itemObject: $0) })
        }
    }

//    func fetchItem(id: UUID) {
//        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
//
//        if let itemObject = try? managedContext.fetch(request).first {
//            itemSubject.send(Item(itemObject: itemObject))
//        }
//    }


    func fetchMyAreas() {
        let request: NSFetchRequest<AreasObject> = AreasObject.fetchRequest()

        if let areasObject = try? managedContext.fetch(request).first {
            print("filter 2")
            areasSubject.send(FocusAreas(areasObject: areasObject) )
        }
    }

    func fetchRelatedItems(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "relatedItemsData CONTAINS %@", id.uuidString)

        if let itemObjects = try? managedContext.fetch(request) {
            relatedItemsSubject.send(itemObjects.map { Item(itemObject: $0) })
        }
    }

    func fetchProjects() {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", ItemType.project.rawValue)

        if let itemObjects = try? managedContext.fetch(request) {
                projectsSubject.send(itemObjects.map { ProjectDTOReduced(itemObject: $0) })
        }
    }
}
