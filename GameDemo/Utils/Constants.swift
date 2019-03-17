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
    
}

enum StandardUtils {
    
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
    
}
