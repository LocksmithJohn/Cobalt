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

    func fetchTasks() {
        coreDataManager.actionSubject.send(.fetchTasks)
    }

}

protocol TasksListInteractor {
    func fetchTasks()
}
//
//extension TasksListInteractor {
//
//}
