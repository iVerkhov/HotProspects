//
//  ContentView.swift
//  HotProspects
//
//  Created by Игорь Верхов on 25.10.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        TabView {
            SortableProspectsView(filter: .none)
                .tabItem { Label("Everyone", systemImage: "person.3") }
            SortableProspectsView(filter: .contacted)
                .tabItem { Label("Conatced", systemImage: "checkmark.circle") }
            SortableProspectsView(filter: .uncontacted)
                .tabItem { Label("Uncontacted", systemImage: "questionmark.diamond") }
            MeView()
                .tabItem { Label("Me", systemImage: "person.crop.square") }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Prospect.self)
}
