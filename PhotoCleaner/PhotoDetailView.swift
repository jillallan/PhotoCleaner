//
//  PhotoDetailView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 23/03/2025.
//

import Photos
import SwiftUI

struct PhotoDetailView: View {
    @State var asset: PhotoAsset
    var cache: ImageCachingManager
    let photoCollection: PhotoCollection
    @State var image: Image?
    private let imageSize = CGSize(width: 1024, height: 1024)

    var body: some View {

        VStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }

        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                buttonView()
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .task {
            guard image == nil else { return }
            fetchImage(for: asset)
        }
        .onChange(of: asset) {
            fetchImage(for: asset)
        }
    }

    private func buttonView() -> some View {
        HStack(spacing: 60) {
            Button {
                let previousAsset = photoCollection.previousImage(asset: self.asset)
                self.asset = previousAsset

            } label: {
                Label("Left", systemImage: "arrow.backward")
                    .font(.system(size: 24))
            }

            Button {
                let nextAsset = photoCollection.nextImage(asset: self.asset)
                self.asset = nextAsset
            } label: {
                Label("Right", systemImage: "arrow.forward")
                    .font(.system(size: 24))
            }

        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color.secondary.colorInvert())
        .cornerRadius(15)
    }

    func fetchImage(for asset: PhotoAsset) {
        Task {
            await cache
                .requestImage(for: asset, targetSize: imageSize, completion: { image in
                    Task {
                        if let image {
                            self.image = image
                        }
                    }
                }
            )
        }
    }
}

#Preview {
    let photoAssets = PhotoCollection(collectionType: .all).photoAssets
    let photoCollection = PhotoCollection(collectionType: .all)
    let asset = PhotoAsset(phAsset: PHAsset(), index: 1)
    let image = Image("sheep")

    PhotoDetailView(
        asset: asset,
        cache: ImageCachingManager(),
//        navPath: .constant([]),
        photoCollection: photoCollection,
        image: image
    )
}
