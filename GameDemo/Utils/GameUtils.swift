//
//  LevelUtils.swift
//  GameDemo
//
//  Created by Oguz Parlak on 3.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

enum Difficulity: String {
    case easy, medium, hard
}

enum GameUtils {
    
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
    
}
