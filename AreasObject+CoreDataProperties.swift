//
//  AreasObject+CoreDataProperties.swift
//  CobaltApp (iOS)
//
//  Created by Jan Slusarz on 22/07/2022.
//
//

import Foundation
import CoreData


extension AreasObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AreasObject> {
        return NSFetchRequest<AreasObject>(entityName: "AreasObject")
    }

    @NSManaged public var areas: String?

}

extension AreasObject : Identifiable {

}
