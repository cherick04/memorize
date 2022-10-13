//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    @State private var cardCount = Constants.cardCountMin
    @State private var color = Color.white
    @State private var emojisToAdd = ""
    
    var body: some View {
        Form {
            nameSection
            cardPairSection
            colorSection
            addEmojiSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(theme.name)")
    }
    
    private var nameSection: some View {
        Section("Theme Name") {
            TextField("Name", text: $theme.name)
        }
    }
    
    private var cardPairSection: some View {
        Section("Number of card pairs") {
            Stepper(
                String(cardCount),
                onIncrement: {
                    cardCount += 1
                }, onDecrement: {
                    cardCount -= 1
                    if cardCount < Constants.cardCountMin {
                        cardCount = Constants.cardCountMin
                    }
                }
            )
        }
    }
    
    private var colorSection: some View {
        Section("Color") {
            ColorPicker("Choose color", selection: $color)
        }
    }

    private var addEmojiSection: some View {
        Section("Add Emojis") {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    private func addEmojis(_ emojis: String) {
        withAnimation {
            let newEmojis = emojis
                .filter { $0.isEmoji }
                .map { String($0) }
                .removingDuplicateCharacters
            theme.emojis.append(contentsOf: newEmojis)
                
        }
    }
    
    private var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = theme.emojis.removingDuplicateCharacters
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.emojiSize))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { $0 == emoji })
                            }
                        }
                }
            }
            .font(.system(size: Constants.emojiSize))
        }
    }
    
    private struct Constants {
        static let cardCountMin = 2
        static let emojiSize: CGFloat = 40
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(name: "Preview").theme(at: 0)))
    }
}
