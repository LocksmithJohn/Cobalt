//
//  GlobalViewsRouter.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 20/02/2022.
//

import Combine
import Foundation

final class GlobalRouter {

    static let shared = GlobalRouter()

    var tabbarVisible = MYCurrentValueSubject<Bool>(true)
    var settingsVisible = MYCurrentValueSubject<Bool>(false)
    var popOverType = MYPassthroughSubject<PopoverType?>()
    let tabSubject = MYPassthroughSubject<Int>()

    private var cancellableBag = Set<AnyCancellable>()
    private (set) var routers: [Router] = []

    private init() {}

    func populateRouters(routers: [Router]) {
        self.routers = routers
    }

    func routeWithTab(tab: Int,
                      typeFrom: ScreenType?,
                      typeTo: ScreenType,
                      routerType: RouterType) {
        print("router1 tFrom: \(typeFrom?.title ?? "-"), tTo: \(typeTo.title), tab: \(tab), router: \(routerType.rawValue)")
        guard let router = (GlobalRouter.shared.routers
                                .first { $0.type == routerType })
        else { return }

        tabSubject
            .first()
            .sink { _ in
                print("router2 tFrom: \(typeFrom?.title ?? "-"), tTo: \(typeTo.title), tab: \(tab), router: \(routerType.rawValue)")
                router.route(from: typeFrom, to: typeTo)
            }
            .store(in: &cancellableBag)
        tabSubject.send(tab)
    }

}
