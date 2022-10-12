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
            }
        }
    }
    
    private func colorSample(for theme: Theme) -> some View {
        Rectangle()
            .foregroundColor(Color.byRGBA(theme.color))
            .frame(width: 15, height: 15)
    }
    
    private func emojiSamples(for theme: Theme) -> some View {
        HStack {
            ForEach(theme.emojis, id: \.self) { emoji in
                Text(emoji)
            }
        }
    }
}
