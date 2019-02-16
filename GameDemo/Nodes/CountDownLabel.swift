//
//  CountDownLabel.swift
//  GameDemo
//
//  Created by Oguz Parlak on 16.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import SpriteKit

class CountDownNode: SKLabelNode {
    
    var remainingTimeInSeconds: Int = 0
    
    init(countFrom: Int, position: CGPoint) {
        super.init()
        self.remainingTimeInSeconds = countFrom
        text = String(countFrom)
        fontName = "Avenir"
        fontColor = Colors.peterRiver
        fontSize = 24
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
