//
//  PhotoAssetCollection.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 04/03/2025.
//

//import Foundation
import Photos

class PhotoAssetCollection: RandomAccessCollection {
    private(set) var fetchResult: PHFetchResult<PHAsset>
    private var iteratorIndex: Int = 0

    var startIndex: Int { 0 }
    var endIndex: Int { fetchResult.count }

    init(_ fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
    }

    subscript(position: Int) -> PhotoAsset {
        let asset = PhotoAsset(
            phAsset: fetchResult.object(at: position),
            index: position
        )
        return asset
    }
}
