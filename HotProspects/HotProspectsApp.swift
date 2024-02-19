//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Игорь Верхов on 25.10.2023.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
