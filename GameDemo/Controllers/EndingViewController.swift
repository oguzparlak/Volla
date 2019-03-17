//
//  EndingViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 1.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit
import BubbleTransition
import Lottie

class EndingViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var difficulityMultiplierValue: UILabel!
    @IBOutlet weak var difficulityMultiplierLabel: UILabel!
    @IBOutlet weak var comboCountValue: UILabel!
    @IBOutlet weak var comboCountLabel: UILabel!
    @IBOutlet weak var scoreBaseOnTimeValue: UILabel!
    @IBOutlet weak var scoreBaseOnTimeLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    
    let transition = BubbleTransition()
    
    var successfullyFinishedGame = true
    
    var currentLevel: Int!
    
    var pointDictionary: [String : Any]?
    
    weak var gameViewController: GameViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init or Update views
        self.view.backgroundColor = successfullyFinishedGame ? Colors.emerald : Colors.alizarin
        endButton.layer.cornerRadius = 4.0
        
        // Set transition delegate
        self.transitioningDelegate = self
        
        // Update UI according to finish
        updateUI(when: successfullyFinishedGame)
        
        // Dismiss previous controller after some delay
        gameViewController.dismiss(animated: false, completion: nil)
        
        // If fail then play sad Lottie Animation
        if !successfullyFinishedGame {
            showSadFaceAnimation()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endButtonTapped(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(withIdentifier: "game_vc") as! GameViewController
        gameViewController.endingViewController = self
        present(gameViewController, animated: true, completion: nil)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = view.center
        transition.bubbleColor = Colors.emerald
        transition.duration = 0.25
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = view.center
        transition.bubbleColor = Colors.emerald
        transition.duration = 0.25
        return transition
    }
    
    private func updateUI(when success: Bool) {
        indicatorLabel.text = success ? NSLocalizedString("success", comment: "Success") : NSLocalizedString("failure", comment: "")
        
        totalValue.isHidden = !success
        totalLabel.isHidden = !success
        difficulityMultiplierLabel.isHidden = !success
        difficulityMultiplierValue.isHidden = !success
        comboCountLabel.isHidden = !success
        comboCountValue.isHidden = !success
        scoreBaseOnTimeLabel.isHidden = !success
        scoreBaseOnTimeValue.isHidden = !success
        
        scoreBaseOnTimeLabel.text = NSLocalizedString("scoreBasedOnTime", comment: "")
        difficulityMultiplierLabel.text = NSLocalizedString("difficulityMultiplier", comment: "")
        comboCountLabel.text = NSLocalizedString("comboCount", comment: "")
        totalLabel.text = NSLocalizedString("total", comment: "")
        
        if success {
            scoreBaseOnTimeValue.text = String(pointDictionary!["scoreBasedOnTime"] as! Int)
            comboCountValue.text = String(pointDictionary!["comboCount"] as! Int)
            difficulityMultiplierValue.text = "x" + String(((pointDictionary!["difficulityMultiplier"] as! Int)))
            totalValue.text = String(pointDictionary!["total"] as! Int)
        }
        
        let endButtonTitle = success ? NSLocalizedString("continue", comment: "") : NSLocalizedString("tryAgain", comment: "")
        endButton.setTitle(endButtonTitle, for: .normal)
        
        let endButtonFontColor = success ? Colors.emerald : Colors.peterRiver
        endButton.setTitleColor(endButtonFontColor, for: .normal)
        
    }
    
    func showSadFaceAnimation() {
        let sadFaceAnimation = LOTAnimationView(name: "sad_face")
        sadFaceAnimation.contentMode = .scaleAspectFit
        sadFaceAnimation.loopAnimation = true
        let widthOfLottie: CGFloat = 248
        sadFaceAnimation.frame = CGRect(x: view.frame.midX - widthOfLottie / 2, y: view.frame.midY - widthOfLottie / 2, width: widthOfLottie, height: widthOfLottie)
        self.view.addSubview(sadFaceAnimation)
        sadFaceAnimation.play()
    }

}
