//
//  Pet.swift
//  PWCodeChallenge
//
//  Created by Edmund Holderbaum on 5/6/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import Foundation

class Pet {
    var name: String
    var number: Int
    
    private init(_ name: String, number: UInt32) {
        self.name = name
        self.number = Int(number)
    }
    
    static func make()->[Pet] {
        var items = [Pet]()
        let colors = ["red", "green", "blue", "yellow", "orange", "purple", "black","white","gray", "rainbow", "teal", "magenta", "burgundy"]
        let pets = ["Dog", "Cat", "Rabbit", "Hamster", "Snake", "Weasel", "Spider", "Fish", "Pony", "Turtle", "Rat", "Hedgehog"]
        for _ in 0...100 {
            let number = arc4random_uniform(10000)
            let first = Int(arc4random())
            let second = Int(arc4random())
            let color = colors[first % colors.count]
            let pet = pets[second % pets.count]
            let name = color + pet
            let newItem = Pet(name, number: number)
            items.append(newItem)
        }
        return items
    }
}
