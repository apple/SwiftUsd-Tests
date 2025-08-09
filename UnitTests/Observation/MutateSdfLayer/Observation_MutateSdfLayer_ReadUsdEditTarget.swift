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

final class Observation_MutateSdfLayer_ReadUsdEditTarget: ObservationHelper {

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        var sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        main.SetEditTarget(pxr.UsdEditTarget(sub1.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        let editTarget = main.GetEditTarget()
        sub1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll))

        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        XCTAssertFalse(editTarget.IsValid())
    }

    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        var sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        main.SetEditTarget(pxr.UsdEditTarget(sub1.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        let editTarget = main.GetEditTarget()
        sub1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll))

        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        var sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        main.SetEditTarget(pxr.UsdEditTarget(sub1.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        let editTarget = main.GetEditTarget()
        sub1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll))

        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        var sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        main.SetEditTarget(pxr.UsdEditTarget(sub1.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        let editTarget = main.GetEditTarget()
        sub1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll))

        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var model: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        main.SetEditTarget(pxr.UsdEditTarget(model!.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = nil
        let editTarget = main.GetEditTarget()
        
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.SetSubLayerPaths([]))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var model: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        main.SetEditTarget(pxr.UsdEditTarget(model!.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = nil
        let editTarget = main.GetEditTarget()
        
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var model: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        main.SetEditTarget(pxr.UsdEditTarget(model!.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = nil
        let editTarget = main.GetEditTarget()
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0

        
        """#)))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: Clear
    
    func test_Clear_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var model: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        main.SetEditTarget(pxr.UsdEditTarget(model!.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = nil
        let editTarget = main.GetEditTarget()
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Clear())
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: Reload
    
    func test_Reload_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var model: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        main.SetEditTarget(pxr.UsdEditTarget(model!.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = nil
        let editTarget = main.GetEditTarget()
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Reload(true))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: Import
    
    func test_Import_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()
        
        var model: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        main.SetEditTarget(pxr.UsdEditTarget(model!.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = nil
        let editTarget = main.GetEditTarget()
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var model: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        main.SetEditTarget(pxr.UsdEditTarget(model!.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = nil
        let editTarget = main.GetEditTarget()
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([main.GetRootLayer()], true))
        XCTAssertFalse(editTarget.IsValid())
    }
    
    // MARK: dtor
    
    func test_dtor_IsValid() {
        var l: pxr.SdfLayer? = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "Main.usda"), pxr.SdfLayer.FileFormatArguments()))
        let target = pxr.UsdEditTarget(Overlay.TfWeakPtr(l!), pxr.SdfLayerOffset(0, 1))
        
        let (token, value) = registerNotification(target.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], l = nil)
        XCTAssertFalse(target.IsValid())
    }
    
    func test_dtor_GetLayer() {
        var l: pxr.SdfLayer? = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "Main.usda"), pxr.SdfLayer.FileFormatArguments()))
        let target = pxr.UsdEditTarget(Overlay.TfWeakPtr(l!), pxr.SdfLayerOffset(0, 1))
        
        let (token, value) = registerNotification(Bool(target.GetLayer()))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], l = nil)
        XCTAssertFalse(Bool(target.GetLayer()))
    }
    
    func test_dtor_TfWeakPtr_operatorBool() {
        var l: pxr.SdfLayer? = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "Main.usda"), pxr.SdfLayer.FileFormatArguments()))
        let target = pxr.UsdEditTarget(Overlay.TfWeakPtr(l!), pxr.SdfLayerOffset(0, 1))
        let editTargetsLayer = target.GetLayer()
        
        let (token, value) = registerNotification(Bool(editTargetsLayer))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], l = nil)
        XCTAssertFalse(Bool(editTargetsLayer))

    }
}
