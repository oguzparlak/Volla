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
import GoogleMobileAds
import Crashlytics

class GameScene: SKScene, SquareDelegate, GameSceneDelegate, LivesDelegate, GADRewardBasedVideoAdDelegate {

    var pointCalculator: PointCalculator!
    
    // GameViewController
    weak var viewController: GameViewController?
    
    // SquareBoard
    var board: SquareBoard!
    
    // Array of Squares from squareBoard
    var squaresAsAWhole: Array<Square>!
    
    // Countdown Node
    var countDownNode: CountDownNode!
    
    var bottomLabel: LevelDescriptionNode!
    
    var remainingLivesNode: RemainingLivesNode!
    
    // Remaining time on countdown timer
    var remainingTime = 5
    
    // Square Stack can hold maximum 2 squares
    var squareStack = SquareStack()
    
    // Look up session is a session which
    // starts at the beginning of the game
    // where user can see all the squares
    // for a limited amount of time
    var inLookUpSession = true
    
    var adLoaded = false
    
    // The countdown timer
    var timer: Timer!
    
    // The last touched square on the board
    var lastTouchedSquare: Square?
    
    var isLastAnswerTrue = false
    
    var currentRawLevel: RawLevel?
    
    var maximumTime: Int?
    
    var alertPresenter: AlertPresenter!
    
    var correctAnswerCount: Int! {
        didSet {
            detectFinish()
        }
    }
    
    override func didMove(to view: SKView) {
        // Disable multi touch
        self.view?.isMultipleTouchEnabled = false
        // Get current level
        currentRawLevel = GameUtils.load(level: GameUtils.currentLevel ?? 1, with: GameUtils.currentDifficulity ?? .easy)
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
        bottomLabel = LevelDescriptionNode(text: board.content?.questionDescription)
        bottomLabel.position = CGPoint(x: frame.midX, y: -frame.height / 2 + 48)
        bottomLabel.preferredMaxLayoutWidth = frame.width
        bottomLabel.run(SKAction.fadeIn(withDuration: 1.0))
        addChild(bottomLabel)
        // Show of the squares
        NodeUtils.showAllContent(of: board)
        // Init correctAnswerCount
        correctAnswerCount = board.hasOddSize() ? 1 : 0
        // Get maximum time needed for the current level
        maximumTime = GameUtils.getCountDownFor(difficulity: Difficulity(rawValue: (currentRawLevel?.difficulity)!)!)
        // Init PointCalculator
        pointCalculator = PointCalculator(maximumTime: TimeInterval(maximumTime!))
        pointCalculator.difficulity = Difficulity(rawValue: currentRawLevel?.difficulity ?? "easy")
        // Init RemainingLivesNode
        let remainingLives = GameUtils.getRemainingLivesFor(difficulity: GameUtils.currentDifficulity ?? .easy)
        remainingLivesNode = RemainingLivesNode(currentLives: remainingLives)
        remainingLivesNode.position = CGPoint(x: -frame.width / 2 + NodeUtils.paddingOfSquares * 2 + 8, y: frame.height / 2 - margin + 8)
        remainingLivesNode.livesDelegate = self
        addChild(remainingLivesNode)
        // Init AlertPresenter
        self.alertPresenter = AlertPresenter(with: viewController!)
        // Set Ad Delegate
        // Load Ad
        loadAd()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        // Log current level
        Answers.logLevelStart(GameUtils.currentLevel?.description, customAttributes: nil)
    }
    
    func loadAd() {
        #if DEBUG
            GADRewardBasedVideoAd.sharedInstance().load(DFPRequest(), withAdUnitID: "/6499/example/rewarded-video")
        #else
            GADRewardBasedVideoAd.sharedInstance().load(DFPRequest(), withAdUnitID: "ca-app-pub-9117862267622132/2207219880")
        #endif
    }
    
    @objc func updateTime() {
        // Decrement the remaining time
        remainingTime -= 1
        // Display the countdown timer at each tick
        countDownNode.text = String(remainingTime)
        if inLookUpSession {
            if remainingTime == 0 {
                finishLookUpSession()
                updateBottomLabel(with: NSLocalizedString("goodLuck", comment: ""))
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
    
    func updateBottomLabel(with text: String) {
        bottomLabel.fadeOutAndIn()
        bottomLabel.text = text
    }
    
    func onCloseButtonTapped() {
        if self.currentRawLevel?.isCheckPoint() ?? false {
            self.timer.invalidate()
            self.viewController?.dismiss(animated: true, completion: nil)
        } else {
            alertPresenter.showWarningDialog(onStayTapped: {
                // do nothing just close the dialog
            }) {
                self.timer.invalidate()
                self.dissmissVCOnLose()
            }
        }
    }
    
    private func dissmissVCOnLose() {
        StandardUtils.decrementCurrentLevelByOne()
        let initialViewController = self.view?.window?.rootViewController as! InitialViewController
        initialViewController.updateLevelLabel(level: GameUtils.currentLevel ?? 1)
        self.viewController?.dismiss(animated: true, completion: nil)
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
        animateOnGameEnd()
        if countDownEnded {
            onLose()
        } else {
            if GameUtils.isCheckPoint() {
                self.run(SKAction.playSoundFileNamed("achievement.wav", waitForCompletion: false))
                alertPresenter.showAchievementDialog(passedLevel: GameUtils.currentLevel! + 1, onOkTapped: {
                    self.onWin()
                })
            } else {
                self.onWin()
            }
        }
    }
    
    func animateOnGameEnd() {
        countDownNode.run(SKAction.moveBy(x: 0, y: 160, duration: 1.0))
        bottomLabel.run(SKAction.moveBy(x: 0, y: -160, duration: 1.0))
        remainingLivesNode.run(SKAction.moveBy(x: 0, y: 160, duration: 1.0))
        viewController?.animateCloseButtonAlpha(by: 0)
    }
    
    private func onLose() {
        // Disable all the squares
        squaresAsAWhole.forEach { (square) in
            square.state = .disabled
        }
        let gameLostSound = SKAction.playSoundFileNamed("game_lost", waitForCompletion: false)
        run(gameLostSound)
        // If not on checkpoint show ad dialog
        if currentRawLevel?.isCheckPoint() ?? false {
            alertPresenter.showTryAgainDialog(onCloseTapped: {
                // Dismiss the ViewController
                self.viewController?.dismiss(animated: true, completion: nil)
            }) {
                // Re-Create the ViewController
                self.viewController?.viewDidLoad()
                self.viewController?.animateCloseButtonAlpha(by: 1)
            }
        } else {
            alertPresenter.showAdDialog(onWatchAdTapped: {
                if self.adLoaded {
                    GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self.viewController!)
                } else {
                    self.alertPresenter.showInternetConnectionDialog(onCloseTapped: {
                        // Close Tapped
                        self.dissmissVCOnLose()
                    })
                }
            }) {
                // Close Tapped
                self.dissmissVCOnLose()
            }
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print(reward.type)
        print(reward.amount)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Video closed")
        timer.invalidate()
        self.viewController?.dismiss(animated: true, completion: nil)
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        adLoaded = true
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        adLoaded = false
    }
    
    func onLivesEnd() {
        finishGame(countDownEnded: true)
    }
    
    private func showComboPoint(with point: Int) {
        let comboNode = LevelDescriptionNode(text: "+\(point.description)")
        comboNode.position = CGPoint(x: frame.midX, y: -frame.height / 2 + 90)
        comboNode.preferredMaxLayoutWidth = frame.width
        comboNode.fadeOutAndIn(with: 0.8, reverse: true)
        comboNode.fontSize = 28
        addChild(comboNode)
    }
    
    private func onWin() {
        if GameUtils.newLevelUnlocked() {
            // Show achievement
            alertPresenter.showDifficulityPassedDialog()
        }
        timer.invalidate()
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
        // Update Level Label
        let initialViewController = self.view?.window?.rootViewController as! InitialViewController
        initialViewController.updateLevelLabel(level: GameUtils.currentLevel ?? 1)
        initialViewController.updateUiOnDifficulityChanged()
        presentEndViewController(isSuccess: true, extras: pointDictionary)
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
                        self.disableInteraction()
                        let sound: SKAction!
                        if self.isLastAnswerTrue {
                            sound = SKAction.playSoundFileNamed("bonus.wav", waitForCompletion: false)
                            self.pointCalculator.incrementComboCount()
                            self.showComboPoint(with: GameUtils.getComboPointFor(comboCount: self.pointCalculator.getComboCount()))
                        } else {
                            sound = SKAction.playSoundFileNamed("success.mp3", waitForCompletion: false)
                        }
                        self.run(sound)
                        self.isLastAnswerTrue = true
                        // Increment correct answer count
                        self.correctAnswerCount += 2
                        let currentPoint = self.pointCalculator.calculatePointOnCorrectGuess()
                        // Update label
                        self.updateBottomLabel(with: currentPoint.description)
                        // Check if user should gain lives
                        let currentComboCount = self.pointCalculator.getComboCount()
                        if GameUtils.shouldEarnLives(currentComboPoint: currentComboCount) {
                            self.remainingLivesNode.updateAppeareanceOnCombo()
                        }
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
                        self.pointCalculator.resetComboCount()
                        // TODO Handle on zero
                        self.remainingLivesNode.decrementLive()
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
    
    func fadeOutAndIn(with time: TimeInterval = 0.3, reverse: Bool = false) {
        let firstAnimation = reverse ? SKAction.fadeIn(withDuration: time) : SKAction.fadeOut(withDuration: time)
        let secondAnimation = reverse ? SKAction.fadeOut(withDuration: time) : SKAction.fadeIn(withDuration: time)
        self.run(SKAction.sequence([firstAnimation, secondAnimation]))
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
