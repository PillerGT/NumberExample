//
//  SecondViewControllerModelView.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 21.11.2022.
//

import Foundation

class SecondViewControllerModelView {
    
    let number: String!
    let date: String!
    let infotext: String!
    
    init(modelDB: NumberModel) {
        self.number = "\(modelDB.number)"
        self.date = DateFormatter.formatting(type: .detailDate, date: modelDB.date)
        self.infotext = modelDB.infotext
    }
}
