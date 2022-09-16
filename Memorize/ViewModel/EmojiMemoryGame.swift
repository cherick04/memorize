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
    
    typealias Game = MemoryGame<String>
    typealias Card = Game.Card
    
    // MARK: - Static
    
    /// Returns an instance of MemoryGame
    static func createMemoryGame(theme: Theme) -> Game {
        let data = theme.data
        return Game(numberOfCardPairs: theme.data.count) { index in data[index] }
    }
    
    // MARK: - Properties
    @Published private(set) var model: Game
    private(set) var theme: Theme
    
    /// Array of all cards to be used in game
    var cards: [Card] {
        model.cards
    }
    
    /// Game score in `String` format
    var score: String {
        String(model.score)
    }
    
    /// `Color` is based on score
    ///  Green if positive, red if negative, black if score is zero
    var scoreColor: Color {
        if model.score > 0 {
            return .green
        } else if model.score < 0 {
            return .red
        } else {
            return .black
        }
    }
    
    /// Property holds `Color` based on selected theme
    var themeColor: Color {
        Color.byName(theme.color)
    }
    
    // MARK: - Initializer
    /// Initializer used to control the order of property assignment
    init() {
        theme = Theme()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        theme = Theme(numberOfCardPairs: 3)
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}
