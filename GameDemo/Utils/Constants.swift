//
//  Constants.swift
//  GameDemo
//
//  Created by Oguz Parlak on 17.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

enum Keys {
    
    static let currentLevelKeyForEasy = "current_level_for_easy"
    
    static let currentLevelKeyForMedium = "current_level_for_medium"
    
    static let currentLevelKeyForHard = "current_level_for_hard"
    
    static let currentDifficulityKey = "current_difficulity"
    
    static let easyLevelsKey = "easy_levels"
    
    static let mediumLevelsKey = "medium_levels"
    
    static let hardLevelsKey = "hard_levels"
    
    static let levelsParsedKey = "all_levels_parsed"
    
    static func highScoreKey(for difficulity: Difficulity) -> String {
        return "high_score_\(difficulity.rawValue)"
    }
    
    static func totalScoreKey(for difficulity: Difficulity) -> String {
        return "total_score_\(difficulity.rawValue)"
    }
    
    static func getIsLockedKey(_ difficulity: Difficulity) -> String {
        return "is_locked_\(difficulity.rawValue)"
    }
    
}

enum StandardUtils {
    
    static func updateTotalPoint(with difficulity: Difficulity, point: Int) {
        let userDefaults = UserDefaults.standard
        let key = Keys.totalScoreKey(for: difficulity)
        // Get previous score
        let previousScore = userDefaults.integer(forKey: key)
        // Add the new score and store it
        userDefaults.set(point + previousScore, forKey: key)
    }
    
    static func updateHighScore(with difficulity: Difficulity, point: Int) {
        let userDefaults = UserDefaults.standard
        let key = Keys.highScoreKey(for: difficulity)
        let previousHighScore = userDefaults.integer(forKey: key)
        if point > previousHighScore {
            userDefaults.set(point, forKey: key)
        }
    }
    
    static func getHighScore(of difficulity: Difficulity) -> Int {
        let userDefaults = UserDefaults.standard
        let key = Keys.highScoreKey(for: difficulity)
        return userDefaults.integer(forKey: key)
    }
    
    static func getTotalScore(of difficulity: Difficulity) -> Int {
        let userDefaults = UserDefaults.standard
        let key = Keys.totalScoreKey(for: difficulity)
        return userDefaults.integer(forKey: key)
    }
    
    static func getKeyOfLevelLabel(by difficulity: Difficulity) -> String {
        switch difficulity {
        case .easy:
            return Keys.easyLevelsKey
        case .medium:
            return Keys.mediumLevelsKey
        case .hard:
            return Keys.hardLevelsKey
        }
    }
    
    static func getKeyFor(difficulity: Difficulity) -> String {
        switch difficulity {
        case .easy:
            return Keys.currentLevelKeyForEasy
        case .medium:
            return Keys.currentLevelKeyForMedium
        case .hard:
            return Keys.currentLevelKeyForHard
        }
    }
    
    // Updates the current difficulity
    static func updateDifficulity(_ difficulity: Difficulity) {
        GameUtils.currentDifficulity = difficulity
        UserDefaults.standard.set(difficulity.rawValue, forKey: Keys.currentDifficulityKey)
    }
    
    // Returns the current level with specified difficulity
    static func getCurrentLevelWith(difficulity: Difficulity) -> Int {
        let userDefaults = UserDefaults.standard
        let level = userDefaults.integer(forKey: StandardUtils.getKeyFor(difficulity: difficulity))
        return level == 0 ? 1 : level
    }
    
    // Called only once in the AppDelegate
    static func setCurrentDifficulity() {
        let userDefaults = UserDefaults.standard
        let difficulityAsString = userDefaults.string(forKey: Keys.currentDifficulityKey)
        let difficulity = Difficulity(rawValue: difficulityAsString ?? "easy")
        GameUtils.currentDifficulity = difficulity
    }
    
    // Called only once in the AppDelegate
    static func setCurrentLevel() {
        let userDefaults = UserDefaults.standard
        let difficulity = GameUtils.currentDifficulity
        let difficulityKeyForLevel = StandardUtils.getKeyFor(difficulity: difficulity ?? .easy)
        let level = userDefaults.integer(forKey: difficulityKeyForLevel)
        GameUtils.currentLevel = level
    }
    
    // Returns true if the difficulity is locked
    static func isDifficulityLocked(_ difficulity: Difficulity) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: Keys.getIsLockedKey(difficulity))
    }
    
    static func decrementCurrentLevelByOne() {
        let userDefaults = UserDefaults.standard
        let key = StandardUtils.getKeyFor(difficulity: GameUtils.currentDifficulity ?? .easy)
        let level = userDefaults.integer(forKey: key)
        let previousLevel = level - 1
        if previousLevel == 0 { return }
        GameUtils.currentLevel = previousLevel
        userDefaults.set(previousLevel, forKey: key)
    }
    
    static func enableDifficulity(_ difficulity: Difficulity) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: Keys.getIsLockedKey(difficulity))
    }
    
    // Called only once in the AppDelegate
    static func unlockEasy() {
        enableDifficulity(.easy)
    }
    
}
