//
//  RemainingLivesNode.swift
//  GameDemo
//
//  Created by Oguz Parlak on 24.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit
import SpriteKit

protocol LivesDelegate {
    func onLivesEnd()
}

class RemainingLivesNode: SKShapeNode {
    
    var livesDelegate: LivesDelegate?
    
    // Child node that indicates the remaining lives
    private lazy var labelNode: SKLabelNode = {
        let labelNode = SKLabelNode(fontNamed: "Avenir")
        labelNode.fontColor = Colors.clouds
        labelNode.fontSize = 17
        labelNode.text = currentLives.description
        labelNode.position = CGPoint(x: 0, y: -NodeUtils.radiusOfLivesRemaingingCircle/4)
        return labelNode
    }()
    
    private var currentLives: Int! {
        didSet {
            // Each time currentLives changed update the appearance
            updateAppeareance()
        }
    }
    
    convenience init(currentLives: Int) {
        self.init(circleOfRadius: NodeUtils.radiusOfLivesRemaingingCircle)
        // Assign currentLives
        self.currentLives = currentLives
        // Set fill color to emerald
        fillColor = Colors.emerald
        // Clear the stroke
        strokeColor = .clear
        // Set antialiasing true
        isAntialiased = true
        // Add label Node
        addChild(labelNode)
    }
    
    func decrementLive() {
        currentLives -= 1
    }
    
    private func updateAppeareance() {
        let maximumLives = GameUtils.getRemainingLivesFor(difficulity: GameUtils.currentDifficulity ?? .easy)
        // Change the color of the node if needed
        if Double(currentLives) < Double(maximumLives / 2) {
            // Change the color
            self.run(SKAction.colorTransitionAction(fromColor: self.fillColor, toColor: Colors.wisteria))
        }
        // Update label
        labelNode.text = currentLives.description
        labelNode.fadeOutAndIn()
        // Notifiy if needed
        if currentLives == 0 { livesDelegate?.onLivesEnd() }
    }

}
