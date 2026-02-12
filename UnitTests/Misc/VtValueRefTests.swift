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

final class VtValueRefTests: TemporaryDirectoryHelper {
    private let longStr: std.string = "abcdefghijklmnopqrstuvwxyz"
    
    func test_VtValueDotRef_double_no_dangle() {
        let x = pxr.VtValue(5.0 as Double)
        // VtValue::Ref() is manually renamed to VtValue.__RefUnsafe() in Swift
        let xRef = x.__RefUnsafe()
        let x2: Double = xRef.GetWithDefault(9)
        XCTAssertEqual(x2, 5)
    }
    
    func test_VtValueDotRef_stdstring_no_dangle() {
        let x = pxr.VtValue(longStr)
        // VtValue::Ref() is manually renamed to VtValue.__RefUnsafe() in Swift
        let xRef = x.__RefUnsafe()
        let x2: std.string = xRef.GetWithDefault("abc")
        XCTAssertEqual(x2, longStr)
    }
        
        
    func test_VtValueDotRef_double_yes_dangle() {
        var xRef: pxr.VtValueRef!
        do {
            let x = pxr.VtValue(5.0 as Double)
            // VtValue::Ref() is manually renamed to VtValue.__RefUnsafe() in Swift
            xRef = x.__RefUnsafe()
        }
        let x2: Double = xRef.GetWithDefault(9)
        XCTAssertEqual(x2, 5)
    }
    
    func test_VtValueDotRef_stdstring_yes_dangle() {
        var xRef: pxr.VtValueRef!
        do {
            let x = pxr.VtValue(longStr)
            // VtValue::Ref() is manually renamed to VtValue.__RefUnsafe() in Swift
            xRef = x.__RefUnsafe()
        }
        let x2: std.string = xRef.GetWithDefault("abc")
        // x2 ends up being the empty string because xRef is dangling,
        // so GetWithDefault() ends up doing default initialization I think?
        // regardless, this demonstrates why VtValueRef can trivially be
        // memory unsafe or cause crashes in Swift
        XCTAssertEqual(x2, "")
    }
    
    func test_VtValueDotRef_stdstring_extendedlifetime() {
        var xRef: pxr.VtValueRef!
        do {
            let x = pxr.VtValue(longStr)
            withExtendedLifetime(x) { x in
                // VtValue::Ref() is manually renamed to VtValue.__RefUnsafe() in Swift
                xRef = x.__RefUnsafe()
                let x2: std.string = xRef.GetWithDefault("abc")
                XCTAssertEqual(x2, longStr)
            }
        }
        // x3 ends up being the empty string because xRef is dangling,
        // so GetWithDefault() ends up doing default initialization I think?
        // regardless, this demonstrates why VtValueRef can trivially be
        // memory unsafe or cause crashes in Swift
        let x3: std.string = xRef.GetWithDefault("def")
        XCTAssertEqual(x3, "")
    }
}
