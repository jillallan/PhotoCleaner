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
                            photoItemView(asset: asset)
                        }
                    }
                }
            }
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
        PhotoDetailView(asset: asset, imageSize: imageSize)
            .frame(
                width: PhotoView.itemSize.width,
                height: PhotoView.itemSize.height
            )
            .clipped()
            .cornerRadius(PhotoView.itemCornerRadius)
    }

    func getImage() {
        let imageManager = PHImageManager.default()
        if let collection = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: nil
        ).firstObject {
            if let asset = PHAsset.fetchAssets(
                in: collection,
                options: nil
            ).firstObject {
                imageManager
                    .requestImage(
                        for: asset,
                        targetSize: imageSize,
                        contentMode: .aspectFit,
                        options: nil) { image, info in
                            if let image {
                                print(image.size)
                            }
                        }
            }
        }
    }
}

#Preview {
    PhotoView(filter: .all)
}
