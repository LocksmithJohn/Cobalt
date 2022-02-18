//
//  CoreDataManager+Fetching.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import CoreData
import Foundation

extension CoreDataManager {

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
        request.predicate = NSPredicate(format: "type == %@", ItemType.task.rawValue)

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
