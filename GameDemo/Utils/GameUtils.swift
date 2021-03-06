//
//  LevelUtils.swift
//  GameDemo
//
//  Created by Oguz Parlak on 3.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import UIKit

enum Difficulity: String {
    case easy, medium, hard
    
    func next() -> Difficulity? {
        switch self {
        case .easy:
            return .medium
        case .medium:
            return .hard
        case .hard:
            return nil
        }
    }
}

enum Difficulities {
    
    static let easy = NSLocalizedString("easy", comment: "")
    
    static let medium = NSLocalizedString("medium", comment: "")
    
    static let hard = NSLocalizedString("hard", comment: "")
    
}

enum GameUtils {
    
    // Selected difficulity
    static var currentDifficulity: Difficulity?
    
    // Current level that will be played when user hits play button
    static var currentLevel: Int?
    
    // 40 levels for each difficulity
    static let gameCountForEachLevel = 40
    
    // A flag that indicates whether user is
    // currently playing or not
    static var inGame: Bool = false
    
    // The remaining lives will increment by this value
    // when 3 successive answer is achieved by the user
    static let remainingLivesToIncrementWhenComboHappened = 5
    
    // The successive correct answer count to
    // gain the lives
    static let comboCountToAchieveRemainingLives = 2
    
    static func shouldEarnLives(currentComboPoint: Int) -> Bool {
        return currentComboPoint != 0 && currentComboPoint % comboCountToAchieveRemainingLives == 0
    }
    
    static func isCheckPoint() -> Bool {
        return (currentLevel! + 1) % 10 == 0
    }
    
    static func newLevelUnlocked() -> Bool {
        return !StandardUtils.isDifficulityLocked(currentDifficulity?.next() ?? .easy) && currentDifficulity! != .hard && currentLevel! == gameCountForEachLevel
    }
    
    // Returns remaining lives for specified difficulity
    static func getRemainingLivesFor(difficulity: Difficulity) -> Int {
        switch difficulity {
        case .easy:
            return 5
        case .medium:
            return 10
        case .hard:
            return 15
        }
    }
    
    // Returns the base point for each correct guess
    // depending of difficulity
    static func getBasePointFor(difficulity: Difficulity) -> Int {
        switch difficulity {
        case .easy:
            return 50
        case .medium:
            return 100
        case .hard:
            return 150
        }
    }
    
    // Returns difficulity
    // with specified label
    static func getDifficulityFor(label: String) -> Difficulity {
        switch label {
        case Difficulities.easy:
            return .easy
        case Difficulities.medium:
            return .medium
        case Difficulities.hard:
            return .hard
        default:
            return .easy
        }
    }
    
    static func getTitleFor(difficulity: Difficulity) -> String {
        switch difficulity {
        case .easy:
            return Difficulities.easy
        case .medium:
            return Difficulities.medium
        case .hard:
            return Difficulities.hard
        }
    }
    
    static func getCountDownFor(difficulity: Difficulity) -> Int {
        switch difficulity {
        case .easy:
            return 30
        case .medium:
            return 90
        case .hard:
            return 120
        }
    }
    
    // Returns the color of the specified difficulity
    static func getColorFor(difficulity: Difficulity) -> UIColor {
        switch difficulity {
        case .easy:
            return Colors.peterRiver
        case .medium:
            return Colors.emerald
        case .hard:
            return Colors.alizarin
        }
    }
    
    static func getDifficulityMultiplierFor(difficulity: Difficulity) -> Int {
        switch difficulity {
        case .easy:
            return 1
        case .medium:
            return 2
        case .hard:
            return 3
        }
    }
    
    static func getComboPointFor(comboCount: Int) -> Int {
        switch comboCount {
        case 1:
            return 50
        case 2:
            return 100
        case 3:
            return 150
        case 4:
            return 200
        case 5...Int.max:
            return 250
        default:
            return 0
        }
    }
    
    static func load(level: Int, with difficulity: Difficulity) -> RawLevel? {
        if let data = UserDefaults.standard.value(forKey: StandardUtils.getKeyOfLevelLabel(by: difficulity)) as? Data {
            let rawLevels = try? PropertyListDecoder().decode(Array<RawLevel>.self, from: data)
            let rawLevel = rawLevels?.first(where: { (rawLevel) -> Bool in
                rawLevel.level == level && rawLevel.difficulity == difficulity.rawValue
            })
            return rawLevel
        }
        return nil
    }
    
    static func loadLevels() {
        let userDefaults = UserDefaults.standard
        let levelsParsed = userDefaults.bool(forKey: Keys.levelsParsedKey)
        // If levels are not parsed yet
        if !levelsParsed {
            // Parse levels for each category
            parseLevels(with: Keys.easyLevelsKey)
            parseLevels(with: Keys.mediumLevelsKey)
            parseLevels(with: Keys.hardLevelsKey)
            // Update levels_parsed key
            userDefaults.set(true, forKey: Keys.levelsParsedKey)
            // Save the starting level
            userDefaults.set(1, forKey: Keys.currentLevelKeyForEasy)
            userDefaults.set(1, forKey: Keys.currentLevelKeyForMedium)
            userDefaults.set(1, forKey: Keys.currentLevelKeyForHard)
        }
    }
    
    private static func parseLevels(with fileName: String) {
        let userDefaults = UserDefaults.standard
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let levels = jsonResult as? Array<Dictionary<String, Any>> {
                    // do stuff
                    var rawLevels: [RawLevel] = []
                    for level in levels {
                        let rawLevel = RawLevel(json: level)
                        rawLevels.append(rawLevel)
                    }
                    // Encode levels and save it to UserDefaults
                    userDefaults.set(try? PropertyListEncoder().encode(rawLevels), forKey: fileName)
                }
            } catch {
                // handle error
            }
        }
    }

    static func incrementCurrentLevel() {
        let userDefaults = UserDefaults.standard
        let difficulityKey = StandardUtils.getKeyFor(difficulity: GameUtils.currentDifficulity ?? .easy)
        let currentLevel = userDefaults.integer(forKey: difficulityKey)
        let nextLevel = currentLevel + 1
        if let data = UserDefaults.standard.value(forKey: StandardUtils.getKeyOfLevelLabel(by: GameUtils.currentDifficulity ?? .easy)) as? Data {
            let rawLevels = try? PropertyListDecoder().decode(Array<RawLevel>.self, from: data)
            let filteredLevelsBasedOnDifficulity = rawLevels?.filter({ (level) -> Bool in
                level.difficulity == GameUtils.currentDifficulity?.rawValue
            })
            if nextLevel > (filteredLevelsBasedOnDifficulity?.count)! {
                if let nextDifficulity = GameUtils.currentDifficulity?.next() {
                    let newLevel = StandardUtils.getCurrentLevelWith(difficulity: nextDifficulity)
                    GameUtils.currentLevel = newLevel
                    StandardUtils.updateDifficulity(nextDifficulity)
                    // Unlock
                    StandardUtils.enableDifficulity(nextDifficulity)
                }
                return
            }
        }
        // Switch to next level
        GameUtils.currentLevel = nextLevel
        userDefaults.set(nextLevel, forKey: difficulityKey)
    }
    
}
