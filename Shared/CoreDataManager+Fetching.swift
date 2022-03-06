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

        if let itemObject = try? managedContext.fetch(request).first {
            if reduced {
                projectReducedSubject.send(ProjectDTOReduced(itemObject: itemObject))
            } else {
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

    func fetchRelatedItems(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "relatedItemsData CONTAINS %@", id.uuidString)

        if let itemObjects = try? managedContext.fetch(request) {
            itemObjects.forEach { object in
                print("filter fetched related item: \(object.name)")
            }
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
