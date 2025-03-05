//
//  ContentView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 03/03/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        TabView {
            Tab("Overview", systemImage: "house") {
                MainView()
            }
            Tab("Progress", systemImage: "chart.bar") {
//                SummaryView()
            }
            TabSection("Collections") {
                Tab("On this day", systemImage: "calendar") {
    //                SummaryView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
