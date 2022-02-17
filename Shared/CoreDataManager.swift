//
//  CoreDataManager.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import CoreData
import Foundation
import SwiftUI

class CoreDataManager {

    enum Action {
        case saveTask(task: TaskDTO)
        case fetchTask(id: UUID)
        case fetchTasks

        case saveProject(project: ProjectDTO)
        case fetchProject(id: UUID)
        case fetchProjects
        case fetchProjectReduced(id: UUID)
        case fetchProjectsReduced

        case deleteItem(id: UUID)
        case fetchRelatedItems(id: UUID)
    }

    static let shared = CoreDataManager()

    private init() {
        bindAction()
    }

    let projectSubject = PassthroughSubject<ProjectDTO?, Never>()
    let projectsSubject = PassthroughSubject<[ProjectDTO], Never>()
    let projectReducedSubject = PassthroughSubject<ProjectDTOReduced?, Never>()
    let projectsReducedSubject = PassthroughSubject<[ProjectDTOReduced], Never>()

    let taskSubject = PassthroughSubject<TaskDTO?, Never>()
    let tasksSubject = PassthroughSubject<[TaskDTO], Never>()

    let relatedItemsSubject = PassthroughSubject<[Item], Never>()

    let syncTimeSubject = PassthroughSubject<String?, Never>()
    let actionSubject = PassthroughSubject<Action, Never>()

    var managedContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    private var dateManager = DateManager() // TODO:  zle
    private var controllers: [NSFetchedResultsController<NSFetchRequestResult>] = []
    private var cancellableBag = Set<AnyCancellable>()

    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
        case let .fetchTask(id):
            fetchTask(id: id)
        case .fetchTasks:
            fetchTasks()
        case let .fetchProject(id):
            fetchProject(id: id, reduced: false)
        case .fetchProjects:
            fetchProjects(reduced: false)
        case let .saveTask(task):
            saveItem(item: Item(task))
        case let .deleteItem(id):
            deleteItem(id: id)
        case let .saveProject(project: project):
            saveItem(item: Item(project))
        case let .fetchRelatedItems(id):
            fetchRelatedItems(id: id)
        case .fetchProjectsReduced:
            fetchProjects(reduced: true)
        case let .fetchProjectReduced(id: id):
            fetchProject(id: id, reduced: true)
        }
    }

    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    init(dateManager: DateManager) {
        self.dateManager = dateManager
        dateManager.startSyncTimer()
        bindSyncTimer()
    }

    private func bindSyncTimer() {
        dateManager.timerPublisher?
            .sink(receiveValue: { [weak self] timeValue in
                self?.syncTimeSubject.send(timeValue)
            })
            .store(in: &cancellableBag)
    }

    func fetchTask(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let itemObject = try? managedContext.fetch(request).first {
            taskSubject.send(TaskDTO(itemObject: itemObject))
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
            tasksSubject.send(itemObjects.map { TaskDTO(itemObject: $0) })
        }
    }

    func fetchRelatedItems(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "relatedItemsData CONTAINS %@", id.uuidString)

        if let itemObjects = try? managedContext.fetch(request) {
            relatedItemsSubject.send(itemObjects.map { Item(itemObject: $0) })
        }
    }

    func fetchProjects(reduced: Bool) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", ItemType.project.rawValue)

        if let itemObjects = try? managedContext.fetch(request) {
            if reduced {
                projectsReducedSubject.send(itemObjects.map { ProjectDTOReduced(itemObject: $0) })
            } else {
                projectsSubject.send(itemObjects.map { ProjectDTO(itemObject: $0) })
            }
        }
    }

    func saveItem(item: Item) {
        let itemObject = ItemObject(context: managedContext)
        itemObject.name = item.name
        itemObject.itemDescription = item.itemDesrciption
        itemObject.id = item.id
        itemObject.state = item.status.rawValue
        itemObject.type = item.type.rawValue
        itemObject.relatedItemsData = item.relatedItems
        saveContext()
    }

    func deleteItem(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let task_cd = try? managedContext.fetch(request).first {
            managedContext.delete(task_cd)
            saveContext()
        }
    }
}
