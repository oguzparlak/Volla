//
//  ContentCreator.swift
//  GameDemo
//
//  Created by Oguz Parlak on 17.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import SpriteKit

enum ContentType {
    case letter
    case number
    case shape
    case image
    case emoji
}

protocol Content {
    
    var size: Int { get }
    
    init(with size: Int)
    
    // The content is simply representable if
    // It can be represented as a string
    // If not then It will certainly represented as
    // a SKNode or a subclass of SKNode
    var isSimplyRepresentable: Bool { get }
    
    // Generates a content of Any type
    // depending the type of subclass
    func generate() -> Array<Any>
    
}

class ContentFactory {
    
    static func createContent(with type: ContentType, size: Int) -> Content {
        switch type {
        case .emoji:
            return EmojiContent(with: size)
        default:
            return NumberContent(with: size)
        }
    }
    
}

class LetterContent: Content {
    
    var size: Int
    
    required init(with size: Int) {
        self.size = size
    }
    
    var isSimplyRepresentable = true
    
    func generate() -> Array<Any> {
        let character: Character = Character("a")
        return [character]
    }
    
    
}

class EmojiContent: Content {
    
    var size: Int
    
    required init(with size: Int) {
        self.size = size
    }
    
    func generate() -> Array<Any> {
        return ["asd", ""]
    }
    
    var isSimplyRepresentable = true
    
}

class NumberContent: Content {
    
    var size: Int
    
    required init(with size: Int) {
        self.size = size
    }
    
    func generate() -> Array<Any> {
        var result: [Int] = []
        // TODO Implement it later
        return result
    }
    
    var isSimplyRepresentable = true
    
}


