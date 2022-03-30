//
//  VMFactory.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

class VMFactory {
    static func tasksList(_ dependency: Dependency, router: Router) -> TasksListVM {
        TasksListVM(interactor: Interactor(router: router),
                    appstate: dependency.appState)
    }
    static func taskDetails(_ dependency: Dependency, id: UUID?, projectID: UUID?, router: Router) -> TaskDetailsVM {
        TaskDetailsVM(id: id, projectID: projectID, interactor: Interactor(router: router),
                      appstate: dependency.appState)
    }
    static func projectsList(_ dependency: Dependency, router: Router) -> ProjectsListVM {
        ProjectsListVM(interactor: Interactor(router: router),
                       appstate: dependency.appState)
    }
    static func projectDetails(_ dependency: Dependency, id: UUID?, router: Router) -> ProjectDetailsVM {
        ProjectDetailsVM(id: id, interactor: Interactor(router: router),
                         appstate: dependency.appState)
    }
    static func noteDetails(_ dependency: Dependency, id: UUID?, router: Router) -> NoteDetailsVM {
        NoteDetailsVM(id: id, interactor: Interactor(router: router),
                      appstate: dependency.appState)
    }
    static func notesList(_ dependency: Dependency, router: Router) -> NotesListVM {
        NotesListVM(interactor: Interactor(router: router),
                    appstate: dependency.appState)
    }

    static func more(_ dependency: Dependency, router: Router) -> MoreVM {
        MoreVM(interactor: Interactor(router: router), appstate: dependency.appState)
    }

    static func search(_ dependency: Dependency, router: Router) -> SearchVM {
        SearchVM(interactor: Interactor(router: router), appstate: dependency.appState)
    }
}
