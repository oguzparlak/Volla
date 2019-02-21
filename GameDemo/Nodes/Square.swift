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
    var value: Any?
    
    var isSimplyRepresentable = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    convenience init(rect: CGRect) {
        self.init(rect: rect, cornerRadius: NodeConstants.cornerRadiusOfSquares)
        fillColor = Colors.alizarin
        strokeColor = .clear
        isAntialiased = true
    }
    
    private func updateAppearence() {
        switch state {
        case .closed:
            self.run(SKAction.colorTransitionAction(fromColor: self.fillColor, toColor: Colors.alizarin))
        case .disabled:
            fillColor = Colors.asbestos
        case .opened:
            self.run(SKAction.colorTransitionAction(fromColor: self.fillColor, toColor: Colors.peterRiver))
            // self.run(SKAction.scale(by: 1.01, duration: 0.4))
        }
    }
    
    func didTouch() {
        print(coordinates)
    }
    
}

extension Square {
    
    func fadeIn() {
        self.children[0].run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    func fadeOut() {
        self.children[0].run(SKAction.fadeOut(withDuration: 0.5))
    }
}
