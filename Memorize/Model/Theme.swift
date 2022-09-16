//
//  Theme.swift
//  Memorize
//
//  Created by Erick Chacon on 9/7/22.
//

import Foundation

/// Model listing all possible themes in the form of emojis
struct Theme {
    
    // MARK: - Static
    
    // Given a `Category`, returns an array of `String` to be used as data
    static private func getData(for category: Category, with numberOfCardPairs: Int? = nil) -> [String] {
        var isNumberOfCardPairsRandom = false
        var data: [String]
        
        switch category {
        case .cars:
            data = ["🚗", "🚕", "🚙", "🏎", "🚓", "🛺", "🚘", "🚖", "🚔"].shuffled()
        case .bigCars:
            data = ["🚚", "🚛", "🚒", "🚐", "🚜", "🚑", "🛻", "🚍", "🚌", "🚎"].shuffled()
        case .trains:
            data =  ["🚞", "🚝", "🚄", "🚅", "🚈", "🚂", "🚆", "🚇", "🚊", "🚉"].shuffled()
        case .animalFaces:
            isNumberOfCardPairsRandom = true
            data =  ["🐶", "🐱", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐷", "🐮", "🐸"].shuffled()
        case .animals:
            data =  ["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦬", "🐃", "🐂", "🐄"].shuffled()
        case .sAmericanFlags:
            data =  ["🇦🇷", "🇧🇷", "🇧🇴", "🇨🇱", "🇺🇾", "🇵🇾", "🇪🇨", "🇨🇴", "🇻🇪", "🇵🇪"].shuffled()
        case .asianFlags:
            isNumberOfCardPairsRandom = true
            data =  ["🇨🇳", "🇷🇺", "🇯🇵", "🇰🇵", "🇰🇷", "🇻🇳", "🇹🇭", "🇹🇼", "🇵🇭", "🇲🇳", "🇰🇭", "🇸🇬"].shuffled()
        }
        
        if isNumberOfCardPairsRandom {
            let random = Int.random(in: 2...data.count)
            return Array<String>(data[0..<random])
        }
        
        guard let numberOfCardPairs = numberOfCardPairs,
              numberOfCardPairs <= data.count,
              numberOfCardPairs > 0
        else {
            return data
        }
        
        return Array<String>(data[0..<numberOfCardPairs])
    }
    
    // MARK: - Initializers
    
    init(numberOfCardPairs: Int? = nil) {
        self.category = Category.allCases.randomElement()!
        self.numberOfCardPairs = numberOfCardPairs
        self.data = Theme.getData(for: self.category, with: numberOfCardPairs)
        
    }
    
    // MARK: - Properties
    
    private var category: Category
    private(set) var data: [String]
    private(set) var numberOfCardPairs: Int?
    
    var isGradient: Bool {
        category == .cars
    }
    
    var name: String {
        category.rawValue
    }
    
    /// Returns the name of the color based on theme
    var color: String {
        switch category {
        case .cars: return "red"
        case .bigCars: return "orange"
        case .trains: return "yellow"
        case .animalFaces: return "purple"
        case .animals: return "pink"
        case .sAmericanFlags: return "green"
        case .asianFlags: return "blue"
        }
    }
    
    // MARK: - Other Types
    
    enum Category: String, CaseIterable {
        case cars = "Cars"
        case bigCars = "Big Cars"
        case trains = "Trains"
        case animalFaces = "Animal Faces"
        case animals = "Animals"
        case sAmericanFlags = "S. American Flags"
        case asianFlags = "Asian Flags"
    }
}
