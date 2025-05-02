//
//  CardInfoView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 02/05/2025.
//

import SwiftUI

struct CardInfoView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("2025")
                .font(isCompact ? .body : .title3)
            Text("200 out of 3425 photos left to review")
                .font(isCompact ? .caption : .body)
        }
        .padding(Constants.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CardInfoView()
}
