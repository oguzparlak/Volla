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
    
    var lottieAnimationView: LOTAnimationView!
    
    let userDefaults = UserDefaults.standard
    
    let transition = BubbleTransition()
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = view.center
        transition.bubbleColor = NodeUtils.darkModeEnabled ? Colors.midnightBlue : Colors.clouds
        transition.duration = 0.5
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = view.center
        transition.bubbleColor = NodeUtils.darkModeEnabled ? Colors.midnightBlue : Colors.clouds
        transition.duration = 0.5
        return transition
    }
    
    func presentEndVC() {
        let endingVC = self.storyboard?.instantiateViewController(withIdentifier: "ending_vc") as! EndingViewController
        self.present(endingVC, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let displaySize: CGRect = UIScreen.main.bounds
        let displayWidth = displaySize.width
        let displayHeight = displaySize.height
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set self reference to scene
                scene.viewController = self
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Reassign size of the frame
                scene.size = CGSize(width: displayWidth, height: displayHeight)
                // UpdateUI according to theme preference
                let isDarkModeEnabled = userDefaults.bool(forKey: "dark_mode_enabled")
                let backgroundColor = isDarkModeEnabled ? Colors.midnightBlue : Colors.clouds
                scene.backgroundColor = backgroundColor
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension UIDevice {
    var hasNotch: Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
}

extension GameViewController {
    
    func playLottie(isSucess: Bool = true, completion: @escaping () -> ()) {
        let lottieAsset = isSucess ? "success" : "fail"
        lottieAnimationView = LOTAnimationView(name: lottieAsset)
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.frame = CGRect(x: view.frame.midX - 72 , y: view.frame.midY - 72, width: 144, height: 144)
        self.view.addSubview(lottieAnimationView)
        lottieAnimationView.play { (finished) in completion() }
    }
    
    func hideLottie() {
        lottieAnimationView.isHidden = true
    }
    
}
