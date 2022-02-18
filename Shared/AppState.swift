//
//  AppState.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class AppState  {

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

    let coreDataManager = CoreDataManager.shared
    var isTabbarVisibleSubject = CurrentValueSubject<Bool, Never>(true)

}


