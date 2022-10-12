//
//  ThemeStore.swift
//  Memorize
//
//  Created by Erick Chacon on 10/11/22.
//

import SwiftUI

/// Struct that builds a Theme
struct Theme: Identifiable {
    var name: String
    var emojis: [String]
    var color: RGBA
    var cardPairCount: Int?
    let id: Int
    
    var isGradient = false
    
    // MARK: - Initializers
    
    fileprivate init(name: String, emojis: [String], color: RGBA, id: Int, cardPairCount: Int?) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.cardPairCount = cardPairCount
        self.id = id
    }
    
    // MARK: - Other
    
    struct RGBA {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]()
    
    init(name: String) {
        self.name = name
        
        if themes.isEmpty {
            insertTheme(
                named: "Cars",
                emojis: ["🚗", "🚕", "🚙", "🏎", "🚓", "🛺", "🚘", "🚖", "🚔"],
                color: Theme.RGBA(red: 255, green: 0, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Big Cars",
                emojis: ["🚚", "🚛", "🚒", "🚐", "🚜", "🚑", "🛻", "🚍", "🚌", "🚎"],
                color: Theme.RGBA(red: 255, green: 130, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Trains",
                emojis: ["🚞", "🚝", "🚄", "🚅", "🚈", "🚂", "🚆", "🚇", "🚊", "🚉"],
                color: Theme.RGBA(red: 255, green: 255, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Animal Faces",
                emojis: ["🐶", "🐱", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐷", "🐮", "🐸"],
                color: Theme.RGBA(red: 165, green: 0, blue: 255, alpha: 0.8)
            )
            insertTheme(
                named: "Animal",
                emojis: ["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦬", "🐃", "🐂", "🐄"],
                color: Theme.RGBA(red: 255, green: 0, blue: 165, alpha: 0.8)
            )
            insertTheme(
                named: "S.American Flags",
                emojis: ["🇦🇷", "🇧🇷", "🇧🇴", "🇨🇱", "🇺🇾", "🇵🇾", "🇪🇨", "🇨🇴", "🇻🇪", "🇵🇪"],
                color: Theme.RGBA(red: 0, green: 255, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Asian Flags",
                emojis: ["🇨🇳", "🇷🇺", "🇯🇵", "🇰🇵", "🇰🇷", "🇻🇳", "🇹🇭", "🇹🇼", "🇵🇭", "🇲🇳", "🇰🇭", "🇸🇬"],
                color: Theme.RGBA(red: 0, green: 0, blue: 255, alpha: 0.8)
            )
        }
    }
    
    // MARK: - Intent(s)
    
    func palette(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func insertTheme(named name: String, emojis: [String] = [], color: Theme.RGBA, cardPairCount: Int? = nil, at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis, color: color, id: unique, cardPairCount: cardPairCount)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}
