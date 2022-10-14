//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Erick Chacon on 9/1/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack {
            header
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { cardView(for: $0) }
        }
        .navigationTitle(game.theme.name)
        .navigationBarTitleDisplayMode(isIPad ? .large : .inline)
        .padding(.horizontal)
        .toolbar { ToolbarItem { newGameButton } }
    }
    
    /// Returns the theme name and the score
    private var header: some View {
        HStack {
            Text("Score:")
            Text(game.score).foregroundColor(game.scoreColor)
        }
        .font(.title2)
    }
    
    /// Returns a New Game button
    private var newGameButton: some View {
        Button("New Game") {
            game.newGame()
        }
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0)
        } else {
            CardView(card: card)
                .foregroundColor(game.theme.rgbaColor.color)
                .padding(3)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let theme = Theme(name: "Preview", emojis: "🐶🐱🐭", rgbaColor: RGBAColor(color: .red), id: 1)
        let game = EmojiMemoryGame(theme: theme)
        EmojiMemoryGameView(game: game)
    }
}
