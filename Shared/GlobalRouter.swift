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

    var tabbarVisible = CurrentValueSubject<Bool, Never>(true)
    var popOverType = PassthroughSubject<PopOverType?, Never>()

    private init() {}

    tutaj wrzucic funkcjonalnosc router wrappera, router wrapper usunac,

}
