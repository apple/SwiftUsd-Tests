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

// The fundamental input/output types for the core algorithm

import Foundation

public enum ImageDiff {}

extension ImageDiff {
    public struct ComparisonOptions: Sendable, CustomStringConvertible {
        // Pixels that differ by this amount in any channel count as a failure
        public var failThreshold: Double = 1e-06
        // What percent [0.0 ... 100.0] of the pixels are allowed to fail before the image comparison fails?
        public var failPercent: Double = 0
        // If any pixel exceeds this difference, always treat it as a failure
        public var hardFail: Double = .infinity
        // Pixels that differ by this amount in any channel count as a warning
        public var warnThreshold: Double = 1e-06
        // What percent [0.0 ... 100.0] of the pixels are allowed to warn before the image comparison warns?
        public var warnPercent: Double = 0
        // If any pixel exceeds this difference, always treat it as a warning
        public var hardWarn: Double = .infinity
        // The file extension used for writing the difference image
        public var differenceImageFileExtension: String = "exr"
        
        public static let veryStrict: ComparisonOptions = .init(failThreshold: 1e-06,
                                                                failPercent: 0,
                                                                hardFail: .infinity,
                                                                warnThreshold: 1e-06,
                                                                warnPercent: 0,
                                                                hardWarn: .infinity,
                                                                differenceImageFileExtension: "exr")
        
        public static let somewhatStrict: ComparisonOptions = .init(failThreshold: 0.5,
                                                                    failPercent: 0.005,
                                                                    hardFail: .infinity,
                                                                    warnThreshold: 0.05,
                                                                    warnPercent: 0.0075,
                                                                    hardWarn: .infinity,
                                                                    differenceImageFileExtension: "exr")
        
        public var description: String {
            """
            failThreshold: \(failThreshold)
            failPercent: \(failPercent)
            hardFail: \(hardFail)
            warnThreshold: \(warnThreshold)
            warnPercent: \(warnPercent)
            hardWarn: \(hardWarn)
            differenceImageFileExstension: \(differenceImageFileExtension)
            """
        }
    }
}

extension ImageDiff {
    public struct ComparisonResult: Sendable, CustomStringConvertible {
        public enum Kind: Int, Sendable {
            case pass = 0
            case warn
            case fail
            case differentSizes
            case unreadableFile
            
            mutating func raiseSeverity(to other: Kind) {
                self = .init(rawValue: max(rawValue, other.rawValue))!
            }
        }
        public var firstImage: URL!
        public var secondImage: URL!
        public var differenceImage: URL? = nil
        public var kind: Kind
        public var imageWidth: Int = -1
        public var imageHeight: Int = -1
        public var nFailedPixels = 0
        public var nWarnedPixels = 0
        public var maxDifferenceValue: Double = -.infinity
        public var maxDifferencePosition: (Int, Int, Int) = (-1, -1, -1)
        public var comparisonOptions: ComparisonOptions!
        
        
        public static let pass = ComparisonResult(kind: .pass)
        public static let warn = ComparisonResult(kind: .warn)
        public static let fail = ComparisonResult(kind: .fail)
        public static let differentSizes = ComparisonResult(kind: .differentSizes)
        public static let unreadableFile = ComparisonResult(kind: .unreadableFile)
        
        public var description: String {
            """
            firstImage: \(firstImage?.path(percentEncoded: false) ?? "")
            secondImage: \(secondImage?.path(percentEncoded: false) ?? "")
            differenceImage: \(differenceImage?.path(percentEncoded: false) ?? "")
            kind: \(kind)
            imageWidth: \(imageWidth)
            imageHeight: \(imageHeight)            
            nFailedPixels: \(nFailedPixels)
            nWarnedPixels: \(nWarnedPixels)
            maxDifferenceValue: \(maxDifferenceValue)
            maxDifferencePosition: \(maxDifferencePosition)
            \(comparisonOptions)
            """
        }
    }
}
