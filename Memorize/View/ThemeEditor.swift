//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Erick Chacon on 10/12/22.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    var body: some View {
        Form {
            nameSection
        }
    }
    
    private var nameSection: some View {
        Section("Name") {
            TextField("Name", text: $theme.name)
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(name: "Preview").palette(at: 0)))
    }
}
