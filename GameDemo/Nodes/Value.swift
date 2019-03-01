//
//  Value.swift
//  GameDemo
//
//  Created by Oguz Parlak on 27.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

// TODO 

protocol Sampler {
    
    associatedtype T
    
    func getSamples() -> [T]
    
}

class ValueType<T> : Equatable {
    
    let size: Int
    
    init(with size: Int) {
        self.size = size
    }
    
    static func == (lhs: ValueType<T>, rhs: ValueType<T>) -> Bool {
        guard type(of: lhs) == type(of: rhs) else { return false }
        if type(of: lhs) == String.self {
            return lhs == rhs
        }
        return false
    }
    
}

class NumberValueType: ValueType<Int>, Sampler {
    
    typealias T = Int
    
    func getSamples() -> [Int] {
        return [1]
    }
    
}

class EmojiValueType : ValueType<String>, Sampler {
    
    typealias T = String
    
    func getSamples() -> [String] {
        return [":D"]
    }
    
}
