//
//  InitialViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 24.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit
import Comets

class InitialViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var themeButton: UIButton!
    
    private var userDefaults = UserDefaults.standard
    
    private var isDarkModeEnabled = false
    
    private var comets: [Comet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startParticleAnimation()
        // Read the theme preference from UserDefaults
        isDarkModeEnabled = userDefaults.bool(forKey: "dark_mode_enabled")
        NodeUtils.darkModeEnabled = isDarkModeEnabled
        updateUI(isDarkModeEnabled)
        playButton.alpha = 0.0
        // Animate play button only once
        UIView.animate(withDuration: 0.5) {
            self.playButton.alpha = 1.0
        }
    }
    
    func updateUI(_ isDarkModeEnabled: Bool) {
        let backgroundColor = isDarkModeEnabled ? Colors.midnightBlue : Colors.clouds
        let image = isDarkModeEnabled ? UIImage(named: "ic_moon") : UIImage(named: "ic_sun")
        let cometLineColor = isDarkModeEnabled ? Colors.clouds.withAlphaComponent(0.2) : Colors.midnightBlue.withAlphaComponent(0.2)
        themeButton.setImage(image, for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = backgroundColor
            // Animate Particles
            for i in 0...self.comets.count - 1 {
                var comet = self.comets[i]
                comet.lineColor = cometLineColor
            }
        }
    }
    
    @IBAction func themeButtonTapped(_ sender: UIButton) {
        isDarkModeEnabled = !isDarkModeEnabled
        // Update user defaults
        userDefaults.set(isDarkModeEnabled, forKey: "dark_mode_enabled")
        // update UI
        updateUI(isDarkModeEnabled)
        NodeUtils.darkModeEnabled = isDarkModeEnabled
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let gameViewController = storyboard?.instantiateViewController(withIdentifier: "game_vc") as! GameViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
    
    private func startParticleAnimation() {
        let width = view.bounds.width
        let height = view.bounds.height
        let cometColor = isDarkModeEnabled ? Colors.clouds : Colors.midnightBlue
        comets = [Comet(startPoint: CGPoint(x: 100, y: 0),
                            endPoint: CGPoint(x: 0, y: 100),
                            lineColor: cometColor.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.8 * width),
                            lineColor: cometColor.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.2 * width),
                            lineColor: cometColor.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                            endPoint: CGPoint(x: 0, y: 0.25 * height),
                            lineColor: cometColor.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                            endPoint: CGPoint(x: 0.6 * width, y: height),
                            lineColor: cometColor.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: width - 100, y: height),
                            endPoint: CGPoint(x: width, y: height - 100),
                            lineColor: cometColor.withAlphaComponent(0.2)),
                      Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                            endPoint: CGPoint(x: width, y: 0.75 * height),
                            lineColor: cometColor.withAlphaComponent(0.2))]
        
        // draw line track and animate
        for comet in comets {
            view.layer.addSublayer(comet.drawLine())
            view.layer.addSublayer(comet.animate())
        }
    }
    
}
