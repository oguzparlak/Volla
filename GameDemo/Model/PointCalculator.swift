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
    private let maximumTime: TimeInterval!
    
    // The time that player finished playing
    var finishedTime: TimeInterval?
    
    // Accumulated combo points so far
    private var accumulatedPointFromComboPoints = 0
    
    // Total Point earned so far
    private var totalPointFromBasePoint = 0
    
    // Total bonus points earned
    private var totalBonusPointsEarned = 0
    
    // Difficulity of the current level
    var difficulity: Difficulity!
    
    init(maximumTime: TimeInterval) {
        self.maximumTime = maximumTime
    }
    
    func calculateScoreBasedOnTime() -> Int {
        return Int((finishedTime! / maximumTime) * 1000)
    }
    
    func incrementComboCount() {
        comboCount += 1
        accumulatedPointFromComboPoints += GameUtils.getComboPointFor(comboCount: comboCount)
        totalBonusPointsEarned += accumulatedPointFromComboPoints
    }
    
    func getAccumulatedComboPoints() -> Int {
        return accumulatedPointFromComboPoints
    }
    
    func calculatePointOnCorrectGuess() -> Int {
        totalPointFromBasePoint += GameUtils.getBasePointFor(difficulity: difficulity)
        return accumulatedPointFromComboPoints + totalPointFromBasePoint
    }
    
    func resetComboCount() {
        comboCount = 0
        accumulatedPointFromComboPoints = 0
    }
    
    func getComboCount() -> Int {
        return comboCount
    }
    
    func getTotalComboPoints() -> Int {
        return totalBonusPointsEarned
    }
    
    func getBaseScore() -> Int {
        return totalPointFromBasePoint
    }
    
    func getTotal() -> Int {
        return totalPointFromBasePoint + totalBonusPointsEarned + calculateScoreBasedOnTime()
    }
    
}
