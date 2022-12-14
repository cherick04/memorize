//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeEditor: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var theme: Theme
    let completion: (Theme) -> Void

    @State private var isCustomCardCountOn = false
    @State private var cardCount = 0
    @State private var emojisToAdd = ""
    
    private var isInvalid: Bool {
        theme.emojis.count < Constants.cardCountMin
    }
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                cardPairSection
                colorSection
                addEmojiSection
                removeEmojiSection
            }
            .navigationTitle("Edit Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { handleDismiss() }
                        .disabled(isInvalid)
                }
            }
        }
        .interactiveDismissDisabled(true)
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
            .onAppear {
                isCustomCardCountOn = theme.cardPairCount != nil
                cardCount = theme.cardPairCount ?? theme.emojis.count
            }
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
            ColorPicker("Choose color", selection: $theme.rgbaColor.color)
        }
    }

    private var addEmojiSection: some View {
        Section {
            EmojiTextField(text: $emojisToAdd, placeholder: "")
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        } header: {
            Text("Add Emojis")
        } footer: {
            Text(isInvalid ? "Need at least 2 emojis" : "")
                .foregroundColor(.red)
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
    
    private func handleDismiss() {
        completion(theme)
        presentationMode.wrappedValue.dismiss()
    }
    
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
        ThemeEditor(theme: .constant(ThemeStore(name: "Preview").theme(at: 0))) { _ in }
    }
}
