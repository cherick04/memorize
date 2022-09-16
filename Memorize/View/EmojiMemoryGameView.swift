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
            Text("MEMORIZE!")
                .font(.system(size: 34, weight: .black , design: .rounded))
                .padding(.bottom, -10.0)
            
            header()
            
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                cardView(for: card)
            }
            
            newGameButton()
        }
        .padding(.horizontal)
    }
    
    /// Returns the theme name and the score
    private func header() -> some View {
        HStack {
            Text(game.themeName)
            Spacer()
            Text("Score:")
            Text(game.score).foregroundColor(game.scoreColor)
        }
        .font(.system(size: 25, weight: .semibold))
    }
    
    /// Returns a New Game button
    private func newGameButton() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 150.0, height: 50)
                .foregroundColor(.blue)
            Button (action: {
                game.newGame()
            }, label: {
                Text("New Game").fontWeight(.black)
            })
            .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
            Rectangle().opacity(0)
        } else {
            CardView(card: card, isGradient: game.themeIsGradient, color: game.themeColor)
                .padding(3)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }
}

/// Card View to be reused in game
struct CardView: View {
    let card: EmojiMemoryGame.Card
    let isGradient: Bool
    let color: Color
    
    private var colors: [Color] {
        var c = [color]
        if isGradient {
            c.append(.gray)
        }
        return c
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(color)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                        .padding(5).opacity(0.5).foregroundColor(color)
                    Text(card.content).font(fontSize(width: geometry.size.width))
                } else {
                    shape.fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                }
            }
            .foregroundColor(color)
        }
    }
    
    private func fontSize(width: CGFloat) -> Font {
        Font.system(size: width * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
