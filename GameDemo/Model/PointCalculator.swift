//
//  PointCalculator.swift
//  GameDemo
//
//  Created by Oguz Parlak on 3.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

class PointCalculator {
    
    // The succesive correct guesses of the user
    private var comboCount = 0
    
    // The countdown timer where it starts from
    private let maximumTime: Int!
    
    // The time that player finished playing
    private var finishedTime: Int?
    
    // Accumulated combo points so far
    private var accumulatedPointFromComboPoints = 0
    
    // Difficulity of the current level
    private var difficulity: Difficulity!
    
    init(maximumTime: Int) {
        self.maximumTime = maximumTime
    }
    
    func calculateScoreBasedOnTime() -> Int {
        return (finishedTime! / maximumTime) * 1000
    }
    
    func calculateTotal() -> Int {
        return (calculateScoreBasedOnTime() + accumulatedPointFromComboPoints) * GameUtils.getDifficulityMultiplierFor(difficulity: difficulity)
    }
    
    func incrementComboCount() {
        comboCount += 1
        accumulatedPointFromComboPoints += GameUtils.getComboPointFor(comboCount: comboCount)
    }
    
    func resetComboCount() {
        comboCount = 0
    }
    
    
}
