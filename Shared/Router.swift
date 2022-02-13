//
//  Router.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation
import SwiftUI


final class Router: ObservableObject {

    @Published private (set) var screens: [Screen] = [] {
        didSet { printStactInfo() }
    }

    private let title: String
    init(title: String) {
        self.title = title
    }

    private func send(_ action: StackAction) {
        switch action {
        case .set(let types):
            screens.removeAll()
            addScreens(types)
        case .push(let type):
            guard !exists(type) else { return }
            addScreen(type)
        case .pushExisting(let type):
            screens.removeAll { type == $0.type }
            addScreen(type)
        case .present(let type):
            let screen = Screen(type: type)
            screen.isModal = true
            screens.append(screen)
        case .dismiss:
            objectWillChange.send()
            screens.removeAll { $0.isModal }
            printStactInfo()
        case .pop:
            guard !screens.isEmpty else { return }
            screens.removeLast()
        }
    }

    private func addScreens(_ types: [ScreenType]) {
        types.forEach {
            addScreen($0)
        }
    }

    private func addScreen(_ type: ScreenType) {
        screens.append(Screen(type: type))
    }

    private func removeScreen(_ type: ScreenType) {
        screens.removeAll { $0.type == type }
    }

    private func exists(_ type: ScreenType) -> Bool {
        screens.contains(where: { $0.type == type})
    }

    private func printStactInfo() {
        print("screen     ----\(title) : Screens----")
        screens.reversed().forEach {
            print("screen     |screen: \(String(describing: $0.type.title)) \($0.isModal ? "is Modal" : "")")
        }
        print("screen     -----------------")
    }

    func pop() {
        send(.pop)
    }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        print("route form: \(typeFrom?.title ?? "-") to: \(typeTo.title)")
        switch typeFrom {

            // MARK: - initial tab bar screens
        case .none:
            send(.set([typeTo]))

            // MARK: - Tasks screens flow
        case .tasks :
            if case let .taskDetails(id) = typeTo {
                if id == nil {
                    send(.present(.taskDetails(id: nil)))
                } else {
                    send(.push(.taskDetails(id: id)))
                }
            }
        case let .taskDetails(id) where typeTo == .tasks:
            if id == nil {
                send(.dismiss)
            } else {
                send(.pop)
            }
            // MARK: - Projects screens flow
        case .projects:
            send(.present(.projectDetails(id: nil)))


        default:
            print("route ^ missing route ^ ")

        }
    }

}
