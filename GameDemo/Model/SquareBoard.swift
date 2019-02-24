//
//  SquareBoard.swift
//  GameDemo
//
//  Created by Oguz Parlak on 7.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import UIKit

class SquareBoard : Board<Square> {
    
    var squareDelegate: SquareDelegate?
    
    var content: Content?
    
    // If the board has odd element size
    // Then the middle element should be disabled
    // to finish the game
    func disableMiddleIfNeeded() {
        let squareCount = rows * columns
        if squareCount % 2 == 0 { return }
        let middleSquareCoordinates = ((rows - 1) / 2, (columns - 1) / 2)
        do {
            let squareAtTheMiddle = try getItem(at: middleSquareCoordinates)
            squareAtTheMiddle.state = .disabled
        } catch { print(error) }
    }
    
    func placeContent() {
        let squares = getAllSquares()
        var values = content?.generate()
        let middleCoordinates = getMiddleCoordinates()
        for square in squares {
            if (hasOddSize() && square.coordinates == middleCoordinates) {
                continue
            } else {
                square.value = values?.popLast()!
            }
        }
    }
    
    func getMiddleCoordinates() -> (Int, Int) {
        return (x: (rows - 1) / 2, y: (columns - 1) / 2)
    }
    
    func hasOddSize() -> Bool {
        let squareCount = rows * columns
        return squareCount % 2 == 1
    }
    
    func onSquareTapped(at position: (Int, Int)) {
        squareDelegate?.onSquareTapped(at:  position)
    }
    
    func getAllSquares() -> Array<Square> {
        return Array(self.items.joined())
    }
    
}
