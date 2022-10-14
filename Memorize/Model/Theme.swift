//
//  Theme.swift
//  Memorize
//
//  Created by Erick Chacon on 10/13/22.
//

import Foundation

/// Struct that builds a Theme
struct Theme: Identifiable, Hashable, Codable, Equatable {
    var name: String
    var emojis: String
    var rgbaColor: RGBAColor
    var cardPairCount: Int?
    let id: Int
}
