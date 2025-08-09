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

final class Observation_MutateUsdStage_ReadUsdRelationship: ObservationHelper {

    // MARK: Load

    func test_Load_GetForwardedTargets() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        let bigModelPrim = payloadStage.DefinePrim("/scope/bigModel", "Plane")
        bigModelPrim.CreateRelationship("otherRel", true).AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let rootPrim = mainStage.DefinePrim("/root", "Cube")
        let relationship = rootPrim.CreateRelationship("myRel", true)
        relationship.AddTarget("/smallModel/bigModel.otherRel", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(relationship.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/smallModel/bigModel.otherRel"])
        
        expectingSomeNotifications([token], mainStage.Load("/smallModel", Overlay.UsdLoadWithDescendants))
        XCTAssertTrue(relationship.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/bigModel.doubleSided"])
    }
    
    // MARK: Unload

    func test_Unload_GetForwardedTargets() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        let bigModelPrim = payloadStage.DefinePrim("/scope/bigModel", "Plane")
        bigModelPrim.CreateRelationship("otherRel", true).AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let rootPrim = mainStage.DefinePrim("/root", "Cube")
        let relationship = rootPrim.CreateRelationship("myRel", true)
        relationship.AddTarget("/smallModel/bigModel.otherRel", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(relationship.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/smallModel/bigModel.doubleSided"])
        
        expectingSomeNotifications([token], mainStage.Unload("/smallModel"))
        XCTAssertTrue(relationship.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/bigModel.otherRel"])

    }
    
    // MARK: LoadAndUnload

    func test_LoadAndUnload_GetForwardedTargets() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        let bigModelPrim = payloadStage.DefinePrim("/scope/bigModel", "Plane")
        bigModelPrim.CreateRelationship("otherRel", true).AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let rootPrim = mainStage.DefinePrim("/root", "Cube")
        let relationship = rootPrim.CreateRelationship("myRel", true)
        relationship.AddTarget("/smallModel/bigModel.otherRel", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(relationship.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/smallModel/bigModel.doubleSided"])
        
        expectingSomeNotifications([token], mainStage.LoadAndUnload([], ["/smallModel"], Overlay.UsdLoadWithDescendants))
        XCTAssertTrue(relationship.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/bigModel.otherRel"])

    }
    
    // MARK: SetLoadRules

    func test_SetLoadRules_GetForwardedTargets() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        let bigModelPrim = payloadStage.DefinePrim("/scope/bigModel", "Plane")
        bigModelPrim.CreateRelationship("otherRel", true).AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let rootPrim = mainStage.DefinePrim("/root", "Cube")
        let relationship = rootPrim.CreateRelationship("myRel", true)
        relationship.AddTarget("/smallModel/bigModel.otherRel", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(relationship.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/smallModel/bigModel.otherRel"])
        
        expectingSomeNotifications([token], mainStage.SetLoadRules(pxr.UsdStageLoadRules.LoadAll()))
        XCTAssertTrue(relationship.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/bigModel.doubleSided"])
    }
    
    // MARK: SetPopulationMask

    func test_SetPopulationMask_GetForwardedTargets() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        let bigModelPrim = payloadStage.DefinePrim("/scope/bigModel", "Plane")
        bigModelPrim.CreateRelationship("otherRel", true).AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let rootPrim = mainStage.DefinePrim("/root", "Cube")
        let relationship = rootPrim.CreateRelationship("myRel", true)
        relationship.AddTarget("/smallModel/bigModel.otherRel", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(relationship.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/smallModel/bigModel.doubleSided"])
        
        expectingSomeNotifications([token], mainStage.SetPopulationMask(pxr.UsdStagePopulationMask().GetUnion("/root")))
        XCTAssertTrue(relationship.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/bigModel.otherRel"])

    }
    
    // MARK: MuteLayer
    
    func test_MuteLayer_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        
        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let bigRelationship = bigModelPrim.CreateRelationship("otherRel", true)
        bigRelationship.AddTarget(".foobar", Overlay.UsdListPositionBackOfPrependList)
        let rootPrim = main.DefinePrim("/root", "Cube")
        let rootRelationship = rootPrim.CreateRelationship("myRel", true)
        rootRelationship.AddTarget("/bigModel.otherRel", Overlay.UsdListPositionBackOfPrependList)
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            bigRelationship.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        }
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rootRelationship.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/bigModel.foobar", "/bigModel.doubleSided"])

        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(rootRelationship.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/bigModel.foobar"])
    }
    
    // MARK: UnmuteLayer
    
    func test_UnmuteLayer_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        
        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let bigRelationship = bigModelPrim.CreateRelationship("otherRel", true)
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            bigRelationship.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        }
        
        
        main.MuteLayer(pathForStage(named: "Model.usda"))
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(bigRelationship.GetTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])

        
        expectingSomeNotifications([token], main.UnmuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(bigRelationship.GetTargets(&targets))
        XCTAssertEqual(targets, ["/bigModel.doubleSided"])
    }
    
    // MARK: MuteAndUnmuteLayers
    
    func test_MuteAndUnmuteLayers_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        
        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let bigRelationship = bigModelPrim.CreateRelationship("otherRel", true)
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            bigRelationship.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        }
        
        
        let (token, value) = registerNotification(bigRelationship.HasAuthoredTargets())
        XCTAssertTrue(value)

        
        expectingSomeNotifications([token], main.MuteAndUnmuteLayers([pathForStage(named: "Model.usda")], []))
        XCTAssertFalse(bigRelationship.HasAuthoredTargets())
    }
    
    // MARK: SetMetadata
    
    func test_SetMetadata_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let bigRelationship = bigModelPrim.CreateRelationship("otherRel", true)
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            bigRelationship.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        }
        
        
        let (token, value) = registerNotification(bigRelationship.HasAuthoredTargets())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], main.SetMetadata("subLayers", pxr.VtValue([] as Overlay.String_Vector)))
        XCTAssertFalse(bigRelationship.HasAuthoredTargets())
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let bigRelationship = bigModelPrim.CreateRelationship("otherRel", true)
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            bigRelationship.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        }
        
        
        let (token, value) = registerNotification(bigRelationship.HasAuthoredTargets())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], main.ClearMetadata("subLayers"))
        XCTAssertFalse(bigRelationship.HasAuthoredTargets())
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("noAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        
        let rel = spherePrim.CreateRelationship("myRel", true)
        rel.AddTarget(".foo", Overlay.UsdListPositionBackOfPrependList)
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            rel.AddTarget(".bar", Overlay.UsdListPositionBackOfPrependList)
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/hi.foo"])
        
        
        expectingSomeNotifications([token], main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string)))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/hi.foo", "/hi.bar"])
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        
        let rel = spherePrim.CreateRelationship("myRel", true)
        rel.AddTarget(".foo", Overlay.UsdListPositionBackOfPrependList)
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            rel.AddTarget(".bar", Overlay.UsdListPositionBackOfPrependList)
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/hi.foo", "/hi.bar"])
        
        
        expectingSomeNotifications([token], main.ClearMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR"))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/hi.foo"])
    }
    
    // MARK: Reload
    
    func test_Reload_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        let rel = spherePrim.CreateRelationship("myRel", true)
        rel.AddTarget(".foo", Overlay.UsdListPositionBackOfPrependList)
        main.Save()
        rel.AddTarget(".bar", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/hi.foo", "/hi.bar"])
                
        expectingSomeNotifications([token], main.Reload())
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/hi.foo"])
    }
    
    // MARK: DefinePrim
    
    func test_DefinePrim_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
                
        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let mainRel = bigModelPrim.CreateRelationship("mainRel", true)
        mainRel.AddTarget("/bigModel.otherRel", Overlay.UsdListPositionBackOfPrependList)
        let otherRelationship = bigModelPrim.CreateRelationship("otherRel", true)
        otherRelationship.AddTarget("child.prototypes", Overlay.UsdListPositionBackOfPrependList)

        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(mainRel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/bigModel/child.prototypes"])

        expectingSomeNotifications([token], main.DefinePrim("/bigModel/child", "PointInstancer"))
        XCTAssertFalse(mainRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: CreateClassPrim
    
    func test_CreateClassPrim_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let defPrim = main.DefinePrim("/foo", "PointInstancer")
        var inherits = defPrim.GetInherits()
        inherits.AddInherit("/_class_bar", Overlay.UsdListPositionBackOfPrependList)
        let defRel = defPrim.CreateRelationship("mainRel", true)
        defRel.AddTarget(".otherRel", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(defRel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.otherRel"])

        expectingSomeNotifications([token]) {
            main.CreateClassPrim("/_class_bar").CreateRelationship("mainRel", true).AddTarget(".prototypes", Overlay.UsdListPositionBackOfPrependList)
        }
        
        XCTAssertTrue(defRel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.otherRel", "/foo.prototypes"])
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let p = main.DefinePrim("/foo", "Sphere")
        let rel = p.CreateRelationship("myRel", true)
        rel.AddTarget(".bar", Overlay.UsdListPositionBackOfPrependList)
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        main.SetEditTarget(modelEditTarget)
        rel.AddTarget(".baz", Overlay.UsdListPositionBackOfPrependList)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.bar", "/foo.baz"])

                
        expectingSomeNotifications([token], main.RemovePrim("/foo"))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.bar"])
    }
}
