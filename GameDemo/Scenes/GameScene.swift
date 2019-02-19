//
//  GameScene.swift
//  GameDemo
//
//  Created by Oguz Parlak on 6.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SquareDelegate {
    
    var board: SquareBoard!
    
    var squaresAsAWhole: Array<Square>!
    
    var lastPickedSquare: Square?
    
    var countDownNode: CountDownNode!
    
    var remainingTime = 30
    
    override func didMove(to view: SKView) {
        // 3 * 3 board consists of squares
        board = MockUtils.generateMockSquareBoard(frameWidth: frame.width, frameHeight: frame.height)
        // Get whole squares once
        squaresAsAWhole = board.getAllSquares()
        // Assign a delegate to board
        board.squareDelegate = self
        let widthOfASquare = NodeConstants.calculateWidthOfASquare(screenWidth: frame.width)
        // Get upper left coordinates of the screen
        let middle = NodeConstants.calculateMiddleLeftCoordinatesWithSquareSize(size: widthOfASquare, screenWidth: frame.width, screenHeight: frame.height)
        let startX = middle.0
        // Initialize the square container
        let squareContainer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        squareContainer.strokeColor = .clear
        // Add Square Drawer to Frame
        addChild(squareContainer)
        let padding = NodeConstants.paddingOfSquares
        // Draw squares
        drawSquares(squareContainer, startX, padding, middle, widthOfASquare)
        // Add Countdown Timer
        let margin = NodeConstants.getTopMarginForTimer()
        countDownNode = CountDownNode(countFrom: 30, position: CGPoint(x: frame.midX, y: frame.height / 2 - margin))
        addChild(countDownNode)
        // Start Timer
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.updateTime), userInfo: nil, repeats: true)
        // Add Helper text
        let text = "Try to match\nthe numbers inside the squares"
        let missionLabel = SKLabelNode(text: text)
        missionLabel.fontName = "Avenir"
        missionLabel.fontColor = Colors.peterRiver
        missionLabel.fontSize = 24
        missionLabel.position = CGPoint(x: frame.midX, y: -frame.height / 2 + 48)
        missionLabel.numberOfLines = 3
        missionLabel.horizontalAlignmentMode = .center
        missionLabel.lineBreakMode = .byTruncatingMiddle
        missionLabel.preferredMaxLayoutWidth = frame.width
        addChild(missionLabel)
        missionLabel.alpha = 0
        missionLabel.run(SKAction.fadeIn(withDuration: 1.0))
    }
    
    @objc func updateTime() {
        // TODO Finish the game...
        if remainingTime == 0 { return }
        remainingTime -= 1
        countDownNode.text = String(remainingTime)
    }
    
    func onSquareTapped(at position: (Int, Int)) {
        lastPickedSquare?.state = .opened
        // Play Sound
        let sound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
        run(sound)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Detect touches
        for touch in touches {
            detectTouchForSquares(touch)
        }
    }
    
    func detectTouchForSquares(_ touch: UITouch) {
        let location = touch.location(in: self)
        let possibleSquare = squaresAsAWhole.first { (square) -> Bool in
            square.frame.contains(location)
        }
        if let tappedSquare = possibleSquare {
            lastPickedSquare = tappedSquare
            board.onSquareTapped(at: tappedSquare.coordinates)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


extension SKNode {
    func applyPulseAnimation(with timeInterval: TimeInterval = 1.0) {
        self.run(
            SKAction.sequence([SKAction.scale(to: 1.1, duration: timeInterval),
                               SKAction.scale(to: 0.9, duration: timeInterval),
                               SKAction.scale(to: 1.0, duration: timeInterval)])
        )
    }
}

extension GameScene {
    // Draws all the squares given a squareContainer, and the coordinates
    fileprivate func drawSquares(_ squareContainer: SKShapeNode, _ startX: CGFloat, _ padding: CGFloat, _ upperLeft: (CGFloat, CGFloat), _ widthOfASquare: CGFloat) {
        let squareDrawer = SquareDrawer(rootNode: squareContainer, startingPoint: (startX + padding , upperLeft.1 - widthOfASquare - padding))
        do {
            for i in 0...Int(NodeConstants.numberOfSquaresForEachColumn - 1) {
                for j in 0...Int(NodeConstants.numberOfSquaresForEachRow - 1) {
                    let square = try board.getItem(at: (i, j))
                    squareDrawer.drawSquare(square)
                }
            }
        } catch {
            print(error)
        }
    }
}