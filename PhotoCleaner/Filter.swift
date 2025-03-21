//
//  Filter.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 21/03/2025.
//

import Foundation

struct Filter: Hashable, Identifiable {
    var id: UUID
    var name: String
    var icon: String
    var startDate: Date = Date.distantPast
    var endDate: Date = Date.distantFuture
    var photoCollectionType: PhotoCollectionType

    static var all = Filter(
        id: UUID(),
        name: "All Photos",
        icon: "tray",
        photoCollectionType: .all
    )
    static var onThisDay = Filter(
        id: UUID(),
        name: "On This Day",
        icon: "clock",
        photoCollectionType: .onThisDay
    )

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
