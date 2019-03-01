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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.emerald
        
        endButton.layer.cornerRadius = 4.0
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endButtonTapped(_ sender: UIButton) {
        
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: view.frame.midX, y: view.frame.maxY)
        transition.bubbleColor = Colors.emerald
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: view.frame.midX, y: view.frame.maxY)
        transition.bubbleColor = Colors.emerald
        return transition
    }

}
