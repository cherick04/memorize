//
//  CardView.swift
//  Memorize
//
//  Created by Erick Chacon on 10/13/22.
//

import SwiftUI

/// Card View to be reused in game
struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                if card.isFaceUp {
                    shape.fill(.white)
                    shape.strokeBorder(lineWidth: Constants.lineWidth)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                        .padding(5).opacity(0.5)
                    Text(card.content).font(fontSize(width: geometry.size.width))
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func fontSize(width: CGFloat) -> Font {
        Font.system(size: width * Constants.fontScale)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}
