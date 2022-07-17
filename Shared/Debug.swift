//
//  Debug.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 16/07/2022.
//

import Foundation

final class Debug {

    enum PrintType {
        case notHandled
    }

    static func print(_ type: PrintType, _ code: Int) {
        switch type {
        case .notHandled:
            Swift.print("⚠️ WARNING ⚠️ not yet handled code: \(code)")
        }
    }
}
