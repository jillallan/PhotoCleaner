//
//  PhotoCollectionCard.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 02/05/2025.
//

import SwiftUI

struct PhotoCollectionCard: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }
    
    let image: Image

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFill()

            CardInfoView()
        }
#if os(macOS)
        .background(.quaternary)
#else
        .background(.ultraThinMaterial)
#endif
#if os(iOS) || os(visionOS)
        .hoverEffect()
#endif
        .frame(
            width: isCompact ? Constants.compactVideoCardWidth : Constants
                .videoCardWidth)
        .clipShape(.rect(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    let image = Image(.seafront)
    PhotoCollectionCard(image: image)
}
