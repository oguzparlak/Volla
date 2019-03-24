//
//  AlertPresenter.swift
//  GameDemo
//
//  Created by Oguz Parlak on 24.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import JSSAlertView

class AlertPresenter {
    
    private var rootViewController: UIViewController!
    
    init(with rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func showAdDialog() {
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "An opportunity !",
            text: "You'll be downgraded 1 level back. Watch an ad to play again.",
            buttonText: "Watch Ad",
            cancelButtonText: "Close",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_glasses"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
    }
    
    func showWarningDialog(onStayTapped: @escaping () -> Void, onExitTapped: @escaping () -> Void) {
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "Warning !",
            text: "If you close the game your level will be downgraded.",
            buttonText: "Stay",
            cancelButtonText: "Exit",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_warning"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
        
        alertView.addAction(onStayTapped)
        alertView.addCancelAction(onExitTapped)
    }
    
    func showAchievementDialog() {
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "Good job !",
            text: "Level 10 passed. New checkpoint unlocked !",
            cancelButtonText: "Close",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_warning"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
    }
    
    
}
