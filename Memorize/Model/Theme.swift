//
//  Theme.swift
//  Memorize
//
//  Created by Erick Chacon on 9/7/22.
//

import Foundation

/// Enumeration listing all possible themes in the form of emojis
enum Theme: String, CaseIterable {
    
    case cars = "Cars"
    case trucks = "Trucks"
    case twoWheels = "Two-wheels"
    case trains = "Trains"
    case cableCars = "Cable Cars"
    case animalFaces = "Animal Faces"
    case animals = "Animals"
    case sAmericanFlags = "S. American Flags"
    case asianFlags = "Asian Flags"
    
    /// Returns a random `Theme`
    static func random() -> Theme {
        // Ensure Theme has at least 1 case otherwise
        // the following line will cause an error
        Theme.allCases.randomElement() ?? Theme.allCases[0]
    }
    
    /// Returns the data to be used according to theme
    func data() -> [String] {
        switch self {
        case .cars:
            return ["🚗", "🚕", "🚙", "🏎", "🚓", "🛺"].shuffled()
        case .trucks:
            return ["🚚", "🚛", "🚒", "🚐", "🚜", "🚑", "🛻"].shuffled()
        case .twoWheels:
            return ["🛴", "🚲", "🛵", "🏍"].shuffled()
        case .trains:
            return ["🚞", "🚝", "🚄", "🚅", "🚈", "🚂"].shuffled()
        case .cableCars:
            return ["🚡", "🚠", "🚟", "🚃", "🚋"].shuffled()
        case .animalFaces:
            return ["🐶", "🐱", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁"].shuffled()
        case .animals:
            return ["🐅", "🐆", "🦓", "🦍", "🐘", "🦛", "🦏", "🦬", "🐃", "🐂", "🐄"].shuffled()
        case .sAmericanFlags:
            return ["🇦🇷", "🇧🇷", "🇧🇴", "🇨🇱", "🇺🇾", "🇵🇾", "🇪🇨", "🇨🇴", "🇻🇪", "🇵🇪"].shuffled()
        case .asianFlags:
            return ["🇨🇳", "🇷🇺", "🇯🇵", "🇰🇵", "🇰🇷", "🇻🇳", "🇹🇭", "🇹🇼", "🇵🇭", "🇲🇳", "🇰🇭", "🇸🇬"].shuffled()
        }
    }
    
    ///Returns a number of card pairs
    func cardPairCount() -> Int {
        return data().count - Int.random(in: 0...1)
    }
    
    /// Returns the name of the color based on theme
    func color() -> String {
        switch self {
        case .cars: return "red"
        case .trucks: return "orange"
        case .twoWheels: return "green"
        case .trains: return "yellow"
        case .cableCars: return "blue"
        case .animalFaces: return "purple"
        case .animals: return "pink"
        case .sAmericanFlags: return "gray"
        case .asianFlags: return "green"
        }
    }
}
