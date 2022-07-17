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
        case backgroundTapped
    }

    @Published var previousItem: Item?
    @Published var newItem: Item?
    @Published var selectedNewItemType: Int = 1

    let actionSubject = PassthroughSubject<Action, Never>()

    private var previousRouterType: RouterType {
        switch previousItem?.type {
        case .task: return .tasks
        case .project: return .projects
        case .note: return .notes
        default:
            Debug.print(.notHandled, 675)
            return .more
        }
    }

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

    private func setInitialNewTypes() {
        switch previousItem?.type {
        case .note, .project: selectedNewItemType = 1
        case .task, .waitFor, .nextAction: selectedNewItemType = 2
        default: selectedNewItemType = 1
        }
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
                self?.setInitialNewTypes()
            }
            .store(in: &cancellableBag)
    }

    private func bindAction() {
        actionSubject
            .sink { [weak self] action in
                self?.handleAction(action: action)
            }
            .store(in: &cancellableBag)

        $selectedNewItemType
            .sink { [weak self] selectedType in
                switch selectedType {
                case 1: self?.newItem?.type = .task
                case 2: self?.newItem?.type = .project
                case 3: self?.newItem?.type = .someDay
                case 4: self?.newItem?.type = .reference
                default: self?.newItem?.type = .note
                }
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
        }
    }

    private func goToItemDetails(item: Item) {
        GlobalRouter.shared.popOverType.send(nil)
        let routing: (destinationRouter: RouterType,
                      screenType: ScreenType,
                      tabToSet: TabType) = {
            switch item.type {
            case .project:
                return (.projects, .projectDetails(id: item.id), .projects)
            case .task:
                return (.tasks, .taskDetails(id: item.id, projectID: nil), .tasks)
            default:
                return (.notes, .noteDetails(id: item.id), .notes)
            }
        }()
        GlobalRouter.shared.routeWithTab(screenFrom: .transformView,
                                         screenTo: routing.screenType,
                                         tabToSet: routing.tabToSet,
                                         destinationRouter: routing.destinationRouter,
                                         routerToClear: previousRouterType)

    }
}
