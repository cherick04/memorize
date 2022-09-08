//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Erick Chacon on 9/6/22.
//

import Foundation
import UIKit
import SwiftUI

/// ViewModel uses `MemoryGame` model to interpret game functionality
class EmojiMemoryGame: ObservableObject {
    
    /// Returns an instance of MemoryGame
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let data = theme.data()
        return MemoryGame<String>(numberOfCardPairs: theme.cardPairCount()) { index in data[index] }
    }
    
    // MARK: Properties
    @Published private(set) var model: MemoryGame<String>
    private(set) var theme: Theme
    
    /// Array of all cards to be used in game
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    /// Game score in `String` format
    var score: String {
        String(model.score)
    }
    
    /// Property holds `Color` based on selected theme
    var themeColor: Color {
        Color.byName(theme.color())
    }
    
    // MARK: - Initializer
    /// Initializer used to control the order of property assignment
    init() {
        theme = Theme.random()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        theme = Theme.random()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
