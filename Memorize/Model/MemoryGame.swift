//
//  MemoryGame.swift
//  Memorize
//
//  Created by Erick Chacon on 9/6/22.
//

import Foundation

/// Model holding the basic functionality for a memory game
struct MemoryGame<CardContent>: Codable where CardContent: Equatable, CardContent: Codable {
    
    // MARK: - Properties
    
    private(set) var cards: [Card] = []
    private(set) var score: Int = 0
    
    /// Dictionary holds information of the cards which have already been seen.
    /// Key is the card index. Value is a flag which indicates if the card has been previously shown or not
    private var seenCardDictionary: [Int: Bool] = [:]
    private var firstCardDate: Date?
    private var facedUpCardIndex: Int? {
        get {
            cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
        }
        set {
            cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) }
        }
    }
    
    // MARK: - Initializers
    
    init() {}
    
    init(json: Data) throws {
        self = try JSONDecoder().decode(MemoryGame.self, from: json)
    }
    
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try MemoryGame(json: data)
    }
    
    init(numberOfCardPairs: Int, createCardContent: (Int) -> CardContent) {
        for pairIndex in 0..<numberOfCardPairs {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    // MARK: - Methods
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    /// Chooses card and flips it if the card is not faced up nor matched.
    /// If a card has been faced up before, checks if there is a match and updates the score accordingly.
    ///
    /// - Parameter card: Card chosen to check the logic
    mutating func choose(_ card: Card) {
        
        // Perform logic iff card exists, is not faced up and has not been matched.
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        else {
            return
        }
        
        if let possibleMatchIndex = facedUpCardIndex {
            updateScore(for: possibleMatchIndex, and: chosenIndex)
            cards[chosenIndex].isFaceUp = true
            firstCardDate = nil
        } else {
            facedUpCardIndex = chosenIndex
            firstCardDate = Date()
        }
        
        seenCardDictionary[chosenIndex] = seenCardDictionary[chosenIndex] == nil
    }
    
    private mutating func updateScore(for cardOneIndex: Int, and cardTwoIndex: Int) {
        // Match
        if cards[cardOneIndex].content == cards[cardTwoIndex].content {
            cards[cardOneIndex].isMatched = true
            cards[cardTwoIndex].isMatched = true
            if let firstCardDate = firstCardDate {
                let timeDifference = Int(Date().timeIntervalSince(firstCardDate))
                score += max(10 - timeDifference, 1)
            }
        // Mismatch
        } else {
            decraseScore(for: cardOneIndex)
            decraseScore(for: cardTwoIndex)
        }
    }
    
    /// Given an index, method checks if `seenCardDictionary` has it as a key.
    /// If it does and it detects it's not the first time seeing it, it decreases the score.
    /// Otherwise, it sets the value to false so next time a mismatch occurs, it will decrease the score.
    ///
    /// - Parameter cardIndex: card index used as a key in `seenCardDictionary`
    private mutating func decraseScore(for cardIndex: Int) {
        guard let isFirstRun = seenCardDictionary[cardIndex] else { return }
        
        if !isFirstRun {
            score -= 1
        } else {
            seenCardDictionary[cardIndex] = false
        }
    }
    
    // MARK: - Other Types
    
    /// Model holding card information
    struct Card: Identifiable, Codable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}
