//
//  PhotoCollection.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 04/03/2025.
//

import Foundation
import Photos

@Observable
class PhotoCollection {
    var photoAssets: PhotoAssetCollection = PhotoAssetCollection(PHFetchResult<PHAsset>())

    var smartAlbumType: PHAssetCollectionSubtype?

    init(smartAlbum smartAlbumType: PHAssetCollectionSubtype) {
        self.smartAlbumType = smartAlbumType
    }
}
