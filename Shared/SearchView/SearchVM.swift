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
        case searchTriggered(phrase: String)
    }

    @Published var searchText = ""
    @Published var filteredItems: [ItemReduced] = [] {
        didSet {
            print("filter item ------------------------- - - - - - - - - - -")
            filteredItems.forEach { item in
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

        $searchText
            .sink { [weak self] phrase in
                self?.actionSubject.send(.searchTriggered(phrase: phrase))
            }
            .store(in: &cancellableBag)
    }

    private func handleAction(action: Action) {
        switch action {
//        case .onAppear:
//            interactor.fetchItemsReduced()
        case .back:
            interactor.route(from: screenType, to: .more)
        case .searchTriggered(let phrase):
            interactor.fetchItemsFiltered(phrase: phrase)
        }
    }

    private func bindAppState() {
        appstate.itemsFilteredSubject
            .assign(to: \.filteredItems, on: self)
            .store(in: &cancellableBag)
    }
}
