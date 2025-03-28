//
//  PhotoCollection.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 04/03/2025.
//

import Foundation
import Photos
import OSLog

@Observable
class PhotoCollection {
    var photoAssets: PhotoAssetCollection = PhotoAssetCollection(PHFetchResult<PHAsset>())
    var photoCollectionType: PhotoCollectionType? = nil
    var fetchOptions: PHFetchOptions? = nil
    var cache = ImageCachingManager()

    init(collectionType: PhotoCollectionType) {
        self.photoCollectionType = photoCollectionType

        let fetchOptions = PHFetchOptions()
        fetchOptions.wantsIncrementalChangeDetails = true
        fetchOptions.includeAssetSourceTypes = [
            .typeUserLibrary,
            .typeCloudShared,
            .typeiTunesSynced,
        ]

        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        switch collectionType {
        case .onThisDay:
            if let predicate = createOnThisDayPredicate() {
                fetchOptions.predicate = predicate
            }
        case .all:
            break
        default:
            break
        }

        self.fetchOptions = fetchOptions
    }


    func refreshPhotoAssets(_ fetchResult: PHFetchResult<PHAsset>? = nil) async {
        var newFetchResult = fetchResult

        if newFetchResult == nil {
            newFetchResult = PHAsset.fetchAssets(with: .image, options: self.fetchOptions)
        }

        if let newFetchResult {
            await MainActor.run {
                photoAssets = PhotoAssetCollection(newFetchResult)
                logger.debug("PhotoCollection photoAssets refreshed: \(self.photoAssets.count)")
            }
        }
    }

    func createOnThisDayPredicate() -> NSCompoundPredicate? {
        let calendar = Calendar.current

        if let oldestCreationDate = fetchOldestAsset(with: .image)?.creationDate {
            let startYear = calendar.component(.year, from: oldestCreationDate)
            let endYear = calendar.component(.year, from: Date())
            let years = Array(startYear...endYear)

            let currentMonth = calendar.component(.month, from: Date())
            let currentDay = calendar.component(.day, from: Date())

            let predicates: [NSPredicate] = years.compactMap { year in
                guard
                    let startDate = calendar.date(from: DateComponents(year: year, month: currentMonth, day: currentDay)),
                    let endDate = calendar.date(from: DateComponents(year: year, month: currentMonth, day: currentDay + 1))
                else {
                    return nil
                }

                let fromPredicate = NSPredicate(
                    format: "creationDate >= %@",
                    startDate as NSDate
                )
                let toPredicate = NSPredicate(
                    format: "creationDate < %@",
                    endDate as NSDate
                )
                return NSCompoundPredicate(
                    type: .and,
                    subpredicates: [fromPredicate, toPredicate]
                )
            }

            // Create a compound predicate (AND condition)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

            return compoundPredicate
        } else {
            return nil
        }
    }

    func fetchOldestAsset(with mediaType: PHAssetMediaType) -> PHAsset? {
        let options = PHFetchOptions()

        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        options.fetchLimit = 1

        let fetchResult = PHAsset.fetchAssets(with: mediaType, options: options)

        return fetchResult.firstObject
    }

    func nextImage(asset: PhotoAsset) -> PhotoAsset {
        var nextIndex = asset.index.advanced(by: 1)
        nextIndex = photoAssets.indices.contains(nextIndex) ? nextIndex : 0
        return self.photoAssets[nextIndex]
    }

    func previousImage(asset: PhotoAsset) -> PhotoAsset {
        var nextIndex = asset.index.advanced(by: -1)
        nextIndex = photoAssets.indices.contains(nextIndex) ? nextIndex : 0
        return self.photoAssets[nextIndex]
    }
}

//extension PhotoCollection: IteratorProtocol {
//    func next() -> PhotoAsset? {
//        
//    }
//
//    public typealias Element = PhotoAsset
//}

fileprivate let logger = Logger(
    subsystem: "com.apple.swiftplaygroundscontent.capturingphotos",
    category: "PhotoCollection"
)

enum PhotoCollectionType: String {
    case onThisDay
    case all
    case favorites
}
