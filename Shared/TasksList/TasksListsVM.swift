//
//  TasksListsVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

final class TasksListVM: BaseVM {

    enum Action {
        case onAppear
        case addTask
        case goToTask(id: UUID)
    }

    @Published var tasks: [TaskDTO] = []

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: TasksListAppState
    private let interactor: TasksListInteractor

    init(interactor: TasksListInteractor,
         appstate: TasksListAppState) {
        self.interactor = interactor
        self.appstate = appstate
        super.init(screenType: .tasks)

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.tasksListSubject
            .sink { [weak self] tasks in
                self?.tasks = tasks
            }
            .store(in: &cancellableBag)
    }

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
        case .onAppear:
            interactor.fetchTasks()
        case .addTask:
            interactor.route(from: screenType, to: .taskDetails(id: nil))
        case let .goToTask(id):
            interactor.route(from: screenType, to: .taskDetails(id: id))
        }
    }
}
