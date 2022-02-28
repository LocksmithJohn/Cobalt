//
//  AppState.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation


protocol AppStateProtocol {
    var currentlyManagedItemSubject: PassthroughSubject<Item?, Never> { get }
}

class AppState: AppStateProtocol  {

    var cancellableBag = Set<AnyCancellable>()
    let coreDataManager = CoreDataManager.shared
    let relatedTasksSubject = MYPassthroughSubject<[TaskDTOReduced]>()
    let relatedNextActionsSubject = MYPassthroughSubject<[TaskDTOReduced]>()

    var currentlyManagedItemSubject: PassthroughSubject<Item?, Never> {
        coreDataManager.itemSubject
    }

    init() {
        coreDataManager.relatedItemsSubject
            .map { myitems -> [TaskDTOReduced] in
                myitems.map { TaskDTOReduced(item: $0) }
            }
            .sink { [weak self] tasksReduced in
                self?.relatedTasksSubject.send(tasksReduced.filter { $0.type == .task })
                self?.relatedNextActionsSubject.send(tasksReduced.filter { $0.type == .nextAction })
            }
            .store(in: &cancellableBag)
    }

}

enum PopOverType { // tutaj to przeneisc gdzies
    case itemTransform(id: UUID)
}


