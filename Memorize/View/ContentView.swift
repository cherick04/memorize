//
//  ContentView.swift
//  Memorize
//
//  Created by Erick Chacon on 9/1/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    /// Returns the best width to fit on screen based on current screen width and height
    private func widthThatBestFits(cardCount: Int) -> CGFloat {
        switch cardCount {
        case 0...4:
            return 120
        case 5...9:
            return 110
        case 10...20:
            return 80
        default:
            return 60
        }
        
        // Linear equation based on data
        // return 112.753 - (1.6986 * CGFloat(cardCount))
    }
    
    var body: some View {
        return VStack {
            Text("MEMORIZE")
                .font(.system(size: 34, weight: .black , design: .rounded))
                .foregroundColor(.gray)
                
            HStack {
                Text("Theme:").fontWeight(.bold)
                Text(viewModel.theme.rawValue)
                Spacer()
                Text("Score:").fontWeight(.bold)
                Text(viewModel.score).foregroundColor(viewModel.scoreColor)
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: viewModel.cards.count)))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(viewModel.themeColor)
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 150.0, height: 50)
                    .foregroundColor(.blue)
                Button (action: {
                    viewModel.newGame()
                }, label: {
                    Text("New Game").fontWeight(.black)
                })
                .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
}

/// Card View to be reused in game
struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
    }
}
