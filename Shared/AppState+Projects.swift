//
//  AppState+Projects.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 18/02/2022.
//

import Combine
import Foundation

extension AppState: ProjectsListAppState,
                    ProjectDetailsAppState {

    var projectsListSubject: PassthroughSubject<[ProjectDTOReduced], Never> {
        coreDataManager.projectsSubject
    }
    var projectDetailsSubject: PassthroughSubject<ProjectDTO?, Never> { // tutaj wszedzie powinny byc publishery
        coreDataManager.projectSubject
    }

}

protocol ProjectsListAppState {
    var projectsListSubject: PassthroughSubject<[ProjectDTOReduced], Never> { get }
}

protocol ProjectDetailsAppState {
    var projectDetailsSubject: PassthroughSubject<ProjectDTO?, Never> { get }
//    var relatedTasksSubject: PassthroughSubject<[TaskDTOReduced], Never> { get }
    var relatedItemsSubject: PassthroughSubject<[TaskDTOReduced], Never> { get }
//    var relatedWaitForsSubject: PassthroughSubject<[TaskDTOReduced], Never> { get }
}
