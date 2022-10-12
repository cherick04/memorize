//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Erick Chacon on 9/1/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    @StateObject var themeStore = ThemeStore(name: "Default")
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
                .environmentObject(themeStore)
        }
    }
}
