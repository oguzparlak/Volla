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
import BubbleTransition

class GameScene: SKScene, SquareDelegate, GameSceneDelegate {
    
    var pointCalculator: PointCalculator!
    
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
    
    var isLastAnswerTrue = false
    
    var currentRawLevel: RawLevel?
    
    var maximumTime: Int?
    
    var correctAnswerCount: Int! {
        didSet {
            detectFinish()
        }
    }
    
    override func didMove(to view: SKView) {
        // Disable multi touch
        self.view?.isMultipleTouchEnabled = false
        // Get current level
        let currentLevel = UserDefaults.standard.integer(forKey: "current_level")
        currentRawLevel = GameUtils.load(level: currentLevel)
        // Generate board
        board = MockUtils.generateMockSquareBoard(level: currentRawLevel!, frameWidth: frame.width, frameHeight: frame.height)
        // Get whole squares once
        squaresAsAWhole = board.getAllSquares()
        // Assign a delegate to board
        board.squareDelegate = self
        let widthOfASquare = NodeUtils.calculateWidthOfASquare(numberOfSquaresForEachRow: CGFloat((currentRawLevel?.cols)!), screenWidth: frame.width)
        // Get upper left coordinates of the screen
        let middle = NodeUtils.calculateMiddleLeftCoordinatesWithSquareSize(numberOfSquaresForEachColumn: CGFloat(currentRawLevel!.rows), size: widthOfASquare, screenWidth: frame.width, screenHeight: frame.height)
        let startX = middle.0
        // Initialize the square container
        let squareContainer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        squareContainer.strokeColor = .clear
        // Add Square Drawer to Frame
        addChild(squareContainer)
        let padding = NodeUtils.paddingOfSquares
        // Draw squares
        drawSquares(squareContainer, startX, padding, middle, widthOfASquare)
        // Add Countdown Timer
        let margin = NodeUtils.getTopMarginForTimer()
        countDownNode = CountDownNode(countFrom: remainingTime, position: CGPoint(x: frame.midX, y: frame.height / 2 - margin))
        addChild(countDownNode)
        // Start Timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.updateTime), userInfo: nil, repeats: true)
        // Add Description text
        levelDescriptionNode = LevelDescriptionNode(text: board.content?.questionDescription)
        levelDescriptionNode.position = CGPoint(x: frame.midX, y: -frame.height / 2 + 48)
        levelDescriptionNode.preferredMaxLayoutWidth = frame.width
        levelDescriptionNode.run(SKAction.fadeIn(withDuration: 1.0))
        addChild(levelDescriptionNode)
        // Show of the squares
        NodeUtils.showAllContent(of: board)
        // Init correctAnswerCount
        correctAnswerCount = board.hasOddSize() ? 1 : 0
        // Get maximum time needed for the current level
        maximumTime = GameUtils.getCountDownFor(difficulity: Difficulity(rawValue: (currentRawLevel?.difficulity)!)!)
        // Init PointCalculator
        pointCalculator = PointCalculator(maximumTime: TimeInterval(maximumTime!))
        pointCalculator.difficulity = Difficulity(rawValue: currentRawLevel?.difficulity ?? "easy")
    }
    
    @objc func updateTime() {
        // Decrement the remaining time
        remainingTime -= 1
        // Display the countdown timer at each tick
        countDownNode.text = String(remainingTime)
        if inLookUpSession {
            if remainingTime == 0 {
                finishLookUpSession()
            }
        } else {
            if remainingTime == 0 {
                finishGame(countDownEnded: true)
            }
        }
        if remainingTime < 5 {
            let ping = SKAction.playSoundFileNamed("ping.mp3", waitForCompletion: false)
            run(ping)
        }
    }
    
    func onCloseButtonTapped() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func detectFinish() {
        let shouldFinish = correctAnswerCount == board.getSize()
        if shouldFinish { finishGame() }
    }
    
    func finishGame(countDownEnded : Bool = false) {
        pointCalculator.finishedTime = Double(remainingTime)
        // Stop timer
        timer.invalidate()
        // Animate
        countDownNode.run(SKAction.moveBy(x: 0, y: 160, duration: 1.0))
        levelDescriptionNode.run(SKAction.moveBy(x: 0, y: -160, duration: 1.0))
        viewController?.animateCloseButton()
        if countDownEnded {
            // Disable all the squares
            squaresAsAWhole.forEach { (square) in
                square.state = .disabled
            }
            // TODO Play music
            let gameLostSound = SKAction.playSoundFileNamed("game_lost", waitForCompletion: false)
            run(gameLostSound)
            viewController?.playLottie(isSucess: false, completion: nil)
            presentEndViewController(isSuccess: false)
        } else {
            let tada = SKAction.playSoundFileNamed("tada.wav", waitForCompletion: false)
            run(tada)
            // Lottie
            viewController?.playLottie(completion: nil)
            // Calculate Point based on time
            let pointBasedOnTime = pointCalculator.calculateScoreBasedOnTime()
            // Combo Points
            let comboCount = pointCalculator.getComboCount()
            // Difficulity multiplier
            let difficulityMultiplier = GameUtils.getDifficulityMultiplierFor(difficulity: Difficulity(rawValue: (currentRawLevel?.difficulity)!)!)
            // Total Point
            let totalPoint = pointCalculator.calculateTotal()
            let pointDictionary = [
                "scoreBasedOnTime" : pointBasedOnTime,
                "comboCount" : comboCount,
                "difficulityMultiplier": difficulityMultiplier,
                "total": totalPoint
            ]
            // Increment current level
            GameUtils.incrementCurrentLevel()
            presentEndViewController(isSuccess: true, extras: pointDictionary)
        }
    }
    
    func presentEndViewController(isSuccess: Bool = true, extras: Dictionary<String, Any>? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.viewController?.presentEndVC(isSuccess: isSuccess, extras: extras, level: (self.currentRawLevel?.level)!)
        }
    }
    
    func finishLookUpSession() {
        // End the lookUpSession
        inLookUpSession = false
        // Reset the seconds
        remainingTime = maximumTime!
        // Reset the timer
        countDownNode.text = String(remainingTime)
        // Hide the content
        NodeUtils.hideAllContent(of: board)
    }
    
    func onSquareTapped(at position: (Int, Int)) {
        if lastTouchedSquare?.state == .disabled { return }
        // Play Sound
        let tapSound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
        run(tapSound)
        // Open it
        lastTouchedSquare?.state = .opened
        enableInteraction()
        if let lastAddedSquare = squareStack.peek() {
            // If select the same square, then close both
            if lastAddedSquare.position == lastTouchedSquare?.position {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // Close them both
                    self.lastTouchedSquare?.state = .closed
                    lastAddedSquare.state = .closed
                    // Pop the stack
                    self.lastTouchedSquare = self.squareStack.pop()
                    self.disableInteraction()
                }
            } else {
                // Check if there is a match
                if lastAddedSquare.isEqual(lastTouchedSquare) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        // Disable both of them and clear stack
                        self.lastTouchedSquare?.state = .disabled
                        lastAddedSquare.state = .disabled
                        self.squareStack.popAll()
                        // play correct sound
                        let correctSound = SKAction.playSoundFileNamed("success.mp3", waitForCompletion: false)
                        self.run(correctSound)
                        self.disableInteraction()
                        if self.isLastAnswerTrue {
                            self.pointCalculator.incrementComboCount()
                        }
                        self.isLastAnswerTrue = true
                        // Increment correct answer count
                        self.correctAnswerCount += 2
                    }
                } else {
                    // No match close them both
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        // Close both of them and clear stack
                        self.lastTouchedSquare?.state = .closed
                        lastAddedSquare.state = .closed
                        self.squareStack.popAll()
                        // play false sound
                        let falseSound = SKAction.playSoundFileNamed("sound_wrong.wav", waitForCompletion: false)
                        self.run(falseSound)
                        self.disableInteraction()
                        self.isLastAnswerTrue = false
                    }
                }
            }
        } else {
            // Stack is empty, push the square into stack
            squareStack.push(lastTouchedSquare!)
            self.disableInteraction()
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
        // Called before each time a frame is rendered
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
        squareDrawer.numberOfSquaresForEachRow = currentRawLevel?.cols
        squareDrawer.numberOfSquaresForEachColumn = currentRawLevel?.rows
        do {
            for i in 0...Int(squareDrawer.numberOfSquaresForEachColumn - 1) {
                for j in 0...Int(squareDrawer.numberOfSquaresForEachRow - 1) {
                    let square = try board.getItem(at: (i, j))
                    squareDrawer.drawSquare(square, with: board.contentType!)
                }
            }
        } catch {
            print(error)
        }
    }
}

extension GameScene {
    
    private func disableInteraction() {
        NodeUtils.setUserInteractionEnabledOf(squares: board, enabled: false)
    }
    
    private func enableInteraction() {
        NodeUtils.setUserInteractionEnabledOf(squares: board, enabled: true)
    }
}
