//
//  Relations.swift
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

struct Relations {
    var relatedItems: [String]

    init(relations: [String] = []) {
        self.relatedItems = relations
    }

    func textData() -> String {
        relatedItems.joined(separator: ";")
    }

    mutating func addRelation(is relation: ItemRelation, for id: UUID) {
        let rowValueItem = relation.rawValue + id.uuidString
        if !relatedItems.contains(rowValueItem) {
            relatedItems.append(rowValueItem)
        }
    }
    
    mutating func removeRelation(is relation: ItemRelation, for id: UUID) {
        relatedItems.removeAll { $0.contains(id.uuidString) }
    }

    func getParentProjectId() -> UUID? {
        guard let relatedItem = (relatedItems.first { getRelation(relatedItem: $0) == .sbt }) else { return nil }
        return getRelatorID(relation: relatedItem)
    }

    private func getRelatorID(relation: String) -> UUID? {
        let relatorID = relation.dropFirst(3)
        return UUID(uuidString: String(relatorID))
    }

    private func getRelation(relatedItem: String) -> ItemRelation? {
        let relationString = String(relatedItem.prefix(3))
        return ItemRelation(rawValue: relationString)
    }

}

extension String {
    func relations() -> Relations? {
        Relations(relations: components(separatedBy: ";"))
    }

    func tags() -> ItemTags? {
        ItemTags(tags: components(separatedBy: ";"))
    }

    func areas() -> FocusAreas? {
        FocusAreas(areas: components(separatedBy: ";"))
    }
}
