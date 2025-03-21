//
//  PhotoDetailView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 06/03/2025.
//

import Photos
import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.displayScale) private var displayScale

    var asset: PhotoAsset
    var imageSize: CGSize

    @State var image: UIImage?
    
    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .onAppear {
            let imageManager = PHImageManager.default()

            if let phAsset = asset.phAsset {
                imageManager
                    .requestImage(
                        for: phAsset,
                        targetSize: imageSize,
                        contentMode: .aspectFit,
                        options: nil) { image, info in
                            if let image {
                                self.image = image
                            }
                        }
            }
        }
    }
}

//#Preview {
//    ImageView()
//}
