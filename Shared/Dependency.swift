//
//  Dependency.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import SwiftUI

class Dependency: ObservableObject {

//    let dateManager = DateManager()
    let interactor = Interactor()
    let appState = AppState()

    private var bag = Set<AnyCancellable>()

    @Published var notesRouter = Router()// tutaj routery chyba byly normalnie potworzone
    @Published var tasksRouter = Router()
    @Published var projectsRouter = Router()

    init() {
//        self.coreDataManager = CoreDataManager(dateManager: dateManager)
//        self.appState = AppState(coreDataManager: coreDataManager)
//        self.interactor = Interactor(appState: appState, coreDataManager: coreDataManager)
//        let asdf = \AppState.errors
        bindRouters()
    }

    private func bindRouters() {
        #if os(iOS)
        Publishers.Merge3(notesRouter.$screens,
                          tasksRouter.$screens,
                          projectsRouter.$screens)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &bag)
        #endif
    }

}
