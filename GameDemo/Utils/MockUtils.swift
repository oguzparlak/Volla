//
//  MockUtils.swift
//  GameDemo
//
//  Created by Oguz Parlak on 7.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import UIKit

enum MockUtils {
    
    static func generateMockSquareBoard(frameWidth: CGFloat, frameHeight: CGFloat) -> SquareBoard {
        let numberOfSquaresForEachRow = Int(NodeConstants.numberOfSquaresForEachRow)
        let numberOfSquaresForEachColumn = Int(NodeConstants.numberOfSquaresForEachColumn)
        let squares = [[Square]](repeating: [Square](repeating: Square(), count: numberOfSquaresForEachRow), count: numberOfSquaresForEachColumn)
        let board = SquareBoard(rows: numberOfSquaresForEachColumn, columns: numberOfSquaresForEachRow, items: squares)
        let heightOfSquare = NodeConstants.calculateWidthOfASquare(screenWidth: frameWidth)
        for i in 0...numberOfSquaresForEachColumn - 1 {
            for j in 0...numberOfSquaresForEachRow - 1 {
                let square = Square(rect: CGRect(x: 0, y: 0, width: heightOfSquare, height: heightOfSquare))
                square.coordinates = (i, j)
                do { try board.add(item: square, to: (i, j)) } catch { print(error) }
            }
        }
        return board
    }
    
}
