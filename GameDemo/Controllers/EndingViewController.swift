//
//  EndingViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 1.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit
import BubbleTransition

class EndingViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
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
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endButtonTapped(_ sender: UIButton) {
        // If success go to next level
        // If not re-play the existing level
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
        
    }

}
