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
        case toggleDone(task: TaskDTOReduced)
    }

    @Published var allTasks: [TaskDTOReduced] = []
    @Published var nextActionTasks: [TaskDTOReduced] = []
    @Published var visibleTasks: [TaskDTOReduced] = []
    @Published var tasksDone: [TaskDTOReduced] = []
    @Published var waitingFors: [TaskDTOReduced] = []

    @Published var filterTab: Int = 0

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
            }
            .store(in: &cancellableBag)

        $filterTab
            .sink { [weak self] filter in
                guard let self = self else { return }
                switch filter {
                case 0:
                    self.visibleTasks = self.nextActionTasks
                case 1:
                    self.visibleTasks = self.tasksDone
                default:
                    self.visibleTasks = self.allTasks
                }
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
            interactor.route(from: screenType, to: .taskDetails(id: nil, projectID: nil))
        case let .goToTask(id):
            interactor.route(from: screenType, to: .taskDetails(id: id, projectID: nil))
        case let .toggleDone(task):
            Haptic.impact(.medium)
            interactor.toggleDone(item: task)
            interactor.fetchTasks()
        }
    }

//    private func fillTasks(_ tasks: [TaskDTOReduced], tab: Int) {
//        print("filter  tab: \(tab)")
//        self.tasksNew = tasks.filter { $0.status == (tab == 0 ? .new : .done) }
//        //        tasksDone = tasks.filter { $0.status == .done }
//    }

    //    private var filteredStatus: ItemStatus {
    //        switch filter {
    //        case 0: return .new
    //        default: return .done
    //        }
    //    }
}
