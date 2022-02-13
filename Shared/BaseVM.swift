//
//  BaseVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Combine
import Foundation

class BaseVM: ObservableObject {

    let screenType: ScreenType
    var cancellableBag = Set<AnyCancellable>()

    init(screenType: ScreenType) {
        self.screenType = screenType
    }

}
