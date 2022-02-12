//
//  Interactor.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class Interactor: TasksListInteractor {

    private let coreDataManager = CoreDataManager.shared

}

protocol TasksListInteractor {
//    var tasksSubject: PassthroughSubject<[TaskDTO], Never> { get }
    func fetchTasks()
}

extension TasksListInteractor {
    func fetchTasks() {
        coreDataManager.fetchTa
    }
}
