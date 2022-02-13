//
//  Interactor.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class Interactor: TasksListInteractor,
                  TaskDetailsInteractor,
                  ProjectsListInteractor,
                  ProjectDetailsInteractor {

    let coreDataManager = CoreDataManager.shared
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func fetchTasks() {
        coreDataManager.actionSubject.send(.fetchTasks)
    }

    func fetchProjects() {
        coreDataManager.actionSubject.send(.fetchProjects)
    }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        router.route(from: typeFrom, to: typeTo)
    }

}

protocol CommonInteractor {
    var coreDataManager: CoreDataManager { get }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType)
}

protocol TasksListInteractor: CommonInteractor {
    func fetchTasks()
}

protocol TaskDetailsInteractor: CommonInteractor {
    func fetchTask(id: UUID)
    func fetchTasks()
    func saveTask(_ task: TaskDTO)
    func deleteTask(id: UUID)
}

extension TaskDetailsInteractor {
    func fetchTask(id: UUID) {
        coreDataManager.actionSubject.send(.fetchTask(id: id))
    }
    func saveTask(_ task: TaskDTO) {
        coreDataManager.actionSubject.send(.saveTask(task: task))
    }
    func deleteTask(id: UUID) {
        coreDataManager.actionSubject.send(.deleteItem(id: id))
    }
}

protocol ProjectsListInteractor: CommonInteractor {
    func fetchProjects()
}


protocol ProjectDetailsInteractor: CommonInteractor {
    func fetchProject(id: UUID)
    func fetchProjects()
    func saveProject(_ project: ProjectDTO)
    func deleteProject(id: UUID)}

extension ProjectDetailsInteractor {
    func fetchProject(id: UUID) {
        coreDataManager.actionSubject.send(.fetchProject(id: id))
    }
    func saveProject(_ project: ProjectDTO) {
        coreDataManager.actionSubject.send(.saveProject(project: project))
    }
    func deleteProject(id: UUID) {
        coreDataManager.actionSubject.send(.deleteItem(id: id))
    }
}
