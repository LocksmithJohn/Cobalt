//
//  VMFactory.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

class VMFactory {
    static func tasksList(dependency: Dependency) -> TasksListVM {
        TasksListVM(interactor: dependency.interactor, appstate: dependency.appState)
    }
}
