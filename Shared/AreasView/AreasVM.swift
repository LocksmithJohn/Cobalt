//
//  AreasVM.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 21/07/2022.
//

import Foundation

final class AreasVM: BaseVM {

    enum Action {
        case onAppear
        case deleteArea(name: String)
        case addArea(name: String)
    }

    @Published var focusAreas: FocusAreas = FocusAreas()  {
        didSet {
            print("filter count: \(focusAreas.areas.count)")
        }
    }


    let actionSubject = MYPassthroughSubject<Action>()

    private let appState: AreasAppState
    private let interactor: AreasInteractor

    init(interactor: AreasInteractor,
         appState: AreasAppState) {
        self.interactor = interactor
        self.appState = appState
        super.init(screenType: .areas)
        print("filter AreasVM")

        bindAppState()
        bindAction()
    }

    //MARK: - Bind methods

    private func bindAppState() {
        appState.areasSubject
            .sink { [weak self] focusAreas in
            print("filter focusAreas: \(focusAreas)")
                self?.focusAreas = focusAreas
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
            onAppearAction()
        case let .deleteArea(name):
            deleteArea(name)
        case let .addArea(name):
            addArea(name)
        }
    }

    //MARK: - Actions

    private func onAppearAction() {
        print("filter onAppearAction()")

        interactor.fetchAreas()
    }

    private func deleteArea(_ name: String) {
        interactor.deleteArea(name: name)
        interactor.fetchAreas()
    }

    private func addArea(_ name: String) {
        if !name.isEmpty {
            interactor.addArea(name: name)
            interactor.fetchAreas()
        }
    }

}
