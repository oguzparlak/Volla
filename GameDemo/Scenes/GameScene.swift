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
    
    // GameViewController
    weak var viewController: GameViewController?
    
    // SquareBoard
    var board: SquareBoard!
    
    // Array of Squares from squareBoard
    var squaresAsAWhole: Array<Square>!
    
    // Countdown Node
    var countDownNode: CountDownNode!
    
    var levelDescriptionNode: LevelDescriptionNode!
    
    // Remaining time on countdown timer
    var remainingTime = 5
    
    // Square Stack can hold maximum 2 squares
    var squareStack = SquareStack()
    
    // Look up session is a session which
    // starts at the beginning of the game
    // where user can see all the squares
    // for a limited amount of time
    var inLookUpSession = true
    
    // The countdown timer
    var timer: Timer!
    
    // The last touched square on the board
    var lastTouchedSquare: Square?
    
    var clickEnabled = true
    
    var correctAnswerCount: Int! {
        didSet {
            detectFinish()
        }
    }
    
    override func didMove(to view: SKView) {
        // Disable multi touch
        self.view?.isMultipleTouchEnabled = false
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
        countDownNode = CountDownNode(countFrom: remainingTime, position: CGPoint(x: frame.midX, y: frame.height / 2 - margin))
        addChild(countDownNode)
        // Start Timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.updateTime), userInfo: nil, repeats: true)
        // Add Description text
        levelDescriptionNode = LevelDescriptionNode(text: "Try to match\nthe numbers inside the squares")
        levelDescriptionNode.position = CGPoint(x: frame.midX, y: -frame.height / 2 + 48)
        levelDescriptionNode.preferredMaxLayoutWidth = frame.width
        levelDescriptionNode.run(SKAction.fadeIn(withDuration: 1.0))
        addChild(levelDescriptionNode)
        // Show of the squares
        NodeConstants.showAllContent(of: board)
        // Init correctAnswerCount
        correctAnswerCount = board.hasOddSize() ? 1 : 0
    }
    
    @objc func updateTime() {
        // Decrement the remaining time
        remainingTime -= 1
        // Display the countdown timer at each tick
        countDownNode.text = String(remainingTime)
        if inLookUpSession {
            let ping = SKAction.playSoundFileNamed("ping.mp3", waitForCompletion: false)
            run(ping)
            if remainingTime == 0 {
                finishLookUpSession()
            }
        } else {
            if remainingTime == 0 {
                finishGame(countDownEnded: true)
            }
        }
    }
    
    func detectFinish() {
        let shouldFinish = correctAnswerCount == board.getSize()
        if shouldFinish { finishGame() }
    }
    
    func finishGame(countDownEnded : Bool = false) {
        timer.invalidate()
        if countDownEnded {
            
        } else {
            let tada = SKAction.playSoundFileNamed("tada.wav", waitForCompletion: false)
            run(tada)
            // Animate
            countDownNode.run(SKAction.moveBy(x: 0, y: 120, duration: 1.0))
            levelDescriptionNode.run(SKAction.moveBy(x: 0, y: -120, duration: 1.0))
            // Lottie
            viewController?.initLottie()
            viewController?.playLottie {
                print("Finished playing...")
            }
            
        }
    }
    
    func finishLookUpSession() {
        // End the lookUpSession
        inLookUpSession = false
        // Reset the seconds
        remainingTime = 30
        // Reset the timer
        countDownNode.text = String(remainingTime)
        // Hide the content
        NodeConstants.hideAllContent(of: board)
    }
    
    func onSquareTapped(at position: (Int, Int)) {
        if lastTouchedSquare?.state == .disabled { return }
        // Play Sound
        let tapSound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
        run(tapSound)
        // Open it
        lastTouchedSquare?.state = .opened
        clickEnabled = false
        if let lastAddedSquare = squareStack.peek() {
            // If select the same square, then close both
            if lastAddedSquare.position == lastTouchedSquare?.position {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // Close them both
                    self.lastTouchedSquare?.state = .closed
                    lastAddedSquare.state = .closed
                    // Pop the stack
                    self.lastTouchedSquare = self.squareStack.pop()
                    // Enable click
                    self.clickEnabled = true
                }
            } else {
                // Check if there is a match
                if lastAddedSquare.isEqual(lastTouchedSquare) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        // Disable both of them and clear stack
                        self.lastTouchedSquare?.state = .disabled
                        lastAddedSquare.state = .disabled
                        self.squareStack.popAll()
                        self.clickEnabled = true
                        // play correct sound
                        let correctSound = SKAction.playSoundFileNamed("success.mp3", waitForCompletion: false)
                        self.run(correctSound)
                        // Increment correct answer count
                        self.correctAnswerCount += 2
                    }
                } else {
                    // No match close them both
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        // Disable both of them and clear stack
                        self.lastTouchedSquare?.state = .closed
                        lastAddedSquare.state = .closed
                        self.squareStack.popAll()
                        self.clickEnabled = true
                        // play false sound
                        let falseSound = SKAction.playSoundFileNamed("sound_wrong.wav", waitForCompletion: false)
                        self.run(falseSound)
                    }
                }
            }
        } else {
            // Stack is empty, push the square into stack
            squareStack.push(lastTouchedSquare!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Detect touches
        for touch in touches {
            detectTouchForSquares(touch)
        }
    }
    
    func detectTouchForSquares(_ touch: UITouch) {
        if inLookUpSession { return }
        let location = touch.location(in: self)
        let possibleSquare = squaresAsAWhole.first { (square) -> Bool in
            square.frame.contains(location)
        }
        if let tappedSquare = possibleSquare {
            lastTouchedSquare = tappedSquare
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
