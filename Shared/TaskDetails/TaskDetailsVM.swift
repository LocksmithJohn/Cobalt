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

    @Published var taskName: String = "" {
        didSet {
            print("life taskName: \(taskName)")
        }
    }
    @Published var taskDescription: String = ""

    @Published var projects: [ProjectDTOReduced] = []
    @Published var relatedProject: ProjectDTOReduced?

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: TaskDetailsAppState
    private let interactor: TaskDetailsInteractor
    private let id: UUID?
    //    private var relatedProjectID: UUID?

    private var newTask: TaskDTO {
        TaskDTO(id: UUID(),
                name: taskName,
                itemDesrciption: taskDescription,
                type: .task,
                status: .new,
                relatedItems: "")
    }

    init(id: UUID?,
         relatedProjectID: UUID?,
         interactor: TaskDetailsInteractor,
         appstate: TaskDetailsAppState) {
        self.interactor = interactor
        self.appstate = appstate
        self.id = id
        //        self.relatedProjectID = relatedProjectID
        super.init(screenType: .taskDetails(id: id, relatedProjectID: UUID(uuidString: "tutaj wywalic to? ")))

        bindAppState()
        bindAction()
        print("life TaskDetailsVM: init")
    }

    deinit{
        print("life TaskDetailsVM: deinit")
    }

    private func bindAppState() {
        appstate.taskDetailsSubject // tutaj czemu ten subject leci 2 razy
            .compactMap { $0 }
            .sink { [weak self] task in
                self?.taskName = task.name
                self?.taskDescription = task.itemDesrciption
                print("filter getUUIDs 1: \(task.relatedItems)")
                print("filter getUUIDs 2: \(task.relatedItems.getUUIDs())")
                if let relatedProjectID = task.relatedItems.getUUIDs().first?.id {
                    self?.interactor.fetchProjectReduced(id: relatedProjectID) // tutaj interactor musi byc w akcjach
                }
            }
            .store(in: &cancellableBag)
        appstate.projectsReducedSubject
            .compactMap { $0 }
            .sink { [weak self] projects in
                self?.projects = projects
            }
            .store(in: &cancellableBag)
        appstate.projectReducedSubject
            .compactMap { $0 }
            .sink { [weak self] relatedProject in
                self?.relatedProject = relatedProject
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
            interactor.fetchProjectsReduced()
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
