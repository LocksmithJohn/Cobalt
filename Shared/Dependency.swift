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
    let appState: AppState
    let coreDataManager: CoreDataManager
//    let interactor: InteractorProtocol

    private var bag = Set<AnyCancellable>()

    @Published var routerInbox = IOS_Router()// tutaj routery chyba byly normalnie potworzone
    @Published var routerTasks = IOS_Router()
    @Published var routerProjects = IOS_Router()

    init() {
//        self.coreDataManager = CoreDataManager(dateManager: dateManager)
//        self.appState = AppState(coreDataManager: coreDataManager)
//        self.interactor = Interactor(appState: appState, coreDataManager: coreDataManager)
//        let asdf = \AppState.errors
        bindRouters()
    }

    private func bindRouters() {
        #if os(iOS)
        Publishers.Merge3(routerTasks.$screens,
                          routerProjects.$screens,
                          routerInbox.$screens)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &bag)
        #endif
    }

}
