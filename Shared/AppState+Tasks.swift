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
    var projectsReducedSubject: MYPassthroughSubject<[ProjectDTOReduced]> {
        coreDataManager.projectsSubject
    }
    var projectReducedSubject: MYPassthroughSubject<ProjectDTOReduced?> {
        coreDataManager.projectReducedSubject
    }
    var taskDetailsSubject: MYPassthroughSubject<TaskDTO?> {
        coreDataManager.taskSubject
    }
    var tasksListSubject: MYPassthroughSubject<[TaskDTOReduced]> {
        coreDataManager.tasksSubject
    }
    
}

protocol TasksListAppState {
    var tasksListSubject: MYPassthroughSubject<[TaskDTOReduced]> { get }
}

protocol TaskDetailsAppState {
    var taskDetailsSubject: MYPassthroughSubject<TaskDTO?> { get }
    var projectsReducedSubject: MYPassthroughSubject<[ProjectDTOReduced]> { get }
    var projectReducedSubject: MYPassthroughSubject<ProjectDTOReduced?> { get }
}
