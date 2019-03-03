//
//  NodeConstants.swift
//  GameDemo
//
//  Created by Oguz Parlak on 7.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

enum NodeUtils {
    
    static var darkModeEnabled = false
    
    // The padding between squares and the frame
    static let paddingOfSquares: CGFloat = 16
    
    // The number of squares fits for each row
    static let numberOfSquaresForEachRow: CGFloat = 3
    
    // The number of squares fits for each column
    static let numberOfSquaresForEachColumn: CGFloat = 3
    
    // The corner radius of the squares
    static let cornerRadiusOfSquares: CGFloat = 4.0
    
    // Returns the width and also height of a square
    static func calculateWidthOfASquare(numberOfSquaresForEachRow: CGFloat?, screenWidth: CGFloat) -> CGFloat {
        return (screenWidth - paddingOfSquares * (numberOfSquaresForEachRow! + 1)) / numberOfSquaresForEachRow!
    }
    
    // Returns the upperLeftCorner of the device frame
    static func calculateUpperLeftCornerCoordinates(screenWidth: CGFloat, screenHeight: CGFloat) -> (CGFloat, CGFloat) {
        let startX = -(screenWidth / 2)
        let startY = (screenHeight / 2)
        return (startX, startY)
    }
    
    // Returns the middleLeftCorner of the device frame
    static func calculateMiddleLeftCoordinatesWithSquareSize(numberOfSquaresForEachColumn: CGFloat, size: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat) -> (CGFloat, CGFloat) {
        let startX = -screenWidth * 0.5
        let startY = size * 0.5 * numberOfSquaresForEachColumn + paddingOfSquares * numberOfSquaresForEachColumn
        return (startX, startY)
    }
    
    static func getTopMarginForTimer() -> CGFloat {
        if UIDevice.current.hasNotch {
            return 90
        } else {
            return 48
        }
    }
    
    static func hideAllContent(of board: SquareBoard) {
        for square in board.getAllSquares() {
            let labelNode = square.children[0]
            labelNode.run(SKAction.fadeOut(withDuration: 0.5))
            square.state = .closed
        }
        board.disableMiddleIfNeeded()
    }
    
    static func showAllContent(of board: SquareBoard) {
        for square in board.getAllSquares() {
            if square.children.isEmpty { break }
            let labelNode = square.children[0]
            labelNode.run(SKAction.fadeIn(withDuration: 0.5))
            square.state = .opened
        }
        board.disableMiddleIfNeeded()
    }
    
    static func setUserInteractionEnabledOf(squares: SquareBoard?, enabled: Bool) {
        squares?.getAllSquares().forEach { (square) in
            square.isUserInteractionEnabled = enabled
        }
    }
    
}

func lerp(a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat
{
    return (b-a) * fraction + a
}

struct ColorComponents {
    var red = CGFloat(0)
    var green = CGFloat(0)
    var blue = CGFloat(0)
    var alpha = CGFloat(0)
}

extension UIColor {
    func toComponents() -> ColorComponents {
        var components = ColorComponents()
        getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha)
        return components
    }
}

extension SKAction {
    static func colorTransitionAction(fromColor : UIColor, toColor : UIColor, duration : Double = 0.4) -> SKAction
    {
        return SKAction.customAction(withDuration: duration, actionBlock: { (node : SKNode!, elapsedTime : CGFloat) -> Void in
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let startColorComponents = fromColor.toComponents()
            let endColorComponents = toColor.toComponents()
            let transColor = UIColor(red: lerp(a: startColorComponents.red, b: endColorComponents.red, fraction: fraction),
                                     green: lerp(a: startColorComponents.green, b: endColorComponents.green, fraction: fraction),
                                     blue: lerp(a: startColorComponents.blue, b: endColorComponents.blue, fraction: fraction),
                                     alpha: lerp(a: startColorComponents.alpha, b: endColorComponents.alpha, fraction: fraction))
            (node as? SKShapeNode)?.fillColor = transColor
        }
        )
    }
}
