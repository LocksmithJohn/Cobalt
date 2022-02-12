//
//  CoreDataManager.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import CoreData
import Foundation

class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    let projectsSubject = CurrentValueSubject<[ProjectDTO], Never>([])
    let projectSubject = CurrentValueSubject<ProjectDTO?, Never>()
    let tasksSubject = CurrentValueSubject<[TaskDTO], Never>([])
    let taskSubject = CurrentValueSubject<TaskDTO?, Never>()

    let syncTimeSubject = PassthroughSubject<String?, Never>()

    var managedContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    private let dateManager: DateManager
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

    private func setFetchedResultsController(entityType: EntityType) {
        let className = String(describing: entityType.type.self)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        fetch.sortDescriptors = [NSSortDescriptor(key: entityType.mainAttributeName, ascending: true)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetch,
                                                           managedObjectContext: managedContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        resultsController.delegate = self
        controllers.append(resultsController)
    }

    init(dateManager: DateManager) {
        self.dateManager = dateManager
        super.init()
        setFetchedResultsController(entityType: .project)
        setFetchedResultsController(entityType: .task)
        dateManager.startSyncTimer()
        bindSyncTimer()
        getInitialData()
        fetch()
    }

    func fetch() {
        do {
            try controllers.first?.performFetch()
        } catch {
            fatalError()
        }
        do {
            try controllers.last?.performFetch()
        } catch {
            fatalError()
        }
    }

    private func bindSyncTimer() {
        dateManager.timerPublisher?
            .sink(receiveValue: { [weak self] timeValue in
                self?.syncTimeSubject.send(timeValue)
            })
            .store(in: &cancellableBag)
    }

    private func getInitialData() {
        if let projects = getItems(entityType: .project) as? [Project_CD] {
            projectsSubject.send(projects)
        }
        if let tasks = getItems(entityType: .task) as? [Task_CD] {
            tasksSubject.send(tasks)
        }
    }
}



//extension CoreDataManager: NSFetchedResultsControllerDelegate {
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        switch controller.fetchRequest.entity?.name {
//        case String(describing: Project_CD.self):
//            guard let projects = controller.fetchedObjects,
//                  let projects = projects as? [Project_CD] else {
//
//                      projectsSubject.send(completion: .failure(.fetchEntity(type: .project)))
//                      return
//                  }
//            projectsSubject.send(projects)
//        case String(describing: Task_CD.self):
//            guard let tasks = controller.fetchedObjects,
//                  let tasks = tasks as? [Task_CD] else {
//                      tasksSubject.send(completion: .failure(.fetchEntity(type: .task)))
//                      return
//                  }
//            tasksSubject.send(tasks)
//        default:
//            return
//        }
//        dateManager.updateDate()
//    }
//
//}
