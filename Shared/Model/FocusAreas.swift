//
//  FocusAreas.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 21/07/2022.
//

struct FocusAreas {
    var areas: [String]
    init(areas: [String] = []) {
        self.areas = areas
    }

    init(areasObject: AreasObject) {
        self = areasObject.areas?.areas() ?? FocusAreas()
    }

    func textData() -> String {
        areas.joined(separator: ";")
    }

    mutating func addArea(area: String) {
        areas.append(area)
    }

    mutating func deleteArea(areaName: String) {
        areas.removeAll { name in
            name == areaName
        }
    }
}
