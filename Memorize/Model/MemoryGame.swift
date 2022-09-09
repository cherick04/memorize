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
    
    /// Dictionary holds information of the cards which have already been seen.
    /// Key is the card index. Value is a flag which indicates if the card has been previously shown or not
    private var seenCardDictionary: [Int: Bool]
    private var facedUpCardIndex: Int?
    
    // MARK: Initializer
    
    init(numberOfCardPairs: Int, createCardContent: (Int) -> CardContent) {
        score = 0
        cards = []
        seenCardDictionary = [:]
        for pairIndex in 0..<numberOfCardPairs {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    // MARK: Methods
    
    /// Chooses card and flips it if the card is not faced up nor matched.
    /// If a card has been faced up before, checks if there is a match and updates the score accordingly.
    ///
    /// - Parameter card: Card chosen to check the logic
    mutating func choose(_ card: Card) {
        
        /// Given an index, method checks if `seenCardDictionary` has it as a key.
        /// If it does and it detects it's not the first time seeing it, it decreases the score.
        /// Otherwise, it sets the value to false so next time a mismatch occurs, it will decrease the score.
        ///
        /// - Parameter cardIndex: card index used as a key in `seenCardDictionary`
        func decraseScore(for cardIndex: Int) {
            if let isFirstRun = seenCardDictionary[cardIndex] {
                if !isFirstRun {
                    score -= 1
                } else {
                    seenCardDictionary[cardIndex] = false
                }
            }
        }
        
        // Only check logic if card exists, is not faced up and has not been matched.
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let possibleMatchIndex = facedUpCardIndex {
                // Match
                if cards[possibleMatchIndex].content == cards[chosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[possibleMatchIndex].isMatched = true
                    score += 2
                // Mismatch
                } else {
                    decraseScore(for: possibleMatchIndex)
                    decraseScore(for: chosenIndex)
                }
                facedUpCardIndex = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                facedUpCardIndex = chosenIndex
            }
            
            seenCardDictionary[chosenIndex] = seenCardDictionary[chosenIndex] == nil
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
