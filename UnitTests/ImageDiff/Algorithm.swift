//===----------------------------------------------------------------------===//
// This source file is part of github.com/apple/SwiftUsd-Tests
//
// Copyright © 2025 Apple Inc. and the SwiftUsd-Tests project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0
//===----------------------------------------------------------------------===//

// The core image comparison algorithm.

import Foundation
import OpenUSD

extension ImageDiff {
    /// Compares the images at the given URLs using the comparison options, returning the result of the comparison.
    /// If differenceImage is not nil, the image at that URL is the absolute value of the per-component per-pixel difference between the images
    public static func compareImages(_ lhs: URL, _ rhs: URL, options: ComparisonOptions = .veryStrict,
                                     file: StaticString = #file, line: UInt = #line) -> ComparisonResult {
        // Can we load the images?
        var result = ComparisonResult.unreadableFile
        result.firstImage = lhs
        result.secondImage = rhs
        result.differenceImage = nil
        result.comparisonOptions = options
        
        
        let differenceImageURL = FileManager.default.temporaryDirectory.appending(path: "diff-\(UUID().uuidString).\(options.differenceImageFileExtension)")
        
        guard let lhsImage = ImageHelper(reading: lhs),
              let rhsImage = ImageHelper(reading: rhs),
              let diffImage = ImageHelper(writing: differenceImageURL, format: lhsImage) else {
            return result
        }
        
        // Are the images the same size?
        result.kind = .differentSizes
        guard lhsImage.width == rhsImage.width && lhsImage.height == rhsImage.height && lhsImage.depth == 1 && rhsImage.depth == 1 else {
            return result
        }
        
        // Are the images actually the same?
        result.kind = .pass
        result.differenceImage = differenceImageURL
        result.imageWidth = Int(lhsImage.width)
        result.imageHeight = Int(lhsImage.height)
        
        for x in 0..<lhsImage.width {
            for y in 0..<lhsImage.height {
                for c in 0..<lhsImage.numberOfComponents {
                    let lValue = lhsImage.value(x: x, y: y, component: c)
                    let rValue = rhsImage.value(x: x, y: y, component: c)
                    
                    let diffValue = Swift.abs(lValue - rValue)
                    updateResult(absComponent: diffValue, position: (Int(x), Int(y), Int(c)), result: &result)
                    
                    diffImage.setValue(x: x, y: y, component: c, value: diffValue)
                }
            }
        }
        
        diffImage.writeToDisk()
        
        return result
    }
    
    // Update the `result` inout variable based on `absComponent`
    private static func updateResult(absComponent: Double,
                                     position: (Int, Int, Int),
                                     result: inout ComparisonResult) {
        
        if absComponent > result.comparisonOptions.hardFail {
            result.nFailedPixels += 1
            result.kind.raiseSeverity(to: .fail)
        } else if absComponent > result.comparisonOptions.failThreshold {
            result.nFailedPixels += 1
        }
        
        if absComponent > result.comparisonOptions.hardWarn {
            result.nWarnedPixels += 1
            result.kind.raiseSeverity(to: .warn)
        } else if absComponent > result.comparisonOptions.warnThreshold {
            result.nWarnedPixels += 1
        }
        
        let currentFailPercent = 100 * Double(result.nFailedPixels) / Double(result.imageWidth * result.imageHeight)
        let currentWarnPercent = 100 * Double(result.nWarnedPixels) / Double(result.imageWidth * result.imageHeight)
        
        if currentFailPercent > result.comparisonOptions.failPercent {
            result.kind.raiseSeverity(to: .fail)
        }
        if currentWarnPercent > result.comparisonOptions.warnPercent {
            result.kind.raiseSeverity(to: .warn)
        }
        
        if absComponent > result.maxDifferenceValue {
            result.maxDifferenceValue = absComponent
            result.maxDifferencePosition = position
        }
    }
}

