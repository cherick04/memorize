//
//  Array.swift
//  Memorize
//
//  Created by Erick Chacon on 9/15/22.
//

import Foundation

extension Array {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
