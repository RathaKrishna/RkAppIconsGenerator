//
//  RKAssetSize.swift
//  RkAppIconsGenerator
//
//  Created by Rathakrishnan on 05/03/21.
//  Copyright © 2021 Rathakrishnan. All rights reserved.
//

import Foundation

struct AssetSize {
    let string: String
    let width: Float
    let height: Float

    /** Parse string like 50x45
    *   or 50.5x25.5
    *   ! 50.5.5x60.5.6 will not work
    */
    init(size: String) throws {
        let regex = "^([\\d\\.]+)x([\\d\\.]+)$"
        if let expression = try? NSRegularExpression(pattern: regex) {
            let range = NSRange(size.startIndex..<size.endIndex, in: size)

            var widthResult: Float?
            var heightResult: Float?

            expression.enumerateMatches(in: size, options: [], range: range) { (match, _, stop) in
                defer { stop.pointee = true }
                guard let match = match else { return }

                if match.numberOfRanges == 3,
                   let wRange = Range(match.range(at: 1), in: size),
                   let hRange = Range(match.range(at: 2), in: size) {

                    widthResult = Float(size[wRange])
                    heightResult = Float(size[hRange])
                }
            }

            if let width = widthResult, let height = heightResult {
                self.string = size
                self.width = width
                self.height = height
                return
            }
        }

        throw AssetCatalogError.invalidFormat(format: .size)
    }

    func multiply(_ scale: AssetScale) -> NSSize {
        let width = Int(self.width * Float(scale.value))
        let height = Int(self.height * Float(scale.value))
        return NSSize(width: width, height: height)
    }
}

// swiftlint:disable identifier_name
enum AssetScale: String {
    case x1 = "1x"
    case x2 = "2x"
    case x3 = "3x"

    var value: Int {
        switch self {
        case .x1: return 1
        case .x2: return 2
        case .x3: return 3
        }
    }
}
// swiftlint:enable identifier_name


///  Error Types for AssetCatalog.
///
///  - rescalingImageFailed:           Rescaling the given image failed.
///  - gettingJSONDataFailed:          Getting image information from the given JSON file failed.
///  - fileNotFound:                  The supplied JSON file could not be found.
///  - castingJSONToDictionaryFailed: Casting the supplied JSON file to a Dictionary failed.
///  - gettingImagesArrayFailed:      Getting the information which images to generate failed.
///  - writingContentsJSONFailed:     Saving the Contents.json for the asset catalog failed.
enum AssetCatalogError: Error {
    enum Format {
        case size, scale, orientation
    }
    case missingImage
    case rescalingImageFailed
    case gettingJSONDataFailed
    case invalidFormat(format: Format)
    case missingPlatformJSON
}
