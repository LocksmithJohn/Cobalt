//
//  TransformItemVM.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 19/02/2022.
//

import Combine
import Foundation

final class TransformItemVM: PopoverVM {

    enum Action {
        case onAppear
        case saveItem
        case typeSelected(ItemType)
        case backgroundTapped
    }

    @Published var previousItem: Item?
    @Published var newItem: Item?

    let actionSubject = PassthroughSubject<Action, Never>()

    private let id: UUID
    private let appstate: AppStateProtocol
    private var interactor: InteractorProtocol

    init(id: UUID,
         interactor: InteractorProtocol,
         appstate: AppStateProtocol) {
        self.id = id
        self.interactor = interactor
        self.appstate = appstate
        super.init(screenType: .transformView)

        bindAction()
        bindAppState()
    }

    private func bindAppState() {
        appstate.currentlyManagedItemSubject
            .sink { [weak self] item in
                self?.newItem = item
            }
            .store(in: &cancellableBag)
        appstate.currentlyManagedItemSubject
            .first()
            .sink { [weak self] item in
                self?.previousItem = item
            }
            .store(in: &cancellableBag)
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
            interactor.fetchItem(id: id)
        case .saveItem:
            guard let newItem = newItem else { return }

            interactor.editItem(id: id, item: newItem)
            goToItemDetails(item: newItem)
        case .backgroundTapped:
            GlobalRouter.shared.popOverType.send(nil)
        case let .typeSelected(type):
            newItem?.type = type
        }
    }

    private func goToItemDetails(item: Item) {
        GlobalRouter.shared.popOverType.send(nil)
        let routing: (RouterType, ScreenType, Int) = {
            switch item.type {
            case .project:
                return (.projects, .projectDetails(id: item.id), 2)
            default:
                return (.tasks, .taskDetails(id: item.id, projectID: nil), 1)
            }
        }()
        GlobalRouter.shared.routeWithTab(tab: routing.2,
                                         typeFrom: .transformView,
                                         typeTo: routing.1,
                                         routerType: routing.0)
    }

//    private func prepareItem() {
//        switch (previousItem?.type, newItem?.type) {
//        case (.note, .task):
//            newItem?.name = String(previousItem?.name.prefix(10) ?? "") + "..."
//        default:
//            break
//        }
//    }

}
