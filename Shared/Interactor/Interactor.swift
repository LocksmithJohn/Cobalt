//
//  Interactor.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

protocol InteractorProtocol {
    var coreDataManager: CoreDataManager { get }
    var cancellableBag: Set<AnyCancellable> { get set }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType)
    func fetchItem(id : UUID)
    func editItem(id: UUID, item: Item)
    func toggleDone(item: ItemProtocol) // tutaj nie wystarczy ID?
    func updateType(id: UUID, type: ItemType)
    func deleteAll()
}

class Interactor {

    let coreDataManager = CoreDataManager.shared
    var cancellableBag = Set<AnyCancellable>()

    private let router: Router?

    init(router: Router? = nil) {
        self.router = router
    }

    func fetchItem(id: UUID) {
        coreDataManager.actionSubject.send(.fetchItem(id: id))
    }

    func editItem(id: UUID, item: Item) {
       coreDataManager.actionSubject.send(.editItem(id: id, item: item))
    }

    func toggleDone(item: ItemProtocol) {
        let newState: ItemStatus = item.status == .new ? .done : .new
        coreDataManager.editItem(id: item.id, status: newState)
    }

    func updateType(id: UUID, type: ItemType) {
        coreDataManager.editItem(id: id, type: type)
    }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        router?.route(from: typeFrom, to: typeTo)
    }

    func deleteAll() {
        coreDataManager.deleteAllTasks()
    }
}


