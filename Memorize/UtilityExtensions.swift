//
//  UtilityExtensions.swift
//  Memorize
//
//  Created by Erick Chacon on 10/11/22.
//

import Foundation
import SwiftUI

extension Array {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

extension Color {
    /// Returns a `Color` value based on a `Theme.RGBA` value given
    static func byRGBA(_ rgba: Theme.RGBA) -> Color {
        Color(
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            opacity: rgba.alpha
        )
    }
}

extension Array where Element == String {
    var removingDuplicateCharacters: [String] {
        reduce(into: []) { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}
