//
//  ContentView.swift
//  Memorize
//
//  Created by Erick Chacon on 9/1/22.
//

import SwiftUI

/// Enumeration listing all possible themes
enum Themes: String, CaseIterable {
    case vehicles = "Vehicles"
    case animals = "Animals"
    case fruits = "Fruits"
    
    /// Returns the data to be used according to theme
    func data() -> [String] {
        switch self {
        case .vehicles:
            return ["🦼", "🛴", "🚲", "🛵", "🏍",
                    "🛺", "🚡", "🚠", "🚅", "🚈",
                    "🚂", "✈️", "🚀", "🛸", "🚁", "🚤"] /*
                    "🐶", "🐱", "🐭", "🐹",
                    "🦊", "🐻", "🐼", "🐻‍❄️",
                    "🐯", "🦁", "🐮", "🐷"]*/
        case .animals:
            return ["🐶", "🐱", "🐭", "🐹", "🐰",
                    "🦊", "🐻", "🐼", "🐻‍❄️", "🐨",
                    "🐯", "🦁", "🐮", "🐷"]
        case .fruits:
            return ["🍏", "🍎", "🍐", "🍊", "🍋",
                    "🍌", "🍉", "🍇", "🍓", "🫐",
                    "🍈", "🍒"]
        }
    }
    
    /// Returns the name of the theme to be used as the image name
    func name() -> String {
        switch self {
        case .vehicles:
            return "car"
        case .animals:
            return "pawprint"
        case .fruits:
            // Not found as a system name because of version incompatiblility. Imported directly to Assets folder
            return "carrot"
        }
    }
}

struct ContentView: View {
    @State var theme: Themes = .vehicles
    
    /// Calculates a random number of cards (more than 4) and returns the data in a random order
    func randomData() -> ArraySlice<String> {
        let data = theme.data()
        let random = Int.random(in: 4..<data.count)
        return data.shuffled()[...random]
    }
    
    /// Calculates the best width to fit on screen based on current screen width and height
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        let count = CGFloat(cardCount)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        return abs((height/count) - (width/count)) + ((count / 2) * 10)
    }
    
    var body: some View {
        let data = randomData()
        
        return VStack {
            Text("Memorize!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: data.count)))]) {
                    ForEach(data, id: \.self) { emoji in
                            CardView(content: emoji)
                                .aspectRatio(2/3, contentMode: .fit)
                    }
                }
                .foregroundColor(.red)
            }
            
            Spacer()
            HStack {
                vehicles
                Spacer()
                animals
                Spacer()
                fruits
            }
            .padding(.horizontal, 30.0)
        }
        .padding(.horizontal)
    }
    
    /// View showing Vehicles Theme button
    var vehicles: some View {
        let imageName = Themes.vehicles.name() + (theme == .vehicles ? ".fill" : "")
        
        return Button(action: {
            theme = .vehicles
        }, label: {
            VStack {
                Image(systemName: imageName).font(.largeTitle)
                Text(Themes.vehicles.rawValue).font(.footnote)
            }
        })
    }
    
    /// View showing Animals Theme button
    var animals: some View {
        let imageName = Themes.animals.name() + (theme == .animals ? ".fill" : "")
        
        return Button(action: {
            theme = .animals
        }, label: {
            VStack {
                Image(systemName: imageName).font(.largeTitle)
                Text(Themes.animals.rawValue).font(.footnote)
            }
        })
    }
    
    /// View showing Fruits Theme button
    var fruits: some View {
        let imageName = Themes.fruits.name() + (theme == .fruits ? ".fill" : "")
        return Button(action: {
            theme = .fruits
        }, label: {
            VStack {
                Image(imageName).font(.largeTitle)
                Text(Themes.fruits.rawValue).font(.footnote)
            }
        })
    }
}

/// Card View to be reused in game
struct CardView: View {
    var content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 20).fill(.white)
                RoundedRectangle(cornerRadius: 20).strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 20).fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
