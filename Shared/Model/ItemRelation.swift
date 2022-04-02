//
//  ItemRelation.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 02/04/2022.
//

import Foundation

enum ItemRelation: String {
    /// is subtask of ...
    case sbt
    /// is parent project of ...
    case ppr
    /// blocks ...
    case bks
    /// is blocked by ...
    case ibb
}

struct Relations: Codable {
    var relatedItems: [String]

    init(relations: [String] = []) {
        self.relatedItems = relations
    }

    func textData() -> String {
        relatedItems.joined(separator: ";")
    }

    mutating func addRelation(is relation: ItemRelation, of id: UUID) {
        relatedItems.append(relation.rawValue + id.uuidString)
    }

    func getParentProjectId() -> UUID? {
        guard let relatedItem = (relatedItems.first { getRelation(relatedItem: $0) == .sbt }) else { return nil }

        let uuidString = String(relatedItem.dropFirst(3))
        return UUID(uuidString: uuidString)

    }

    private func getID(relatedItem: String) -> UUID? {
        UUID(uuidString: String(relatedItem.dropFirst(3)))
    }

    private func getRelation(relatedItem: String) -> ItemRelation? {
        ItemRelation(rawValue: String(relatedItem.prefix(3)))
    }

}

extension String {
    func relations() -> Relations? {
        Relations(relations: components(separatedBy: ";"))
    }
}


