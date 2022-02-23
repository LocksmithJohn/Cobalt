//
//  Dependency.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import SwiftUI

class Dependency: ObservableObject {

    let appState = AppState()

    private var bag = Set<AnyCancellable>()

    @Published var notesRouter = Router(type: .notes)
    @Published var tasksRouter = Router(type: .tasks)
    @Published var projectsRouter = Router(type: .projects)

    var routersWrapper: RouterWrapper?

    init() {
        bindRouters()
        routersWrapper = RouterWrapper(routers: [notesRouter, tasksRouter, projectsRouter])
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
