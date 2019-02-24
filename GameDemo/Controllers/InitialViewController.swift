//
//  InitialViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 24.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.clouds
        playButton.alpha = 0.0
        UIView.animate(withDuration: 1.5) {
            self.playButton.alpha = 1.0
        }
    
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(withIdentifier: "game_vc") as! GameViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
    
}
