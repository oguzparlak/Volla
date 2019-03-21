//
//  ProgressViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 16.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit
import ActivityRings

class ProgressViewController: UIViewController {

    @IBOutlet weak var highScoreValueLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var remainingLevelsLabel: UILabel!
    @IBOutlet weak var ringContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var seperatorView: UIView!
    
    lazy var progressLabel: UILabel = {
        let progressLabel = UILabel(frame: CGRect(x: ringContainer.frame.width / 2 - 20, y: ringContainer.frame.height / 2 - 45 , width: 90, height: 90))
        progressLabel.textColor = activeTabColor
        progressLabel.font = UIFont(name: "Avenir", size: 18)
        return progressLabel
    }()
    
    var activeTabColor: UIColor?
    
    var ringView: ActivityRingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeTabColor = Colors.alizarin
        
        progressLabel.text = "%75"
        
        // Init RingView
        ringView = ActivityRingView(frame: CGRect(x: 0, y: 0, width: ringContainer.frame.width, height: ringContainer.frame.height))
        ringView?.ringWidth = 20
        
        // Add Subviews
        ringContainer.addSubview(ringView!)
        ringContainer.addSubview(progressLabel)
        
        updateProgress(with: 0.65)
    }
    
    func updateProgress(with progress: Double) {
        ringView?.startColor = activeTabColor!
        ringView?.endColor = activeTabColor!
        ringView?.animateProgress(to: progress, withDuration: 1)
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        let title = sender.getCurrentTitle()!
        let difficulity = GameUtils.getDifficulityFor(label: title)
        let color = GameUtils.getColorFor(difficulity: difficulity)
        activeTabColor = color
        sender.tintColor = activeTabColor
        updateProgress(with: 0.45)
    }
}

extension UISegmentedControl {
    
    func getCurrentTitle() -> String? {
        return self.titleForSegment(at: selectedSegmentIndex)
    }
    
}
