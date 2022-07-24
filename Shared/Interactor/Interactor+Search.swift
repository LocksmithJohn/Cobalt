//
//  Interactor+Search.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/03/2022.
//

import Foundation

extension Interactor: SearchInteractor {
    func fetchItemsFiltered(phrase: String) {
        coreDataManager.actionSubject.send(.fetchFiltered(phrase: phrase))
    }
}

protocol SearchInteractor: InteractorProtocol {
    func fetchItemsFiltered(phrase: String)
}
