//
//  EditView.swift
//  HotProspects
//
//  Created by Игорь Верхов on 19.02.2024.
//

import SwiftData
import SwiftUI

struct EditView: View {
    
    @Bindable var prospect: Prospect
    
    var body: some View {
        Form {
            TextField("Name", text: $prospect.name)
                .font(.headline)
                .textContentType(.name)
            TextField("Email address", text: $prospect.emailAdress)
                .font(.headline)
                .textContentType(.emailAddress)
            Toggle("Contacted", isOn: $prospect.isContacted)
        }
        .navigationTitle("Edit Prospect")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Prospect.self, configurations: config)
        return EditView(prospect: Prospect.example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
