//
//  ItemObject+CoreDataProperties.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 12/02/2022.
//
//

import Foundation
import CoreData


extension ItemObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemObject> {
        return NSFetchRequest<ItemObject>(entityName: "ItemObject")
    }

    @NSManaged public var itemDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var type: String?

}

extension ItemObject : Identifiable {

}
