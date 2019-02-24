//
//  LevelDescriptionNode.swift
//  GameDemo
//
//  Created by Oguz Parlak on 22.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import SpriteKit

class LevelDescriptionNode: SKLabelNode {
    
    init(text: String?) {
        super.init()
        self.text = text
        // let text = "Try to match\nthe numbers inside the squares"
        // let missionLabel = SKLabelNode(text: text)
        fontName = "Avenir"
        fontColor = Colors.peterRiver
        fontSize = 24
        // position = CGPoint(x: frame.midX, y: -frame.height / 2 + 48)
        numberOfLines = 3
        horizontalAlignmentMode = .center
        lineBreakMode = .byTruncatingMiddle
        preferredMaxLayoutWidth = frame.width
        // addChild(missionLabel)
        alpha = 0
        // missionLabel.run(SKAction.fadeIn(withDuration: 1.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
