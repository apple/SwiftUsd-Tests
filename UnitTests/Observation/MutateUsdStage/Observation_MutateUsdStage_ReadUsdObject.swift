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

final class Observation_MutateUsdStage_ReadUsdObject: ObservationHelper {

    // MARK: Load
    
    func test_Load_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], mainStage.Load("/smallModel", Overlay.UsdLoadWithDescendants))
        XCTAssertTrue(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))

    }
    
    // MARK: Unload
    
    func test_Unload_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.Unload("/smallModel"))
        XCTAssertFalse(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
    }

    // MARK: LoadAndUnload
    
    func test_LoadAndUnload_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.LoadAndUnload([], ["/smallModel"], Overlay.UsdLoadWithDescendants))
        XCTAssertFalse(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
    }
    
    // MARK: SetLoadRules
    
    func test_SetLoadRules_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], mainStage.SetLoadRules(pxr.UsdStageLoadRules.LoadAll()))
        XCTAssertTrue(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
    }
    
    // MARK: SetPopulationMask
    
    func test_SetPopulationMask_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.SetPopulationMask(pxr.UsdStagePopulationMask()))
        XCTAssertFalse(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
    }
    
    // MARK: MuteLayer
    
    func test_MuteLayer_HasCustomData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.SetCustomDataByKey("myCustomKey", pxr.VtValue("myCustomValue" as pxr.TfToken))
        }
        
        let (token, value) = registerNotification(spherePrim.HasCustomData())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertFalse(spherePrim.HasCustomData())
    }
    
    // MARK: UnmuteLayer
    
    func test_UnmuteLayer_IsHidden() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.SetHidden(true)
        }
        
        main.MuteLayer(pathForStage(named: "Model.usda"))
        
        let (token, value) = registerNotification(spherePrim.IsHidden())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.UnmuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(spherePrim.IsHidden())
    }
    
    // MARK: MuteAndUnmuteLayers
    
    func test_MuteAndUnmuteLayers_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.SetActive(true)
        }
        
        let (token, value) = registerNotification(spherePrim.HasAuthoredMetadata("active"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.MuteAndUnmuteLayers([pathForStage(named: "Model.usda")], []))
        XCTAssertFalse(spherePrim.HasAuthoredMetadata("active"))
    }
    
    // MARK: SetMetadata
    
    func test_SetMetadata_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.SetActive(false)
                        
        let (token, value) = registerNotification(spherePrim.HasMetadata("active"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.SetMetadata("subLayers", pxr.VtValue([] as Overlay.String_Vector)))
        XCTAssertFalse(spherePrim.HasMetadata("active"))
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.SetActive(false)
                        
        let (token, value) = registerNotification(spherePrim.HasMetadata("active"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadata("subLayers"))
        XCTAssertFalse(spherePrim.HasMetadata("active"))
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("noAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            spherePrim.SetActive(false)
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        
        var isActive = pxr.VtValue()
        let (token, value) = registerNotification(spherePrim.GetMetadata("active", &isActive))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string)))
        XCTAssertTrue(spherePrim.GetMetadata("active", &isActive))
        XCTAssertFalse(isActive.Get())
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            spherePrim.SetActive(false)
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        
        var isActive = pxr.VtValue()
        let (token, value) = registerNotification(spherePrim.GetMetadata("active", &isActive))
        XCTAssertTrue(value)
        XCTAssertFalse(isActive.Get())
        
        expectingSomeNotifications([token], main.ClearMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR"))
        XCTAssertFalse(spherePrim.GetMetadata("active", &isActive))
    }
    
    // MARK: SetStartTimeCode
    
    func test_SetStartTimeCode_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("startTimeCode"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetStartTimeCode(7))
        XCTAssertTrue(p.HasAuthoredMetadata("startTimeCode"))
    }
    
    // MARK: SetEndTimeCode
    
    func test_SetEndTimeCode_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("endTimeCode"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetEndTimeCode(7))
        XCTAssertTrue(p.HasAuthoredMetadata("endTimeCode"))
    }
    
    // MARK: SetTimeCodesPerSecond
    
    func test_SetTimeCodesPerSecond_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("timeCodesPerSecond"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetTimeCodesPerSecond(7))
        XCTAssertTrue(p.HasAuthoredMetadata("timeCodesPerSecond"))
    }
    
    // MARK: SetFramesPerSecond
    
    func test_SetFramesPerSecond_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("framesPerSecond"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetFramesPerSecond(7))
        XCTAssertTrue(p.HasAuthoredMetadata("framesPerSecond"))
    }
    
    // MARK: Reload
    
    func test_Reload_SetDisplayName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        spherePrim.SetDisplayName("foo")
        main.Save()
        
        spherePrim.SetDisplayName("Bar")
        
        let (token, value) = registerNotification(spherePrim.GetDisplayName())
        XCTAssertEqual(value, "Bar")
        
        expectingSomeNotifications([token], main.Reload())
        XCTAssertEqual(spherePrim.GetDisplayName(), "foo")
    }
    
    // MARK: SetColorConfiguration
    
    func test_SetColorConfiguration_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("colorConfiguration"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetColorConfiguration(pxr.SdfAssetPath("foo")))
        XCTAssertTrue(p.HasAuthoredMetadata("colorConfiguration"))
    }
    
    // MARK: SetColorManagementSystem
    
    func test_SetColorManagementSystem_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("colorManagementSystem"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetColorManagementSystem("foo"))
        XCTAssertTrue(p.HasAuthoredMetadata("colorManagementSystem"))
    }
    
    // MARK: SetDefaultPrim
    
    func test_SetDefaultPrim_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        let foo = main.DefinePrim("/foo", "Cube")
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("defaultPrim"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetDefaultPrim(foo))
        XCTAssertTrue(p.HasAuthoredMetadata("defaultPrim"))
    }
    
    // MARK: ClearDefaultPrim
    
    func test_ClearDefaultPrim_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        let foo = main.DefinePrim("/foo", "Cube")
        main.SetDefaultPrim(foo)
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("defaultPrim"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearDefaultPrim())
        XCTAssertFalse(p.HasAuthoredMetadata("defaultPrim"))
    }
    
    // MARK: OverridePrim
    
    func test_OverridePrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.GetPrimAtPath("/foo")
        
        let (token, value) = registerNotification(foo.IsValid())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.OverridePrim("/foo"))
        XCTAssertTrue(main.GetPrimAtPath("/foo").IsValid())
    }
    
    // MARK: DefinePrim
    
    func test_DefinePrim_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Plane")
        
        let (token, value) = registerNotification(foo.GetObjectAtPath("bar").IsValid())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.DefinePrim("/foo/bar", "Sphere"))
        XCTAssertTrue(foo.GetObjectAtPath("bar").IsValid())
    }
    
    // MARK: CreateClassPrim
    
    func test_CreateClassPrim_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let defPrim = main.DefinePrim("/foo", "Sphere")
        var inherits = defPrim.GetInherits()
        inherits.AddInherit("/_class_bar", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(defPrim.GetObjectAtPath(".myAttr"))
        XCTAssertFalse(value.IsValid())
        
        expectingSomeNotifications([token]) {
            main.CreateClassPrim("/_class_bar").CreateAttribute("myAttr", .Float, true, Overlay.SdfVariabilityVarying)
        }
        XCTAssertTrue(defPrim.GetObjectAtPath(".myAttr").IsValid())
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.RemovePrim("/foo"))
        XCTAssertFalse(p.IsValid())
    }
    
    // MARK: dtor
    
    func test_dtor_IsValid() {
        var main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token]) { main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll)) }
        XCTAssertFalse(Bool(p))
    }
}
