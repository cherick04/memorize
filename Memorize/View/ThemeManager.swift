//
//  ThemeManager.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    VStack(alignment: .leading) {
                        Text(theme.name)
                    }
                }
            }
        }
    }
}
