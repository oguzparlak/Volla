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

class GameViewController: UIViewController {
    
    var lottieAnimationView: LOTAnimationView!

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
                // Change the bg color
                scene.backgroundColor = Colors.clouds
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
    
    func initLottie(isSucess: Bool = true) {
        let lottieAsset = isSucess ? "success" : "success"
        lottieAnimationView = LOTAnimationView(name: lottieAsset)
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.frame = CGRect(x: view.frame.midX - 72 , y: view.frame.midY - 72, width: 144, height: 144)
        self.view.addSubview(lottieAnimationView)
    }
    
    func playLottie(with callback: @escaping () -> ()) {
        lottieAnimationView.play { (finished) in callback() }
    }
    
    func hideLottie() {
        lottieAnimationView.isHidden = true
    }
    
    func showLottie() {
        lottieAnimationView.isHidden = false
    }
    
}
