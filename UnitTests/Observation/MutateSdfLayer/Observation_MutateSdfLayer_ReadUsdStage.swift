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

final class Observation_MutateSdfLayer_ReadUsdStage: ObservationHelper {

    // MARK: SetField
    
    func test_SetField_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.GetStartTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], layer.SetField("/", "startTimeCode", pxr.VtValue(17.0 as Double)))
        XCTAssertEqual(main.GetStartTimeCode(), 17)
    }
    
    func test_SetField_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
                
        let (token, value) = registerNotification(main.Traverse())
        XCTAssertEqual(Array(value), [p])
        
        expectingSomeNotifications([token], layer.SetField("/foo", "active", pxr.VtValue(false)))
        XCTAssertEqual(Array(main.Traverse()), [])
    }

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_GetLayerStack() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))

        
        let (token, value) = registerNotification(main.GetLayerStack(false))
        XCTAssertEqual(Array(value), [main.GetRootLayer(), sub1.GetRootLayer()])
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        XCTAssertEqual(Array(main.GetLayerStack(false)), [main.GetRootLayer(), sub2.GetRootLayer()])
    }
    
    // MARK: EraseField
    
    func test_EraseField_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(7)
        
        let (token, value) = registerNotification(main.HasAuthoredMetadata("startTimeCode"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseField("/", "startTimeCode"))
        XCTAssertFalse(main.HasAuthoredMetadata("startTimeCode"))
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_GetLayerStack() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))

        
        let (token, value) = registerNotification(main.GetLayerStack(false))
        XCTAssertEqual(Array(value), [main.GetRootLayer(), sub1.GetRootLayer()])
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertEqual(Array(main.GetLayerStack(false)), [main.GetRootLayer()])
    }
    
    // MARK: SetColorConfiguration
    
    func test_SetColorConfiguration_GetColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(main.GetColorConfiguration())
        XCTAssertEqual(value, pxr.SdfAssetPath(""))
        
        expectingSomeNotifications([token], layer.SetColorConfiguration(pxr.SdfAssetPath("fizz")))
        XCTAssertEqual(main.GetColorConfiguration(), pxr.SdfAssetPath("fizz"))
    }
    
    // MARK: ClearColorConfiguration
    
    func test_ClearColorConfiguration_GetColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetColorConfiguration(pxr.SdfAssetPath("fizz"))

        let (token, value) = registerNotification(main.GetColorConfiguration())
        XCTAssertEqual(value, pxr.SdfAssetPath("fizz"))
        
        expectingSomeNotifications([token], layer.ClearColorConfiguration())
        XCTAssertEqual(main.GetColorConfiguration(), pxr.SdfAssetPath(""))
    }
    
    // MARK: SetColorManagementSystem
    
    func test_SetColorManagementSystem_GetColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(main.GetColorManagementSystem())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], layer.SetColorManagementSystem("fizz"))
        XCTAssertEqual(main.GetColorManagementSystem(), "fizz")
    }
    
    // MARK: ClearColorManagementSystem
    
    func test_ClearColorManagementSystem_GetColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetColorManagementSystem("buzz")

        let (token, value) = registerNotification(main.GetColorManagementSystem())
        XCTAssertEqual(value, "buzz")
        
        expectingSomeNotifications([token], layer.ClearColorManagementSystem())
        XCTAssertEqual(main.GetColorManagementSystem(), "")
    }
    
    // MARK: SetComment
    
    func test_SetComment_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value!, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )


        """#)
        
        expectingSomeNotifications([token], layer.SetComment("my comment"))
        XCTAssertEqual(main.ExportToString()!, #"""
        #usda 1.0
        (
            "my comment"
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )


        """#)
    }
    
    // MARK: SetDefaultPrim
    
    func test_SetDefaultPrim_GetDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Cube")
        

        let (token, value) = registerNotification(main.GetDefaultPrim())
        XCTAssertFalse(Bool(value))
        
        expectingSomeNotifications([token], layer.SetDefaultPrim("foo"))
        XCTAssertEqual(main.GetDefaultPrim(), main.GetPrimAtPath("/foo"))
    }
        
    func test_SetDefaultPrim_HasDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Cube")
        

        let (token, value) = registerNotification(main.HasDefaultPrim())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetDefaultPrim("foo"))
        XCTAssertTrue(main.HasDefaultPrim())
    }
    
    // MARK: ClearDefaultPrim
    
    func test_ClearDefaultPrim_GetDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Cube")
        main.SetDefaultPrim(main.GetPrimAtPath("foo"))

        let (token, value) = registerNotification(main.GetDefaultPrim())
        XCTAssertEqual(value, main.GetPrimAtPath("foo"))
        
        expectingSomeNotifications([token], layer.ClearDefaultPrim())
        XCTAssertFalse(Bool(main.GetDefaultPrim()))
    }
    
    func test_ClearDefaultPrim_HasDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Cube")
        main.SetDefaultPrim(main.GetPrimAtPath("/foo"))

        let (token, value) = registerNotification(main.HasDefaultPrim())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearDefaultPrim())
        XCTAssertFalse(main.HasDefaultPrim())
    }
    
    // MARK: SetDocumentation
    
    func test_SetDocumentation_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var metadataOut = pxr.VtValue()
        let (token, value) = registerNotification(main.GetMetadata("documentation", &metadataOut))
        XCTAssertTrue(value)
        XCTAssertEqual(metadataOut.Get() as std.string, "")
        
        expectingSomeNotifications([token], layer.SetDocumentation("fizzbuzz"))
        XCTAssertTrue(main.GetMetadata("documentation", &metadataOut))
        XCTAssertEqual(metadataOut.Get() as std.string, "fizzbuzz")
    }
    
    // MARK: SetStartTimeCode
    
    func test_SetStartTimeCode_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.GetStartTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], layer.SetStartTimeCode(2.718))
        XCTAssertEqual(main.GetStartTimeCode(), 2.718)
    }
        
    func test_SetStartTimeCode_HasAuthoredTimeCodeRange() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetEndTimeCode(7)
        
        let (token, value) = registerNotification(main.HasAuthoredTimeCodeRange())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetStartTimeCode(2.718))
        XCTAssertTrue(main.HasAuthoredTimeCodeRange())
    }
    
    // MARK: ClearStartTimeCode
    
    func test_ClearStartTimeCode_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(4)
        
        let (token, value) = registerNotification(main.GetStartTimeCode())
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], layer.ClearStartTimeCode())
        XCTAssertEqual(main.GetStartTimeCode(), 0)
    }
    
    func test_ClearStartTimeCode_HasAuthoredTimeCodeRange() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(4)
        main.SetEndTimeCode(200)
        
        let (token, value) = registerNotification(main.HasAuthoredTimeCodeRange())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearStartTimeCode())
        XCTAssertFalse(main.HasAuthoredTimeCodeRange())
    }
    
    // MARK: SetEndTimeCode
    
    func test_SetEndTimeCode_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.GetEndTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], layer.SetEndTimeCode(2.718))
        XCTAssertEqual(main.GetEndTimeCode(), 2.718)
    }
    
    func test_SetEndTimeCode_HasAuthoredTimeCodeRange() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(-3.14)
        
        let (token, value) = registerNotification(main.HasAuthoredTimeCodeRange())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetEndTimeCode(2.718))
        XCTAssertTrue(main.HasAuthoredTimeCodeRange())
    }
    
    // MARK: ClearEndTimeCode
    
    func test_ClearEndTimeCode_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetEndTimeCode(4)
        
        let (token, value) = registerNotification(main.GetEndTimeCode())
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], layer.ClearEndTimeCode())
        XCTAssertEqual(main.GetEndTimeCode(), 0)
    }
    
    func test_ClearEndTimeCode_HasAuthoredTimeCodeRange() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(1)
        main.SetEndTimeCode(4)
        
        let (token, value) = registerNotification(main.HasAuthoredTimeCodeRange())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearEndTimeCode())
        XCTAssertFalse(main.HasAuthoredTimeCodeRange())
    }
    
    // MARK: SetTimeCodesPerSecond
    
    func test_SetTimeCodesPerSecond_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], layer.SetTimeCodesPerSecond(19))
        XCTAssertEqual(main.GetTimeCodesPerSecond(), 19)
    }
    
    // MARK: ClearTimeCodesPerSecond
    
    func test_ClearTimeCodesPerSecond_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetTimeCodesPerSecond(4)
        
        let (token, value) = registerNotification(main.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], layer.ClearTimeCodesPerSecond())
        XCTAssertEqual(main.GetTimeCodesPerSecond(), 24)
    }
    
    // MARK: SetFramesPerSecond
    
    func test_SetFramesPerSecond_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.GetFramesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], layer.SetFramesPerSecond(19))
        XCTAssertEqual(main.GetFramesPerSecond(), 19)
    }
    
    // MARK: ClearFramesPerSecond
    
    func test_ClearFramesPerSecond_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetFramesPerSecond(5)
        
        let (token, value) = registerNotification(main.GetFramesPerSecond())
        XCTAssertEqual(value, 5)
        
        expectingSomeNotifications([token], layer.ClearFramesPerSecond())
        XCTAssertEqual(main.GetFramesPerSecond(), 24)
    }
    
    // MARK: SetFramePrecision
    
    func test_SetFramePrecision_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var metadataOut = pxr.VtValue()
        let (token, value) = registerNotification(main.GetMetadata("framePrecision", &metadataOut))
        XCTAssertTrue(value)
        XCTAssertEqual(metadataOut.Get() as Int32, 3)
        
        expectingSomeNotifications([token], layer.SetFramePrecision(27))
        XCTAssertTrue(main.GetMetadata("framePrecision", &metadataOut))
        XCTAssertEqual(metadataOut.Get() as Int32, 27)
    }
    
    // MARK: ClearFramePrecision
    
    func test_ClearFramePrecision_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetFramePrecision(16)
        
        var metadataOut = pxr.VtValue()
        let (token, value) = registerNotification(main.GetMetadata("framePrecision", &metadataOut))
        XCTAssertTrue(value)
        XCTAssertEqual(metadataOut.Get() as Int32, 16)
        
        expectingSomeNotifications([token], layer.ClearFramePrecision())
        XCTAssertTrue(main.GetMetadata("framePrecision", &metadataOut))
        XCTAssertEqual(metadataOut.Get() as Int32, 3)
    }
    
    // MARK: SetOwner
    
    func test_SetOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.HasAuthoredMetadata("owner"))
        XCTAssertFalse(value)

        expectingSomeNotifications([token], layer.SetOwner("foo"))
        XCTAssertTrue(main.HasAuthoredMetadata("owner"))
    }
    
    // MARK: ClearOwner
    
    func test_ClearOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetOwner("foo")
        
        let (token, value) = registerNotification(main.HasAuthoredMetadata("owner"))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ClearOwner())
        XCTAssertFalse(main.HasAuthoredMetadata("owner"))
    }
    
    // MARK: SetSessionOwner
    
    func test_SetSessionOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.HasAuthoredMetadata("sessionOwner"))
        XCTAssertFalse(value)

        expectingSomeNotifications([token], layer.SetSessionOwner("foo"))
        XCTAssertTrue(main.HasAuthoredMetadata("sessionOwner"))
    }
    
    // MARK: ClearSessionOwner
    
    func test_ClearSessionOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetSessionOwner("foo")
        
        let (token, value) = registerNotification(main.HasAuthoredMetadata("sessionOwner"))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ClearSessionOwner())
        XCTAssertFalse(main.HasAuthoredMetadata("sessionOwner"))
    }
    
    // MARK: SetHasOwnedSubLayers
    
    func test_SetHasOwnedSubLayers_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.HasAuthoredMetadata("hasOwnedSubLayers"))
        XCTAssertFalse(value)

        expectingSomeNotifications([token], layer.SetHasOwnedSubLayers(true))
        XCTAssertTrue(main.HasAuthoredMetadata("hasOwnedSubLayers"))
    }
    
    // MARK: SetCustomLayerData
    
    func test_SetCustomLayerData_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(main.GetMetadataByDictKey("customLayerData", "foo", &vtValue))
        XCTAssertFalse(value)

        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetCustomLayerData(dict))
        XCTAssertTrue(main.GetMetadataByDictKey("customLayerData", "foo", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("bar" as std.string))
    }
    
    func test_SetCustomLayerData_HasMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.HasMetadataDictKey("customLayerData", "foo"))
        XCTAssertFalse(value)

        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetCustomLayerData(dict))
        XCTAssertTrue(main.HasMetadataDictKey("customLayerData", "foo"))
    }
    
    // MARK: ClearCustomLayerData
    
    func test_ClearCustomLayerData_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetCustomLayerData(dict)

        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(main.GetMetadataByDictKey("customLayerData", "foo", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("bar" as std.string))

        expectingSomeNotifications([token], layer.ClearCustomLayerData())
        XCTAssertFalse(main.GetMetadataByDictKey("customLayerData", "foo", &vtValue))
    }
    
    func test_ClearCustomLayerData_HasMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetCustomLayerData(dict)

        
        let (token, value) = registerNotification(main.HasMetadataDictKey("customLayerData", "foo"))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ClearCustomLayerData())
        XCTAssertFalse(main.HasMetadataDictKey("customLayerData", "foo"))
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(main.GetMetadataByDictKey("expressionVariables", "foo", &vtValue))
        XCTAssertFalse(value)
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertTrue(main.GetMetadataByDictKey("expressionVariables", "foo", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("bar" as std.string))
    }
    
    func test_SetExpressionVariables_HasMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(main.HasMetadataDictKey("expressionVariables", "foo"))
        XCTAssertFalse(value)
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertTrue(main.HasMetadataDictKey("expressionVariables", "foo"))
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetExpressionVariables(dict)
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(main.GetMetadataByDictKey("expressionVariables", "foo", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("bar" as std.string))
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(main.GetMetadataByDictKey("expressionVariables", "foo", &vtValue))
    }
    
    func test_ClearExpressionVariables_HasMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetExpressionVariables(dict)

        
        let (token, value) = registerNotification(main.HasMetadataDictKey("expressionVariables", "foo"))
        XCTAssertTrue(value)
                
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(main.HasMetadataDictKey("expressionVariables", "foo"))
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_GetUsedLayers() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main5.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model5.usda"), Overlay.UsdStage.LoadAll))
        
        
        let (token, value) = registerNotification(main.GetUsedLayers(false))
        XCTAssertEqual(Array(value).sorted(), [main.GetRootLayer(), main.GetSessionLayer()].sorted())
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model5.usda")]))
        XCTAssertEqual(Array(main.GetUsedLayers(false)).sorted(), [main.GetRootLayer(), main.GetSessionLayer(), model.GetRootLayer()].sorted())
    }
    
    func test_SetSubLayerPaths_Traverse() throws {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        main.DefinePrim("/alpha", "Sphere")
        model.DefinePrim("/beta", "Sphere")
        model.OverridePrim("/alpha").SetActive(false)
        
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [main.GetPrimAtPath("/alpha")])
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        XCTAssertEqual(Array(main.Traverse()), [main.GetPrimAtPath("/beta")])
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_GetLayerStack() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))

        let (token, value) = registerNotification(main.GetLayerStack(true))
        XCTAssertEqual(Array(value), [main.GetSessionLayer(), main.GetRootLayer()])
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertEqual(Array(main.GetLayerStack(true)), [main.GetSessionLayer(), main.GetRootLayer(), model.GetRootLayer()])
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        model.DefinePrim("/beta", "Sphere")
        
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [main.GetPrimAtPath("/beta")])
        
        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertEqual(Array(main.Traverse()), [])
    }
    
    // MARK: SetSubLayerOffset
    
    func test_SetSubLayerOffset_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        model.DefinePrim("/foo", "Sphere").GetAttribute("radius").Set(6.0, 2.0)

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
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
        
        
        """#)
        
        expectingSomeNotifications([token], layer.SetSubLayerOffset(pxr.SdfLayerOffset(2, 3), 0))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double radius.timeSamples = {
                8: 6,
            }
        }
        
        
        """#)
    }
    
    // MARK: Apply
    
    func test_Apply_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        main.DefinePrim("/beta", "Sphere")
        
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [main.GetPrimAtPath("/beta")])
        
        var batchEdit = pxr.SdfBatchNamespaceEdit()
        batchEdit.Add(pxr.SdfNamespaceEdit.Rename("/beta", "alpha"))
        expectingSomeNotifications([token], layer.Apply(batchEdit))
        XCTAssertEqual(Array(main.Traverse()), [main.GetPrimAtPath("/alpha")])
        XCTAssertNotEqual(Array(main.Traverse()), value)
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_ExportToString() {
        /*
         Before TransferContent, we'll have top -> copyDest
         After TransferContent, we'll have top -> copySrc -> copyDest -> opinion, and have opinion be reachable
         
         top -> copySrc
            copyDest -> opinion, copyDest
                copySrc -> opinion, copyDest
                    opinion
         
         */
        
        let top = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Top.usda"), Overlay.UsdStage.LoadAll))
        let copyDest = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "CopyDest.usda"), Overlay.UsdStage.LoadAll))
        let copySrc = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "CopySrc.usda"), Overlay.UsdStage.LoadAll))
        let opinion = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Opinion.usda"), Overlay.UsdStage.LoadAll))
        
        opinion.DefinePrim("/foo", "Sphere")
        Overlay.Dereference(top.GetRootLayer()).InsertSubLayerPath("CopyDest.usda", 0)
        Overlay.Dereference(copySrc.GetRootLayer()).InsertSubLayerPath("Opinion.usda", 0)
        
        let (token, value) = registerNotification(top.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Top.usda"))
        """
        )


        """#)
        
        expectingSomeNotifications([token], Overlay.Dereference(copyDest.GetRootLayer()).TransferContent(copySrc.GetRootLayer()))
        XCTAssertEqual(top.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Top.usda"))
        """
        )

        def Sphere "foo"
        {
        }
        

        """#)
    }
    
    func test_TransferContent_ExportToString_2502_regression() {
        // This is the old version of test_TransferContent_ExportToString. It caught a regression introduced in vanilla OpenUSD 25.02,
        // that was fixed in 25.02a. Even though it's fixed, we should keep it around to catch it if it regresses again
        /*
         Before TransferContent, we'll have top -> copyDest
         After TransferContent, we'll have top -> copySrc -> copyDest -> opinion, and have opinion be reachable
         
         top -> copySrc
         copyDest -> opinion, copyDest
         copySrc -> opinion, copyDest
         opinion
         
         */
        
        let top = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Top.usda"), Overlay.UsdStage.LoadAll))
        let copyDest = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub/copy.usda"), Overlay.UsdStage.LoadAll))
        let copySrc = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub/Sub/copy.usda"), Overlay.UsdStage.LoadAll))
        let opinion = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub/Sub/opinion.usda"), Overlay.UsdStage.LoadAll))
        
        opinion.DefinePrim("/foo", "Sphere")
        Overlay.Dereference(top.GetRootLayer()).InsertSubLayerPath("Sub/copy.usda", 0)
        Overlay.Dereference(copySrc.GetRootLayer()).InsertSubLayerPath("Sub/copy.usda", 0)
        Overlay.Dereference(copySrc.GetRootLayer()).InsertSubLayerPath("Sub/opinion.usda", 0)
        
        let (token, value) = registerNotification(top.ExportToString())
        XCTAssertEqual(value, #"""
            #usda 1.0
            (
                doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Top.usda"))
            """
            )
            
            
            """#)
        
        expectingSomeNotifications([token], Overlay.Dereference(copyDest.GetRootLayer()).TransferContent(copySrc.GetRootLayer()))
        XCTAssertEqual(top.ExportToString(), #"""
            #usda 1.0
            (
                doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Top.usda"))
            """
            )
            
            def Sphere "foo"
            {
            }
            
            
            """#)
    }
    
    // MARK: SetRootPrims
    
    func test_SetRootPrim_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [foo, bar])
        
        expectingSomeNotifications([token], layer.SetRootPrims([layer.GetPrimAtPath("/bar"), layer.GetPrimAtPath("/foo")]))
        XCTAssertEqual(Array(main.Traverse()), [bar, foo])
    }
    
    // MARK: InsertRootPrim
    
    func test_InsertRootPrim_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [foo, bar])
        
        expectingSomeNotifications([token], layer.InsertRootPrim(layer.GetPrimAtPath("/foo/bar"), 0))
        XCTAssertEqual(Array(main.Traverse()), [main.GetPrimAtPath("/bar"), foo])
    }
    
    // MARK: RemoveRootPrim
    
    func test_RemoveRootPrim_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [foo, bar])
        
        expectingSomeNotifications([token], layer.RemoveRootPrim(layer.GetPrimAtPath("/bar")))
        XCTAssertEqual(Array(main.TraverseAll()), [foo])
    }
    
    // MARK: ScheduleRemoveIfInert
    
    func test_ScheduleRemoveIfInert_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.OverridePrim("/foo")
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [p])
        
        expectingSomeNotifications([token], layer.ScheduleRemoveIfInert(layer.GetObjectAtPath("/foo").GetSpec()))
        XCTAssertEqual(Array(main.TraverseAll()), [])
    }
    
    // MARK: RemovePrimIfInert
    
    func test_RemovePrimIfInert_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.OverridePrim("/foo")
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [p])
        
        expectingSomeNotifications([token], layer.RemovePrimIfInert(layer.GetPrimAtPath("/foo")))
        XCTAssertEqual(Array(main.TraverseAll()), [])
    }
    
    // MARK: RemovePropertyIfHasOnlyRequiredFields
    
    func test_RemovePropertyIfHasOnlyRequiredFields_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.OverridePrim("/foo").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(layer.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0

        over "foo"
        {
            double myAttr
        }


        """#)
        
        expectingSomeNotifications([token], layer.RemovePropertyIfHasOnlyRequiredFields(layer.GetPropertyAtPath("/foo.myAttr")))
        XCTAssertEqual(layer.ExportToString(), #"""
        #usda 1.0


        """#)
    }
    
    // MARK: RemoveInertSceneDescription
    
    func test_RemoveInertSceneDescription_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.OverridePrim("/foo")
        
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [p])
        
        expectingSomeNotifications([token], layer.RemoveInertSceneDescription())
        XCTAssertEqual(Array(main.TraverseAll()), [])
    }
    
    // MARK: SetRootPrimOrder
    
    func test_SetRootPrimOrder_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [foo, bar])
        
        expectingSomeNotifications([token], layer.SetRootPrimOrder(["bar", "foo"]))
        XCTAssertEqual(Array(main.Traverse()), [bar, foo])
    }
    
    // MARK: InsertInRootPrimOrder
    
    func test_InsertInRootPrimOrder_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        layer.SetRootPrimOrder(["foo"])
        
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [foo, bar])
        
        expectingSomeNotifications([token], layer.InsertInRootPrimOrder("bar", 0))
        XCTAssertEqual(Array(main.TraverseAll()), [bar, foo])
    }
    
    // MARK: RemoveFromRootPrimOrder
    
    func test_RemoveFromRootPrimOrder_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        layer.SetRootPrimOrder(["bar", "foo"])
        
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [bar, foo])
        
        expectingSomeNotifications([token], layer.RemoveFromRootPrimOrder("bar"))
        XCTAssertEqual(Array(main.TraverseAll()), [foo, bar])
    }
    
    // MARK: RemoveFromRootPrimOrderByIndex
    
    func test_RemoveFromRootPrimOrderByIndex_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        layer.SetRootPrimOrder(["bar", "foo"])
        
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [bar, foo])
        
        expectingSomeNotifications([token], layer.RemoveFromRootPrimOrderByIndex(0))
        XCTAssertEqual(Array(main.TraverseAll()), [foo, bar])
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value!, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )
        

        """#)
        
        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }
        

        """#)))
        XCTAssertEqual(main.ExportToString(addSourceFileComment: false)!, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }
        

        """#)
    }
    
    // MARK: Clear
    
    func test_Clear_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [foo])
        
        expectingSomeNotifications([token], layer.Clear())
        XCTAssertEqual(Array(main.TraverseAll()), [])
    }
    
    // MARK: Reload
    
    func test_Reload_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [foo])
        
        expectingSomeNotifications([token], layer.Reload(true))
        XCTAssertEqual(Array(main.Traverse()), [])
    }
    
    // MARK: Import
    
    func test_Import_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()

        let foo = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [foo])
        
        expectingSomeNotifications([token], layer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertEqual(Array(main.TraverseAll()), [])
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))

        let foo = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [foo])
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([main.GetRootLayer()], true))
        XCTAssertEqual(Array(main.Traverse()), [])
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        
        """#)
        
        expectingSomeNotifications([token], layer.SetIdentifier(pathForStage(named: "NewMain.usda")))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "NewMain.usda"))
        """
        )

        
        """#)
    }
}
