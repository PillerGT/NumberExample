//
//  ItemObject.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 21.11.2022.
//

import Foundation

class ItemObject: NSObject {
    
    var type: ItemType
    var data: Any?
    
    init(type: ItemType, data: Any?) {
        self.type = type
        self.data = data
    }
}

enum ItemType {
    case history
    case info
    case top
}
