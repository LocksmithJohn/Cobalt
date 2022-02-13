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

    enum Action {
        case fetchTask(id: UUID)
        case fetchTasks
        case saveTask(task: TaskDTO)
        case fetchProject(id: UUID)
        case fetchProjects
        case deleteItem(id: UUID)
    }

    static let shared = CoreDataManager()

    private init() {
        bindAction()
    }

    let projectsSubject = CurrentValueSubject<[ProjectDTO], Never>([])
    let projectSubject = CurrentValueSubject<ProjectDTO?, Never>(nil)
    let tasksSubject = CurrentValueSubject<[TaskDTO], Never>([])
    let taskSubject = CurrentValueSubject<TaskDTO?, Never>(nil)

    let syncTimeSubject = PassthroughSubject<String?, Never>()
    let actionSubject = PassthroughSubject<Action, Never>()

    var managedContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    private var dateManager = DateManager() // tutaj zle
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
            fetchProject(id: id)
        case .fetchProjects:
            fetchProjects()
        case let .saveTask(task):
            saveItem(item: task)
        case let .deleteItem(id):
            deleteItem(id: id)
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

    //    private func setFetchedResultsController(entityType: ItemType) {
    //        let className = String(describing: entityType.type.self)
    //        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: className)
    //        fetch.sortDescriptors = [NSSortDescriptor(key: entityType.mainAttributeName, ascending: true)]
    //        let resultsController = NSFetchedResultsController(fetchRequest: fetch,
    //                                                           managedObjectContext: managedContext,
    //                                                           sectionNameKeyPath: nil,
    //                                                           cacheName: nil)
    //        resultsController.delegate = self
    //        controllers.append(resultsController)
    //    }

    init(dateManager: DateManager) {
        self.dateManager = dateManager
        //        super.init()
        //        setFetchedResultsController(entityType: .project)
        //        setFetchedResultsController(entityType: .task)
        dateManager.startSyncTimer()
        bindSyncTimer()
        //        getInitialData()
        fetch()
    }

    private func fetch() {// tutaj do wyalenia?
        do { try controllers.first?.performFetch() }
        catch { fatalError() }
        do { try controllers.last?.performFetch() }
        catch { fatalError() }
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

    func fetchProject(id: UUID) {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)

        if let itemObject = try? managedContext.fetch(request).first {
            projectSubject.send(ProjectDTO(itemObject: itemObject))
        }
    }

    func fetchTasks() {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", ItemType.task.rawValue)

        if let itemObjects = try? managedContext.fetch(request) {
            tasksSubject.send(itemObjects.map { TaskDTO(itemObject: $0) })
        }
    }

    func fetchProjects() {
        let request: NSFetchRequest<ItemObject> = ItemObject.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", ItemType.project.rawValue)

        if let itemObjects = try? managedContext.fetch(request) {
            projectsSubject.send(itemObjects.map { ProjectDTO(itemObject: $0) })
        }
    }

    func saveItem(item: Item) {
        let itemObject = ItemObject(context: managedContext)
        itemObject.name = item.name
        itemObject.itemDescription = item.itemDesrciption
        itemObject.id = item.id
        itemObject.state = item.status.rawValue
        itemObject.type = item.type.rawValue
//        project.tasks.forEach {
//            let task_cd = Task_CD(context: managedContext)
//            task_cd.id = $0.id
//            task_cd.name = $0.name
//            task_cd.taskDescription = $0.description
//            project_cd.addToTask(task_cd)
//        }
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

    //    private func getInitialData() {
    //        if let projects = getItems(entityType: .project) as? [Project_CD] {
    //            projectsSubject.send(projects)
    //        }
    //        if let tasks = getItems(entityType: .task) as? [Task_CD] {
    //            tasksSubject.send(tasks)
    //        }
    //    }
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
