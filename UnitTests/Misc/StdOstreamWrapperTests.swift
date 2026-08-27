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
#if canImport(XLangTestingUtil)
import XLangTestingUtil
#endif // #if canImport(XLangTestingUtil)

final class StdOstreamWrapperTests: TemporaryDirectoryHelper {
    fileprivate typealias xlang = _xLanguage_StdOstreamWrapper
        
    func test_stream_noop() {
        let expected = ""
        let actual = xlang.returnStreamOutput { _ in }
        XCTAssertEqual(expected, String(actual))
    }

    // Swift 6.1 crashes when compiling the extension that adds `<<` in Swift
    #if compiler(>=6.2)
    func test_emptyString() {
        let expected = ""
        let actual = xlang.returnStreamOutput { $0.pointee << "" }
        XCTAssertEqual(expected, String(actual))
    }

    func test_emptyStringTwice() {
        let expected = ""
        let actual = xlang.returnStreamOutput {
            $0.pointee << ""
            $0.pointee << ""
        }
        XCTAssertEqual(expected, String(actual))
    }

    func test_hello() {
        let expected = "hello"
        let actual = xlang.returnStreamOutput {
            $0.pointee << "hello"
        }
        XCTAssertEqual(expected, String(actual))
    }

    func test_hello_world() {
        let expected = "hello world"
        let actual = xlang.returnStreamOutput {
            $0.pointee << "hello"
            $0.pointee << " world"
        }
        XCTAssertEqual(expected, String(actual))
    }

    func test_hello_world_newlines() {
        let expected = "hello\nworld"
        let actual = xlang.returnStreamOutput {
            $0.pointee << "hello"
            $0.pointee << "\n"
            $0.pointee << "world"
        }
        XCTAssertEqual(expected, String(actual))
    }
    
    func test_hello_world_newlines_again() {
        let expected = "hello\nworld"
        let actual = xlang.returnStreamOutput {
            $0.pointee << "hello\n"
            $0.pointee << "world"
        }
        XCTAssertEqual(expected, String(actual))
    }
    #endif // #if compiler(>=6.2)
}
