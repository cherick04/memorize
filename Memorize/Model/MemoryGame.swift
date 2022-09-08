//
//  MemoryGame.swift
//  Memorize
//
//  Created by Erick Chacon on 9/6/22.
//

import Foundation

/// Model holding the basic functionality for a memory game
struct MemoryGame<CardContent> where CardContent: Equatable {
    
    // MARK: Properties
    
    private(set) var cards: [Card]
    private(set) var score: Int
    
    private var facedUpCardIndex: Int?
    
    // MARK: Initializer
    
    init(numberOfCardPairs: Int, createCardContent: (Int) -> CardContent) {
        score = 0
        cards = []
        for pairIndex in 0..<numberOfCardPairs {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    // MARK: Methods
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let possibleMatchIndex = facedUpCardIndex {
                if cards[possibleMatchIndex].content == cards[chosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[possibleMatchIndex].isMatched = true
                }
                facedUpCardIndex = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                facedUpCardIndex = chosenIndex
            }
            
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    // MARK:
    /// Model holding card information
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}
