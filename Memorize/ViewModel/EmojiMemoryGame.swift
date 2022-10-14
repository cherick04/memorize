//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Erick Chacon on 9/6/22.
//

import Foundation
import SwiftUI

/// ViewModel uses `MemoryGame` model to interpret game functionality
class EmojiMemoryGame: ObservableObject {
    
    typealias Game = MemoryGame<String>
    typealias Card = Game.Card
    
    // MARK: - Static
    
    /// Creates a new memory game if a theme exists
    private static func createMemoryGame(with theme: Theme) -> Game {
        let data = theme.emojis
        return Game(numberOfCardPairs: data.count) { index in String(data[index]) }
    }
    
    // MARK: - Initializer
    
    init(theme: Theme) {
        self.theme = theme
        self.model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    // MARK: - Properties
    
    @Published private(set) var model: Game
    
    var theme: Theme {
        didSet { newGame(for: theme) }
    }
    
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

    // MARK: - Private
    
    func newGame(for theme: Theme) {
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        newGame(for: theme)
    }
}
