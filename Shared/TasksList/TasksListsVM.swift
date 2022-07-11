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
        case toggleDone(id: UUID, status: ItemStatus)
    }

    @Published var allTasks: [TaskDTOReduced] = []
    @Published var nextActionTasks: [TaskDTOReduced] = []
    @Published var allDoneTasks: [TaskDTOReduced] = []
    @Published var allActiveTasks: [TaskDTOReduced] = []
    @Published var tasksDone: [TaskDTOReduced] = []
    @Published var waitingFors: [TaskDTOReduced] = []
    @Published var doneVisible = true
    @Published var filterTab: Int = 1

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
                guard let self = self else { return }

                self.allTasks = tasks
                self.waitingFors = tasks.filter { $0.type == .waitFor }
                self.nextActionTasks = tasks.filter { $0.type == .nextAction }
                self.updateListForTab(self.filterTab)
            }
            .store(in: &cancellableBag)
    }

    private func updateListForTab(_ tab: Int) {
        switch tab {
        case 0:
            allActiveTasks = waitingFors.filter { $0.status != .done }
            allDoneTasks = waitingFors.filter { $0.status == .done }
        case 1:
            allActiveTasks = nextActionTasks.filter { $0.status != .done }
            allDoneTasks = nextActionTasks.filter { $0.status == .done }
        default:
            allActiveTasks = allTasks.filter { $0.status != .done }
            allDoneTasks = allTasks.filter { $0.status == .done }
        }
    }

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)

        $filterTab
            .sink { [weak self] tab in
                guard let self = self else { return }

                self.updateListForTab(tab)
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
        case .onAppear:
            interactor.fetchTasks()
        case .addTask:
            interactor.route(from: screenType, to: .taskDetails(id: nil, projectID: nil))
        case let .goToTask(id):
            interactor.route(from: screenType, to: .taskDetails(id: id, projectID: nil))
        case let .toggleDone(id, status):
            interactor.toggleDone(id: id, status: status)
            interactor.fetchTasks()
        }
    }
}
