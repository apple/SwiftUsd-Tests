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

final class Observation_MutateSdfLayer_ReadSdfLayer: ObservationHelper {

    // MARK: SetField
    
    func test_SetField_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasField("/", "startTimeCode", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetField("/", "startTimeCode", pxr.VtValue(17.0 as Double)))
        XCTAssertTrue(layer.HasField("/", "startTimeCode", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    func test_SetField_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var (token, value) = registerNotification(layer.GetField("/", "endTimeCode"))
        XCTAssertEqual(value.Get(), 0.0)
        
        expectingSomeNotifications([token], layer.SetField("/", "endTimeCode", pxr.VtValue(17.0 as Double)))
        var temp = layer.GetField("/", "endTimeCode")
        XCTAssertEqual(temp.Get(), 17.0)
    }
    
    func test_SetField_IsDirty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.IsDirty())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetField("/", "endTimeCode", pxr.VtValue(17.0 as Double)))
        XCTAssertTrue(layer.IsDirty())
    }

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_GetExpressionVariables() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let (token, value) = registerNotification(layer.GetExpressionVariables())
        XCTAssertEqual(value.size(), 1)
        XCTAssertEqual(value["WHICH_SUBLAYER"], pxr.VtValue(pathForStage(named: "Sub1.usda")))

        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        let newVariables = layer.GetExpressionVariables()
        XCTAssertEqual(newVariables.size(), 1)
        XCTAssertEqual(newVariables["WHICH_SUBLAYER"], pxr.VtValue(pathForStage(named: "Sub2.usda")))
    }
    
    // MARK: EraseField
    
    func test_EraseField_ListFields() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(7)
        
        let (token, value) = registerNotification(layer.ListFields("/"))
        XCTAssertEqual(value, ["startTimeCode"])
        
        expectingSomeNotifications([token], layer.EraseField("/", "startTimeCode"))
        XCTAssertEqual(layer.ListFields("/"), [])
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_GetFieldDictValueByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let (token, value) = registerNotification(layer.GetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertEqual(value, pxr.VtValue(pathForStage(named: "Sub1.usda")))

        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertTrue(layer.GetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER").IsEmpty())
    }
    
    // MARK: SetColorConfiguration
    
    func test_SetColorConfiguration_HasColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(layer.HasColorConfiguration())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetColorConfiguration(pxr.SdfAssetPath("fizz")))
        XCTAssertTrue(layer.HasColorConfiguration())
    }
    
    // MARK: ClearColorConfiguration
    
    func test_ClearColorConfiguration_GetColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        layer.SetColorConfiguration(pxr.SdfAssetPath("foo"))

        let (token, value) = registerNotification(layer.GetColorConfiguration())
        XCTAssertEqual(value, pxr.SdfAssetPath("foo"))
        
        expectingSomeNotifications([token], layer.ClearColorConfiguration())
        XCTAssertEqual(layer.GetColorConfiguration(), pxr.SdfAssetPath(""))
    }
    
    // MARK: SetColorManagementSystem
    
    func test_SetColorManagementSystem_GetColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(layer.GetColorManagementSystem())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], layer.SetColorManagementSystem("fizz"))
        XCTAssertEqual(layer.GetColorManagementSystem(), "fizz")
    }
    
    // MARK: ClearColorManagementSystem
    
    func test_ClearColorManagementSystem_GetColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetColorManagementSystem("buzz")

        let (token, value) = registerNotification(layer.GetColorManagementSystem())
        XCTAssertEqual(value, "buzz")
        
        expectingSomeNotifications([token], layer.ClearColorManagementSystem())
        XCTAssertEqual(layer.GetColorManagementSystem(), "")
    }
    
    // MARK: SetComment
    
    func test_SetComment_GetComment() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(layer.GetComment())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], layer.SetComment("hello"))
        XCTAssertEqual(layer.GetComment(), "hello")
    }
    
    // MARK: SetDefaultPrim
    
    func test_SetDefaultPrim_HasDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Cube")
        

        let (token, value) = registerNotification(layer.HasDefaultPrim())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetDefaultPrim("foo"))
        XCTAssertTrue(layer.HasDefaultPrim())
    }
    
    // MARK: ClearDefaultPrim
    
    func test_ClearDefaultPrim_GetDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Cube")
        layer.SetDefaultPrim("foo")
        

        let (token, value) = registerNotification(layer.GetDefaultPrim())
        XCTAssertEqual(value, "foo")
        
        expectingSomeNotifications([token], layer.ClearDefaultPrim())
        XCTAssertEqual(layer.GetDefaultPrim(), "")
    }
    
    // MARK: SetDocumentation
    
    func test_SetDocumentation_GetDocumentation() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetDocumentation())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], layer.SetDocumentation("fizzbuzz"))
        XCTAssertEqual(layer.GetDocumentation(), "fizzbuzz")
    }
    
    // MARK: SetStartTimeCode
    
    func test_SetStartTimeCode_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetStartTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], layer.SetStartTimeCode(2.718))
        XCTAssertEqual(layer.GetStartTimeCode(), 2.718)
    }
    
    func test_SetStartTimeCode_HasStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasStartTimeCode())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetStartTimeCode(2.718))
        XCTAssertTrue(layer.HasStartTimeCode())
    }
    
    // MARK: ClearStartTimeCode
    
    func test_ClearStartTimeCode_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(7)
        
        let (token, value) = registerNotification(layer.GetStartTimeCode())
        XCTAssertEqual(value, 7)
        
        expectingSomeNotifications([token], layer.ClearStartTimeCode())
        XCTAssertEqual(layer.GetStartTimeCode(), 0)
    }
    
    func test_ClearStartTimeCode_HasStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetStartTimeCode(7)
        
        let (token, value) = registerNotification(layer.HasStartTimeCode())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearStartTimeCode())
        XCTAssertFalse(layer.HasStartTimeCode())
    }
    
    // MARK: SetEndTimeCode
    
    func test_SetEndTimeCode_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetEndTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], layer.SetEndTimeCode(2.718))
        XCTAssertEqual(layer.GetEndTimeCode(), 2.718)
    }
    
    func test_SetEndTimeCode_HasEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasEndTimeCode())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetEndTimeCode(2.718))
        XCTAssertTrue(layer.HasEndTimeCode())
    }
    
    // MARK: ClearEndTimeCode
    
    func test_ClearEndTimeCode_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetEndTimeCode(4)
        
        let (token, value) = registerNotification(layer.GetEndTimeCode())
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], layer.ClearEndTimeCode())
        XCTAssertEqual(layer.GetEndTimeCode(), 0)
    }
    
    func test_ClearEndTimeCode_HasEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetEndTimeCode(4)
        
        let (token, value) = registerNotification(layer.HasEndTimeCode())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearEndTimeCode())
        XCTAssertFalse(layer.HasEndTimeCode())
    }
    
    // MARK: SetTimeCodesPerSecond
    
    func test_SetTimeCodesPerSecond_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], layer.SetTimeCodesPerSecond(19))
        XCTAssertEqual(layer.GetTimeCodesPerSecond(), 19)
    }
    
    func test_SetTimeCodesPerSecond_HasTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasTimeCodesPerSecond())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetTimeCodesPerSecond(19))
        XCTAssertTrue(layer.HasTimeCodesPerSecond())
    }
    
    // MARK: ClearTimeCodesPerSecond
    
    func test_ClearTimeCodesPerSecond_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetTimeCodesPerSecond(4)
        
        let (token, value) = registerNotification(layer.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], layer.ClearTimeCodesPerSecond())
        XCTAssertEqual(layer.GetTimeCodesPerSecond(), 24)
    }
    
    func test_ClearTimeCodesPerSecond_HasTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetTimeCodesPerSecond(4)
        
        let (token, value) = registerNotification(layer.HasTimeCodesPerSecond())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearTimeCodesPerSecond())
        XCTAssertFalse(layer.HasTimeCodesPerSecond())
    }
    
    // MARK: SetFramesPerSecond
    
    func test_SetFramesPerSecond_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetFramesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], layer.SetFramesPerSecond(19))
        XCTAssertEqual(layer.GetFramesPerSecond(), 19)
    }
    
    func test_SetFramesPerSecond_HasFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasFramesPerSecond())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFramesPerSecond(19))
        XCTAssertTrue(layer.HasFramesPerSecond())
    }
    
    // MARK: ClearFramesPerSecond
    
    func test_ClearFramesPerSecond_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetFramesPerSecond(5)
        
        let (token, value) = registerNotification(layer.GetFramesPerSecond())
        XCTAssertEqual(value, 5)
        
        expectingSomeNotifications([token], layer.ClearFramesPerSecond())
        XCTAssertEqual(layer.GetFramesPerSecond(), 24)
    }
    
    func test_ClearFramesPerSecond_HasFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.SetFramesPerSecond(5)
        
        let (token, value) = registerNotification(layer.HasFramesPerSecond())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearFramesPerSecond())
        XCTAssertFalse(layer.HasFramesPerSecond())
    }
    
    // MARK: SetFramePrecision
    
    func test_SetFramePrecision_GetFramePrecision() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetFramePrecision())
        XCTAssertEqual(value, 3)
        
        expectingSomeNotifications([token], layer.SetFramePrecision(6))
        XCTAssertEqual(layer.GetFramePrecision(), 6)
    }
    
    func test_SetFramePrecision_HasFramePrecision() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasFramePrecision())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFramePrecision(6))
        XCTAssertTrue(layer.HasFramePrecision())
    }
    
    // MARK: ClearFramePrecision
    
    func test_ClearFramePrecision_GetFramePrecision() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetFramePrecision(5)
        
        let (token, value) = registerNotification(layer.GetFramePrecision())
        XCTAssertEqual(value, 5)
        
        expectingSomeNotifications([token], layer.ClearFramePrecision())
        XCTAssertEqual(layer.GetFramePrecision(), 3)
    }
    
    func test_ClearFramePrecision_HasFramePrecision() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetFramePrecision(5)
        
        let (token, value) = registerNotification(layer.HasFramePrecision())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearFramePrecision())
        XCTAssertFalse(layer.HasFramePrecision())
    }
    
    // MARK: SetOwner
    
    func test_SetOwner_GetOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetOwner())
        XCTAssertEqual(value, "")

        expectingSomeNotifications([token], layer.SetOwner("foo"))
        XCTAssertEqual(layer.GetOwner(), "foo")
    }
    
    func test_SetOwner_HasOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasOwner())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], layer.SetOwner("foo"))
        XCTAssertTrue(layer.HasOwner())
    }
    
    // MARK: ClearOwner
    
    func test_ClearOwner_GetOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetOwner("foo")
        
        let (token, value) = registerNotification(layer.GetOwner())
        XCTAssertEqual(value, "foo")

        expectingSomeNotifications([token], layer.ClearOwner())
        XCTAssertEqual(layer.GetOwner(), "")
    }
    
    func test_ClearOwner_HasOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetOwner("foo")
        
        let (token, value) = registerNotification(layer.HasOwner())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ClearOwner())
        XCTAssertFalse(layer.HasOwner())
    }
    
    // MARK: SetSessionOwner
    
    func test_SetSessionOwner_GetSessionOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetSessionOwner())
        XCTAssertEqual(value, "")

        expectingSomeNotifications([token], layer.SetSessionOwner("foo"))
        XCTAssertEqual(layer.GetSessionOwner(), "foo")
    }
    
    func test_SetSessionOwner_HasSessionOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasSessionOwner())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], layer.SetSessionOwner("foo"))
        XCTAssertTrue(layer.HasSessionOwner())
    }
    
    // MARK: ClearSessionOwner
    
    func test_ClearSessionOwner_GetSessionOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetSessionOwner("foo")
        
        let (token, value) = registerNotification(layer.GetSessionOwner())
        XCTAssertEqual(value, "foo")

        expectingSomeNotifications([token], layer.ClearSessionOwner())
        XCTAssertEqual(layer.GetSessionOwner(), "")
    }
    
    func test_ClearSessionOwner_HasSessionOwner() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetSessionOwner("foo")
        
        let (token, value) = registerNotification(layer.HasSessionOwner())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ClearSessionOwner())
        XCTAssertFalse(layer.HasSessionOwner())
    }
    
    // MARK: SetHasOwnedSubLayers
    
    func test_SetHasOwnedSubLayers_GetHasOwnedSubLayers() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetHasOwnedSubLayers())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], layer.SetHasOwnedSubLayers(true))
        XCTAssertTrue(layer.GetHasOwnedSubLayers())
    }
    
    // MARK: SetCustomLayerData
    
    func test_SetCustomLayerData_GetCustomLayerData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetCustomLayerData())
        XCTAssertEqual(value.size(), 0)

        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetCustomLayerData(dict))
        let newDict = layer.GetCustomLayerData()
        XCTAssertEqual(newDict.size(), 1)
        XCTAssertEqual(newDict["foo"], pxr.VtValue("bar" as std.string))
    }
    
    func test_SetCustomLayerData_HasCustomLayerData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasCustomLayerData())
        XCTAssertFalse(value)

        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetCustomLayerData(dict))
        XCTAssertTrue(layer.HasCustomLayerData())
    }
    
    // MARK: ClearCustomLayerData
    
    func test_ClearCustomLayerData_GetCustomLayerData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetCustomLayerData(dict)

        
        let (token, value) = registerNotification(layer.GetCustomLayerData())
        XCTAssertEqual(value.size(), 1)
        XCTAssertEqual(value["foo"], pxr.VtValue("bar" as std.string))

        expectingSomeNotifications([token], layer.ClearCustomLayerData())
        XCTAssertEqual(layer.GetCustomLayerData().size(), 0)
    }
    
    func test_ClearCustomLayerData_HasCustomLayerData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetCustomLayerData(dict)

        
        let (token, value) = registerNotification(layer.HasCustomLayerData())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ClearCustomLayerData())
        XCTAssertFalse(layer.HasCustomLayerData())
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_GetExpressionVariables() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetExpressionVariables())
        XCTAssertEqual(value.size(), 0)
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        
        let newDict = layer.GetExpressionVariables()
        XCTAssertEqual(newDict.size(), 1)
        XCTAssertEqual(newDict["foo"], pxr.VtValue("bar" as std.string))
    }
    
    func test_SetExpressionVariables_HasExpressionVariables() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasExpressionVariables())
        XCTAssertFalse(value)
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertTrue(layer.HasExpressionVariables())
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_GetExpressionVariables() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetExpressionVariables(dict)

        
        let (token, value) = registerNotification(layer.GetExpressionVariables())
        XCTAssertEqual(value.size(), 1)
        XCTAssertEqual(value["foo"], pxr.VtValue("bar" as std.string))
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertEqual(layer.GetExpressionVariables().size(), 0)
    }
    
    func test_ClearExpressionVariables_HasExpressionVariables() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        layer.SetExpressionVariables(dict)
        

        let (token, value) = registerNotification(layer.HasExpressionVariables())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(layer.HasExpressionVariables())
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_GetCompositionAssetDependencies() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(model) {}
        
        
        let (token, value) = registerNotification(layer.GetCompositionAssetDependencies())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        XCTAssertEqual(Array(layer.GetCompositionAssetDependencies()), [pathForStage(named: "Model.usda")])
    }
    
    func test_SetSubLayerPaths_GetSubLayerPaths() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(model) {}
        
        
        let (token, value) = registerNotification(layer.GetSubLayerPaths())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        XCTAssertEqual(Array(layer.GetSubLayerPaths()), [pxr.SdfAssetPath(pathForStage(named: "Model.usda"))])
    }
    
    func test_SetSubLayerPaths_GetNumSubLayerPaths() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(model) {}
        
        
        let (token, value) = registerNotification(layer.GetNumSubLayerPaths())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        XCTAssertEqual(layer.GetNumSubLayerPaths(), 1)
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_GetSubLayerOffsets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(model) {}

        let (token, value) = registerNotification(layer.GetSubLayerOffsets())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertEqual(Array(layer.GetSubLayerOffsets()), [pxr.SdfLayerOffset(0, 1)])
    }
    
    func test_InsertSubLayerPath_GetSubLayerOffset() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        layer.InsertSubLayerPath("/foo.usda", 0)
        layer.SetSubLayerOffset(pxr.SdfLayerOffset(2, 3), 0)

        let (token, value) = registerNotification(layer.GetSubLayerOffset(0))
        XCTAssertEqual(value, pxr.SdfLayerOffset(2, 3))
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertEqual(layer.GetSubLayerOffset(0), pxr.SdfLayerOffset(0, 1))
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_GetSubLayerPaths() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(model) {}
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        
        
        let (token, value) = registerNotification(layer.GetSubLayerPaths())
        XCTAssertEqual(Array(value), [pxr.SdfAssetPath(pathForStage(named: "Model.usda"))])
        
        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertEqual(Array(layer.GetSubLayerPaths()), [])
    }
    
    // MARK: SetSubLayerOffset
    
    func test_SetSubLayerOffset_GetSubLayerOffset() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(model) {}
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let (token, value) = registerNotification(layer.GetSubLayerOffset(0))
        XCTAssertEqual(value, pxr.SdfLayerOffset(0, 1))
        
        expectingSomeNotifications([token], layer.SetSubLayerOffset(pxr.SdfLayerOffset(2, 3), 0))
        XCTAssertEqual(layer.GetSubLayerOffset(0), pxr.SdfLayerOffset(2, 3))
    }
    
    // MARK: SetPermissionToSave
    
    func test_SetPermissionToSave_PermissionToSave() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.PermissionToSave())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetPermissionToSave(false))
        XCTAssertFalse(layer.PermissionToSave())
    }
    
    // MARK: SetPermissionToEdit
    
    func test_SetPermissionToEdit_PermissionToEdit() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.PermissionToEdit())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetPermissionToEdit(false))
        XCTAssertFalse(layer.PermissionToEdit())
    }
    
    // MARK: Apply
    
    func test_Apply_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        main.DefinePrim("/beta", "Sphere")
        
        
        let (token, value) = registerNotification(layer.HasSpec("/beta"))
        XCTAssertTrue(value)
        
        var batchEdit = pxr.SdfBatchNamespaceEdit()
        batchEdit.Add(pxr.SdfNamespaceEdit.Rename("/beta", "alpha"))
        expectingSomeNotifications([token], layer.Apply(batchEdit))
        XCTAssertFalse(layer.HasSpec("/beta"))
    }
    
    // MARK: SetStateDelegate
    
    func test_SetStateDelegate_GetStateDelegate() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(layer.GetStateDelegate())
        
        let delegateForSetting = pxr.SdfSimpleLayerStateDelegate.New()
        expectingSomeNotifications([token], layer.SetStateDelegate(Overlay.TfRefPtr(Overlay.DereferenceOrNil(delegateForSetting)?.as())))
        let secondGet = layer.GetStateDelegate()
        XCTAssertEqual(Overlay.TfWeakPtr(Overlay.DereferenceOrNil(delegateForSetting)?.as()), secondGet)
        XCTAssertNotEqual(value, secondGet)
    }
    
    // MARK: SetTimeSample
    
    func test_SetTimeSample_ListAllTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        light.GetTextureFileAttr().Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        let (token, value) = registerNotification(layer.ListAllTimeSamples())
        XCTAssertEqual(Array(value), [1])
        
        expectingSomeNotifications([token], layer.SetTimeSample("/foo.inputs:texture:file", 2.0, pxr.SdfAssetPath("/fizz")))
        XCTAssertEqual(Array(layer.ListAllTimeSamples()), [1, 2])
    }
    
    func test_SetTimeSample_ListTimeSamplesForPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        light.GetTextureFileAttr().Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        let (token, value) = registerNotification(layer.ListTimeSamplesForPath("/foo.inputs:texture:file"))
        XCTAssertEqual(Array(value), [1])
        
        expectingSomeNotifications([token], layer.SetTimeSample("/foo.inputs:texture:file", 2.0, pxr.SdfAssetPath("/fizz")))
        XCTAssertEqual(Array(layer.ListTimeSamplesForPath("/foo.inputs:texture:file")), [1, 2])
    }
    
    func test_SetTimeSample_GetNumTimeSamplesForPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        light.GetTextureFileAttr().Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        let (token, value) = registerNotification(layer.GetNumTimeSamplesForPath("/foo.inputs:texture:file"))
        XCTAssertEqual(value, 1)
        
        expectingSomeNotifications([token], layer.SetTimeSample("/foo.inputs:texture:file", 2.0, pxr.SdfAssetPath("/fizz")))
        XCTAssertEqual(layer.GetNumTimeSamplesForPath("/foo.inputs:texture:file"), 2)
    }
    
    func test_SetTimeSample_QueryTimeSample() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        light.GetTextureFileAttr().Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(layer.QueryTimeSample("/foo.inputs:texture:file", 2.0, &vtValue))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetTimeSample("/foo.inputs:texture:file", 2.0, pxr.SdfAssetPath("/fizz")))
        XCTAssertTrue(layer.QueryTimeSample("/foo.inputs:texture:file", 2.0, &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(pxr.SdfAssetPath("/fizz")))
    }
    
    // MARK: EraseTimeSample
    
    func test_EraseTimeSample_ListAllTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        light.GetTextureFileAttr().Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        let (token, value) = registerNotification(layer.ListAllTimeSamples())
        XCTAssertEqual(Array(value), [1])
        
        expectingSomeNotifications([token], layer.EraseTimeSample("/foo.inputs:texture:file", 1))
        XCTAssertEqual(Array(layer.ListAllTimeSamples()), [])
    }
    
    func test_EraseTimeSample_QueryTimeSample() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let light = pxr.UsdLuxDomeLight.Define(Overlay.TfWeakPtr(main), "/foo")
        light.GetTextureFileAttr().Set(pxr.SdfAssetPath("buzz"), 1.0)
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(layer.QueryTimeSample("/foo.inputs:texture:file", 1, &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(pxr.SdfAssetPath("buzz")))

        expectingSomeNotifications([token], layer.EraseTimeSample("/foo.inputs:texture:file", 1))
        XCTAssertFalse(layer.QueryTimeSample("/foo.inputs:texture:file", 1, &vtValue))
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_HasStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let other = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Other.usda"), Overlay.UsdStage.LoadAll))
        other.SetStartTimeCode(2.718)
        
        let (token, value) = registerNotification(layer.HasStartTimeCode())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.TransferContent(other.GetRootLayer()))
        XCTAssertTrue(layer.HasStartTimeCode())
    }
    
    // MARK: SetRootPrims
    
    func test_SetRootPrim_GetRootPrims() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(layer.GetRootPrims().keys())
        XCTAssertEqual(value, ["foo", "bar"])
        
        expectingSomeNotifications([token], layer.SetRootPrims([layer.GetPrimAtPath("/bar"), layer.GetPrimAtPath("/foo")]))
        XCTAssertEqual(layer.GetRootPrims().keys(), ["bar", "foo"])
    }
    
    // MARK: InsertRootPrim
    
    func test_InsertRootPrim_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        
        let (token, value) = registerNotification(layer.ExportToString())
        XCTAssertEqual(value!, #"""
        #usda 1.0

        def Sphere "foo"
        {
            def Sphere "bar"
            {
            }
        }

        
        """#)
                
        expectingSomeNotifications([token], layer.InsertRootPrim(layer.GetPrimAtPath("/foo/bar"), 0))
        XCTAssertEqual(layer.ExportToString()!, #"""
        #usda 1.0

        def Sphere "bar"
        {
        }

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: RemoveRootPrim
    
    func test_RemoveRootPrim_GetRootPrims() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(Array(layer.GetRootPrims().keys()))
        XCTAssertEqual(value, ["foo", "bar"])
        
        expectingSomeNotifications([token], layer.RemoveRootPrim(layer.GetPrimAtPath("/bar")))
        XCTAssertEqual(Array(layer.GetRootPrims().keys()), ["foo"])
    }
    
    // MARK: ScheduleRemoveIfInert
    
    func test_ScheduleRemoveIfInert_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.OverridePrim("/foo")
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ScheduleRemoveIfInert(layer.GetObjectAtPath("/foo").GetSpec()))
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
    
    // MARK: RemovePrimIfInert
    
    func test_RemovePrimIfInert_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.OverridePrim("/foo")
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemovePrimIfInert(layer.GetPrimAtPath("/foo")))
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
    
    // MARK: RemovePropertyIfHasOnlyRequiredFields
    
    func test_RemovePropertyIfHasOnlyRequiredFields_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.OverridePrim("/foo").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(layer.HasSpec("/foo.myAttr"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemovePropertyIfHasOnlyRequiredFields(layer.GetPropertyAtPath("/foo.myAttr")))
        XCTAssertFalse(layer.HasSpec("/foo.myAttr"))
    }
    
    // MARK: RemoveInertSceneDescription
    
    func test_RemoveInertSceneDescription_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.OverridePrim("/foo")
        
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemoveInertSceneDescription())
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
    
    // MARK: SetRootPrimOrder
    
    func test_SetRootPrimOrder_GetRootPrimOrder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        
        
        let (token, value) = registerNotification(Array(layer.GetRootPrimOrder()))
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], layer.SetRootPrimOrder(["bar", "foo"]))
        XCTAssertEqual(Array(layer.GetRootPrimOrder()), ["bar", "foo"])
    }
    
    // MARK: InsertInRootPrimOrder
    
    func test_InsertInRootPrimOrder_GetRootPrimOrder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        layer.SetRootPrimOrder(["foo"])
        
        
        let (token, value) = registerNotification(Array(layer.GetRootPrimOrder()))
        XCTAssertEqual(value, ["foo"])

        expectingSomeNotifications([token], layer.InsertInRootPrimOrder("bar", 0))
        XCTAssertEqual(Array(layer.GetRootPrimOrder()), ["bar", "foo"])
    }
    
    // MARK: RemoveFromRootPrimOrder
    
    func test_RemoveFromRootPrimOrder_GetRootPrimOrder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        layer.SetRootPrimOrder(["bar", "foo"])
        
        
        let (token, value) = registerNotification(Array(layer.GetRootPrimOrder()))
        XCTAssertEqual(value, ["bar", "foo"])

        expectingSomeNotifications([token], layer.RemoveFromRootPrimOrder("bar"))
        XCTAssertEqual(Array(layer.GetRootPrimOrder()), ["foo"])
    }
    
    // MARK: RemoveFromRootPrimOrderByIndex
    
    func test_RemoveFromRootPrimOrderByIndex_GetRootPrimOrder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        layer.SetRootPrimOrder(["bar", "foo"])
        
        
        let (token, value) = registerNotification(Array(layer.GetRootPrimOrder()))
        XCTAssertEqual(value, ["bar", "foo"])

        expectingSomeNotifications([token], layer.RemoveFromRootPrimOrderByIndex(0))
        XCTAssertEqual(Array(layer.GetRootPrimOrder()), ["foo"])
    }
    
    // MARK: Save
    
    func test_Save_IsDirty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(layer.IsDirty())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Save(true))
        XCTAssertFalse(layer.IsDirty())
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertFalse(value)

        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0
        
        def Sphere "foo"
        {
        }
        

        """#)))
        XCTAssertTrue(layer.HasSpec("/foo"))
    }
    
    // MARK: Clear
    
    func test_Clear_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Clear())
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
    
    // MARK: Reload
    
    func test_Reload_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.Reload(true))
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
    
    // MARK: Import
    
    func test_Import_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()

        main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([main.GetRootLayer()], true))
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_GetIdentifier() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.Save()

        let (token, value) = registerNotification(layer.GetIdentifier())
        XCTAssertEqual(value, pathForStage(named: "Main.usda"))
        
        expectingSomeNotifications([token], layer.SetIdentifier(pathForStage(named: "NewMain.usda")))
        XCTAssertEqual(layer.GetIdentifier(), pathForStage(named: "NewMain.usda"))
    }
    
    // MARK: SetMuted
    
    func test_SetMuted_IsMuted_instance() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        
        let (token, value) = registerNotification(layer.IsMuted())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetMuted(true))
        XCTAssertTrue(layer.IsMuted())
    }
    
    func test_SetMuted_GetMutedLayers() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(Array(pxr.SdfLayer.GetMutedLayers()))
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], layer.SetMuted(true))
        XCTAssertEqual(Array(pxr.SdfLayer.GetMutedLayers()), [pathForStage(named: "Main.usda")])
    }
        
    func test_SetMuted_IsMuted_static() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let path = pathForStage(named: "Main.usda")
        
        let (token, value) = registerNotification(pxr.SdfLayer.IsMuted(path))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetMuted(true))
        XCTAssertTrue(pxr.SdfLayer.IsMuted(path))
    }
    
    // MARK: AddToMutedLayers
    
    func test_AddToMutedLayers_IsMuted_instance() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let (token, value) = registerNotification(layer.IsMuted())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.AddToMutedLayers(pathForStage(named: "Main.usda")))
        XCTAssertTrue(layer.IsMuted())
    }
    
    func test_AddToMutedLayers_GetMutedLayers() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        
        let (token, value) = registerNotification(Array(pxr.SdfLayer.GetMutedLayers()))
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], pxr.SdfLayer.AddToMutedLayers("foo"))
        XCTAssertEqual(Array(pxr.SdfLayer.GetMutedLayers()), ["foo"])
    }
    
    func test_AddToMutedLayers_IsMuted_static() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
                
        let path = pathForStage(named: "Main.usda")

        let (token, value) = registerNotification(pxr.SdfLayer.IsMuted(path))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.AddToMutedLayers(pathForStage(named: "Main.usda")))
        XCTAssertTrue(pxr.SdfLayer.IsMuted(path))
    }
        
    // MARK: RemoveFromMutedLayers
    
    func test_RemoveFromMutedLayers_IsMuted_instance() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        layer.SetMuted(true)
        let (token, value) = registerNotification(layer.IsMuted())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.RemoveFromMutedLayers(pathForStage(named: "Main.usda")))
        XCTAssertFalse(layer.IsMuted())
    }
    
    func test_RemoveFromMutedLayers_GetMutedLayers() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        
        pxr.SdfLayer.AddToMutedLayers("foo")
        let (token, value) = registerNotification(Array(pxr.SdfLayer.GetMutedLayers()))
        XCTAssertEqual(value, ["foo"])
        
        expectingSomeNotifications([token], pxr.SdfLayer.RemoveFromMutedLayers("foo"))
        XCTAssertEqual(Array(pxr.SdfLayer.GetMutedLayers()), [])
    }
    
    func test_RemoveFromMutedLayers_IsMuted_static() {
        for l in pxr.SdfLayer.GetMutedLayers() { pxr.SdfLayer.RemoveFromMutedLayers(l) }
                
        let path = pathForStage(named: "Main.usda")
        
        pxr.SdfLayer.AddToMutedLayers(path)
        let (token, value) = registerNotification(pxr.SdfLayer.IsMuted(path))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.RemoveFromMutedLayers(pathForStage(named: "Main.usda")))
        XCTAssertFalse(pxr.SdfLayer.IsMuted(path))
    }
}


