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
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            colorSample(for: theme)
                            Text(theme.name)
                        }
                        Text("Number of card pairs: \(theme.emojis.count)")
                        Text("Number of card pairs to be used: \(theme.cardPairCount ?? theme.emojis.count)")
                        emojiSamples(for: theme)
                    }
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
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
                ToolbarItem { EditButton() }
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
    
    private func emojiSamples(for theme: Theme) -> some View {
        let emojis = theme.emojis.count <= Constants.maxEmojiSampleCount
        ? theme.emojis.map { $0 }
        : Array<Character>(theme.emojis.map { $0 }[0..<Constants.maxEmojiSampleCount])
        return HStack {
            ForEach(emojis, id: \.self) { emoji in
                Text(String(emoji))
            }
            if theme.emojis.count > Constants.maxEmojiSampleCount {
                Text("...")
            }
        }
    }
    
    private struct Constants {
        static let colorSampleLength: CGFloat = 15
        static let maxEmojiSampleCount = 8
    }
}
