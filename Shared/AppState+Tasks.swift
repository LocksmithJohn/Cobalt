//
//  AppState+Tasks.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Combine
import Foundation

extension AppState: TasksListAppState,
                    TaskDetailsAppState {
    var projectsReducedSubject: PassthroughSubject<[ProjectDTOReduced], Never> {
        coreDataManager.projectsSubject
    }
    var projectReducedSubject: PassthroughSubject<ProjectDTOReduced?, Never> {
        coreDataManager.projectReducedSubject
    }
    var taskDetailsSubject: PassthroughSubject<TaskDTO?, Never> {
        coreDataManager.taskSubject
    }
    var tasksListSubject: PassthroughSubject<[TaskDTOReduced], Never> {
        coreDataManager.tasksSubject
    }
    
}

protocol TasksListAppState {
    var tasksListSubject: PassthroughSubject<[TaskDTOReduced], Never> { get }
}

protocol TaskDetailsAppState {
    var taskDetailsSubject: PassthroughSubject<TaskDTO?, Never> { get }
    var projectsReducedSubject: PassthroughSubject<[ProjectDTOReduced], Never> { get }
    var projectReducedSubject: PassthroughSubject<ProjectDTOReduced?, Never> { get }
}
