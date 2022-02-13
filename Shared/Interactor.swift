//
//  Interactor.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class Interactor: TasksListInteractor, TaskDetailsInteractor {

    let coreDataManager = CoreDataManager.shared
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func fetchTasks() {
        coreDataManager.actionSubject.send(.fetchTasks)
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

extension TasksListInteractor {
    func fetchTasks() {
        coreDataManager.actionSubject.send(.fetchTasks)
    }
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
    func fetchTasks() {
        coreDataManager.actionSubject.send(.fetchTasks)
    }
}
