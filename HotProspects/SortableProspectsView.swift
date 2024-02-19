//
//  SortableProspectsView.swift
//  HotProspects
//
//  Created by Игорь Верхов on 19.02.2024.
//

import SwiftUI

struct SortableProspectsView: View {
    let filter: ProspectsView.FilterType
    @State private var sortOrder = SortDescriptor(\Prospect.name)
    
    var body: some View {
        NavigationStack {
            ProspectsView(filter: filter, sort: sortOrder)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort") {
                            Picker("Sort order", selection: $sortOrder) {
                                Text("Date added")
                                    .tag(SortDescriptor(\Prospect.dateAdded))
                                Text("Name")
                                    .tag(SortDescriptor(\Prospect.name))
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    SortableProspectsView(filter: .none)
}
