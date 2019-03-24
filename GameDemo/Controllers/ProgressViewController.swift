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

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var highScoreValueLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var remainingLevelsLabel: UILabel!
    @IBOutlet weak var ringContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var progressTitleLabel: UILabel!
    
    lazy var progressLabel: UILabel = {
        let progressLabel = UILabel(frame: CGRect(x: ringContainer.frame.width / 2 - 15, y: ringContainer.frame.height / 2 - 45 , width: 90, height: 90))
        progressLabel.textColor = activeTabColor
        progressLabel.font = UIFont(name: "Avenir", size: 18)
        return progressLabel
    }()
    
    var activeTabColor: UIColor?
    
    var ringView: ActivityRingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Respond the changes to the theme
        self.view.backgroundColor = NodeUtils.darkModeEnabled ? Colors.midnightBlue : Colors.clouds
        // Set active tab color
        activeTabColor = GameUtils.getColorFor(difficulity: GameUtils.currentDifficulity ?? .easy)
        // Init RingView
        ringView = ActivityRingView(frame: CGRect(x: 0, y: 0, width: ringContainer.frame.width, height: ringContainer.frame.height))
        ringView?.ringWidth = 20
        // Add Subviews
        ringContainer.addSubview(ringView!)
        ringContainer.addSubview(progressLabel)
        // Enable - Disable segments
        updateSegmentAvailability()
        // Select segment
        updateSelectedSegment()
        
    }
    
    private func updateSelectedSegment() {
        let difficulity = GameUtils.currentDifficulity
        var selectedIndex = 0
        switch difficulity {
        case .medium?:
            selectedIndex = 1
        case .hard?:
            selectedIndex = 2
        default:
            selectedIndex = 0
        }
        segmentedControl.selectedSegmentIndex = selectedIndex
        segmentValueChanged(segmentedControl)
    }
    
    private func updateSegmentAvailability() {
        let segmentCount = segmentedControl.numberOfSegments
        for i in 0...segmentCount - 1 {
            let segmentTitle = segmentedControl.titleForSegment(at: i)
            let difficulity: Difficulity = GameUtils.getDifficulityFor(label: segmentTitle!)
            let isEnabled = StandardUtils.isDifficulityEnabled(difficulity)
            segmentedControl.setEnabled(isEnabled, forSegmentAt: i)
        }
    }
    
    func updateProgress(with progress: Double) {
        ringView?.startColor = activeTabColor!
        ringView?.endColor = activeTabColor!
        ringView?.animateProgress(to: progress, withDuration: 1)
        seperatorView.backgroundColor = activeTabColor
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        let title = segmentedControl.getCurrentTitle()!
        let difficulity = GameUtils.getDifficulityFor(label: title)
        let color = GameUtils.getColorFor(difficulity: difficulity)
        activeTabColor = color
        segmentedControl.tintColor = activeTabColor
        progressLabel.textColor = activeTabColor
        // Set percentage
        let currentLevel = StandardUtils.getCurrentLevelWith(difficulity: difficulity)
        let percentage = Double(currentLevel) / Double(GameUtils.gameCountForEachLevel)
        progressLabel.text = "%\(Int(percentage * 100))"
        updateProgress(with: percentage)
        // Update remaining levels label
        remainingLevelsLabel.text = "\(currentLevel) / \(GameUtils.gameCountForEachLevel)"
        // Update labels
        totalLabel.textColor = activeTabColor
        totalValueLabel.textColor = activeTabColor
        highScoreLabel.textColor = activeTabColor
        highScoreValueLabel.textColor = activeTabColor
        remainingLevelsLabel.textColor = activeTabColor
        progressTitleLabel.textColor = activeTabColor
        closeButton.setImage(getImageFor(color: activeTabColor!), for: .normal)
    }
    
    private func getImageFor(color: UIColor) -> UIImage? {
        switch color {
        case Colors.alizarin:
            return UIImage(named: "ic_close_red")
        case Colors.peterRiver:
            return UIImage(named: "ic_close_blue")
        case Colors.emerald:
            return UIImage(named: "ic_close_green")
        default:
            return UIImage(named: "ic_close_green")
        }
    }
}

extension UISegmentedControl {
    
    func getCurrentTitle() -> String? {
        return self.titleForSegment(at: selectedSegmentIndex)
    }
    
}
