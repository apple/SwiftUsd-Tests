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

final class Observation_MutateSdfLayer_ReadUsdAttribute: ObservationHelper {

    // MARK: SetField
    
    func test_SetField_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        attr.Set(5.0, 1.0)
                
        let (token, value) = registerNotification(attr.GetColorSpace())
        XCTAssertEqual(value, "")
                
        expectingSomeNotifications([token], layer.SetField("/foo.radius", "colorSpace", pxr.VtValue("fizzbuzz" as pxr.TfToken)))
        XCTAssertEqual(attr.GetColorSpace(), "fizzbuzz")
    }

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(sub1) {}
        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("xformOpOrder")
        let attrOver = sub2.OverridePrim("/foo").CreateAttribute("xformOpOrder", .TokenArray, false, Overlay.SdfVariabilityVarying)
        attrOver.Set(["foo"] as pxr.VtTokenArray, .Default())

        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        XCTAssertTrue(attr.HasValue())
    }
    
    // MARK: EraseField
    
    func test_EraseField_GetVariability() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Float, true, Overlay.SdfVariabilityVarying)
        attr.SetVariability(Overlay.SdfVariabilityUniform)

        
        let (token, value) = registerNotification(attr.GetVariability())
        XCTAssertEqual(value, Overlay.SdfVariabilityUniform)
        
        expectingSomeNotifications([token], layer.EraseField("/foo.myAttr", "variability"))
        XCTAssertEqual(attr.GetVariability(), Overlay.SdfVariabilityVarying)
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(sub1) {}
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("xformOpOrder")
        let attrOver = sub1.OverridePrim("/foo").CreateAttribute("xformOpOrder", .TokenArray, false, Overlay.SdfVariabilityVarying)
        attrOver.Set(["foo"] as pxr.VtTokenArray, .Default())

        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_HasColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        let attr = main.DefinePrim("/foo", "Plane").GetAttribute("doubleSided")
        let overAttr = sub2.OverridePrim("/foo").CreateAttribute("doubleSided", .Bool, false, Overlay.SdfVariabilityVarying)
        overAttr.SetColorSpace("foobar")

        
        let (token, value) = registerNotification(attr.HasColorSpace())
        XCTAssertFalse(value)
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertTrue(attr.HasColorSpace())
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda")))
        let attr = main.DefinePrim("/foo", "Plane").GetAttribute("doubleSided")
        let overAttr = sub2.OverridePrim("/foo").CreateAttribute("doubleSided", .Bool, false, Overlay.SdfVariabilityVarying)
        overAttr.SetColorSpace("foo")

        
        let (token, value) = registerNotification(attr.GetColorSpace())
        XCTAssertEqual(value, "foo")
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertEqual(attr.GetColorSpace(), "")
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model1.usda"), Overlay.UsdStage.LoadAll))
        let model2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model2.usda"), Overlay.UsdStage.LoadAll))
        
        let attr = main.DefinePrim("/foo", "Cube").GetAttribute("radius")
        let over1Attr = model1.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying)
        over1Attr.Set(5.0, 5.0)
        let over2Attr = model2.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying)
        over2Attr.Set(7.0, 7.0)
        
        layer.SetSubLayerPaths([pathForStage(named: "Model2.usda"), pathForStage(named: "Model1.usda")])
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 6.0))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 7.0)
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model1.usda"), pathForStage(named: "Model2.usda")]))
        XCTAssertTrue(attr.Get(&radius, 6.0))
        XCTAssertEqual(radius, 5.0)
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_GetConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let overAttr = model.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying)
        overAttr.AddConnection("/foo.radius", Overlay.UsdListPositionBackOfPrependList)

        
        var connections = pxr.SdfPathVector()
        let (token, value) = registerNotification(attr.GetConnections(&connections))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertTrue(attr.GetConnections(&connections))
        XCTAssertEqual(connections, ["/foo.radius"])
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_GetVariability() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        let attr = main.DefinePrim("/foo", "Plane").CreateAttribute("fizzy", .Bool, true, Overlay.SdfVariabilityVarying)
        model.OverridePrim("/foo").CreateAttribute("fizzy", .Bool, true, Overlay.SdfVariabilityUniform)
        
        
        let (token, value) = registerNotification(attr.GetVariability())
        XCTAssertEqual(value, Overlay.SdfVariabilityUniform)
        
        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertEqual(attr.GetVariability(), Overlay.SdfVariabilityVarying)
    }
    
    // MARK: SetSubLayerOffset
    
    func test_SetSubLayerOffset_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        let overAttr = model.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying)
        overAttr.Set(5.0, 2.0)
        overAttr.Set(9.0, 4.0)
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 3.0))
        XCTAssertTrue(value)
        XCTAssertEqual(7, radius)

        expectingSomeNotifications([token], layer.SetSubLayerOffset(pxr.SdfLayerOffset(2, 3), 0))
        XCTAssertTrue(attr.Get(&radius, 2.0))
        XCTAssertEqual(5, radius)
    }
    
    // MARK: SetTimeSample
    
    func test_SetTimeSample_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        let attr = light.GetTextureFileAttr()
        attr.Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        var assetPath = pxr.SdfAssetPath()
        let (token, value) = registerNotification(attr.Get(&assetPath, 2.0))
        XCTAssertTrue(value)
        XCTAssertEqual(assetPath, pxr.SdfAssetPath("buzz"))
        
        expectingSomeNotifications([token], layer.SetTimeSample("/foo.inputs:texture:file", 2.0, pxr.SdfAssetPath("/fizz")))
        XCTAssertTrue(attr.Get(&assetPath, 2.0))
        XCTAssertEqual(assetPath, pxr.SdfAssetPath("/fizz"))
    }
    
    // MARK: EraseTimeSample
    
    func test_EraseTimeSample_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        let attr = light.GetTextureFileAttr()
        attr.Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseTimeSample("/foo.inputs:texture:file", 1.0))
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        let other = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Other.usda"), Overlay.UsdStage.LoadAll))
        let otherAttr = other.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        otherAttr.Set(6.0, 2)
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 2))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 1)
        
        expectingSomeNotifications([token], layer.TransferContent(other.GetRootLayer()))
        XCTAssertTrue(attr.Get(&radius, 2))
        XCTAssertEqual(radius, 6)
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 2))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 1)
        
        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        
        def Sphere "foo"
        {
            double radius.timeSamples = {
                2: 6,
            }
        }
        
        
        """#)))
        
        XCTAssertTrue(attr.Get(&radius, 2))
        XCTAssertEqual(radius, 6)
    }
    
    // MARK: Clear
    
    func test_Clear_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        let overAttr = sub.OverridePrim("/foo").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        overAttr.Set(5.0, 2.0)
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Clear())
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: Reload
    
    func test_Reload_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        let overAttr = sub.OverridePrim("/foo").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        overAttr.Set(5.0, 2.0)
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Reload(true))
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: Import
    
    func test_Import_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()

        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        let overAttr = sub.OverridePrim("/foo").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        overAttr.Set(5.0, 2.0)
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        let overAttr = sub.OverridePrim("/foo").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        overAttr.Set(5.0, 2.0)
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([sub.GetRootLayer()], true))
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        let overAttr = sub.OverridePrim("/foo").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        overAttr.Set(5.0, 2.0)
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.SetIdentifier(pathForStage(named: "NewSub.usda")))
        XCTAssertFalse(attr.HasValue())
    }
}
