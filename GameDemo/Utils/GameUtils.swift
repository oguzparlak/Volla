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
}

enum GameUtils {
    
    // Selected difficulity
    static var currentDifficulity: Difficulity?
    
    // Current level that will be played when user hits play button
    static var currentLevel: RawLevel?
    
    // Returns difficulity
    // with specified label
    static func getDifficulityFor(label: String) -> Difficulity {
        switch label {
        case NSLocalizedString("easy", comment: ""):
            return .easy
        case NSLocalizedString("medium", comment: ""):
            return .medium
        case NSLocalizedString("hard", comment: ""):
            return .hard
        default:
            return .easy
        }
    }
    
    static func updateDifficulity(_ difficulity: Difficulity) {
        currentDifficulity = difficulity
        UserDefaults.standard.set(difficulity.rawValue, forKey: Keys.currentDifficulityKey)
    }
    
    static func updateCurrentLevel(_ level: RawLevel, with difficulity: Difficulity) {
        currentLevel = level
        let difficulityKeyForLevel = StandardUtils.getKeyFor(difficulity: difficulity)
        UserDefaults.standard.set(currentLevel?.level, forKey: difficulityKeyForLevel)
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
        case 1...2:
            return 100
        case 2...4:
            return 200
        case 4...6:
            return 300
        case 6...Int.max:
            return 400
        default:
            return 0
        }
    }
    
    static func load(level: Int) -> RawLevel? {
        if let data = UserDefaults.standard.value(forKey:"levels") as? Data {
            let rawLevels = try? PropertyListDecoder().decode(Array<RawLevel>.self, from: data)
            let rawLevel = rawLevels?.first(where: { (rawLevel) -> Bool in
                rawLevel.level == level
            })
            return rawLevel
        }
        return nil
    }
    
    static func loadLevels() {
        let userDefaults = UserDefaults.standard
        let levelsParsed = userDefaults.bool(forKey: "levels_parsed")
        if !levelsParsed {
            if let path = Bundle.main.path(forResource: "levels", ofType: "json") {
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
                        userDefaults.set(try? PropertyListEncoder().encode(rawLevels), forKey:"levels")
                        // Save the starting level
                        userDefaults.set(1, forKey: Keys.currentLevelKeyForEasy)
                        // Update levels_parsed key
                        userDefaults.set(true, forKey: "levels_parsed")
                    }
                } catch {
                    // handle error
                }
            }
        }
    }
    
    // TODO Change it according to difficulity
    static func incrementCurrentLevel() {
        let userDefaults = UserDefaults.standard
        let currentLevel = userDefaults.integer(forKey: "current_level")
        if let data = UserDefaults.standard.value(forKey:"levels") as? Data {
            let rawLevels = try? PropertyListDecoder().decode(Array<RawLevel>.self, from: data)
            if currentLevel + 1 > (rawLevels?.count)! {
                return
            }
        }
        userDefaults.set(currentLevel + 1, forKey: "current_level")
    }
    
}
