//
//  NumberExtensions.swift
//  GameDemo
//
//  Created by Oguz Parlak on 30.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

extension Int {
    func formatNumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self))!
    }
}
