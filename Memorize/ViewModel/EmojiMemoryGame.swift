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
    
    // MARK: - Initializer
    
    init() {
        model = Game()
    }
    
    // MARK: - Properties
    
    @Published private(set) var model: Game
    
    var theme: Theme? {
        didSet {
            createMemoryGame()
        }
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
 
    /// If theme color is gradient, add an arbitrary color to give it that gradient look;
    /// otherwise, return an array of colors with only one element
    var themeColors: [Color] {
        guard let theme = theme else { return [] }
        
        var colors = [theme.rgbaColor.color]
        if theme.isGradient {
            colors.append(.gray)
        }
        return colors
    }
    
    var themeName: String {
        theme?.name ?? ""
    }
    
    // MARK: - Private
    
    /// Creates a new memory game if a theme exists
    private func createMemoryGame() {
        guard let theme = theme else { return }
        
        let data = theme.emojis
        model = Game(numberOfCardPairs: data.count) { index in String(data[index]) }
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame() {
        createMemoryGame()
    }
}
