//
//  UUIDManager.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 16/02/2022.
//

import Foundation

extension String {

    func getItemRelation() -> ItemRelation? {
        switch self.prefix(3) {
        case ItemRelation.sbt.rawValue:
            return .sbt
        case ItemRelation.ppr.rawValue:
            return .ppr
        default:
            return nil
        }
    }

    func getUUIDs() -> [(relation: ItemRelation, id: UUID)] {
        let components = self.components(separatedBy: ",")

        let tuples: [(ItemRelation, UUID)] = components
            .compactMap { textValue -> (ItemRelation, UUID)? in
                guard let relation = ItemRelation(rawValue: String(textValue.prefix(3))),
                      let id = UUID(uuidString: String(textValue.dropFirst(3)))
                else { return nil }

                return (relation, id)
            }

        return tuples
    }

}
