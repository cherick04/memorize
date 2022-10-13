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
    
    @State private var themeToEdit: Theme?
    @State private var themeToAdd: Theme?
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { row(for: $0) }
                    .onDelete { indexSet in
                        store.themes.remove(atOffsets: indexSet)
                    }
                    .onMove { indexSet, newOffset in
                        store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                    }
            }
            .navigationTitle("Themes")
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem { addButton }
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented,
                       UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    private var addButton: some View {
        Button {
            store.insertTheme(named: "New Theme", at: 0)
            themeToAdd = store.theme(at: 0)
        } label: {
            Image(systemName: "plus")
        }
        .popover(item: $themeToAdd, arrowEdge: .bottom) { newTheme in
            ThemeEditor(theme: $store.themes[newTheme])
        }
    }
    
    private func row(for theme: Theme) -> some View {
        VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
            HStack {
                colorSample(for: theme)
                Text(theme.name)
                Spacer() // 1
            }
            Text("Number of card pairs: \(theme.emojis.count)")
            Text("Number of card pairs to be used: \(theme.cardPairCount ?? theme.emojis.count)")
            emojiSamples(for: theme)
        }
        .contentShape(Rectangle()) // 2 - 1 & 2 needed to make the whole row tapable
        .gesture(editMode == .active ? tap(for: theme) : nil)
        .sheet(item: $themeToEdit) { themeToEdit in
            ThemeEditor(theme: $store.themes[themeToEdit])
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
    
    private func tap(for theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
    
    private struct Constants {
        static let colorSampleLength: CGFloat = 15
        static let maxEmojiSampleCount = 8
        static let verticalSpacing: CGFloat = 5
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager()
            .environmentObject(ThemeStore(name: "Preview"))
    }
}
