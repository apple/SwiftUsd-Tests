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

final class SdfSpecHandleTests: TemporaryDirectoryHelper {
    // MARK: SdfSpecHandle.pointee
    
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
    
    // MARK: SdfSpec upcasting/downcasting
    
    fileprivate func _stageForSpecCasting() -> pxr.UsdStage {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let p = stage.DefinePrim("/myPrim", "")
        p.CreateAttribute("myAttribute", .Bool, true, .SdfVariabilityVarying)
        p.CreateRelationship("myRelationship", true)
        var variantSet = p.GetVariantSet("myVariantSet")
        variantSet.AddVariant("myVariant", .UsdListPositionBackOfPrependList)
        variantSet.SetVariantSelection("myVariant")
        
        Overlay.withUsdEditContext(variantSet.GetVariantEditContext(pxr.SdfLayerHandle())) {
            p.CreateAttribute("myVariantedAttribute", .Double, true, .SdfVariabilityVarying)
        }
        
        return stage
    }
    
    func test_SdfSpec_to_SdfPropertySpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim.myAttribute").pointee
            let castedShouldSucceed: pxr.SdfPropertySpec? = pxr.SdfPropertySpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim").pointee
            let castedShouldFail: pxr.SdfPropertySpec? = pxr.SdfPropertySpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfSpec_to_SdfPrimSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim").pointee
            let castedShouldSucceed: pxr.SdfPrimSpec? = pxr.SdfPrimSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim.myAttribute").pointee
            let castedShouldFail: pxr.SdfPrimSpec? = pxr.SdfPrimSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfSpec_to_SdfVariantSetSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let variantSets = layer.GetPrimAtPath("/myPrim").pointee.GetVariantSets()
            let shouldSucceed: pxr.SdfSpec = pxr.SdfSpec(variantSets.items()["myVariantSet"]!.pointee)
            let castedShouldSucceed: pxr.SdfVariantSetSpec? = pxr.SdfVariantSetSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim.myAttribute").pointee
            let castedShouldFail: pxr.SdfVariantSetSpec? = pxr.SdfVariantSetSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfSpec_to_SdfVariantSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let variantSets = layer.GetPrimAtPath("/myPrim").pointee.GetVariantSets()
            let variant: pxr.SdfVariantSpec = variantSets.items()["myVariantSet"]!.pointee.GetVariants()[0].pointee
            let shouldSucceed: pxr.SdfSpec = pxr.SdfSpec(variant)
            let castedShouldSucceed: pxr.SdfVariantSpec? = pxr.SdfVariantSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim.myAttribute").pointee
            let castedShouldFail: pxr.SdfVariantSpec? = pxr.SdfVariantSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfSpec_to_SdfAttributeSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim.myAttribute").pointee
            let castedShouldSucceed: pxr.SdfAttributeSpec? = pxr.SdfAttributeSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim").pointee
            let castedShouldFail: pxr.SdfAttributeSpec? = pxr.SdfAttributeSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfSpec_to_SdfRelationshipSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim.myRelationship").pointee
            let castedShouldSucceed: pxr.SdfRelationshipSpec? = pxr.SdfRelationshipSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim").pointee
            let castedShouldFail: pxr.SdfRelationshipSpec? = pxr.SdfRelationshipSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfSpec_to_SdfPseudoRootSpecSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfSpec = layer.GetObjectAtPath("/").pointee
            let castedShouldSucceed: pxr.SdfPseudoRootSpec? = pxr.SdfPseudoRootSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfSpec = layer.GetObjectAtPath("/myPrim").pointee
            let castedShouldFail: pxr.SdfPseudoRootSpec? = pxr.SdfPseudoRootSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfPropertySpec_to_SdfSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfPropertySpec = pxr.SdfPropertySpec(layer.GetObjectAtPath("/myPrim.myAttribute").pointee)!
            let castedShouldSucceed: pxr.SdfSpec = pxr.SdfSpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }
    
    func test_SdfPropertySpec_to_SdfAttributeSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfPropertySpec = pxr.SdfPropertySpec(layer.GetObjectAtPath("/myPrim.myAttribute").pointee)!
            let castedShouldSucceed: pxr.SdfAttributeSpec? = pxr.SdfAttributeSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfPropertySpec = pxr.SdfPropertySpec(layer.GetObjectAtPath("/myPrim.myRelationship").pointee)!
            let castedShouldFail: pxr.SdfAttributeSpec? = pxr.SdfAttributeSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }

    func test_SdfPropertySpec_to_SdfRelationshipSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfPropertySpec = pxr.SdfPropertySpec(layer.GetObjectAtPath("/myPrim.myRelationship").pointee)!
            let castedShouldSucceed: pxr.SdfRelationshipSpec? = pxr.SdfRelationshipSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfPropertySpec = pxr.SdfPropertySpec(layer.GetObjectAtPath("/myPrim.myAttribute").pointee)!
            let castedShouldFail: pxr.SdfRelationshipSpec? = pxr.SdfRelationshipSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }
    
    func test_SdfPrimSpec_to_SdfSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfPrimSpec = layer.GetPrimAtPath("/myPrim").pointee
            let castedShouldSucceed: pxr.SdfSpec = pxr.SdfSpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }

    func test_SdfPrimSpec_to_SdfPseudoRootSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfPrimSpec = layer.GetPrimAtPath("/").pointee
            let castedShouldSucceed: pxr.SdfPseudoRootSpec? = pxr.SdfPseudoRootSpec(shouldSucceed)
            XCTAssertNotNil(castedShouldSucceed)
            
            let shouldFail: pxr.SdfPrimSpec = layer.GetPrimAtPath("/myPrim").pointee
            let castedShouldFail: pxr.SdfPseudoRootSpec? = pxr.SdfPseudoRootSpec(shouldFail)
            XCTAssertNil(castedShouldFail)
        }
    }

    func test_SdfVariantSetSpec_to_SdfSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let variantSets = layer.GetPrimAtPath("/myPrim").pointee.GetVariantSets()
            let shouldSucceed: pxr.SdfVariantSetSpec = variantSets.items()["myVariantSet"]!.pointee
            let castedShouldSucceed: pxr.SdfSpec = pxr.SdfSpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }

    func test_SdfVariantSpec_to_SdfSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let variantSets = layer.GetPrimAtPath("/myPrim").pointee.GetVariantSets()
            let shouldSucceed: pxr.SdfVariantSpec = variantSets.items()["myVariantSet"]!.pointee.GetVariants()[0].pointee
            let castedShouldSuceed: pxr.SdfSpec = pxr.SdfSpec(shouldSucceed)
        }
    }

    func test_SdfAttributeSpec_to_SdfSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfAttributeSpec = pxr.SdfAttributeSpec(layer.GetObjectAtPath("/myPrim.myAttribute").pointee)!
            let castedShouldSucceed: pxr.SdfSpec = pxr.SdfSpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }

    func test_SdfAttributeSpec_to_SdfPropertySpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfAttributeSpec = pxr.SdfAttributeSpec(layer.GetObjectAtPath("/myPrim.myAttribute").pointee)!
            let castedShouldSucceed: pxr.SdfPropertySpec = pxr.SdfPropertySpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }
    
    func test_SdfRelationshipSpec_to_SdfSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfRelationshipSpec = pxr.SdfRelationshipSpec(layer.GetObjectAtPath("/myPrim.myRelationship").pointee)!
            let castedShouldSucceed: pxr.SdfSpec = pxr.SdfSpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }

    func test_SdfRelationshipSpec_to_SdfPropertySpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfRelationshipSpec = pxr.SdfRelationshipSpec(layer.GetObjectAtPath("/myPrim.myRelationship").pointee)!
            let castedShouldSucceed: pxr.SdfPropertySpec = pxr.SdfPropertySpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }
    
    func test_SdfPseudoRootSpec_to_SdfSpec() {
        let stage = _stageForSpecCasting()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        withExtendedLifetime(layer) {
            let shouldSucceed: pxr.SdfPseudoRootSpec = pxr.SdfPseudoRootSpec(layer.GetPseudoRoot().pointee)!
            let castedShouldSucceed: pxr.SdfSpec = pxr.SdfSpec(shouldSucceed)
            withExtendedLifetime(castedShouldSucceed) {}
        }
    }
}

