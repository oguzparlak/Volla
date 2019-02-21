//
//  SquareDrawer.swift
//  GameDemo
//
//  Created by Oguz Parlak on 8.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import SpriteKit

class SquareDrawer {
    
    // The container of squares
    let rootNode: SKNode!
    
    // The starting edge coordinates of this container
    let startingPoint: (CGFloat, CGFloat)!
    
    // The accumulated x so far
    var accumulatedX: CGFloat!
    
    // The accumulated y so far
    var accumulatedY: CGFloat!
    
    // Width of a square
    var widthOfASquare: CGFloat!
    
    var currentRow = 0 {
        didSet {
            accumulatedY -= NodeConstants.calculateWidthOfASquare(screenWidth: rootNode.frame.width) + NodeConstants.paddingOfSquares
        }
    }
    
    var squareCount = 0 {
        didSet {
            let remainder = squareCount % Int(NodeConstants.numberOfSquaresForEachRow)
            let widthOfASquare = NodeConstants.calculateWidthOfASquare(screenWidth: rootNode.frame.width)
            let startingX = startingPoint.0
            accumulatedX += widthOfASquare + NodeConstants.paddingOfSquares
            if remainder == 0 { accumulatedX = startingX }
        }
    }
    
    init(rootNode: SKNode, startingPoint: (CGFloat, CGFloat)) {
        self.rootNode = rootNode
        self.accumulatedX = startingPoint.0
        self.accumulatedY = startingPoint.1
        self.startingPoint = startingPoint
    }
    
    func drawSquare(_ square: Square) {
        square.position = CGPoint(x: accumulatedX, y: accumulatedY)
        // Increment square count
        squareCount += 1
        // If reached end of the row
        // Increment the currentRow
        if squareCount % Int(NodeConstants.numberOfSquaresForEachRow) == 0 {
             currentRow += 1
        }
        // Animate square
        square.applyPulseAnimation(with: 0.3)
        // Draw square
        rootNode.addChild(square)
        // Draw content of square
        drawContent(of: square)
    }
    
    func drawContent(of square: Square) {
        let isSimplyRepresentable = square.isSimplyRepresentable
        if isSimplyRepresentable {
            let value = square.value as? String ?? ""
            let labelNode = SKLabelNode(text: value)
            labelNode.fontName = "Avenir"
            labelNode.fontColor = Colors.clouds
            labelNode.fontSize = 24.0
            let labelHeight = labelNode.frame.height
            labelNode.position = CGPoint(x: square.frame.width / 2, y: square.frame.width / 2 - labelHeight / 2)
            square.addChild(labelNode)
        }
    }
    
}
