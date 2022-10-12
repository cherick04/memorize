//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var managing = false
    
    var body: some View {
        HStack {
            Button {
                managing = true
            } label: {
                Image(systemName: "slider.vertical.3")
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text("Choose Theme")
                }
            }
        }
        .foregroundColor(.blue)
        .sheet(isPresented: $managing) {
            ThemeManager()
        }
    }
}
