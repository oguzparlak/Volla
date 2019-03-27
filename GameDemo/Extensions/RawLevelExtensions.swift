//
//  RawLevelExtensions.swift
//  GameDemo
//
//  Created by Oguz Parlak on 27.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

extension RawLevel {
    
    func isCheckPoint() -> Bool {
        return self.level % 10 == 0
    }
    
}
