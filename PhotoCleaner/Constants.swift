//
//  Constants.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 02/05/2025.
//

import Foundation

///  Constant values that the app defines.
struct Constants {
    static let cornerRadius: Double = 10.0

    static var cardPadding: Double {
        #if os(tvOS)
        30
        #else
        20
        #endif
    }

    static var videoCardWidth: Double {
        #if os(tvOS)
        550
        #elseif os(macOS)
        250
        #else
        300
        #endif
    }

    static let compactVideoCardWidth: Double = 200
}
