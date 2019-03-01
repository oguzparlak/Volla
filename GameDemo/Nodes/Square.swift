//
//  Square.swift
//  GameDemo
//
//  Created by Oguz Parlak on 7.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import SpriteKit

class Square : SKShapeNode {
    
    enum State {
        case opened, closed, disabled
    }
    
    // A board comes with closed state by default
    var state: State = .closed {
        didSet {
            updateAppearence()
        }
    }
    
    // The coordinates that this square is lays on
    var coordinates: (Int, Int) = (0, 0)
    
    // The value behind this square
    var value: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    convenience init(rect: CGRect) {
        self.init(rect: rect, cornerRadius: NodeUtils.cornerRadiusOfSquares)
        fillColor = Colors.alizarin
        strokeColor = .clear
        isAntialiased = true
    }
    
    private func updateAppearence() {
        switch state {
        case .closed:
            self.run(SKAction.colorTransitionAction(fromColor: self.fillColor, toColor: Colors.alizarin))
            fadeOut()
        case .disabled:
            let disabledSquareColor = NodeUtils.darkModeEnabled ? Colors.midnightBlue : Colors.clouds
            self.run(SKAction.colorTransitionAction(fromColor: self.fillColor, toColor: disabledSquareColor))
            fadeOut()
        case .opened:
            self.run(SKAction.colorTransitionAction(fromColor: self.fillColor, toColor: Colors.peterRiver))
            fadeIn()
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let simpleValue = value
        let anotherSquare = object as? Square
        let anotherSquareValue = anotherSquare?.value
        return anotherSquareValue == simpleValue
    }
    
    func didTouch() {
        print(coordinates)
    }
    
}

extension Square {
    
    func fadeIn() {
        if self.children.count < 1 { return }
        let firstChild = self.children[0]
        firstChild.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func fadeOut() {
        if self.children.count < 1 { return }
        let firstChild = self.children[0]
        firstChild.run(SKAction.fadeOut(withDuration: 0.5))
    }
}
