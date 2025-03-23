//
//  PhotoDetailView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 23/03/2025.
//

import Photos
import SwiftUI

struct PhotoDetailView: View {
    var asset: PhotoAsset
    var cache: ImageCachingManager
    @State var image: Image?
    private let imageSize = CGSize(width: 1024, height: 1024)

    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
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
    let asset = PhotoAsset(phAsset: PHAsset(), index: 1)
    let image = Image("sheep")

    PhotoDetailView(asset: asset, cache: ImageCachingManager(), image: image)
}
