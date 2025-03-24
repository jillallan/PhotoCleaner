//
//  PhotoDetailView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 23/03/2025.
//

import Photos
import SwiftUI

struct PhotoDetailView: View {
    @State var assetID: Int
    var asset: PhotoAsset
    var cache: ImageCachingManager
    @State var photoAssets: PhotoAssetCollection
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
            let assetq = photoAssets[assetID]
            print(assetq)
            await cache
                .requestImage(for: assetq, targetSize: imageSize, completion: { image in
                    Task {
                        if let image {
                            self.image = image
                        }
                    }
                })

        }
    }

    private func buttonView() -> some View {
        HStack(spacing: 60) {
            Button {
                Task {
                    //                await asset.setIsFavorite(!asset.isFavorite)
                    assetID -= 1
                    let assetq = photoAssets[assetID]
                    print(assetq)
                    await cache
                        .requestImage(for: assetq, targetSize: imageSize, completion: { image in
                            Task {
                                if let image {
                                    self.image = image
                                }
                            }
                        })

                }
            } label: {
                Label("Left", systemImage: "arrow.backward")
                    .font(.system(size: 24))
            }

            Button {
                Task {
                    //                await asset.setIsFavorite(!asset.isFavorite)
                    assetID += 1
                    let assetq = photoAssets[assetID]
                    print(assetq)
                    await cache
                        .requestImage(for: assetq, targetSize: imageSize, completion: { image in
                            Task {
                                if let image {
                                    self.image = image
                                }
                            }
                        })

                }
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
}

#Preview {
    let photoAssets = PhotoCollection(collectionType: .all).photoAssets
    let asset = PhotoAsset(phAsset: PHAsset(), index: 1)
    let image = Image("sheep")

    PhotoDetailView(
        assetID: 1,
        asset: asset,
        cache: ImageCachingManager(),
        photoAssets: photoAssets,
        image: image
    )
}
