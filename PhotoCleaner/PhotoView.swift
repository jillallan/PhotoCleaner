//
//  PhotoView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 03/03/2025.
//

import Photos
import SwiftUI

struct PhotoView: View {
    @Environment(\.displayScale) private var displayScale

    let filter: Filter
    var photoCollection = PhotoCollection(collectionType: .all)

    @State var photoAssets: PhotoAssetCollection?

    private static let itemSpacing = 12.0
    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 180, height: 180)

    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }

    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(photoCollection.photoAssets) { asset in
                            NavigationLink(value: asset) {
                                photoItemView(asset: asset)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: PhotoAsset.self, destination: { asset in
                PhotoDetailView(asset: asset, cache: photoCollection.cache)
            })
            .onAppear {
                Task {
                     await photoCollection.refreshPhotoAssets()
                }
                
            }
            .navigationTitle(filter.name)
        }
    }

    init(filter: Filter) {
        self.filter = filter
        let photoCollection = PhotoCollection(
            collectionType: filter.photoCollectionType
        )
        self.photoCollection = photoCollection
    }

    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoItemView(
            asset: asset,
            cache: photoCollection.cache,
            imageSize: imageSize
        )
            .frame(
                width: PhotoView.itemSize.width,
                height: PhotoView.itemSize.height
            )
            .clipped()
            .cornerRadius(PhotoView.itemCornerRadius)
            .onAppear {
                Task {
                    await photoCollection.cache
                        .startCachingImages(for: [asset], targetSize: imageSize)
                }
            }
            .onDisappear {
                Task {
                    await photoCollection.cache
                        .stopCachingImages(for: [asset], targetSize: imageSize)
                }
            }
    }
}

#Preview {
    PhotoView(filter: .all)
}
