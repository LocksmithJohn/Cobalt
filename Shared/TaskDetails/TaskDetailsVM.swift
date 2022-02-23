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
        case selectedProject(id: UUID)
    }

    @Published var taskName: String = ""
    @Published var taskDescription: String = ""

    @Published var projects: [ProjectDTOReduced] = []
    @Published var relatedProject: ProjectDTOReduced?

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: TaskDetailsAppState
    private let interactor: TaskDetailsInteractor
    private let id: UUID?
    private var projectID: UUID?
    private var newTask = TaskDTO(newID: UUID()) // TODO: different solution tha in ProjectDetailsVM
    private let isCreating: Bool

    init(id: UUID?,
         projectID: UUID?,
         interactor: TaskDetailsInteractor,
         appstate: TaskDetailsAppState) {
        self.isCreating = id == nil
        self.interactor = interactor
        self.appstate = appstate
        self.id = id
        self.projectID = projectID
        super.init(screenType: .taskDetails(id: id, projectID: projectID))

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.taskDetailsSubject // TODO: - czemu ten subject leci 2 razy
            .compactMap { $0 }
            .sink { [weak self] task in
                self?.taskName = task.name
                self?.taskDescription = task.itemDescription ?? ""
                if let projectID = task.relatedItems?.getUUIDs().first?.id { // TODO: - ta operacje nie moze byc tutaj
                    self?.projectID = projectID
                    self?.interactor.fetchProjectReduced(id: projectID) // TODO: - interactor musi byc w akcjach
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
            if let id = id {
                interactor.fetchTask(id: id)
            }
            interactor.fetchProjectsReduced()
        case .saveTask:
            writeTaskValues()
            interactor.saveTask(newTask)
            if let projectID = projectID {
                interactor.fetchRelatedItems(id: projectID)
            }
            interactor.fetchTasks() // tutaj zaciągac tylko taski reduced, tylko jezeli wiem ze wracam naliste taskow
            interactor.route(from: screenType, to: .tasks)
        case .back:
            if let projectID = projectID {
                interactor.route(from: screenType, to: .projectDetails(id: projectID))
            } else {
                interactor.route(from: screenType, to: .tasks)
            }
            interactor.fetchTasks()
        case .deleteTask:
            guard let id = id else { return }

            interactor.deleteTask(id: id)
            interactor.route(from: screenType, to: .tasks)
        case let .selectedProject(id):
            projectID = id
        }
    }

    private func writeTaskValues() {
        addSbtRelation() // tutaj to sie wykonuje tylko dla istniejacego parent projectu
        newTask.name = taskName // zapisywanie taska wyniesc stąd
        newTask.itemDescription = taskDescription
    }

    private func addSbtRelation() {
        guard let projectIDString = projectID?.uuidString else { return }

        newTask.relatedItems = ItemRelation.sbt.rawValue + projectIDString + ","
    }

}
