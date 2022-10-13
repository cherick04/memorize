//
//  ThemeManager.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var themeToAdd: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    VStack(alignment: .leading) {
                        HStack {
                            colorSample(for: theme)
                            Text(theme.name)
                            Spacer()
                            Text("Card Count: \(theme.emojis.count)")
                        }
                        numberOfCardPairs(for: theme)
                        emojiSamples(for: theme)
                    }
                }
            }
            .navigationTitle("Themes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented,
                        UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem {
                    Button {
                        store.insertTheme(named: "New Theme", at: 0)
                        themeToAdd = store.theme(at: 0)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popover(item: $themeToAdd, arrowEdge: .bottom) { theme in
                        ThemeEditor(theme: $store.themes[theme])
                    }
                }
            }
        }
    }
    
    private func colorSample(for theme: Theme) -> some View {
        Rectangle()
            .foregroundColor(Color.byRGBA(theme.color))
            .frame(
                width: Constants.colorSampleLength,
                height: Constants.colorSampleLength
            )
    }
    
    private func numberOfCardPairs(for theme: Theme) -> some View {
        var str = ""
        if let cardPairCount = theme.cardPairCount {
            str = "Number of card pairs to play: \(cardPairCount)"
        } 
        
        return Text(str)
    }
    
    private func emojiSamples(for theme: Theme) -> some View {
        let emojis = theme.emojis.count <= Constants.maxEmojiSampleCount
        ? theme.emojis
        : String(theme.emojis[0..<Constants.maxEmojiSampleCount])
        return HStack {
            ForEach([emojis], id: \.self) { emoji in
                Text(emoji)
            }
            if theme.emojis.count > Constants.maxEmojiSampleCount {
                Text("...")
            }
        }
    }
    
    private struct Constants {
        static let colorSampleLength: CGFloat = 15
        static let maxEmojiSampleCount = 10
    }
}
