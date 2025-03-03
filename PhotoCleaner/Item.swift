//
//  Item.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 03/03/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
