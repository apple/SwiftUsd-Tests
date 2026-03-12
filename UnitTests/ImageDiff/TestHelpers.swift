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

// Public test utility functions that might be useful to clients
// that want to compare images in unit tests

import Foundation
import XCTest

protocol ImageDiffTestHelpers: XCTestCase {}

struct ImageComparisonUnexpectedResultError: Error {
    let expectedResult: ImageDiff.ComparisonResult
    let actualResult: ImageDiff.ComparisonResult
    let lhs: URL
    let rhs: URL
    let options: ImageDiff.ComparisonOptions
}

extension ImageDiffTestHelpers {
    @discardableResult
    public func expectComparisonResult(isExactly expectedResult: ImageDiff.ComparisonResult, _ lhs: URL, _ rhs: URL, options: ImageDiff.ComparisonOptions = .somewhatStrict,
                                              file: StaticString = #file, line: UInt = #line) -> (ImageDiff.ComparisonResult, actualResultMatchedExpectedResult: Bool) {
        var success = false
        let actualResult = ImageDiff.compareImages(lhs, rhs, options: options, file: file, line: line)
        switch (expectedResult.kind, actualResult.kind) {
        // Pre-comparison errors
        case (.unreadableFile, .unreadableFile): success = true
        case (.unreadableFile, _): XCTFail("Files were unexpectedly readable: \(lhs), \(rhs)", file: file, line: line)
        case (_, .unreadableFile): XCTFail("Couldn't read files: \(lhs), \(rhs)", file: file, line: line)
        case (.differentSizes, .differentSizes): success = true
        case (.differentSizes, _): XCTFail("Files unexpectedly had the same size: \(lhs), \(rhs)", file: file, line: line)
        case (_, .differentSizes): XCTFail("Files were different sizes: \(lhs), \(rhs)", file: file, line: line)
            
        case (.pass, .pass): success = true
        case (.pass, .warn): warn("\(lhs) and \(rhs) differ some (expected the same): \(lhs), \(rhs)", file: file, line: line)
        case (.pass, .fail): XCTFail("\(lhs) and \(rhs) are different (expected the same): \(lhs), \(rhs)", file: file, line: line)
        case (.warn, .pass): warn("\(lhs) and \(rhs) are unexpectedly the same (expected small differences): \(lhs), \(rhs)", file: file, line: line)
        case (.warn, .warn): success = true
        case (.warn, .fail): XCTFail("\(lhs) and \(rhs) are different (expected small differences): \(lhs), \(rhs)", file: file, line: line)
        case (.fail, .pass): XCTFail("\(lhs) and \(rhs) are unexpectedly the same (expected differences): \(lhs), \(rhs)", file: file, line: line)
        case (.fail, .warn): XCTFail("\(lhs) and \(rhs) are slightly different (expected differences): \(lhs), \(rhs)", file: file, line: line)
        case (.fail, .fail): success = true
        }
        return (actualResult, success)
    }
        
    @discardableResult
    public func requireComparisonResult(isExactly expectedResult: ImageDiff.ComparisonResult, _ lhs: URL, _ rhs: URL, options: ImageDiff.ComparisonOptions = .somewhatStrict,
                                               file: StaticString = #file, line: UInt = #line) throws -> ImageDiff.ComparisonResult {
        let (actualResult, identicalKinds) = expectComparisonResult(isExactly: expectedResult, lhs, rhs, options: options, file: file, line: line)
        guard identicalKinds else {
            throw ImageComparisonUnexpectedResultError(expectedResult: expectedResult, actualResult: actualResult, lhs: lhs, rhs: rhs, options: options)
        }
        return actualResult
    }
    
    @discardableResult
    public func expectImagesCompareIdentical(_ lhs: URL, _ rhs: URL, options: ImageDiff.ComparisonOptions = .somewhatStrict,
                                                    file: StaticString = #file, line: UInt = #line) -> ImageDiff.ComparisonResult {
        expectComparisonResult(isExactly: .pass, lhs, rhs, options: options, file: file, line: line).0
    }
    
    public func requireImagesCompareIdentical(_ lhs: URL, _ rhs: URL, options: ImageDiff.ComparisonOptions = .somewhatStrict,
                                              file: StaticString = #file, line: UInt = #line) throws {
        try requireComparisonResult(isExactly: .pass, lhs, rhs, options: options, file: file, line: line)
    }
        
    func warn(_ message: String, file: StaticString = #file, line: UInt = #line) {
        let context = XCTSourceCodeContext(location: XCTSourceCodeLocation(filePath: file.description, lineNumber: Int(line)))
        let issue = XCTIssue(type: .assertionFailure, compactDescription: message, sourceCodeContext: context)
        // Would be nice to `issue.severity = .warning`, but there doesn't
        // seem to be a way to do that that doesn't break compilation when
        // a 6.3 snapshot compiles when Xcode 16.3 is the active Xcode
        record(issue)
    }
}

@MainActor internal func addImageAttachment(_ image: URL, name: String, keepAlways: Bool, file: StaticString = #file, line: UInt = #line, function: String = #function) {
    let attachment = XCTAttachment(contentsOfFile: image)
    attachment.name = name
    attachment.lifetime = keepAlways ? .keepAlways : .deleteOnSuccess
    
    XCTContext.runActivity(named: name) {
        $0.add(attachment)
    }
    
    addSwiftBuildAttachmentIfNeeded(attachment: image, name: name + "." + image.pathExtension, file: file, line: line, function: function)
}

internal func addComparisonResultAttachment(_ comparisonResult: ImageDiff.ComparisonResult, file: StaticString = #file, line: UInt = #line, function: String = #function) {
    let data = comparisonResult.description.data(using: .utf8)!
    let tmpFile = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString + ".imagecomparison.txt")
    try! data.write(to: tmpFile)
    addSwiftBuildAttachmentIfNeeded(attachment: tmpFile, name: "imagecomparison.txt", file: file, line: line, function: function)
}

fileprivate func addSwiftBuildAttachmentIfNeeded(attachment: URL, name: String, file: StaticString = #file, line: UInt = #line, function: String = #function) {
    #if OPENUSD_SWIFT_BUILD_FROM_CLI
    guard let resultBundlePath = ProcessInfo.processInfo.environment["RESULT_BUNDLE_PATH"] else {
        print("RESULT_BUNDLE_PATH is unset")
        return
    }
    
    let fm = FileManager.default
    var isDirectory: ObjCBool = false
    if fm.fileExists(atPath: resultBundlePath, isDirectory: &isDirectory) {
        if !isDirectory.boolValue {
            print("$RESULT_BUNDLE_PATH is not a directory")
            return
        }
    } else {
        do {
            try fm.createDirectory(atPath: resultBundlePath, withIntermediateDirectories: true)
        } catch {
            print("Error creating $RESULT_BUNDLE_PATH: \(error)")
            return
        }
    }
    
    let basename = "\(function)__\(file)__\(line)__\(name)"
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
    let destDir = URL(fileURLWithPath: resultBundlePath).appending(path: basename)
    do {
        try fm.copyItem(at: attachment, to: destDir)
    } catch {
        print("Error copying \(attachment) to \(destDir): \(error)")
    }
    #endif
}
