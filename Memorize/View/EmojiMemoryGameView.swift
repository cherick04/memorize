//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Erick Chacon on 9/1/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                ThemeChooser()
                    .imageScale(.large)
                Spacer()
                Text("MEMORIZE!")
                    .font(.system(size: 34, weight: .black , design: .rounded))
                    .padding(.bottom, -10.0)
                Spacer()
            }
            header
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { cardView(for: $0) }
            newGameButton
        }
        .padding(.horizontal)
    }
    
    /// Returns the theme name and the score
    private var header: some View {
        HStack {
            if game.theme != nil {
                Text(game.themeName)
                Spacer()
                Text("Score:")
                Text(game.score).foregroundColor(game.scoreColor)
            }
        }
        .font(.system(size: 25, weight: .semibold))
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
                .foregroundColor(game.theme?.rgbaColor.color)
                .padding(3)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
