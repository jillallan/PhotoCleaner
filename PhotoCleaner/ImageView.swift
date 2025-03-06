//
//  ImageView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 06/03/2025.
//

import Photos
import SwiftUI

struct ImageView: View {
    @Environment(\.displayScale) private var displayScale
    let asset: PhotoAsset
    @State var loadedImage: UIImage?

    private static let itemSize = CGSize(width: 90, height: 90)
    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }
    
    var body: some View {
        let _ = print("hello view")
        VStack {
            Text("Hello image view")
            if let loadedImage {
                Image(uiImage: loadedImage)
            }
        }
        .onAppear {
            print("Hello")
            let imageManager = PHImageManager.default()

            print(asset.identifier)
            print(String(describing: asset.phAsset?.localIdentifier))
            if let phAsset = asset.phAsset {
                imageManager
                    .requestImage(
                        for: phAsset,
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

//#Preview {
//    ImageView()
//}
