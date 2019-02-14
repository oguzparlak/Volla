//
//  Square.swift
//  GameDemo
//
//  Created by Oguz Parlak on 7.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import SpriteKit

class Square : SKShapeNode {
    
    // Determines whether this square is openly visible to user
    var isOpen = false
    
    // The coordinates that this square is lays on
    var coordinates: (Int, Int) = (0, 0)
    
    // The value behind this square
    var value = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    convenience init(rect: CGRect) {
        self.init(rect: rect, cornerRadius: NodeConstants.cornerRadiusOfSquares)
        fillColor = Colors.alizarin
        strokeColor = .clear
        isAntialiased = true
    }
    
    func reset() {
        
    }
    
    func didTouch() {
        print(coordinates)
    }
    
    deinit {
        reset()
    }
    
}
