//
//  Interactor+Search.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/03/2022.
//

import Foundation

extension Interactor: SearchInteractor {
    func fetchItemsReduced() {
        coreDataManager.actionSubject.send(.fetchItemsReduced)
    }
}

protocol SearchInteractor: InteractorProtocol {
    func fetchItemsReduced()
}
