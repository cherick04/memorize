//
//  ThemeStore.swift
//  Memorize
//
//  Created by Erick Chacon on 10/11/22.
//

import Foundation

extension Theme {
    fileprivate init(name: String, emojis: String, rgbaColor: RGBAColor, id: Int, cardPairCount: Int?) {
        self.name = name
        self.emojis = emojis
        self.rgbaColor = rgbaColor
        self.cardPairCount = cardPairCount
        self.id = id
    }
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    init(name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty { loadDefaultThemes() }
    }
    
    // MARK: - UserDefaults
    
    private var userDefaultsKey: String {
        "ThemeStore:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    // MARK: - Private
    
    private func loadDefaultThemes() {
        insertTheme(
            named: "Cars",
            emojis: "🚗🚕🚙🏎🚓🛺🚘🚖🚔",
            rgbaColor: RGBAColor(red: 1, green: 0, blue: 0, alpha: 0.8)
        )
        insertTheme(
            named: "Big Cars",
            emojis: "🚚🚛🚒🚐🚜🚑🛻🚍🚌🚎",
            rgbaColor: RGBAColor(red: 1, green: 0.5, blue: 0, alpha: 0.8)
        )
        insertTheme(
            named: "Trains",
            emojis: "🚞🚝🚄🚅🚈🚂🚆🚇🚊🚉",
            rgbaColor: RGBAColor(red: 1, green: 1, blue: 0, alpha: 0.8)
        )
        insertTheme(
            named: "Animal Faces",
            emojis: "🐶🐱🦊🐻🐼🐻‍❄️🐨🐯🦁🐷🐮🐸🐵🙈🙉🙊",
            rgbaColor: RGBAColor(red: 0.65, green: 0, blue: 1, alpha: 0.8)
        )
        insertTheme(
            named: "Animal",
            emojis: "🐅🐆🦓🦍🐘🦛🦏🦬🐃🐂🐄",
            rgbaColor: RGBAColor(red: 1, green: 0, blue: 0.65, alpha: 0.8)
        )
        insertTheme(
            named: "S.American Flags",
            emojis: "🇦🇷🇧🇷🇧🇴🇨🇱🇺🇾🇵🇾🇪🇨🇨🇴🇻🇪🇵🇪",
            rgbaColor: RGBAColor(red: 0, green: 1, blue: 0, alpha: 0.8)
        )
        insertTheme(
            named: "Asian Flags",
            emojis: "🇨🇳🇷🇺🇯🇵🇰🇵🇰🇷🇻🇳🇹🇭🇹🇼🇵🇭🇲🇳🇰🇭🇸🇬",
            rgbaColor: RGBAColor(red: 0, green: 0, blue: 1, alpha: 0.8)
        )
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
        emojis: String = "",
        rgbaColor: RGBAColor = RGBAColor(red: 0, green: 0, blue: 0, alpha: 0.8),
        cardPairCount: Int? = nil,
        at index: Int = 0) {
            let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
            let theme = Theme(name: name, emojis: emojis, rgbaColor: rgbaColor, id: unique, cardPairCount: cardPairCount)
            let safeIndex = min(max(index, 0), themes.count)
            themes.insert(theme, at: safeIndex)
    }
}
