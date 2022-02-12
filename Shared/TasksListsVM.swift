//
//  TasksListsVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

final class TasksListVM: BaseVM {

    private let appstate: TasksListAppState
    private let interactor: TasksListInteractor

    init(interactor: TasksListInteractor,
         appstate: TasksListAppState) {
        self.interactor = interactor
        self.appstate = appstate
        super.init(screenType: .tasks)
    }
}
