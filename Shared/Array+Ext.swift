//
//  Array+Ext.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 17/02/2022.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
