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

    var previousModals: [Screen] = []
    let type: RouterType
    var modalsChanged: Bool {
        screens.filter { $0.isModal } !=
        previousModals.filter { $0.isModal }
    }
    
    init(type: RouterType) {
        self.type = type
        send(.set([type.initialScreen]))
    }

    private func send(_ action: StackAction) {
        previousModals = screens.filter { $0.isModal }
        switch action {
        case .set(let types):
            screens.removeAll()
            addScreens(types)
        case .pushIfNotExists(let type):
            guard !exists(type) else { return }
            addScreen(type)
        case .clearAndPush(let type):
            screens.removeAll { type == $0.type }
            addScreen(type)
        case .present(let type):
            let screen = Screen(type: type)
            screen.isModal = true
            screens.append(screen)
        case .dismiss:
            removeLastModal()
        case .dismissAll:
            screens.removeAll(where: { $0.isModal })
        case .pop:
            guard !screens.isEmpty else { return }
            screens.removeLast()
        case .backToHome:
            if let homeScreen = screens.first {
                screens = [homeScreen]
            }
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

    private func removeLastModal() {
        if let lastModalIndex = screens.lastIndex(where: { $0.isModal }) {
            screens.remove(at: lastModalIndex)
        }
    }

    private func removeScreens(_ type: ScreenType) {
        screens.removeAll { $0.type == type }
    }

    private func exists(_ type: ScreenType) -> Bool {
        screens.contains(where: { $0.type == type })
    }

    private func printStactInfo() {
            print("screen     ----\(type) : Screens----")
            screens.reversed().forEach {
                print("screen     |screen: \(String(describing: $0.type.title)) \($0.isModal ? "is Modal" : "")")
            }
            print("screen     -----------------")
    }

    func pop() {
        send(.pop)
    }

    func backToHome() {
        send(.backToHome)
    }

    func route(from typeFrom: ScreenType?, to typeTo: ScreenType) {
        print("routerr: \(type) from: \(typeFrom?.title ?? "-") to: \(typeTo.title)")
        switch typeFrom {

            // MARK: - initial tab bar screens
        case .none:
            send(.set([typeTo]))

            // MARK: - Tasks list flow
        case .tasks :
            if case let .taskDetails(id, projectID) = typeTo {
                if id == nil {
                    send(.present(.taskDetails(id: nil, projectID: nil)))
                } else {
                    send(.pushIfNotExists(.taskDetails(id: id, projectID: nil)))
                }
            }

            // MARK: - Tasks details flow
        case let .taskDetails(taskID, projectID):
            switch typeTo {
            case .tasks:
                if taskID == nil {
                    send(.dismiss)
                } else {
                    send(.pop)
                }
            case .projectDetails:
                send(.dismiss)
            default:
                break
            }

            // MARK: - Projects list flow
        case .projects:
            if case let .projectDetails(id) = typeTo {
                if id == nil {
                    send(.present(.projectDetails(id: nil)))
                } else {
                    send(.pushIfNotExists(.projectDetails(id: id)))
                }
            }

            // MARK: - Project details flow
        case let .projectDetails(projectID):
            switch typeTo {
            case .projects:
                if projectID == nil {
                    send(.dismiss)
                } else {
                    send(.pop)
                }
            case let .taskDetails(taskID, projectID):
                send(.present(.taskDetails(id: taskID, projectID: projectID)))
            default:
                break
            }

            // MARK: - Project details flow
        case let .projectDetails(projectID) where typeTo == .taskDetails(id: nil, projectID: projectID):
            send(.present(.taskDetails(id: nil, projectID: projectID)))

            // MARK: - Notes list flow
        case .notes:
            if case let .noteDetails(id) = typeTo {
                if id == nil {
                    send(.present(.noteDetails(id: nil)))
                } else {
                    send(.pushIfNotExists(.noteDetails(id: id)))
                }
            }

            // MARK: - Note details flow
        case let .noteDetails(id):
            if id == nil {
                send(.dismiss)
            } else {
                send(.pop)
            }

            // MARK: - Transform flow
        case .transformView:
            switch typeTo {
            case let .projectDetails(id):
                send(.set([.projects, .projectDetails(id: id)]))
            case let .taskDetails(id, _):
                send(.set([.tasks, .taskDetails(id: id, projectID: nil)]))
            default:
                break
            }

            // MARK: - More flow
        case .more:
            send(.present(typeTo))

            // MARK: - Search flow
        case .search:
            send(.dismiss)
        default:
            print("WARING: ^ missing route ^ ")
        }
    }

}
