//
//  Color.swift
//  Memorize
//
//  Created by Erick Chacon on 9/7/22.
//

import Foundation
import SwiftUI

extension Color {
    
    /// Returns a `Color` value  based on a color name given.
    /// If no color is found, returns `Color.black` by default.
    ///
    ///  - Parameter name: a `String` representing the `Color` value to be used
    static func byName(_ name: String) -> Color {
        switch name {
        case "red":
            return .red
        case "orange":
            return .orange
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "blue":
            return .blue
        case "purple":
            return .purple
        case "pink":
            return .pink
        case "gray":
            return .gray
        case "black":
            return .black
        default:
            return .black
        }
    }
}
