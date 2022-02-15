//
//  TaskDetailsVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Combine
import Foundation

final class TaskDetailsVM: BaseVM {

    enum Action {
        case onAppear
        case back
        case saveTask
        case deleteTask
    }

    @Published var taskName: String = ""
    @Published var taskDescription: String = ""

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: TaskDetailsAppState
    private let interactor: TaskDetailsInteractor
    private let id: UUID?
    private var newTask: TaskDTO {
        TaskDTO(id: UUID(),
                name: taskName,
                itemDesrciption: taskDescription,
                type: .task,
                status: .new,
                relatedItems: ItemIDs())
    }

    init(id: UUID?,
         interactor: TaskDetailsInteractor,
         appstate: TaskDetailsAppState) {
        self.interactor = interactor
        self.appstate = appstate
        self.id = id
        super.init(screenType: .taskDetails(id: id))

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.taskDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] task in
                self?.taskName = task.name
                self?.taskDescription = task.itemDesrciption
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
            guard let id = id else { return }

            interactor.fetchTask(id: id)
        case .saveTask:
            interactor.saveTask(newTask)
            interactor.fetchTasks()
            interactor.route(from: screenType, to: .tasks)
        case .back:
            interactor.route(from: screenType, to: .tasks)
            interactor.fetchTasks()
        case .deleteTask:
            guard let id = id else { return }

            interactor.deleteTask(id: id)
            interactor.route(from: screenType, to: .tasks)
        }
    }

}
