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
    
    static func generateMockSquareBoard(level: RawLevel, frameWidth: CGFloat, frameHeight: CGFloat) -> SquareBoard {
        let squares = [[Square]](repeating: [Square](repeating: Square(), count: level.cols), count: level.rows)
        let board = SquareBoard(rows: level.rows, columns: level.cols, items: squares)
        let heightOfSquare = NodeUtils.calculateWidthOfASquare(numberOfSquaresForEachRow: CGFloat(level.cols), screenWidth: frameWidth)
        // Generate the content
        let contentType = ContentType(rawValue: level.contentType)
        let content = ContentFactory.createContent(with: contentType ?? .numbers, size: level.rows * level.cols)
        board.content = content
        board.contentType = contentType
        for i in 0...level.rows - 1 {
            for j in 0...level.cols - 1 {
                let square = Square(rect: CGRect(x: 0, y: 0, width: heightOfSquare, height: heightOfSquare))
                square.coordinates = (i, j)
                do { try board.add(item: square, to: (i, j)) } catch { print(error) }
            }
        }
        // Place the content inside the squares
        board.placeContent()
        // Disable the middle square if the square size is odd number
        board.disableMiddleIfNeeded()
        return board
    }
    
}
