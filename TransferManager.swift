//
//  TransferManager.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 11/07/2022.
//

import Foundation

final class TransferManager {

    static let shared = TransferManager()

//    private let coredataManager = CoreDataManager.shared

    private init() {}

    func toProjectDTOReduced(item: ItemProtocol) -> ProjectDTOReduced {
        ProjectDTOReduced(item: item)
    }

    func toTaskDTOReduced(item: ItemProtocol) -> TaskDTOReduced {
        TaskDTOReduced(item: item)
    }

    func toNoteDTOReduced(item: ItemProtocol) -> NoteDTOReduced {
        NoteDTOReduced(item: item)
    }

//    func transformItem(_ from: ItemType, to: ItemType) {
//        coredataManager.actionSubject.send(.editItem(id: id, item: item))
//    }

}
