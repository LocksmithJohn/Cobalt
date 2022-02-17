//
//  TabbarVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 17/02/2022.
//

import Combine
import Foundation

final class TabbarVM: ObservableObject {

    @Published var isTabbarVisible = true
    let dependency: Dependency

    private var cancellableBag = Set<AnyCancellable>()

    init(dependency: Dependency) {
        self.dependency = dependency
        bindTabbarVisibility()
    }

    private func bindTabbarVisibility() {
        dependency.appState.isTabbarVisibleSubject
            .sink { [weak self] isTabbarVisible in
                self?.isTabbarVisible = isTabbarVisible
            }
            .store(in: &cancellableBag)
    }
    
}
