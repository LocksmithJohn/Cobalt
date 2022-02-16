//
//  AppState.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class AppState: TasksListAppState,
                TaskDetailsAppState,
                ProjectsListAppState,
                ProjectDetailsAppState {
    var taskDetailsSubject: CurrentValueSubject<TaskDTO?, Never> {
        coreDataManager.taskSubject
    }
    var tasksListSubject: CurrentValueSubject<[TaskDTO], Never> {
        coreDataManager.tasksSubject
    }
    var projectsListSubject: CurrentValueSubject<[ProjectDTO], Never> {
        coreDataManager.projectsSubject
    }
    var projectDetailsSubject: CurrentValueSubject<ProjectDTO?, Never> {
        coreDataManager.projectSubject
    }

    var relatedItemsSubject: CurrentValueSubject<[Item], Never> {
        coreDataManager.relatedItemsSubject
    }

    var projectsReducedSubject: CurrentValueSubject<[ProjectDTOReduced], Never> {
        coreDataManager.projectsReducedSubject
    }

    let coreDataManager = CoreDataManager.shared
    var isTabbarVisibleSubject = CurrentValueSubject<Bool, Never>(true)

}

protocol TasksListAppState {
    var tasksListSubject: CurrentValueSubject<[TaskDTO], Never> { get }
}

protocol TaskDetailsAppState {
    var taskDetailsSubject: CurrentValueSubject<TaskDTO?, Never> { get }
    var projectsReducedSubject: CurrentValueSubject<[ProjectDTOReduced], Never> { get }
}

protocol ProjectsListAppState {
    var projectsListSubject: CurrentValueSubject<[ProjectDTO], Never> { get }
}

protocol ProjectDetailsAppState {
    var projectDetailsSubject: CurrentValueSubject<ProjectDTO?, Never> { get }
    var relatedItemsSubject: CurrentValueSubject<[Item], Never> { get } // tutaj ma byc ograniczone dto

}
