//
//  VMFactory.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

class VMFactory {
    static func tasksList(_ dependency: Dependency) -> TasksListVM {
        TasksListVM(interactor: Interactor(router: dependency.tasksRouter),
                    appstate: dependency.appState)
    }
    static func taskDetails(_ dependency: Dependency, id: UUID?) -> TaskDetailsVM {
        TaskDetailsVM(id: id, interactor: Interactor(router: dependency.tasksRouter),
                      appstate: dependency.appState)
    }
    static func projectsList(_ dependency: Dependency) -> ProjectsListVM {
        ProjectsListVM(interactor: Interactor(router: dependency.projectsRouter),
                       appstate: dependency.appState)
    }
    static func projectDetails(_ dependency: Dependency, id: UUID?) -> ProjectDetailsVM {
        ProjectDetailsVM(id: id, interactor: Interactor(router: dependency.projectsRouter),
                         appstate: dependency.appState)
    }
}
