//
//  GameViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 6.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Lottie
import BubbleTransition

class GameViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    
    var lottieAnimationView: LOTAnimationView!
    
    let userDefaults = UserDefaults.standard
    
    let transition = BubbleTransition()
    
    var gameSceneDelegate: GameSceneDelegate!
    
    weak var endingViewController: EndingViewController?
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = view.center
        transition.bubbleColor = NodeUtils.darkModeEnabled ? Colors.midnightBlue : Colors.clouds
        transition.duration = 0.25
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = view.center
        transition.bubbleColor = NodeUtils.darkModeEnabled ? Colors.midnightBlue : Colors.clouds
        transition.duration = 0.25
        return transition
    }
    
    func presentEndVC(isSuccess: Bool = true, extras: Dictionary<String, Any>? = nil, level: Int) {
        let endingVC = self.storyboard?.instantiateViewController(withIdentifier: "ending_vc") as! EndingViewController
        endingVC.gameViewController = self
        endingVC.successfullyFinishedGame = isSuccess
        endingVC.currentLevel = level
        endingVC.pointDictionary = extras
        self.present(endingVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If came from EndingViewController, dismiss the EndingViewController
        endingViewController?.dismiss(animated: true, completion: nil)
        
        let closeImage = NodeUtils.darkModeEnabled ? UIImage(named: "ic_close") : UIImage(named: "ic_close_blue")
        closeButton.setImage(closeImage, for: .normal)
        
        self.transitioningDelegate = self
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set self reference to scene
                scene.viewController = self
                // Set game scene delegate
                self.gameSceneDelegate = scene
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.size = view.bounds.size
                view.ignoresSiblingOrder = true
                // UpdateUI according to theme preference
                let isDarkModeEnabled = userDefaults.bool(forKey: "dark_mode_enabled")
                let backgroundColor = isDarkModeEnabled ? Colors.midnightBlue : Colors.clouds
                scene.backgroundColor = backgroundColor
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.gameSceneDelegate.onCloseButtonTapped()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}


extension UIDevice {
    var hasNotch: Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
}

extension GameViewController {
    
    func playLottie(isSucess: Bool = true, completion: (() -> ())?) {
        let lottieAsset = isSucess ? "success" : "fail"
        lottieAnimationView = LOTAnimationView(name: lottieAsset)
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.frame = CGRect(x: view.frame.midX - 72 , y: view.frame.midY - 72, width: 144, height: 144)
        self.view.addSubview(lottieAnimationView)
        lottieAnimationView.play { (finished) in if completion != nil { completion!() } }
    }
    
    func hideLottie() {
        lottieAnimationView.isHidden = true
    }
    
    func animateCloseButtonAlpha(by value: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.closeButton.alpha = value
        }
    }
    
}

// GameSceneDelegate to communicate between
// ViewController and SKScene
protocol GameSceneDelegate {
    func onCloseButtonTapped()
}
