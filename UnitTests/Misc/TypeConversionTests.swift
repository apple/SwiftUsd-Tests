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

final class TypeConversionTests: TemporaryDirectoryHelper {

    func test_Float_from_GfHalf() {
        let x: pxr.GfHalf = pxr.GfHalf(1.25)
        let y: Float = Float(x)
        XCTAssertEqual(y, 1.25)
    }
    
    func test_String_from_TfToken() {
        XCTAssertEqual(String(pxr.TfToken.UsdGeomTokens.Cube), "Cube")
    }
    
    func test_String_from_SdfPath() {
        XCTAssertEqual(String(pxr.SdfPath("/foo/bar.fizz")), "/foo/bar.fizz")
    }

    func test_stdstring_from_TfToken() {
        XCTAssertEqual(std.string(pxr.TfToken.UsdGeomTokens.Cube), "Cube")
    }
    
    func test_String_from_ArResolvedPath() {
        XCTAssertEqual(String(pxr.ArResolvedPath("/foo/bar")), "/foo/bar")
    }
    
    func test_stdstring_from_ArResolvedPath() {
        XCTAssertEqual(std.string(pxr.ArResolvedPath("/fizz/buzz")), "/fizz/buzz" as std.string)
    }
    
    func test_SdfAssetPath_from_String() {
        XCTAssertEqual(pxr.SdfAssetPath("/foo" as String), "/foo" as pxr.SdfAssetPath)
    }
}
