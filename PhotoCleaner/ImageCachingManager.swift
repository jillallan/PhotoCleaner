//
//  ImageCachingManager.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 21/03/2025.
//

import Foundation
import Photos
import SwiftUI

actor ImageCachingManager {
    private let imageManager = PHCachingImageManager()
    private var imageContentMode = PHImageContentMode.aspectFit

    func startCachingImages(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets = assets.compactMap { $0.phAsset }
        imageManager
            .startCachingImages(
                for: phAssets,
                targetSize: targetSize,
                contentMode: imageContentMode,
                options: nil
            )
    }

    func stopCachingImages(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets = assets.compactMap { $0.phAsset }
        imageManager
            .stopCachingImages(
                for: phAssets,
                targetSize: targetSize,
                contentMode: imageContentMode,
                options: nil
            )
    }

    func requestImage(for asset: PhotoAsset, targetSize: CGSize, completion: @escaping (Image?) -> Void) {
        guard let phAsset = asset.phAsset else {
            completion(nil)
            return
        }
        imageManager
            .requestImage(
                for: phAsset,
                targetSize: targetSize,
                contentMode: imageContentMode,
                options: nil) { image, info in
                    if let image {
                        let result = Image(uiImage: image)
                        completion(result)
                    }
                }
    }
}
