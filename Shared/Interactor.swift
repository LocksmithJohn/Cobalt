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

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType)
}

class Interactor {

    let coreDataManager = CoreDataManager.shared
    private let router: Router

    init(router: Router) {
        self.router = router
    }





    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        router.route(from: typeFrom, to: typeTo)
    }

}


