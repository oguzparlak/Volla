//
//  RawLevel.swift
//  GameDemo
//
//  Created by Oguz Parlak on 3.03.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation

struct RawLevel : Codable {
    
    var level: Int
    var rows: Int
    var cols: Int
    var contentType: String
    var difficulity: String
    
    init(json: [String: Any]) {
        level = json["level"] as! Int
        rows = json["rows"] as! Int
        cols = json["cols"] as! Int
        contentType = json["contentType"] as! String
        difficulity = json["difficulity"] as! String
    }
    
}
