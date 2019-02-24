//
//  Board.swift
//  GameDemo
//
//  Created by Oguz Parlak on 7.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

// A generic model of a 2d Board
class Board<T> {
    
    // The row size of the board
    let rows: Int
    
    // The column size of the board
    let columns: Int
    
    // Items that belongs to this board
    var items: [[T]]
    
    init(rows: Int, columns: Int, items: [[T]]) {
        // assign row count
        self.rows = rows
        // assign column count
        self.columns = columns
        // init array
        self.items = items
    }
    
    func add(item: T, to coordinate: (Int, Int)) throws {
        if !inBounds(position: coordinate) {
            throw BoardError.indexOutOfBounds
        }
        // get x coordinate
        let x = coordinate.0
        // get y coordinate
        let y = coordinate.1
        // assign item
        items[x][y] = item
    }
    
    func getItem(at position: (Int, Int)) throws -> T {
        if !inBounds(position: position) {
            throw BoardError.indexOutOfBounds
        }
        // get x coordinate
        let x = position.0
        // get y coordinate
        let y = position.1
        // return item at that coordinate
        return items[x][y]
    }
    
    func getSize() -> Int {
        return rows * columns
    }
    
    private func inBounds(position: (Int, Int)) -> Bool {
        return position.0 < rows && position.1 < columns
    }
    
}
