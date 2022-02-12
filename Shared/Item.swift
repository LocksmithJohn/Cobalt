//
//  TaskDTO.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation

class Item {
    let name: String
    let itemDesrciption: String
    
    init(name: String, itemDesrciption: String) {
        self.name = name
        self.itemDesrciption = itemDesrciption
    }
}

class TaskDTO: Item {}

class ProjectDTO: Item {}
