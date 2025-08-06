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

final class Observation_MutateUsdStage_ReadUsdAttribute: ObservationHelper {

    // MARK: MuteLayer
    
    func test_MuteLayer_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let sphere = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        let radiusAttr = sphere.GetRadiusAttr()
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            radiusAttr.Set(3.1415 as Double, pxr.UsdTimeCode.Default())
        }
        
        var radiusValue = 0.0
        let (token, value) = registerNotification(radiusAttr.Get(&radiusValue, pxr.UsdTimeCode.Default()))
        XCTAssertTrue(value)
        XCTAssertEqual(radiusValue, 3.1415)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(radiusAttr.Get(&radiusValue, pxr.UsdTimeCode.Default()))
        XCTAssertEqual(radiusValue, 1)
    }

    // MARK: UnmuteLayer
    
    func test_UnmuteLayer_GetTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let sphere = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        let radiusAttr = sphere.GetRadiusAttr()
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            radiusAttr.Set(3.1415 as Double, 2.718)
        }
        
        main.MuteLayer(pathForStage(named: "Model.usda"))
        var timeSamples = Overlay.Double_Vector()
        let (token, value) = registerNotification(radiusAttr.GetTimeSamples(&timeSamples))
        XCTAssertTrue(value)
        #warning("assert commented out to avoid compiler crash")
        //XCTAssertEqual(Array(timeSamples), [])

        
        expectingSomeNotifications([token], main.UnmuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(radiusAttr.GetTimeSamples(&timeSamples))
        #warning("assert commented out to avoid compiler crash")
        //XCTAssertEqual(Array(timeSamples), [2.718])
    }
    
    // MARK: MuteAndUnmuteLayers
    
    func test_MuteAndUnmuteLayers_HasAuthoredValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let sphere = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        let radiusAttr = sphere.GetRadiusAttr()
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            radiusAttr.Set(3.1415 as Double, 2.718)
        }
        
        let (token, value) = registerNotification(radiusAttr.HasAuthoredValue())
        XCTAssertTrue(value)

        
        expectingSomeNotifications([token], main.MuteAndUnmuteLayers([pathForStage(named: "Model.usda")], []))
        XCTAssertFalse(radiusAttr.HasAuthoredValue())
    }
    
    // MARK: SetMetadata
    
    func test_SetMetadata_HasAuthoredValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).Set(2.0, 5.0)
                        
        let attr = spherePrim.GetAttribute("radius")
        let (token, value) = registerNotification(attr.HasAuthoredValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.SetMetadata("subLayers", pxr.VtValue([] as Overlay.String_Vector)))
        XCTAssertFalse(attr.HasAuthoredValue())
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasAuthoredValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).Set(2.0, 5.0)
                        
        let attr = spherePrim.GetAttribute("radius")
        let (token, value) = registerNotification(attr.HasAuthoredValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadata("subLayers"))
        XCTAssertFalse(attr.HasAuthoredValue())
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("noAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        let radiusAttr = spherePrim.GetAttribute("radius")
        let customAttr = spherePrim.CreateAttribute("myAttr", .Asset, true, Overlay.SdfVariabilityUniform)
        customAttr.Set(pxr.SdfAssetPath("`${EXPR_HAS_ATTR}`"), .Default())
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            radiusAttr.Set(9.0, .Default())
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        var radius = 0.0
        let (token1, value1) = registerNotification(radiusAttr.Get(&radius, .Default()))
        XCTAssertTrue(value1)
        XCTAssertEqual(1, radius)
        
        var assetPath = pxr.SdfAssetPath()
        let (token2, value2) = registerNotification(customAttr.Get(&assetPath, .Default()))
        XCTAssertTrue(value2)
        XCTAssertEqual(assetPath, pxr.SdfAssetPath(pxr.SdfAssetPathParams().Authored("`${EXPR_HAS_ATTR}`").Evaluated("noAttr")))
        
        expectingAllNotifications([token1, token2], main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string)))
        XCTAssertTrue(radiusAttr.Get(&radius, .Default()))
        XCTAssertEqual(9, radius)
        XCTAssertTrue(customAttr.Get(&assetPath, .Default()))
        XCTAssertEqual(assetPath, pxr.SdfAssetPath(pxr.SdfAssetPathParams().Authored("`${EXPR_HAS_ATTR}`").Evaluated("hasAttr")))
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        let radiusAttr = spherePrim.GetAttribute("radius")
        let customAttr = spherePrim.CreateAttribute("myAttr", .Asset, true, Overlay.SdfVariabilityUniform)
        customAttr.Set(pxr.SdfAssetPath("`${EXPR_HAS_ATTR}`"), .Default())
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            radiusAttr.Set(9.0, .Default())
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        var radius = 0.0
        let (token1, value1) = registerNotification(radiusAttr.Get(&radius, .Default()))
        XCTAssertTrue(value1)
        XCTAssertEqual(9, radius)
        
        var assetPath = pxr.SdfAssetPath()
        let (token2, value2) = registerNotification(customAttr.Get(&assetPath, .Default()))
        XCTAssertTrue(value2)
        XCTAssertEqual(assetPath, pxr.SdfAssetPath(pxr.SdfAssetPathParams().Authored("`${EXPR_HAS_ATTR}`").Evaluated("hasAttr")))
        
        expectingAllNotifications([token1, token2], main.ClearMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR"))
        XCTAssertTrue(radiusAttr.Get(&radius, .Default()))
        XCTAssertEqual(1, radius)
        XCTAssertTrue(customAttr.Get(&assetPath, .Default()))
        XCTAssertEqual(assetPath, pxr.SdfAssetPath("`${EXPR_HAS_ATTR}`"))
    }
    
    // MARK: SetInterpolationType
    
    func test_SetInterpolationType_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let attr = main.DefinePrim("/hi", "Sphere").GetAttribute("radius")
        attr.Set(0.0, 0.0)
        attr.Set(10.0, 10.0)
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 4))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 4)
                
        expectingSomeNotifications([token], main.SetInterpolationType(Overlay.UsdInterpolationTypeHeld))
        XCTAssertTrue(attr.Get(&radius, 4))
        XCTAssertEqual(radius, 0)
    }
    
    // MARK: Reload
    
    func test_Reload_GetVariability() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
                        
        let prim = main.DefinePrim("/smallModel", "Plane")
        let attr = prim.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        main.Save()
        attr.SetVariability(Overlay.SdfVariabilityUniform)
        
        let (token, value) = registerNotification(attr.GetVariability())
        XCTAssertEqual(value, Overlay.SdfVariabilityUniform)
        
        expectingSomeNotifications([token], main.Reload())
        XCTAssertEqual(attr.GetVariability(), Overlay.SdfVariabilityVarying)
    }
    
    // MARK: CreateClassPrim
    
    func test_CreateClassPrim_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let defPrim = main.DefinePrim("/foo", "Sphere")
        var inherits = defPrim.GetInherits()
        inherits.AddInherit("/_class_bar", Overlay.UsdListPositionBackOfPrependList)
        
        var radius = 0.0
        let (token, value) = registerNotification(defPrim.GetAttribute("radius").Get(&radius, 4.0))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 1)
        
        expectingSomeNotifications([token]) {
            main.CreateClassPrim("/_class_bar").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).Set(7.0, 4.0)
        }
        XCTAssertTrue(defPrim.GetAttribute("radius").Get(&radius, 4.0))
        XCTAssertEqual(radius, 7)
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_GetTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        main.SetEditTarget(modelEditTarget)
        attr.Set(4.0, 7)
        attr.Set(6.0, 9)
        
        
        var samples = Overlay.Double_Vector()
        let (token, value) = registerNotification(attr.GetTimeSamples(&samples))
        XCTAssertTrue(value)
        //XCTAssertEqual(Array(samples), [7, 9])
        
        expectingSomeNotifications([token], main.RemovePrim("/foo"))
        XCTAssertTrue(attr.GetTimeSamples(&samples))
        //XCTAssertEqual(Array(samples), [])
    }
}
