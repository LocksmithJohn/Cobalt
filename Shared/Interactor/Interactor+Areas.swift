//
//  Interactor+Areas.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 22/07/2022.
//

import Foundation

extension Interactor: AreasInteractor {
    func fetchAreas() {
        coreDataManager.actionSubject.send(.fetchAreas)
    }

    func deleteArea(name: String) {
        coreDataManager.actionSubject.send(.deleteArea(name: name))
    }

    func addArea(name: String) {
        coreDataManager.actionSubject.send(.addArea(name: name))
    }
}

protocol AreasInteractor: InteractorProtocol {
    func fetchAreas()
    func deleteArea(name: String)
    func addArea(name: String)
}
