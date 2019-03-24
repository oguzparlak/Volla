//
//  InitialViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 24.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit
import Comets
import Crashlytics

class InitialViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var circularLevelIndicator: UIView!
    @IBOutlet weak var difficulityStackView: UIStackView!
    @IBOutlet weak var difficulityLabel: UILabel!
    @IBOutlet weak var currentLevelLabel: UILabel!
    
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
        // Update LevelIndicator
        circularLevelIndicator.layer.cornerRadius = circularLevelIndicator.frame.size.width / 2
        circularLevelIndicator.clipsToBounds = true
        // Difficulity Tap Handler
        difficulityStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDifficulitySelected(_:))))
        // Update UI
        updateUiOnDifficulityChanged()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func difficulityViewTapped(_ sender: Any) {
        onDifficulitySelected(sender as AnyObject)
    }
    
    @objc func onDifficulitySelected(_ sender: AnyObject) {
        // Open an ActionSheet to choose desired difficulity
        let alertController = UIAlertController(title: nil, message: "Choose difficulity", preferredStyle: .actionSheet)
        // Create actions
        let easyAction = UIAlertAction(title: Difficulities.easy, style: .default, handler: handleOnActionSelected)
        let mediumAction = UIAlertAction(title: Difficulities.medium, style: .default, handler: handleOnActionSelected)
        let hardAction = UIAlertAction(title: Difficulities.hard, style: .default, handler: handleOnActionSelected)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        // Check availability of the levels
        mediumAction.isEnabled = StandardUtils.isDifficulityEnabled(.medium)
        hardAction.isEnabled = StandardUtils.isDifficulityEnabled(.hard)
        // Add actions
        alertController.addAction(easyAction)
        alertController.addAction(mediumAction)
        alertController.addAction(hardAction)
        alertController.addAction(cancelAction)
        // Present
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func handleOnActionSelected(selectedAction: UIAlertAction) {
        let title = selectedAction.title
        let difficulity = GameUtils.getDifficulityFor(label: title!)
        StandardUtils.updateDifficulity(difficulity)
        updateUiOnDifficulityChanged()
    }
    
    func updateUiOnDifficulityChanged() {
        // Update difficulity
        let difficulity = GameUtils.currentDifficulity
        let color = GameUtils.getColorFor(difficulity: difficulity ?? .easy)
        let difficulityDescription = GameUtils.getTitleFor(difficulity: difficulity ?? .easy)
        circularLevelIndicator.backgroundColor = color
        currentLevelLabel.textColor = color
        difficulityLabel.textColor = color
        difficulityLabel.text = difficulityDescription
        // Update level
        let currentLevel = StandardUtils.getCurrentLevelWith(difficulity: difficulity ?? .easy)
        GameUtils.currentLevel = currentLevel
        updateLevelLabel(level: currentLevel)
    }
    
    func updateUI(_ isDarkModeEnabled: Bool) {
        let backgroundColor = isDarkModeEnabled ? Colors.midnightBlue : Colors.clouds
        let image = isDarkModeEnabled ? UIImage(named: "ic_moon") : UIImage(named: "ic_sun")
        let progressImage = isDarkModeEnabled ? UIImage(named: "ic_progress") : UIImage(named: "ic_progress_blue")
        progressButton.setImage(progressImage, for: .normal)
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
        // Send a log to Fabric
        Answers.logCustomEvent(withName: "themeChanged", customAttributes: ["darkModeEnabled" : isDarkModeEnabled])
    }
    @IBAction func progressButtonTapped(_ sender: UIButton) {
        let progressViewController = storyboard?.instantiateViewController(withIdentifier: "progress_vc") as! ProgressViewController
        present(progressViewController, animated: true, completion: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        // Log an Event to Fabric
        let currentLevel = userDefaults.integer(forKey: "current_level")
        Answers.logLevelStart(currentLevel.description, customAttributes: nil)
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
    
    func updateLevelLabel(level: Int) {
        let currentLevelDescription = String(format: NSLocalizedString("level", comment: ""), level)
        currentLevelLabel.text = currentLevelDescription
    }
    
}
