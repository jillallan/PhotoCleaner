//
//  PhotoDetailView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 06/03/2025.
//

import Photos
import SwiftUI

struct PhotoItemView: View {
    @Environment(\.displayScale) private var displayScale

    var asset: PhotoAsset
    var cache: ImageCachingManager
    var imageSize: CGSize

    @State var image: Image?
    @State private var imageRequestID: PHImageRequestID?

    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .task {
            guard image == nil else { return }
            await cache
                .requestImage(for: asset, targetSize: imageSize, completion: { image in
                    Task {
                        if let image {
                            self.image = image
                        }
                    }
                })
        }
    }
}

#Preview {
    let phAsset = PHAsset()
    let cache = ImageCachingManager()

    var imageSize: CGSize = CGSize(width: 180, height: 180)
    let image = Image("sheep")

    PhotoItemView(
        asset: PhotoAsset(phAsset: phAsset, index: 1),
        cache: cache,
        imageSize: imageSize,
        image: image
    )
}
