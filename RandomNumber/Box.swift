//
//  Box.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 21.11.2022.
//

import Foundation

typealias Callback<T> = (T) -> Void

class Box<T> {
    
    typealias Listener = Callback<T>
    
    var listener : Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}
