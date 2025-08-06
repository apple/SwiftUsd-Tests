// ===-------------------------------------------------------------------===//
// This source file is part of github.com/apple/SwiftUsd-Tests
//
// Copyright © 2025 Apple Inc. and the SwiftUsd-Tests authors. All Rights Reserved. 
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at: 
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.     
// 
// SPDX-License-Identifier: Apache-2.0
// ===-------------------------------------------------------------------===//

import XCTest
import OpenUSD

final class ComparableTests: TemporaryDirectoryHelper {

    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any Comparable.Type)
    }
    
    func test_SdfPath() {
        let a: pxr.SdfPath = "/foo/bar"
        let b: pxr.SdfPath = "/alpha"
        let c: pxr.SdfPath = "/foo/bar/baz"
        XCTAssertGreaterThan(a, b)
        XCTAssertLessThan(b, c)
        XCTAssertLessThan(a, c)
        assertConforms(pxr.SdfPath.self)
    }
    
    func test_SdfLayerHandle() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        
        let a: pxr.SdfLayerHandle = stage.GetRootLayer()
        let b: pxr.SdfLayerHandle = stage.GetSessionLayer()
        let c: pxr.SdfLayerHandle = stage.GetRootLayer()
        
        if a < b {
            XCTAssertLessThan(a, b)
            XCTAssertGreaterThan(b, c)
            XCTAssertEqual(a, c)
        } else if a > b {
            XCTAssertGreaterThan(a, b)
            XCTAssertLessThan(b, c)
            XCTAssertEqual(a, c)
        } else if a == b {
            // Should never be possible, because root layer and session layer should be different
            XCTAssertNotEqual(a, b)
        }
        assertConforms(pxr.SdfLayerHandle.self)
    }
}
