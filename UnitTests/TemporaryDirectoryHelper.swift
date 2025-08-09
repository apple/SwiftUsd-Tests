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

import XCTest
import OpenUSD
public typealias pxr = OpenUSD.pxr

class TemporaryDirectoryHelper: XCTestCase {
    func copyResourceToWorkingDirectory(subPath: String, destName: String) throws -> std.string {
        let srcUrl = urlForResource(subPath: subPath)
        let destUrl = tempDirectory.appending(path: destName, directoryHint: .notDirectory)
        try FileManager.default.copyItem(at: srcUrl, to: destUrl)
        return std.string(destUrl.path(percentEncoded: false))
    }
    
    func pathForStage(named: String) -> std.string {
        std.string(urlForStage(named: named).path(percentEncoded: false))
    }
        
    func urlForStage(named fileName: String) -> URL {
        tempDirectory.appending(path: fileName, directoryHint: .notDirectory)
    }
    
    func urlForResource(subPath: String) -> URL {
        resourcesUrl().appending(path: subPath)
    }
    
    func assertClosed(_ name: String, file: StaticString = #file, line: UInt = #line) {
        let p = pxr.UsdStage.CreateNew(pathForStage(named: name), .LoadAll)
        XCTAssertTrue(Bool(p), file: file, line: line)
    }
    
    func assertOpen(_ name: String, file: StaticString = #file, line: UInt = #line) {
        let p = pxr.UsdStage.CreateNew(pathForStage(named: name), .LoadAll)
        XCTAssertFalse(Bool(p), file: file, line: line)
    }

    func test_noop() {}
    
    var tempDirectory: URL!
    
    override func setUpWithError() throws {
        tempDirectory = FileManager.default
            .temporaryDirectory
            .appending(path: "SwiftUsdTests", directoryHint: .isDirectory)
            .appending(path: UUID().uuidString, directoryHint: .isDirectory)
        
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: tempDirectory)
        tempDirectory = nil
    }
    
    func dataContentsOfFile(at url: URL) throws -> Data {
        guard let data = FileManager.default.contents(atPath: url.path(percentEncoded: false)) else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        return data
    }
    
    func contentsOfFile(at url: URL) throws -> String {
        guard let result = String(data: try dataContentsOfFile(at: url), encoding: .utf8) else {
            throw CocoaError(.formatting)
        }
        return result
    }
        
    func contentsOfResource(subPath: String) throws -> String {
        try contentsOfFile(at: urlForResource(subPath: subPath))
    }
    
    func contentsOfStage(named: String) throws -> String {
        try contentsOfFile(at: urlForStage(named: named))
    }
    
    func resourcesUrl() -> URL {
        #if canImport(XLangTestingUtil)
        let bundleUrl = Bundle.module.bundleURL
        #else
        let bundleUrl = Bundle(for: type(of: self)).bundleURL
        #endif // #if canImport(XLangTestingUtil)

        #if OPENUSD_SWIFT_BUILD_FROM_CLI
        return bundleUrl.appending(path: "Resources")
        #else
        return bundleUrl.appending(path: "Contents/Resources/Resources")
        #endif // #if OPENUSD_SWIFT_BUILD_FROM_CLI
    }

}
