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
    let tabSubject = MYPassthroughSubject<TabType>()

    private var cancellableBag = Set<AnyCancellable>()
    private (set) var routers: [Router] = []

    private init() {}

    func populateRouters(routers: [Router]) {
        self.routers = routers
    }

    func routeWithTab(screenFrom: ScreenType?,
                      screenTo: ScreenType,
                      tabToSet: TabType,
                      destinationRouter: RouterType,
                      routerToClear: RouterType? = nil) {
        guard let router = (GlobalRouter.shared.routers
                                .first { $0.type == destinationRouter })
        else { return }

        tabSubject.send(tabToSet)
        router.route(from: screenFrom, to: screenTo)

        if let routerToReset = (GlobalRouter.shared.routers
            .first { $0.type == routerToClear }) {
            routerToReset.backToHome()
        }
    }

}
