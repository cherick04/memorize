//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var themeToEdit: Theme?
    @State private var themeToAdd: Theme?
    @State private var editMode: EditMode = .inactive
    @State private var playingGames: [Int: EmojiMemoryGame] = [:]
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    if let game = playingGames[theme.id] {
                        NavigationLink(destination: EmojiMemoryGameView(game: game)) {
                            row(for: theme)
                        }
                    }
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Memorize")
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) { addButton }
            }
            .onAppear { loadPlayingGames() }
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loadPlayingGames() {
        store.themes.forEach { theme in
            playingGames[theme.id] = EmojiMemoryGame(theme: theme)
        }
    }
    
    private var addButton: some View {
        Button {
            store.insertTheme(named: "New Theme", at: 0)
            themeToAdd = store.theme(at: 0)
            loadPlayingGames()
        } label: {
            Image(systemName: "plus")
        }
        .sheet(item: $themeToAdd) { newTheme in
            ThemeEditor(theme: $store.themes[newTheme]) { newTheme in
                playingGames[newTheme.id] = EmojiMemoryGame(theme: newTheme)
            }
        }
    }
    
    private func row(for theme: Theme) -> some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            HStack {
                Text(theme.name)
                    .font(.title2)
                    .foregroundColor(theme.rgbaColor.color)
                Spacer() // 1
            }
            Text("Number of card pairs: \(theme.emojis.count)")
            Text("Number of card pairs to be used: \(theme.cardPairCount ?? theme.emojis.count)")
            emojiSamples(for: theme)
        }
        .contentShape(Rectangle()) // 2 - 1 & 2 needed to make the whole row tapable
        .gesture(editMode == .active ? tap(for: theme) : nil)
        .sheet(item: $themeToEdit) { themeToEdit in
            ThemeEditor(theme: $store.themes[themeToEdit]) { editedTheme in
                if let game = playingGames[editedTheme.id],
                   game.theme != editedTheme {
                    game.theme = editedTheme
                }
            }
        }
    }
    
    private func emojiSamples(for theme: Theme) -> some View {
        let maxCount = isIPad ? Constants.maxEmojiCountForIpad : Constants.maxEmojiCountForIphone
        let emojis = theme.emojis.count <= maxCount
        ? theme.emojis.map { $0 }
        : Array<Character>(theme.emojis.map { $0 }[0..<maxCount])
        
        return HStack {
            Text(isIPad ? "Sample cards:" : "")
            ForEach(emojis, id: \.self) { emoji in
                Text(String(emoji))
            }
            if theme.emojis.count > maxCount {
                Text("...")
            }
        }
    }
    
    private func tap(for theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
    
    private struct Constants {
        static let colorSampleLength: CGFloat = 15
        static let maxEmojiCountForIpad = 12
        static let maxEmojiCountForIphone = 6
        static let verticalSpacing: CGFloat = 5
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser()
            .environmentObject(ThemeStore(name: "Preview"))
    }
}
