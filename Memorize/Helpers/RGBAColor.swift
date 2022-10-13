//
//  RGBAColor.swift
//  Memorize
//
//  Created by Erick Chacon on 10/13/22.
//

import Foundation

/// Values for each property must be from 0 to 1.0
struct RGBAColor: Hashable, Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}
