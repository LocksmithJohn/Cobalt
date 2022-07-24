//
//  AppState+Search.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/03/2022.
//

import Foundation

extension AppState: SearchAppState {

    var itemsFilteredSubject: MYPassthroughSubject<[ItemReduced]> {
        coreDataManager.itemsFilteredSubject
    }

}

protocol SearchAppState {
    var itemsFilteredSubject: MYPassthroughSubject<[ItemReduced]> { get }
}
