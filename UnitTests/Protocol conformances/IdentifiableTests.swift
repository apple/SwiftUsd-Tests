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

final class IdentifiableTests: TemporaryDirectoryHelper {
    
    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any Identifiable.Type)
    }
    func assertIDIsSelf<T: Identifiable>(_ t: T.Type) {
        XCTAssertTrue(T.ID.self is T.Type)
    }
    
    func test_SdfPath() {
        let p: pxr.SdfPath = "/hello/world"
        let id: pxr.SdfPath = p.id
        XCTAssertEqual(p, id)
        assertConforms(pxr.SdfPath.self)
        assertIDIsSelf(pxr.SdfPath.self)
    }
    
    func test_TfToken() {
        let t: pxr.TfToken = "Cube"
        let id: pxr.TfToken = t.id
        XCTAssertEqual(t, id)
        assertConforms(pxr.TfToken.self)
        assertIDIsSelf(pxr.TfToken.ID.self)
    }
    
    func test_UsdAttribute() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim1")
        let a: pxr.UsdAttribute = cube1.GetExtentAttr()
        let id: pxr.UsdAttribute = a.id
        XCTAssertEqual(a, id)
        assertConforms(pxr.UsdAttribute.self)
        assertIDIsSelf(pxr.UsdAttribute.ID.self)
    }
    
    func test_UsdPrim() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1: pxr.UsdPrim = stage.DefinePrim("/myPrim1", "Cube")
        let id: pxr.UsdPrim = cube1.id
        XCTAssertEqual(cube1, id)
        assertConforms(pxr.UsdPrim.self)
        assertIDIsSelf(pxr.UsdPrim.ID.self)
    }
}
