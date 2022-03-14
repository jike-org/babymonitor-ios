//
//  Box.swift
//  Baby Monitor
//
//  Created by Andreas on 20.02.2022.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    
}
