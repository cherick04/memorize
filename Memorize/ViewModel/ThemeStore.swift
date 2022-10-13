//
//  ThemeStore.swift
//  Memorize
//
//  Created by Erick Chacon on 10/11/22.
//

import SwiftUI

/// Struct that builds a Theme
struct Theme: Identifiable, Hashable {
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
    
    /// Values for each property must be from 0 to 1.0
    struct RGBA: Hashable {
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
                color: Theme.RGBA(red: 1, green: 0, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Big Cars",
                emojis: ["🚚", "🚛", "🚒", "🚐", "🚜", "🚑", "🛻", "🚍", "🚌", "🚎"],
                color: Theme.RGBA(red: 1, green: 0.5, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Trains",
                emojis: ["🚞", "🚝", "🚄", "🚅", "🚈", "🚂", "🚆", "🚇", "🚊", "🚉"],
                color: Theme.RGBA(red: 1, green: 1, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Animal Faces",
                emojis: ["🐶", "🐱", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐷", "🐮", "🐸"],
                color: Theme.RGBA(red: 0.65, green: 0, blue: 1, alpha: 0.8)
            )
            insertTheme(
                named: "Animal",
                emojis: ["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦬", "🐃", "🐂", "🐄"],
                color: Theme.RGBA(red: 1, green: 0, blue: 0.65, alpha: 0.8)
            )
            insertTheme(
                named: "S.American Flags",
                emojis: ["🇦🇷", "🇧🇷", "🇧🇴", "🇨🇱", "🇺🇾", "🇵🇾", "🇪🇨", "🇨🇴", "🇻🇪", "🇵🇪"],
                color: Theme.RGBA(red: 0, green: 1, blue: 0, alpha: 0.8)
            )
            insertTheme(
                named: "Asian Flags",
                emojis: ["🇨🇳", "🇷🇺", "🇯🇵", "🇰🇵", "🇰🇷", "🇻🇳", "🇹🇭", "🇹🇼", "🇵🇭", "🇲🇳", "🇰🇭", "🇸🇬"],
                color: Theme.RGBA(red: 0, green: 0, blue: 1, alpha: 0.8)
            )
        }
    }
    
    // MARK: - Intent(s)
    
    func theme(at index: Int) -> Theme {
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
    
    func insertTheme(
        named name: String,
        emojis: [String] = [],
        color: Theme.RGBA = Theme.RGBA(red: 1, green: 1, blue: 1, alpha: 1),
        cardPairCount: Int? = nil,
        at index: Int = 0) {
            let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
            let theme = Theme(name: name, emojis: emojis, color: color, id: unique, cardPairCount: cardPairCount)
            let safeIndex = min(max(index, 0), themes.count)
            themes.insert(theme, at: safeIndex)
    }
}
