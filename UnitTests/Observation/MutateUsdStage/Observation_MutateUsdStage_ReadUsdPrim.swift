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

final class Observation_MutateUsdStage_ReadUsdPrim: ObservationHelper {

    // MARK: Load
    
    func test_Load_GetAllDescendants() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let rootPrim = mainStage.DefinePrim("/root", "Scope")
        
        let scopePrim = mainStage.DefinePrim("/root/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rootPrim.GetAllDescendants())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/root/smallModel")])
        
        expectingSomeNotifications([token], mainStage.Load("/root/smallModel", Overlay.UsdLoadWithDescendants))
        XCTAssertEqual(Array(rootPrim.GetAllDescendants()), [mainStage.GetPrimAtPath("/root/smallModel"), mainStage.GetPrimAtPath("/root/smallModel/bigModel")])
    }
    
    // MARK: Unload
    
    func test_Unload_GetAllDescendants() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let rootPrim = mainStage.DefinePrim("/root", "Scope")
        
        let scopePrim = mainStage.DefinePrim("/root/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rootPrim.GetAllDescendants())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/root/smallModel"), mainStage.GetPrimAtPath("/root/smallModel/bigModel")])
        
        expectingSomeNotifications([token], mainStage.Unload("/root/smallModel"))
        XCTAssertEqual(Array(rootPrim.GetAllDescendants()), [mainStage.GetPrimAtPath("/root/smallModel")])
    }
    
    // MARK: LoadAndUnload
    
    func test_LoadAndUnload_GetAllDescendants() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let rootPrim = mainStage.DefinePrim("/root", "Scope")
        
        let scopePrim = mainStage.DefinePrim("/root/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rootPrim.GetAllDescendants())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/root/smallModel"), mainStage.GetPrimAtPath("/root/smallModel/bigModel")])
        
        expectingSomeNotifications([token], mainStage.LoadAndUnload([], ["/root/smallModel"], Overlay.UsdLoadWithDescendants))
        XCTAssertEqual(Array(rootPrim.GetAllDescendants()), [mainStage.GetPrimAtPath("/root/smallModel")])
    }
    
    // MARK: SetLoadRules
    
    func test_SetLoadRules_GetAllDescendants() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let rootPrim = mainStage.DefinePrim("/root", "Scope")
        
        let scopePrim = mainStage.DefinePrim("/root/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rootPrim.GetAllDescendants())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/root/smallModel")])
        
        expectingSomeNotifications([token], mainStage.SetLoadRules(pxr.UsdStageLoadRules.LoadAll()))
        XCTAssertEqual(Array(rootPrim.GetAllDescendants()), [mainStage.GetPrimAtPath("/root/smallModel"), mainStage.GetPrimAtPath("/root/smallModel/bigModel")])
    }
    
    // MARK: SetPopulationMask
    
    func test_SetPopulationMask_GetAllDescendants() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let rootPrim = mainStage.DefinePrim("/root", "Scope")
        
        let scopePrim = mainStage.DefinePrim("/root/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rootPrim.GetAllDescendants())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/root/smallModel"), mainStage.GetPrimAtPath("/root/smallModel/bigModel")])
        
        expectingSomeNotifications([token], mainStage.SetPopulationMask(pxr.UsdStagePopulationMask()))
        XCTAssertEqual(Array(rootPrim.GetAllDescendants()), [])
    }
    
    // MARK: MuteLayer
    
    func test_MuteLayer_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.SetActive(false)
        }
        
        let (token, value) = registerNotification(spherePrim.IsActive())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(spherePrim.IsActive())
    }
    
    func test_MuteLayer_HasProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.CreateRelationship("myRel", true)
        }
        
        let (token, value) = registerNotification(spherePrim.HasProperty("myRel"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertFalse(spherePrim.HasProperty("myRel"))
    }
    
    // MARK: UnmuteLayer
    
    func test_UnmuteLayer_HasAuthoredActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.SetActive(false)
        }
        
        main.MuteLayer(pathForStage(named: "Model.usda"))
        
        let (token, value) = registerNotification(spherePrim.HasAuthoredActive())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.UnmuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(spherePrim.HasAuthoredActive())
    }
    
    // MARK: MuteAndUnmuteLayers
    
    func test_MuteAndUnmuteLayers_GetAuthoredPropertyNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.CreateAttribute("customAttr", .Bool, true, Overlay.SdfVariabilityVarying)
        }
        
        let (token, value) = registerNotification(spherePrim.GetAuthoredPropertyNames(Overlay.DefaultPropertyPredicateFunc))
        XCTAssertEqual(value, ["customAttr"])
        
        expectingSomeNotifications([token], main.MuteAndUnmuteLayers([pathForStage(named: "Model.usda")], []))
        XCTAssertEqual(spherePrim.GetAuthoredPropertyNames(Overlay.DefaultPropertyPredicateFunc), [])
    }
    
    // MARK: SetMetadata
    
    func test_SetMetadata_HasAttribute() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.CreateAttribute("myAttr", .Color3f, true, Overlay.SdfVariabilityVarying)
                        
        let (token, value) = registerNotification(spherePrim.HasAttribute("myAttr"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.SetMetadata("subLayers", pxr.VtValue([] as Overlay.String_Vector)))
        XCTAssertFalse(spherePrim.HasAttribute("myAttr"))
        
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasAttribute() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.CreateAttribute("myAttr", .Color3f, true, Overlay.SdfVariabilityVarying)
                        
        let (token, value) = registerNotification(spherePrim.HasAttribute("myAttr"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadata("subLayers"))
        XCTAssertFalse(spherePrim.HasAttribute("myAttr"))
        
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_HasAttribute() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("noAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            spherePrim.CreateAttribute("myAttr", .Bool, true, Overlay.SdfVariabilityVarying)
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        
        let (token, value) = registerNotification(spherePrim.HasAttribute("myAttr"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string)))
        XCTAssertTrue(spherePrim.HasAttribute("myAttr"))
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_HasAttribute() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            spherePrim.CreateAttribute("myAttr", .Bool, true, Overlay.SdfVariabilityVarying)
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        
        let (token, value) = registerNotification(spherePrim.HasAttribute("myAttr"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR"))
        XCTAssertFalse(spherePrim.HasAttribute("myAttr"))
    }
    
    // MARK: Reload
    
    func test_Reload_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        main.Save()
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            spherePrim.SetActive(false)
        }
        
        let (token, value) = registerNotification(spherePrim.IsActive())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.Reload())
        XCTAssertTrue(spherePrim.IsActive())
    }
    
    // MARK: OverridePrim
    
    func test_OverridePrim_GetAllChildren() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Plane")
        
        let (token, value) = registerNotification(foo.GetAllChildren())
        XCTAssertEqual(Array(value), [])

        expectingSomeNotifications([token], main.OverridePrim("/foo/bar"))
        XCTAssertEqual(Array(foo.GetAllChildren()), [main.GetPrimAtPath("/foo/bar")])
    }
    
    // MARK: DefinePrim
    
    func test_DefinePrim_GetChildren() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Plane")
        
        let (token, value) = registerNotification(foo.GetChildren())
        XCTAssertEqual(Array(value), [])

        expectingSomeNotifications([token], main.DefinePrim("/foo/bar", "Sphere"))
        XCTAssertEqual(Array(foo.GetChildren()), [main.GetPrimAtPath("/foo/bar")])
    }
    
    func test_DefinePrim_GetPropertyAtPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Plane")
        
        let (token, value) = registerNotification(foo.GetPropertyAtPath("bar.radius").IsValid())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.DefinePrim("/foo/bar", "Sphere"))
        XCTAssertTrue(foo.GetPropertyAtPath("bar.radius").IsValid())
    }
    
    // MARK: CreateClassPrim
    
    func test_CreateClassPrim_GetTypeName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let defPrim = main.DefinePrim("/foo", "")
        var inherits = defPrim.GetInherits()
        inherits.AddInherit("/_class_bar", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(defPrim.GetTypeName())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token]) {
            main.CreateClassPrim("/_class_bar").SetTypeName("Sphere")
        }
        XCTAssertEqual(defPrim.GetTypeName(), "Sphere")
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_GetAllChildrenNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let p = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        main.DefinePrim("/foo/baz", "Sphere")
        
        let (token, value) = registerNotification(p.GetAllChildrenNames())
        XCTAssertEqual(value, ["bar", "baz"])
        
        expectingSomeNotifications([token], main.RemovePrim("/foo/bar"))
        XCTAssertEqual(p.GetAllChildrenNames(), ["baz"])
    }
}
