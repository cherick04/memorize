//
//  Theme.swift
//  Memorize
//
//  Created by Erick Chacon on 9/7/22.
//

import Foundation

/// Model listing all possible themes in the form of emojis
struct Theme {
    var name: String
    var emojis: [String]
    var color: String
    
    private let emojiData = [
        "Cars": (["🚗", "🚕", "🚙", "🏎", "🚓", "🛺", "🚘", "🚖", "🚔"], "red"),
        "Big Cars": (["🚚", "🚛", "🚒", "🚐", "🚜", "🚑", "🛻", "🚍", "🚌", "🚎"], "orange"),
        "Trains": (["🚞", "🚝", "🚄", "🚅", "🚈", "🚂", "🚆", "🚇", "🚊", "🚉"], "yellow"),
        "Animal Faces": (["🐶", "🐱", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐷", "🐮", "🐸"], "purple"),
        "Animals": (["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦬", "🐃", "🐂", "🐄"], "pink"),
        "S. American Flags": (["🇦🇷", "🇧🇷", "🇧🇴", "🇨🇱", "🇺🇾", "🇵🇾", "🇪🇨", "🇨🇴", "🇻🇪", "🇵🇪"], "green"),
        "Asian Flags": (["🇨🇳", "🇷🇺", "🇯🇵", "🇰🇵", "🇰🇷", "🇻🇳", "🇹🇭", "🇹🇼", "🇵🇭", "🇲🇳", "🇰🇭", "🇸🇬"], "blue")
    ]
    
    // MARK: - Initializers
    
    init(name: String, emojis: [String], color: String, numberOfCardPairs: Int? = nil) {
        self.name = name
        self.emojis = emojis
        self.color = color
    }
    
    init(numberOfCardPairs: Int? = nil) {
        let randomIndex =  Int.random(in: 0..<emojiData.count)
        self.name = Array(emojiData.keys)[randomIndex]
        self.color = Array(emojiData.values)[randomIndex].1
        
        var emojis = Array(emojiData.values)[randomIndex].0.shuffled()
        if let numberOfCardPairs = numberOfCardPairs,
           numberOfCardPairs <= emojis.count,
           numberOfCardPairs > 0 {
            emojis = Array<String>(emojis[0..<numberOfCardPairs])
        }
        self.emojis = emojis
    }
    
    // MARK: - Properties
    
    var isGradient: Bool {
        name == "Cars"
    }
}
