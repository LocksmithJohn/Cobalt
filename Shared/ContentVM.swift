//
//  ContentVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/03/2022.
//

import Combine
import Foundation

final class ContentVM: ObservableObject {

    @Published var settingVisible = true
    private var cancellableBag = Set<AnyCancellable>()

    init() {
        GlobalRouter.shared.settingsVisible
            .assign(to: \.settingVisible, on: self)
            .store(in: &cancellableBag)
    }
}
