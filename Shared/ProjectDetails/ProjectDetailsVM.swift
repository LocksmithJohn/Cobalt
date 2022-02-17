//
//  ProjectDetailsVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Combine
import Foundation
import UIKit

final class ProjectDetailsVM: BaseVM {

    enum Action {
        case onAppear
        case back
        case saveProject
        case deleteProject
        case showAddingTask
    }

    @Published var projectName: String = ""
    @Published var projectDescription: String = ""
    @Published var relatedItems: [Item] = []

    let actionSubject = PassthroughSubject<Action, Never>()

    private let appstate: ProjectDetailsAppState
    private let interactor: ProjectDetailsInteractor
    private let id: UUID
    private var newProject: ProjectDTO {

        ProjectDTO(id: UUID(),
                   name: projectName,
                   itemDesrciption: projectDescription,
                   type: .project,
                   status: .new,
                   relatedItems: "")
    }

    init(id: UUID?,
         interactor: ProjectDetailsInteractor,
         appstate: ProjectDetailsAppState) {
        self.interactor = interactor
        self.appstate = appstate
        self.id = id ?? UUID() // DOC: If this is creating project flow (not editing), create new project id here
        super.init(screenType: .projectDetails(id: id))

        bindAppState()
        bindAction()
    }

    private func bindAppState() {
        appstate.projectDetailsSubject
            .compactMap { $0 }
            .sink { [weak self] project in
                self?.projectName = project.name
                self?.projectDescription = project.itemDesrciption
            }
            .store(in: &cancellableBag)

        appstate.relatedItemsSubject
            .compactMap { $0 }
            .sink { [weak self] relatedItems in
                self?.relatedItems = relatedItems
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
            interactor.fetchProject(id: id)
            interactor.fetchRelatedItems(id: id)
        case .saveProject:
            let taskID = UUID()
            let projectID = UUID()

            let taskRelations = ItemRelation.sbt.rawValue + projectID.uuidString + ","
            let projectRelations = ItemRelation.ppr.rawValue + taskID.uuidString + ","

            let subtask = TaskDTO(id: taskID, // TODO: - tą cala logike przeniesc gdzies
                                  name: "subtask title",
                                  itemDesrciption: "subtask desc",
                                  type: .task,
                                  status: .new,
                                  relatedItems: taskRelations)

            let anotherProject = ProjectDTO(id: projectID,
                                            name: projectName,
                                            itemDesrciption: projectDescription,
                                            type: .project,
                                            status: .new,
                                            relatedItems: projectRelations)

            interactor.saveTask(subtask)
            interactor.saveProject(anotherProject)
            interactor.route(from: screenType, to: .projects)
            interactor.fetchProjects()
        case .back:
            interactor.route(from: screenType, to: .projects)
            interactor.fetchProjects()
        case .deleteProject:
            interactor.deleteProject(id: id)
            interactor.route(from: screenType, to: .projects)
        case .showAddingTask:
            interactor.route(from: screenType, to: .taskDetails(id: nil, projectID: id))
        }
    }

}

