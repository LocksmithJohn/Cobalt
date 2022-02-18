//
//  Interactor+Tasks.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Foundation

extension Interactor: TaskDetailsInteractor,
                      TasksListInteractor {

    func fetchTask(id: UUID) {
        coreDataManager.actionSubject.send(.fetchTask(id: id))
    }
    func saveTask(_ task: TaskDTO) {
        coreDataManager.actionSubject.send(.saveTask(task: task))
    }
    func deleteTask(id: UUID) {
        coreDataManager.actionSubject.send(.deleteItem(id: id))
    }
    func fetchProjectsReduced() {
        coreDataManager.actionSubject.send(.fetchProjects)
    }
    func fetchProjectReduced(id: UUID) {
        coreDataManager.actionSubject.send(.fetchProjectReduced(id: id))
    }
    func fetchTasks() {
        coreDataManager.actionSubject.send(.fetchTasks)
    }

}

protocol TasksListInteractor: InteractorProtocol {
    func fetchTasks()
}

protocol TaskDetailsInteractor: InteractorProtocol {
    func fetchTask(id: UUID)
    func fetchTasks()
    func saveTask(_ task: TaskDTO)
    func fetchProjectsReduced()
    func fetchProjectReduced(id: UUID)
    func deleteTask(id: UUID)
    func fetchRelatedItems(id: UUID)
}
