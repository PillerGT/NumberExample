//
//  DateFormatter+Extensions.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 27.11.2022.
//

import Foundation

enum DateType : String {
    case createDate = "yyyy-MM-dd HH:mm:ss" //"2020-10-17 07:31:04"
    case detailDate = "HH:mm:ss dd/MM/yyyy"
}

extension DateFormatter {
    
    class func formatting(type: DateType, date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
}
