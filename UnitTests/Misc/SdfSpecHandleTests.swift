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

final class SdfSpecHandleTests: TemporaryDirectoryHelper {
    func test_SdfSpecHandle_pointee() {
        var stage: pxr.UsdStage! = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var layer: pxr.SdfLayer! = Overlay.Dereference(stage.GetRootLayer())
        stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        
        let handle: pxr.SdfSpecHandle = layer.GetObjectAtPath("/foo")
        let spec: pxr.SdfSpec = handle.pointee
        
        XCTAssertTrue(Bool(handle))
        XCTAssertFalse(spec.IsDormant())
        
        stage = nil
        layer = nil
        
        XCTAssertFalse(Bool(handle))
        XCTAssertTrue(spec.IsDormant())
    }
    
    func test_SdfPropertySpecHandle_pointee() {
        var stage: pxr.UsdStage! = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var layer: pxr.SdfLayer! = Overlay.Dereference(stage.GetRootLayer())
        let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        p.CreateAttribute("myattr", .Bool, true, .SdfVariabilityVarying)
        
        let handle: pxr.SdfPropertySpecHandle = layer.GetPropertyAtPath("/foo.myattr")
        let spec: pxr.SdfPropertySpec = handle.pointee
        
        XCTAssertTrue(Bool(handle))
        XCTAssertFalse(spec.IsDormant())
        
        stage = nil
        layer = nil
        
        XCTAssertFalse(Bool(handle))
        XCTAssertTrue(spec.IsDormant())
    }
    
    func test_SdfPrimSpecHandle_pointee() {
        var stage: pxr.UsdStage! = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var layer: pxr.SdfLayer! = Overlay.Dereference(stage.GetRootLayer())
        stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        
        let handle: pxr.SdfPrimSpecHandle = layer.GetPrimAtPath("/foo")
        let spec: pxr.SdfPrimSpec = handle.pointee
        
        XCTAssertTrue(Bool(handle))
        XCTAssertFalse(spec.IsDormant())
        
        stage = nil
        layer = nil
        
        XCTAssertFalse(Bool(handle))
        XCTAssertTrue(spec.IsDormant())
    }
    
    func test_SdfVariantSetSpecHandle_pointee() {
        var stage: pxr.UsdStage! = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var layer: pxr.SdfLayer! = Overlay.Dereference(stage.GetRootLayer())
        let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        var vsets = p.GetVariantSets()
        var vset = vsets.AddVariantSet("myvariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("alpha")
        
        let vsetsProxy = layer.GetPrimAtPath("/foo").pointee.GetVariantSets()
        let handle: pxr.SdfVariantSetSpecHandle = vsetsProxy.__findUnsafe("myvariant").pointee.second
        let spec: pxr.SdfVariantSetSpec = handle.pointee
        
        XCTAssertTrue(Bool(handle))
        XCTAssertFalse(spec.IsDormant())
        
        stage = nil
        layer = nil
        
        XCTAssertFalse(Bool(handle))
        XCTAssertTrue(spec.IsDormant())
    }
    
    func test_SdfVariantSpecHandle_pointee() {
        var stage: pxr.UsdStage! = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var layer: pxr.SdfLayer! = Overlay.Dereference(stage.GetRootLayer())
        let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        var vsets = p.GetVariantSets()
        var vset = vsets.AddVariantSet("myvariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("alpha")

        let vsetsProxy = layer.GetPrimAtPath("/foo").pointee.GetVariantSets()
        let handle: pxr.SdfVariantSpecHandle = vsetsProxy.__findUnsafe("myvariant").pointee.second.pointee.GetVariantList()[0]
        let spec: pxr.SdfVariantSpec = handle.pointee
        
        XCTAssertTrue(Bool(handle))
        XCTAssertFalse(spec.IsDormant())
        
        stage = nil
        layer = nil
        
        XCTAssertFalse(Bool(handle))
        XCTAssertTrue(spec.IsDormant())
    }
    
    func test_SdfAttributeSpecHandle_pointee() {
        var stage: pxr.UsdStage! = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var layer: pxr.SdfLayer! = Overlay.Dereference(stage.GetRootLayer())
        let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        p.CreateAttribute("myattr", .Bool, true, .SdfVariabilityVarying)
        
        let handle: pxr.SdfAttributeSpecHandle = layer.GetAttributeAtPath("/foo.myattr")
        let spec: pxr.SdfAttributeSpec = handle.pointee
        
        XCTAssertTrue(Bool(handle))
        XCTAssertFalse(spec.IsDormant())
        
        stage = nil
        layer = nil
        
        XCTAssertFalse(Bool(handle))
        XCTAssertTrue(spec.IsDormant())
    }
    
    func test_SdfRelationshipSpecHandle_pointee() {
        var stage: pxr.UsdStage! = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var layer: pxr.SdfLayer! = Overlay.Dereference(stage.GetRootLayer())
        let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        p.CreateRelationship("myrel", true)
        
        let handle: pxr.SdfRelationshipSpecHandle = layer.GetRelationshipAtPath("/foo.myrel")
        let spec: pxr.SdfRelationshipSpec = handle.pointee
        
        XCTAssertTrue(Bool(handle))
        XCTAssertFalse(spec.IsDormant())
        
        stage = nil
        layer = nil
        
        XCTAssertFalse(Bool(handle))
        XCTAssertTrue(spec.IsDormant())
    }

    func test_SdfPseudoRootSpecHandle_pointee() {
        // v25.05: No public methods return SdfPseudoRootSpec or SdfPseudoRootSpecHandle
        
        func inner(_ handle: pxr.SdfPseudoRootSpecHandle) {
            let spec: pxr.SdfPseudoRootSpec = handle.pointee
            withExtendedLifetime(spec) {}
        }
    }
}
