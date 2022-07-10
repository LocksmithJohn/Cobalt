//
//  ItemTags.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 07/04/2022.
//

import Foundation

struct ItemTags {
    var tags: [String]

    init(tags: [String] = []) {
        self.tags = tags
    }

    func textData() -> String {
        tags.joined(separator: ";")
    }

    mutating func addTag(tag: String) {
        tags.append(tag)
    }
}
