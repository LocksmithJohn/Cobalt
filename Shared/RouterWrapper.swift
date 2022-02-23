//
//  RouterWrapper.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 22/02/2022.
//

import Combine
import Foundation

class RouterWrapper {

    let tabSubject = PassthroughSubject<Int, Never>()
    let routers: [Router]

    init(routers: [Router]) {
        self.routers = routers
    }
    
}
