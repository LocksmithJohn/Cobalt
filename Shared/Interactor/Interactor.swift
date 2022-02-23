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
    var routerWrapper: RouterWrapper? { get }
    var cancellableBag: Set<AnyCancellable> { get set }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType)
    func routeWrapped(from typeFrom: ScreenType?, to typeTo: ScreenType, with routerType: RouterType)
    func route(tab: Int)
    func fetchItem(id : UUID)
    func editItem(id: UUID, item: Item)
}

class Interactor {

    let coreDataManager = CoreDataManager.shared
    let routerWrapper: RouterWrapper?
    var cancellableBag = Set<AnyCancellable>()

    private let router: Router?

    init(router: Router? = nil,
         routerWrapper: RouterWrapper? = nil) {
        self.router = router
        self.routerWrapper = routerWrapper
    }

    func fetchItem(id: UUID) {
        coreDataManager.actionSubject.send(.fetchItem(id: id))
    }

    func editItem(id: UUID, item: Item) {
        coreDataManager.actionSubject.send(.editItem(id: id, item: item))
    }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        router?.route(from: typeFrom, to: typeTo)
    }

    func routeWrapped(from typeFrom: ScreenType?, to typeTo: ScreenType, with routerType: RouterType) {
        guard let router = (routerWrapper?.routers.first { $0.type == routerType }) else { return }

        router.route(from: typeFrom, to: typeTo)
    }

    func route(tab: Int) {
        routerWrapper?.tabSubject.send(tab)
    }

}


