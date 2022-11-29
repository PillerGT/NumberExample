//
//  NumberModel.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 27.11.2022.
//

import Foundation
import RealmSwift

class NumberModel: Object {
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var number: Int = 0
   @Persisted var infotext: String = ""
   @Persisted var date: Date = Date()
    
    convenience init(number: Int, infotext: String) {
        self.init()
        self.number = number
        self.infotext = infotext
        self.date = Date()
   }
}
