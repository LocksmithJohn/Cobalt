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
    func toggleDone(id: UUID, status: ItemStatus)
    func updateType(id: UUID, type: ItemType)
    func updateStatus(id: UUID, status: ItemStatus)
    func updateTag(tag: String)
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

    func toggleDone(id: UUID, status: ItemStatus) { // tutaj potrzebne?
        let newState: ItemStatus = status == .new ? .done : .new
        coreDataManager.editItem(id: id, status: newState) // tutaj powinny byc actiony
    }

    func updateType(id: UUID, type: ItemType) {
        coreDataManager.editItem(id: id, type: type)
    }

    func updateStatus(id: UUID, status: ItemStatus) {
        coreDataManager.editItem(id: id, status: status)
    }

    func updateTag(id: UUID, tag: String) {
//        coreDataManager.editItem(id: id, ta)
    }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        router?.route(from: typeFrom, to: typeTo)
    }

    func deleteAll() {
        coreDataManager.deleteAllTasks()
    }
}


