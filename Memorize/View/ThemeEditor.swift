//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme

    @State private var isCustomCardCountOn = false
    @State private var cardCount = Constants.cardCountMin
    @State private var color = Color.white
    @State private var emojisToAdd = ""
    
    // TODO: - Add a submit and cancel button
    var body: some View {
        Form {
            nameSection
            cardPairSection
            colorSection
            addEmojiSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(theme.name)")
        .frame(minWidth: 400, minHeight: 550)
    }
    
    private var nameSection: some View {
        Section("Theme Name") {
            TextField("Name", text: $theme.name)
        }
    }
    
    private var cardPairSection: some View {
        return Section("Number of card pairs to show") {
            Toggle("Custom", isOn: $isCustomCardCountOn)
            Stepper(
                String(cardCount),
                onIncrement: {
                    if cardCount < theme.emojis.count {
                        cardCount += 1
                    }
                }, onDecrement: {
                    cardCount -= 1
                    if cardCount < Constants.cardCountMin {
                        cardCount = Constants.cardCountMin
                    }
                }
            )
            .onChange(of: cardCount) { cardCount in
                if isCustomCardCountOn {
                    theme.cardPairCount = cardCount
                }
            }
            .disabled(!isCustomCardCountOn)
        }
    }
    
    private var colorSection: some View {
        Section("Color") {
            ColorPicker("Choose color", selection: $color)
                .onChange(of: color) { color in
                    theme.color = color.toRGBA
                }
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
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
            updateCardCount()
        }
    }
    
    private var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.emojiSize))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                                updateCardCount()
                            }
                        }
                }
            }
            .font(.system(size: Constants.emojiSize))
        }
    }
    
    // MARK: - Helpers
    
    private func updateCardCount() {
        if !isCustomCardCountOn {
            cardCount = theme.emojis.count
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
