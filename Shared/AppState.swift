//
//  AppState.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class AppState: TasksListAppState {

    let coreDataManager = CoreDataManager.shared

    var tasksSubject: CurrentValueSubject<[TaskDTO], Never> {
        coreDataManager.tasksSubject
    }


}

protocol TasksListAppState {

    var tasksSubject: CurrentValueSubject<[TaskDTO], Never> { get }

}
