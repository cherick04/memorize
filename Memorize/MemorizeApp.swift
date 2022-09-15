//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Erick Chacon on 9/1/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
