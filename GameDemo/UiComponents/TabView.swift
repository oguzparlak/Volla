//
//  TabView.swift
//  GameDemo
//
//  Created by Oguz Parlak on 16.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import UIKit

class TabView: UIButton {
    
    var difficulity: Difficulity = .easy
    
    @IBInspectable
    var activeColor: UIColor = Colors.peterRiver
    
    @IBInspectable
    var text: String? {
        set {
            setTitle(newValue, for: .normal)
        }
        get {
            return currentTitle
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
    
    @IBInspectable
    var disabled: Bool = true {
        didSet {
            titleLabel?.textColor = disabled ? Colors.asbestos : activeColor
            layer.borderWidth = 0
            setNeedsDisplay()
        }
    }

}
