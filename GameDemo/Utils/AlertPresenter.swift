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
            title: NSLocalizedString("opportunity", comment: ""),
            text: NSLocalizedString("downgradeWarning", comment: ""),
            buttonText: NSLocalizedString("watchAd", comment: ""),
            cancelButtonText: NSLocalizedString("close", comment: ""),
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
            title: NSLocalizedString("warning", comment: ""),
            text: NSLocalizedString("levelDowngradeWarning", comment: ""),
            buttonText: NSLocalizedString("stay", comment: ""),
            cancelButtonText: NSLocalizedString("exit", comment: ""),
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
            text: NSLocalizedString("downgradeOnNoConnection", comment: ""),
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
            title: NSLocalizedString("again", comment: ""),
            text: NSLocalizedString("checkpointMessage", comment: ""),
            buttonText: NSLocalizedString("tryAgain", comment: ""),
            cancelButtonText: NSLocalizedString("cancel", comment: ""),
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
            title: NSLocalizedString("goodJob", comment: ""),
            text: String(format: NSLocalizedString("levelPassed", comment: ""), passedLevel),
            buttonText: "OK",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_flag"))
        
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
        alertView.addAction(onOkTapped)
    }
    
    func showDifficulityPassedDialog(onOkTapped: @escaping () -> Void) {
        let difficulity = GameUtils.getTitleFor(difficulity: GameUtils.currentDifficulity ?? .easy)
        let alertView = JSSAlertView().show(
            rootViewController,
            title: "Good job !",
            text: String(format: NSLocalizedString("difficulityPassed", comment: ""), difficulity),
            buttonText: "OK",
            color: Colors.clouds,
            iconImage: UIImage(named: "ic_trophy"))
        
        alertView.addAction(onOkTapped)
        alertView.setTextFont("Avenir")
        alertView.setTitleFont("Avenir")
        alertView.setButtonFont("Avenir")
    }
    
    
}
