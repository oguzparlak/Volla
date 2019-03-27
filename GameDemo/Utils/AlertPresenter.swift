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
    
    func showAdDialog(onWatchAdTapped: @escaping () -> Void, onCloseTapped: @escaping () -> Void) {
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
        
        alertView.addAction(onWatchAdTapped)
        alertView.addCancelAction(onCloseTapped)
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
    
    func showInternetConnectionDialog(onCloseTapped: @escaping () -> Void) {
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "Ooops !",
            text: "No active Internet connection found. Your level is downgraded.",
            buttonText: "OK",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_warning"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
        
        alertView.addAction(onCloseTapped)
    }
    
    func showTryAgainDialog(onCloseTapped: @escaping () -> Void, onTryAgainTapped: @escaping () -> Void) {
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "Again ?",
            text: "Checkpoint saved your life. You can try again.",
            buttonText: "Try Again",
            cancelButtonText: "Cancel",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_restart"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
        
        alertView.addAction(onTryAgainTapped)
        alertView.addCancelAction(onCloseTapped)
    }
    
    func showAchievementDialog(passedLevel: Int, onOkTapped: @escaping () -> Void) {
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "Good job !",
            text: "Level \(passedLevel) passed. New checkpoint unlocked !",
            buttonText: "OK",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_trophy"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
        alertView.addAction(onOkTapped)
    }
    
    func showDifficulityPassedDialog() {
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "Good job !",
            text: "\(GameUtils.getTitleFor(difficulity: GameUtils.currentDifficulity ?? .easy)) completed. New difficulity level unlocked !",
            buttonText: "OK",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_trophy"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
    }
    
    
}
