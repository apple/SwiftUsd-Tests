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

final class Observation_MutateUsdObject_ReadSdfLayer: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")

        let (token, value) = registerNotification(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetMetadata("colorSpace", pxr.VtValue("foo" as pxr.TfToken)))
        XCTAssertTrue(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    func test_SetMetadata_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")

        let (token, value) = registerNotification(layer.GetField("/foo.radius", "colorSpace"))
        XCTAssertTrue(value.IsEmpty())
        
        expectingSomeNotifications([token], attr.SetMetadata("colorSpace", pxr.VtValue("foo" as pxr.TfToken)))
        XCTAssertEqual(layer.GetField("/foo.radius", "colorSpace"), pxr.VtValue("foo" as pxr.TfToken))
    }
    
    func test_SetMetadata_GetColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetColorConfiguration())
        XCTAssertEqual(value, pxr.SdfAssetPath(""))
        
        expectingSomeNotifications([token], p.SetMetadata("colorConfiguration", pxr.VtValue(pxr.SdfAssetPath("fizzy"))))
        XCTAssertEqual(layer.GetColorConfiguration(), pxr.SdfAssetPath("fizzy"))
    }
    
    func test_SetMetadata_HasColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.HasColorManagementSystem())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("colorManagementSystem", pxr.VtValue("fizzy" as pxr.TfToken)))
        XCTAssertTrue(layer.HasColorManagementSystem())
    }
    
    func test_SetMetadata_GetComment() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetComment())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], p.SetMetadata("comment", pxr.VtValue("my doc" as std.string)))
        XCTAssertEqual(layer.GetComment(), "my doc")
    }
    
    func test_SetMetadata_HasDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.DefinePrim("/foo", "Sphere")
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.HasDefaultPrim())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("defaultPrim", pxr.VtValue("foo" as pxr.TfToken)))
        XCTAssertTrue(layer.HasDefaultPrim())
    }
    
    func test_SetMetadata_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetStartTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], p.SetMetadata("startTimeCode", pxr.VtValue(17.0)))
        XCTAssertEqual(layer.GetStartTimeCode(), 17)
    }
    
    func test_SetMetadata_HasEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.HasEndTimeCode())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("endTimeCode", pxr.VtValue(17.0)))
        XCTAssertTrue(layer.HasEndTimeCode())
    }
    
    func test_SetMetadata_HasTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.HasTimeCodesPerSecond())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("timeCodesPerSecond", pxr.VtValue(17.0)))
        XCTAssertTrue(layer.HasTimeCodesPerSecond())
    }
    
    func test_SetMetadata_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetFramesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], p.SetMetadata("framesPerSecond", pxr.VtValue(17.0)))
        XCTAssertEqual(layer.GetFramesPerSecond(), 17)
    }
    
    func test_SetMetadata_HasFramePrecision() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.HasFramePrecision())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("framePrecision", pxr.VtValue(17.0)))
        XCTAssertTrue(layer.HasFramePrecision())
    }
    
    func test_SetMetadata_GetOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetOwner())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], p.SetMetadata("owner", pxr.VtValue("fizz" as std.string)))
        XCTAssertEqual(layer.GetOwner(), "fizz")
    }
    
    func test_SetMetadata_GetSessionOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetSessionOwner())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], p.SetMetadata("sessionOwner", pxr.VtValue("fizz" as std.string)))
        XCTAssertEqual(layer.GetSessionOwner(), "fizz")
    }
    
    func test_SetMetadata_GetCustomLayerData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetCustomLayerData())
        XCTAssertEqual(value, [:])
        
        expectingSomeNotifications([token], p.SetMetadata("customLayerData", pxr.VtValue(["fizz" : pxr.VtValue(17.0)] as pxr.VtDictionary)))
        XCTAssertEqual(layer.GetCustomLayerData(), ["fizz" : pxr.VtValue(17.0)])
    }
    
    func test_SetMetadata_GetExpressionVariables() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetExpressionVariables())
        XCTAssertEqual(value, [:])
        
        expectingSomeNotifications([token], p.SetMetadata("expressionVariables", pxr.VtValue(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)] as pxr.VtDictionary)))
        XCTAssertEqual(layer.GetExpressionVariables(), ["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
    }
    
    func test_SetMetadata_HasExpressionVariables() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.HasExpressionVariables())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("expressionVariables", pxr.VtValue(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)] as pxr.VtDictionary)))
        XCTAssertTrue(layer.HasExpressionVariables())
    }
    
    func test_SetMetadata_GetNumSubLayerPaths() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(layer.GetNumSubLayerPaths())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], p.SetMetadata("subLayers", pxr.VtValue([pathForStage(named: "Model.usda")] as Overlay.String_Vector)))
        XCTAssertEqual(layer.GetNumSubLayerPaths(), 1)
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        attr.SetMetadata("colorSpace", pxr.VtValue("foo" as pxr.TfToken))

        let (token, value) = registerNotification(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearMetadata("colorSpace"))
        XCTAssertFalse(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    func test_ClearMetadata_HasColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetColorConfiguration(pxr.SdfAssetPath("/myConfig"))

        let (token, value) = registerNotification(layer.HasColorConfiguration())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("colorConfiguration"))
        XCTAssertFalse(layer.HasColorConfiguration())
    }
    
    func test_ClearMetadata_GetColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetColorManagementSystem("bar")

        let (token, value) = registerNotification(layer.GetColorManagementSystem())
        XCTAssertEqual(value, "bar")
        
        expectingSomeNotifications([token], p.ClearMetadata("colorManagementSystem"))
        XCTAssertEqual(layer.GetColorManagementSystem(), "")
    }
    
    func test_ClearMetadata_GetDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.DefinePrim("/foo", "Sphere")
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetDefaultPrim("foo")

        let (token, value) = registerNotification(layer.GetDefaultPrim())
        XCTAssertEqual(value, "foo")
        
        expectingSomeNotifications([token], p.ClearMetadata("defaultPrim"))
        XCTAssertEqual(layer.GetDefaultPrim(), "")
    }
    
    func test_ClearMetadata_GetDocumentation() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetDocumentation("foo")

        let (token, value) = registerNotification(layer.GetDocumentation())
        XCTAssertEqual(value, "foo")
        
        expectingSomeNotifications([token], p.ClearMetadata("documentation"))
        XCTAssertEqual(layer.GetDocumentation(), "")
    }
    
    func test_ClearMetadata_HasStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetStartTimeCode(6)

        let (token, value) = registerNotification(layer.HasStartTimeCode())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("startTimeCode"))
        XCTAssertFalse(layer.HasStartTimeCode())
    }
    
    func test_ClearMetadata_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetEndTimeCode(6)

        let (token, value) = registerNotification(layer.GetEndTimeCode())
        XCTAssertEqual(value, 6)
        
        expectingSomeNotifications([token], p.ClearMetadata("endTimeCode"))
        XCTAssertEqual(layer.GetEndTimeCode(), 0)
    }
    
    func test_ClearMetadata_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetTimeCodesPerSecond(6)

        let (token, value) = registerNotification(layer.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 6)
        
        expectingSomeNotifications([token], p.ClearMetadata("timeCodesPerSecond"))
        XCTAssertEqual(layer.GetTimeCodesPerSecond(), 24)
    }
    
    func test_ClearMetadata_HasFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetFramesPerSecond(6)

        let (token, value) = registerNotification(layer.HasFramesPerSecond())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("framesPerSecond"))
        XCTAssertFalse(layer.HasFramesPerSecond())
    }
    
    func test_ClearMetadata_GetFramePrecision() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetFramePrecision(6)

        let (token, value) = registerNotification(layer.GetFramePrecision())
        XCTAssertEqual(value, 6)
        
        expectingSomeNotifications([token], p.ClearMetadata("framePrecision"))
        XCTAssertEqual(layer.GetFramePrecision(), 3)
    }
    
    func test_ClearMetadata_HasOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetOwner("foo")

        let (token, value) = registerNotification(layer.HasOwner())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("owner"))
        XCTAssertFalse(layer.HasOwner())
    }
    
    func test_ClearMetadata_HasSessionOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetSessionOwner("foo")

        let (token, value) = registerNotification(layer.HasSessionOwner())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("sessionOwner"))
        XCTAssertFalse(layer.HasSessionOwner())
    }
    
    func test_ClearMetadata_GetHasOwnedSubLayers() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetHasOwnedSubLayers(true)

        let (token, value) = registerNotification(layer.GetHasOwnedSubLayers())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("hasOwnedSubLayers"))
        XCTAssertFalse(layer.GetHasOwnedSubLayers())
    }
    
    func test_ClearMetadata_HasCustomLayerData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetCustomLayerData(["foo" : pxr.VtValue("bar" as std.string)])

        let (token, value) = registerNotification(layer.HasCustomLayerData())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("customLayerData"))
        XCTAssertFalse(layer.HasCustomLayerData())
    }
    
    func test_ClearMetadata_GetSubLayerPaths() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.InsertSubLayerPath("/foo.usda", 0)

        let (token, value) = registerNotification(layer.GetSubLayerPaths())
        XCTAssertEqual(Array(value), ["/foo.usda"])
        
        expectingSomeNotifications([token], p.ClearMetadata("subLayers"))
        XCTAssertEqual(Array(layer.GetSubLayerPaths()), [])
    }
    
    func test_ClearMetadata_GetSubLayerOffsets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.InsertSubLayerPath("/foo.usda", 0)

        let (token, value) = registerNotification(layer.GetSubLayerOffsets())
        XCTAssertEqual(Array(value), [pxr.SdfLayerOffset(0, 1)])
        
        expectingSomeNotifications([token], p.ClearMetadata("subLayerOffsets"))
        XCTAssertEqual(Array(layer.GetSubLayerOffsets()), [])
    }
    
    func test_ClearMetadata_GetSubLayerOffset() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.InsertSubLayerPath("/foo.usda", 0)
        layer.SetSubLayerOffset(pxr.SdfLayerOffset(0, 2), 0)

        let (token, value) = registerNotification(layer.GetSubLayerOffset(0))
        XCTAssertEqual(value, pxr.SdfLayerOffset(0, 2))
        
        expectingSomeNotifications([token], p.ClearMetadata("subLayerOffsets"))
        XCTAssertEqual(layer.GetSubLayerOffset(0), pxr.SdfLayerOffset(0, 1))
    }

    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_HasFieldDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(layer.HasFieldDictKey("/foo", "assetInfo", "name", &vtValue))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertTrue(layer.HasFieldDictKey("/foo", "assetInfo", "name", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("fizzy" as std.string))
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_HasFieldDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string))
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(layer.HasFieldDictKey("/foo", "assetInfo", "name", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("fizzy" as std.string))
        
        expectingSomeNotifications([token], p.ClearMetadataByDictKey("assetInfo", "name"))
        XCTAssertFalse(layer.HasFieldDictKey("/foo", "assetInfo", "name", &vtValue))
    }
    
    // MARK: SetHidden
    
    func test_SetHidden_ListFields() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.ListFields("/foo"))
        XCTAssertEqual(value, ["specifier", "typeName"])
        
        expectingSomeNotifications([token], p.SetHidden(true))
        XCTAssertEqual(layer.ListFields("/foo"), ["specifier", "typeName", "hidden"])
    }
    
    // MARK: ClearHidden
    
    func test_ClearHidden_ListFields() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetHidden(true)
        
        let (token, value) = registerNotification(layer.ListFields("/foo"))
        XCTAssertEqual(value, ["specifier", "typeName", "hidden"])
        
        expectingSomeNotifications([token], p.ClearHidden())
        XCTAssertEqual(layer.ListFields("/foo"), ["specifier", "typeName"])
    }
    
    // MARK: SetCustomData
    
    func test_SetCustomData_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasField("/foo", "customData", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)]))
        XCTAssertTrue(layer.HasField("/foo", "customData", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetCustomDataByKey
    
    func test_SetCustomDataByKey_HasFieldDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasFieldDictKey("/foo", "customData", "fizz", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetCustomDataByKey("fizz", pxr.VtValue("buzz" as pxr.TfToken)))
        XCTAssertTrue(layer.HasFieldDictKey("/foo", "customData", "fizz", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearCustomData
    
    func test_ClearCustomData_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        let (token, value) = registerNotification(layer.HasField("/foo", "customData", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearCustomData())
        XCTAssertFalse(layer.HasField("/foo", "customData", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearCustomDataByKey
    
    func test_ClearCustomDataByKey_HasFieldDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomDataByKey("fizz", pxr.VtValue("buzz" as pxr.TfToken))
        
        let (token, value) = registerNotification(layer.HasFieldDictKey("/foo", "customData", "fizz", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearCustomDataByKey("fizz"))
        XCTAssertFalse(layer.HasFieldDictKey("/foo", "customData", "fizz", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetAssetInfo
    
    func test_SetAssetInfo_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasField("/foo", "assetInfo", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)]))
        XCTAssertTrue(layer.HasField("/foo", "assetInfo", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetAssetInfoByKey
    
    func test_SetAssetInfoByKey_HasFieldDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasFieldDictKey("/foo", "assetInfo", "name", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetAssetInfoByKey("name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertTrue(layer.HasFieldDictKey("/foo", "assetInfo", "name", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearAssetInfo
    
    func test_ClearAssetInfo_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)])
        
        let (token, value) = registerNotification(layer.HasField("/foo", "assetInfo", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearAssetInfo())
        XCTAssertFalse(layer.HasField("/foo", "assetInfo", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearAssetInfoByKey
    
    func test_ClearAssetInfoByKey_HasFieldDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)])
        
        let (token, value) = registerNotification(layer.HasFieldDictKey("/foo", "assetInfo", "name", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearAssetInfoByKey("name"))
        XCTAssertFalse(layer.HasFieldDictKey("/foo", "assetInfo", "name", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetDocumentation
    
    func test_SetDocumentation_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasField("/foo", "documentation", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetDocumentation("my documentation string"))
        XCTAssertTrue(layer.HasField("/foo", "documentation", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearDocumentation
    
    func test_ClearDocumentation_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDocumentation("my documentation string")
        
        let (token, value) = registerNotification(layer.HasField("/foo", "documentation", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearDocumentation())
        XCTAssertFalse(layer.HasField("/foo", "documentation", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetDisplayName
    
    func test_SetDisplayName_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasField("/foo", "displayName", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetDisplayName("bar"))
        XCTAssertTrue(layer.HasField("/foo", "displayName", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearDisplayName
    
    func test_ClearDisplayName_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDisplayName("bar")
        
        let (token, value) = registerNotification(layer.HasField("/foo", "displayName", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearDisplayName())
        XCTAssertFalse(layer.HasField("/foo", "displayName", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
}
