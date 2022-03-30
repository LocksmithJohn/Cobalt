//
//  TabbarVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 17/02/2022.
//

import Combine
import Foundation

final class TabbarVM: ObservableObject {

    @Published var popoverVM: PopoverVM?
    @Published var isTabbarVisible = true
    @Published var tabSelected = 0

    let dependency: Dependency

    private var cancellableBag = Set<AnyCancellable>()

    init(dependency: Dependency) {
        self.dependency = dependency
        bindTabbarVisibility()
        bindTabsRouting()
        bindPopOver()
    }

    private func bindTabsRouting() {
        GlobalRouter.shared.tabSubject
            .sink(receiveValue: { [weak self] tab in
                self?.tabSelected = tab
            })
            .store(in: &cancellableBag)
    }

    private func bindTabbarVisibility() {
        GlobalRouter.shared.tabbarVisible
            .sink { [weak self] isTabbarVisible in
                self?.isTabbarVisible = isTabbarVisible
            }
            .store(in: &cancellableBag)
    }

    private func bindPopOver() {
        GlobalRouter.shared.popOverType
            .sink { [weak self] type in
                guard let self = self else { return }

                switch type {
                case let .itemTransform(id):
                    self.popoverVM = TransformItemVM(
                        id: id,
                        interactor: Interactor(),
                        appstate: self.dependency.appState)
                case let .addItemToProject(id):
                    self.popoverVM = AddItemToProjectVM(
                        id: id,
                        interactor: Interactor(router: self.dependency.projectsRouter),
                        appstate: self.dependency.appState
                    )
                case .none:
                    self.popoverVM = nil
                }
            }
            .store(in: &cancellableBag)
    }
    
}
