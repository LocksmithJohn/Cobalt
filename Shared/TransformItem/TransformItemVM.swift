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
                print("filter 1 \(item?.id) : \(item?.type.rawValue)")
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
            prepareItem()
            guard let item = newItem else { return }

            GlobalRouter.shared.popOverType.send(nil)
            interactor.editItem(id: id, item: item)
            if previousItem?.type != newItem?.type {
                interactor.routerWrapper?.tabSubject
                    .sink(receiveValue: { [weak self] tab in
                        if tab == 2 {
                            self?.interactor.routeWrapped(from: .transformView, to: .projectDetails(id: item.id), with: .projects)
                        }
                    })
                    .store(in: &interactor.cancellableBag)
                print("router: tab route(tab: 2)")
                interactor.route(tab: 2)
            }
        case .backgroundTapped:
            GlobalRouter.shared.popOverType.send(nil)
        case let .typeSelected(type):
            newItem?.type = type
        }
    }

    private func prepareItem() {
        switch (previousItem?.type, newItem?.type) {
        case (.note, .task):
            newItem?.name = String(previousItem?.name.prefix(30) ?? "") + "..."
        default:
            break
        }
    }

}
