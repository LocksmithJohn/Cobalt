//
//  AppState+Search.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/03/2022.
//

import Foundation

extension AppState: SearchAppState {

    var itemsReducedSubject: MYPassthroughSubject<[ItemReduced]> {
        coreDataManager.itemsReducedSubject
    }

}

protocol SearchAppState {
    var itemsReducedSubject: MYPassthroughSubject<[ItemReduced]> { get }
}
