//
//  MainView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 03/03/2025.
//

import Photos
import SwiftUI

struct ContentView: View {
    @Environment(\.displayScale) private var displayScale

    @State var loadedImage: UIImage?
    @State var loadedAssets: PhotoAssetCollection?

    private static let itemSpacing = 12.0
    private static let itemCornerRadius = 15.0
    private static let itemSize = CGSize(width: 90, height: 90)

    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }

    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing)
    ]

    var body: some View {
        VStack {
            if let loadedAssets {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(loadedAssets) { asset in
                            VStack {
                                ImageView(asset: asset)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            getImage()
            getImages()
        }

    }

    func getImages() {
        if let collection = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumUserLibrary,
            options: nil
        ).firstObject {
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            let photoAssetCollection = PhotoAssetCollection(assets)
            loadedAssets = photoAssetCollection
            for asset in photoAssetCollection {
                print(asset.identifier)
            }
        }
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
                                loadedImage = image
                            }
                        }
            }
        }
    }
}

#Preview {
    ContentView()
}
