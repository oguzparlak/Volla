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
        let numberOfSquaresForEachRow = Int(NodeUtils.numberOfSquaresForEachRow)
        let numberOfSquaresForEachColumn = Int(NodeUtils.numberOfSquaresForEachColumn)
        let squares = [[Square]](repeating: [Square](repeating: Square(), count: numberOfSquaresForEachRow), count: numberOfSquaresForEachColumn)
        let board = SquareBoard(rows: numberOfSquaresForEachColumn, columns: numberOfSquaresForEachRow, items: squares)
        let heightOfSquare = NodeUtils.calculateWidthOfASquare(screenWidth: frameWidth)
        // Generate the content
        let contentType = ContentType.smiley
        let content = ContentFactory.createContent(with: contentType, size: numberOfSquaresForEachRow * numberOfSquaresForEachColumn)
        board.content = content
        board.contentType = contentType
        // let middleCoordinates = board.getMiddleCoordinates()
        for i in 0...numberOfSquaresForEachColumn - 1 {
            for j in 0...numberOfSquaresForEachRow - 1 {
                let square = Square(rect: CGRect(x: 0, y: 0, width: heightOfSquare, height: heightOfSquare))
                square.coordinates = (i, j)
                do { try board.add(item: square, to: (i, j)) } catch { print(error) }
            }
        }
        // Place the content inside the squares
        board.placeContent()
        // Disable the middle square if the square size is odd number
        board.disableMiddleIfNeeded()
        // TODO Bind the values from the content with the square
        // TODO Implement it later
        return board
    }
    
}
