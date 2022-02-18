//
//  Interactor+Projects.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Foundation

extension Interactor: ProjectsListInteractor,
                      ProjectDetailsInteractor {

    func fetchProject(id: UUID) {
        coreDataManager.actionSubject.send(.fetchProject(id: id))
    }
    func saveProject(_ project: ProjectDTO) {
        coreDataManager.actionSubject.send(.saveProject(project: project))
    }
    func deleteProject(id: UUID) {
        coreDataManager.actionSubject.send(.deleteItem(id: id))
    }
    func fetchRelatedItems(id: UUID) {
        coreDataManager.actionSubject.send(.fetchRelatedItems(id: id))
    }
    func fetchProjects() {
        coreDataManager.actionSubject.send(.fetchProjects)
    }

}

protocol ProjectsListInteractor: InteractorProtocol {
    func fetchProjects()
}


protocol ProjectDetailsInteractor: InteractorProtocol {
    func fetchProject(id: UUID)
    func fetchProjects()
    func fetchRelatedItems(id: UUID)
    func saveProject(_ project: ProjectDTO)
    func saveTask(_ task: TaskDTO)
    func deleteProject(id: UUID)
}
