//
//  BaseVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

class BaseVM: ObservableObject {

    let screenType: ScreenType

    init(screenType: ScreenType) {
        self.screenType = screenType
    }

}
