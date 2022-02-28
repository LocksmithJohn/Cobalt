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
    func toggleDone(item: ItemProtocol)
    func updateType(item: ItemProtocol, type: ItemType)
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

//    func toggleDone(task: TaskDTOReduced) {
//        let newState: ItemStatus = task.status == .new ? .done : .new
//        coreDataManager.editItem(id: task.id, status: newState)
//    }

    func toggleDone(item: ItemProtocol) {
        let newState: ItemStatus = item.status == .new ? .done : .new
        coreDataManager.editItem(id: item.id, status: newState)
    }

    func updateType(item: ItemProtocol, type: ItemType) {
        coreDataManager.editItem(id: item.id, type: type)
    }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        router?.route(from: typeFrom, to: typeTo)
    }

    // poniższe dwie metodki wywalic do Global routera
//    func globalRoute(from typeFrom: ScreenType?, to typeTo: ScreenType, with routerType: RouterType) {
//        guard let router = (GlobalRouter.shared.routers.first { $0.type == routerType }) else { return }
//
//        router.route(from: typeFrom, to: typeTo)
//    }

//    func route(tab: Int) {
//        GlobalRouter.shared.tabSubject.send(tab)
//    }

}


