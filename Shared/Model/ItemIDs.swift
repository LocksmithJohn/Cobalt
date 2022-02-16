//
//  ItemIDs.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 13/02/2022.
//

import Foundation

//struct ItemIDs: Codable {
//    
//    var ids: [UUID]
//
//    init(ids: [UUID] = []) {
//        self.ids = ids
//    }
//}
//
//func itemsIdsToData(itemIDs: ItemIDs) -> Data? {
//    do {
//        let data = try JSONEncoder().encode(itemIDs)
//        return data
//    } catch {
//        print(error)
//        return nil
//    }
//}
//
//func dataToItemsID(data: Data?) -> ItemIDs {
//    guard let data = data else { return ItemIDs(ids: []) }
//    do {
//        let decodedItems = try JSONDecoder().decode(ItemIDs.self, from: data)
//        return decodedItems
//    } catch {
//        print(error)
//        return ItemIDs(ids: [])
//    }
//}
