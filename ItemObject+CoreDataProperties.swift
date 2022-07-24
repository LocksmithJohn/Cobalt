//
//  ItemObject+CoreDataProperties.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 22/07/2022.
//
//

import Foundation
import CoreData


extension ItemObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemObject> {
        return NSFetchRequest<ItemObject>(entityName: "ItemObject")
    }

    @NSManaged public var areas: String?
    @NSManaged public var id: UUID
    @NSManaged public var itemDescriptionLong: String?
    @NSManaged public var itemDescriptionShort: String?
    @NSManaged public var name: String?
    @NSManaged public var relatedItemsData: String?
    @NSManaged public var state: String?
    @NSManaged public var tags: String?
    @NSManaged public var type: String?

}

extension ItemObject : Identifiable {

}
