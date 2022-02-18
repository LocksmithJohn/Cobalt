//
//  AppState.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class AppState: TasksListAppState,
                TaskDetailsAppState,
                ProjectsListAppState,
                ProjectDetailsAppState {
    var taskDetailsSubject: PassthroughSubject<TaskDTO?, Never> {
        coreDataManager.taskSubject
    }
    var tasksListSubject: PassthroughSubject<[TaskDTO], Never> {
        coreDataManager.tasksSubject
    }
    var projectsListSubject: PassthroughSubject<[ProjectDTO], Never> {
        coreDataManager.projectsSubject
    }
    var projectDetailsSubject: PassthroughSubject<ProjectDTO?, Never> { // tutaj wszedzie powinny byc publishery
        coreDataManager.projectSubject
    }

    let relatedTasksSubject = MYPassthroughSubject<[TaskDTOReduced]>()
    var cancellableBag = Set<AnyCancellable>()

    init() {
        coreDataManager.relatedItemsSubject
            .map { myitems -> [TaskDTOReduced] in
                myitems.map { TaskDTOReduced(item: $0) }
            }
            .sink { [weak self] tasksReduced in
                self?.relatedTasksSubject.send(tasksReduced)
            }
            .store(in: &cancellableBag)
    }


    var projectsReducedSubject: PassthroughSubject<[ProjectDTOReduced], Never> {
        coreDataManager.projectsReducedSubject
    }

    var projectReducedSubject: PassthroughSubject<ProjectDTOReduced?, Never> {
        coreDataManager.projectReducedSubject
    }

    let coreDataManager = CoreDataManager.shared
    var isTabbarVisibleSubject = CurrentValueSubject<Bool, Never>(true)

}

protocol TasksListAppState {
    var tasksListSubject: PassthroughSubject<[TaskDTO], Never> { get }
}

protocol TaskDetailsAppState {
    var taskDetailsSubject: PassthroughSubject<TaskDTO?, Never> { get }
    var projectsReducedSubject: PassthroughSubject<[ProjectDTOReduced], Never> { get }
    var projectReducedSubject: PassthroughSubject<ProjectDTOReduced?, Never> { get }
}

protocol ProjectsListAppState {
    var projectsListSubject: PassthroughSubject<[ProjectDTO], Never> { get }
}

protocol ProjectDetailsAppState {
    var projectDetailsSubject: PassthroughSubject<ProjectDTO?, Never> { get }
    var relatedTasksSubject: PassthroughSubject<[TaskDTOReduced], Never> { get } // TODO: - ma byc ograniczone dto
}
