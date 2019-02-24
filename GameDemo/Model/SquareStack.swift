//
//  SquareStack.swift
//  GameDemo
//
//  Created by Oguz Parlak on 22.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

class SquareStack {
    
    var stack: [Square] = []
    
    func push(_ square: Square) {
        stack.append(square)
    }
    
    func pop() -> Square? {
        return stack.popLast()
    }
    
    func popAll() {
        stack.removeAll()
    }
    
    func peek() -> Square? {
        return stack.last
    }
    
}
