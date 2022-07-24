//
//  AppState+Areas.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 21/07/2022.
//

import Foundation

extension AppState: AreasAppState {
    var areasSubject: MYPassthroughSubject<FocusAreas> {
        coreDataManager.areasSubject
    }
}

protocol AreasAppState {
    var areasSubject: MYPassthroughSubject<FocusAreas> { get }
}
