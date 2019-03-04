//
//  ContentCreator.swift
//  GameDemo
//
//  Created by Oguz Parlak on 17.02.2019.
//  Copyright © 2019 Oguz Parlak. All rights reserved.
//

import Foundation
import SpriteKit

enum ContentType: String {
    case numbers
    case smiley
    case animals
    case foods
}

protocol Content {
    
    var questionDescription: String { get }
    
    // Generates a content of Any type
    // depending the type of subclass
    func generate() -> Array<String>
    
}

class AbstractContent {
    
    let size: Int
    
    init(with size: Int) {
        self.size = size
    }
    
}

class ContentFactory {
    
    static func createContent(with type: ContentType, size: Int) -> Content {
        switch type {
        case .smiley:
            return SmileyContent(with: size)
        case .animals:
            return AnimalContent(with: size)
        case .foods:
            return FoodContent(with: size)
        default:
            return NumberContent(with: size)
        }
    }
    
}

class FoodContent: AbstractContent, Content {
    
    var questionDescription = NSLocalizedString("matchFoods", comment: "")
    
    func generate() -> Array<String> {
        let foods = ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🥝", "🥥", "🍍", "🥭", "🍑", "🍒", "🍈", "🍓", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶", "🌽", "🥨", "🥖", "🍞", "🥯", "🥐", "🍠", "🥔", "🥕", "🧀", "🥚", "🍳", "🦴", "🌭", "🍔", "🍟", "🥞", "🥓", "🍕", "🥪", "🥩", "🍗", "🥙", "🌮", "🍖", "🥠", "🍣", "🧁", "🌯", "🍰", "🥮", "🍱", "🥗", "🎂", "🍢", "🥟", "🥘", "🥫", "🍡", "🍤", "🍮", "🍭", "🍧", "🍙", "🍝", "🍜", "🍚", "🍨", "🍬" ,"🍫", "🍦", "🍘", "🍲", "🍥", "🍛", "🥧", "🍿", "🍩", "🍪", "🌰"]
        return foods.pickRandom(size)
    }
    
}

class SmileyContent: AbstractContent, Content {
    
    var questionDescription = NSLocalizedString("matchSmileys", comment: "")
    
    func generate() -> Array<String> {
        let smileys = ["🤩", "🤥", "😡", "🤔", "😴", "😱", "🤯", "😐", "🤫", "🤑", "😕", "😵", "🤒", "😤", "🤠", "😈", "😀", "😂", "😍", "👻", "🤣", "👽", "😇", "😼", "🤖", "🤪", "🤡", "🤓", "☠️", "👹", "🎃", "😎", "😁", "😋", "🤮"]
        return smileys.pickRandom(size)
    }
    
}

class AnimalContent: AbstractContent, Content {
    
    var questionDescription: String = NSLocalizedString("matchAnimals", comment: "")
    
    func generate() -> Array<String> {
        let animals = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐽", "🐷", "🐮", "🦁", "🐯", "🐨", "🐼", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐥", "🐣", "🐤", "🐦", "🐧", "🦆", "🦅", "🐝", "🦄", "🐴", "🐗", "🐺", "🦉", "🐛", "🐌", "🐚", "🐞", "🐜", "🦗", "🦖", "🦎", "🐍", "🐢", "🦂", "🐙", "🦕", "🕷", "🦐", "🦑", "🦀", "🐡", "🐠", "🐟", "🐑", "🦒", "🐐", "🐃", "🦌", "🐂", "🐄", "🐕", "🦍", "🐘", "🐩", "🐎", "🐖", "🐈", "🐓", "🐏", "🐪", "🐫", "🐊"]
        return animals.pickRandom(size)
    }
    
}

class NumberContent: AbstractContent, Content {
    
    var questionDescription = NSLocalizedString("matchNumbers", comment: "")
    
    func generate() -> Array<String> {
        var result: [String] = []
        var index = size / 2
        var numbers = Array(0...size).shuffled()
        repeat {
            let randomNumber = numbers.popLast()!
            result.append(String(randomNumber))
            result.append(String(randomNumber))
            index -= 1
        } while(index > 0)
        return result.shuffled()
    }
    
}

extension Array where Element == String {
    func pickRandom(_ elements: Int) -> [String] {
        var maxCount = elements / 2
        let copyOfElements = self.shuffled()
        var result: [String] = []
        copyOfElements.forEach { (value) in
            if maxCount == 0 { return }
            result.append(value)
            result.append(value)
            maxCount -= 1
        }
        return result.shuffled()
    }
}

