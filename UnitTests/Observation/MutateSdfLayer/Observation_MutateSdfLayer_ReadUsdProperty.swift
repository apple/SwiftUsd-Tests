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

final class Observation_MutateSdfLayer_ReadUsdProperty: ObservationHelper {

    // MARK: SetField
    
    func test_SetField_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        attr.Set(5.0, 1.0)
                
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "")
                
        expectingSomeNotifications([token], layer.SetField("/foo.radius", "displayGroup", pxr.VtValue("fizzbuzz" as std.string)))
        XCTAssertEqual(attr.GetDisplayGroup(), "fizzbuzz")
    }

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(sub1) {}
        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        sub2.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).SetDisplayGroup("fizzbuzz")

        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: EraseField
    
    func test_EraseField_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("fizzbuzz")

        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "fizzbuzz")
        
        expectingSomeNotifications([token], layer.EraseField("/foo.radius", "displayGroup"))
        XCTAssertEqual(attr.GetDisplayGroup(), "")
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        sub1.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).SetDisplayGroup("fizzbuzz")

        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_GetNestedDisplayGroups() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        let attr = main.DefinePrim("/foo", "Plane").GetAttribute("doubleSided")
        let overAttr = sub2.OverridePrim("/foo").CreateAttribute("doubleSided", .Bool, false, Overlay.SdfVariabilityVarying)
        overAttr.SetNestedDisplayGroups(["alpha", "beta"])

        
        let (token, value) = registerNotification(attr.GetNestedDisplayGroups())
        XCTAssertEqual(value, [])
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertEqual(attr.GetNestedDisplayGroups(), ["alpha", "beta"])
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda")))
        let attr = main.DefinePrim("/foo", "Plane").GetAttribute("doubleSided")
        let overAttr = sub2.OverridePrim("/foo").CreateAttribute("doubleSided", .Bool, false, Overlay.SdfVariabilityVarying)
        overAttr.SetDisplayGroup("foo")

        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Cube").GetAttribute("radius")
        let overAttr = model.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying)
        overAttr.SetDisplayGroup("fizz")
        
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        XCTAssertEqual(attr.GetDisplayGroup(), "fizz")
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        model.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).SetDisplayGroup("foo")

        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        let attr = main.DefinePrim("/foo", "Plane").GetAttribute("doubleSided")
        let overAttr = model.OverridePrim("/foo").CreateAttribute("doubleSided", .Bool, false, Overlay.SdfVariabilityVarying)
        overAttr.SetDisplayGroup("fizz")
        
        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: SetSubLayerOffset
    
    func test_SetSubLayerOffset_GetPropertyStackWithLayerOffsets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let modelLayer = Overlay.Dereference(model.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(1.0, 2)
        model.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).Set(5.0, 2.0)

        var (token, value) = registerNotification(attr.GetPropertyStackWithLayerOffsets(2))
        XCTAssertEqual(value.size(), 2)
        XCTAssertEqual(value[0].first, layer.GetPropertyAtPath("/foo.radius"))
        XCTAssertEqual(value[0].second, pxr.SdfLayerOffset(0, 1))
        XCTAssertEqual(value[1].first, modelLayer.GetPropertyAtPath("/foo.radius"))
        XCTAssertEqual(value[1].second, pxr.SdfLayerOffset(0, 1))

        
        expectingSomeNotifications([token], layer.SetSubLayerOffset(pxr.SdfLayerOffset(2, 3), 0))
        value = attr.GetPropertyStackWithLayerOffsets(2)
        XCTAssertEqual(value.size(), 2)
        XCTAssertEqual(value[0].first, layer.GetPropertyAtPath("/foo.radius"))
        XCTAssertEqual(value[0].second, pxr.SdfLayerOffset(0, 1))
        XCTAssertEqual(value[1].first, modelLayer.GetPropertyAtPath("/foo.radius"))
        XCTAssertEqual(value[1].second, pxr.SdfLayerOffset(2, 3))
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let other = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Other.usda"), Overlay.UsdStage.LoadAll))
        
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.TransferContent(other.GetRootLayer()))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: SetRootPrims
    
    func test_SetRootPrim_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let attr = foo.GetAttribute("radius")
        main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetRootPrims([layer.GetPrimAtPath("/bar")]))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: InsertRootPrim
    
    func test_InsertRootPrim_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        let attr = bar.GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
                
        expectingSomeNotifications([token], layer.InsertRootPrim(layer.GetPrimAtPath("/foo/bar"), 0))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: RemoveRootPrim
    
    func test_RemoveRootPrim_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let attr = foo.GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemoveRootPrim(layer.GetPrimAtPath("/foo")))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: RemovePropertyIfHasOnlyRequiredFields
    
    func test_RemovePropertyIfHasOnlyRequiredFields_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemovePropertyIfHasOnlyRequiredFields(layer.GetPropertyAtPath("/foo.myAttr")))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0
        

        """#)))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: Clear
    
    func test_Clear_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Clear())
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: Reload
    
    func test_Reload_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Reload(true))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: Import
    
    func test_Import_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()

        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))

        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([main.GetRootLayer()], true))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let overStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "OverStage.usda"), Overlay.UsdStage.LoadAll))
        let overLayer = Overlay.Dereference(overStage.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "OverStage.usda"), 0)
        
        main.DefinePrim("/foo", "Sphere")
        overStage.OverridePrim("/foo").CreateRelationship("myRel", true)
        let rel = main.GetRelationshipAtPath("/foo.myRel")
        
        
        let (token, value) = registerNotification(rel.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], overLayer.SetIdentifier(pathForStage(named: "NewOverStage.usda")))
        XCTAssertFalse(rel.IsDefined())
    }
}
