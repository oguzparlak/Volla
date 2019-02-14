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
    
    func getX(of square: Square) -> CGFloat {
        return square.frame.maxX
    }
    
    func getY(of square: Square) -> CGFloat {
        return square.frame.maxY
    }
    
    func onSquareTapped(at position: (Int, Int)) {
        squareDelegate?.onSquareTapped(at:  position)
    }
    
    func getAllSquares() -> Array<Square> {
        return Array(self.items.joined())
    }
    
}
