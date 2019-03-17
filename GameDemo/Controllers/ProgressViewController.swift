//
//  ProgressViewController.swift
//  GameDemo
//
//  Created by Oguz Parlak on 16.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var tabView: TabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.activeColor = Colors.peterRiver
        tabView.disabled = false
        tabView.text = "Easy"
        
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
