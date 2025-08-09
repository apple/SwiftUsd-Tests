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

final class Observation_MutateUsdStage_ReadUsdSchemaBase: ObservationHelper {

    // MARK: Load
    
    func test_Load_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let mainStagePtr = Overlay.TfWeakPtr(mainStage)
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], mainStage.Load("/smallModel", Overlay.UsdLoadWithDescendants))
        XCTAssertTrue(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))

    }
    
    // MARK: Unload
    
    func test_Unload_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let mainStagePtr = Overlay.TfWeakPtr(mainStage)
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.Unload("/smallModel"))
        XCTAssertFalse(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))

    }
    
    // MARK: LoadAndUnload
    
    func test_LoadAndUnload_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let mainStagePtr = Overlay.TfWeakPtr(mainStage)
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.LoadAndUnload([], ["/smallModel"], Overlay.UsdLoadWithDescendants))
        XCTAssertFalse(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))

    }
    
    // MARK: SetLoadRules
    
    func test_SetLoadRules_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let mainStagePtr = Overlay.TfWeakPtr(mainStage)
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], mainStage.SetLoadRules(pxr.UsdStageLoadRules.LoadAll()))
        XCTAssertTrue(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))

    }
    
    // MARK: SetPopulationMask
    
    func test_SetPopulationMask_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let mainStagePtr = Overlay.TfWeakPtr(mainStage)
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.SetPopulationMask(pxr.UsdStagePopulationMask()))
        XCTAssertFalse(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))

    }
    
    // MARK: MuteLayer
    
    func test_MuteLayer_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        }
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: UnmuteLayer
    
    func test_UnmuteLayer_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        }
        
        main.MuteLayer(pathForStage(named: "Model.usda"))
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.UnmuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertTrue(Bool(pxr.UsdGeomSphere.Get(Overlay.TfWeakPtr(main), "/hi")))
    }
    
    // MARK: MuteAndUnmuteLayers
    
    func test_MuteAndUnmuteLayers_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        }
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.MuteAndUnmuteLayers([pathForStage(named: "Model.usda")], []))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: SetMetadata
    
    func test_SetMetadata_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        }
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.SetMetadata("subLayers", pxr.VtValue([] as Overlay.String_Vector)))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        }
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadata("subLayers"))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("noAttr" as std.string))
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("noAttr")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi/there")
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string)))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("noAttr" as std.string))
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("noAttr")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi/there")
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR"))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: Reload
    
    func test_Reload_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        var schema = pxr.UsdGeomSphere(pxr.UsdPrim())
        
        main.Save()
                
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        }
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.Reload())
        XCTAssertFalse(Bool(schema))
    }
    
    func test_DefinePrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
                
        let (token, value) = registerNotification(Bool(pxr.UsdGeomSphere(main.GetPrimAtPath("/foo"))))
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.DefinePrim("/foo", "Sphere"))
        XCTAssertTrue(Bool(pxr.UsdGeomSphere(main.GetPrimAtPath("/foo"))))
    }
    
    // MARK: CreateClassPrim
    
    func test_CreateClassPrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let defPrim = main.DefinePrim("/foo", "Sphere")
        var inherits = defPrim.GetInherits()
        inherits.AddInherit("/_class_bar", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(pxr.UsdPhysicsRigidBodyAPI(defPrim))
        XCTAssertFalse(Bool(value))
        
        expectingSomeNotifications([token]) {
            main.CreateClassPrim("/_class_bar").ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        }
        XCTAssertTrue(Bool(pxr.UsdPhysicsRigidBodyAPI(defPrim)))
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let p = main.DefinePrim("/foo", "Sphere")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        main.SetEditTarget(modelEditTarget)
        p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let api = pxr.UsdPhysicsRigidBodyAPI(p)
        
                                
        let (token, value) = registerNotification(Bool(api))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.RemovePrim("/foo"))
        XCTAssertFalse(Bool(api))
    }
    
    // MARK: dtor
    
    func test_dtor_operatorBool() {
        var main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token]) { main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll)) }
        XCTAssertFalse(Bool(p))
    }
}
