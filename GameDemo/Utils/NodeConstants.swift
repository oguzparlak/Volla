//
//  NodeConstants.swift
//  GameDemo
//
//  Created by Oguz Parlak on 7.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import UIKit

enum NodeConstants {
    
    // The padding between squares and the frame
    static let paddingOfSquares: CGFloat = 8
    
    // The number of squares fits for each row
    static let numberOfSquaresForEachRow: CGFloat = 2
    
    // The number of squares fits for each column
    static let numberOfSquaresForEachColumn: CGFloat = 2
    
    // The corner radius of the squares
    static let cornerRadiusOfSquares: CGFloat = 4.0
    
    // Returns the width and also height of a square
    static func calculateWidthOfASquare(screenWidth: CGFloat) -> CGFloat {
        return (screenWidth - paddingOfSquares * (numberOfSquaresForEachRow + 1)) / numberOfSquaresForEachRow
    }
    
    // Returns the upperLeftCorner of the device frame
    static func calculateUpperLeftCornerCoordinates(screenWidth: CGFloat, screenHeight: CGFloat) -> (CGFloat, CGFloat) {
        let startX = -(screenWidth / 2)
        let startY = (screenHeight / 2)
        return (startX, startY)
    }
    
    // Returns the middleLeftCorner of the device frame
    static func calculateMiddleLeftCoordinatesWithSquareSize(size: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat) -> (CGFloat, CGFloat) {
        let startX = -screenWidth * 0.5
        let startY = size * 0.5 * numberOfSquaresForEachColumn + paddingOfSquares * numberOfSquaresForEachColumn
        return (startX, startY)
    }
    
}
