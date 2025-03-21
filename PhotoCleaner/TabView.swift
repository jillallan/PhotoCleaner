//
//  TabView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 03/03/2025.
//

import SwiftUI
import SwiftData

struct PhotoCleanerTabView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selectedTab: Filter = .all

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(Filter.all.name, systemImage: Filter.all.icon, value: .all) {
                PhotoView(filter: Filter.all)
            }
            Tab(Filter.onThisDay.name, systemImage: Filter.onThisDay.icon, value: .onThisDay) {
                PhotoView(filter: Filter.onThisDay)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    PhotoCleanerTabView()
        .modelContainer(for: Item.self, inMemory: true)
}
