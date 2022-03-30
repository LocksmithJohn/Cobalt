//
//  SearchVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/03/2022.
//

import Combine

final class SearchVM: BaseVM {

    enum Action {
        case back
        case onAppear
    }

    @Published var items: [ItemReduced] = [] {
        didSet {
            print("filter item ------------------------- - - - - - - - - - -")
            items.forEach { item in
                print("filter item: \(item.name)")
            }
        }
    }

    let actionSubject = MYPassthroughSubject<Action>()
    private let appstate: SearchAppState
    private let interactor: SearchInteractor

    init(interactor: SearchInteractor,
         appstate: SearchAppState) {
        self.interactor = interactor
        self.appstate = appstate
        super.init(screenType: .search)

        bindAction()
        bindAppState()
    }

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
        case .onAppear:
            interactor.fetchItemsReduced()
        case .back:
            interactor.route(from: screenType, to: .more)
        }
    }

    private func bindAppState() {
        appstate.itemsReducedSubject
            .assign(to: \.items, on: self)
            .store(in: &cancellableBag)
    }
}
