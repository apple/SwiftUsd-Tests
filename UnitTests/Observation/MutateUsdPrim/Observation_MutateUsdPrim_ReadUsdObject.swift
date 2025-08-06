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

final class Observation_MutateUsdPrim_ReadUsdObject: ObservationHelper {

    // MARK: SetSpecifier

    func test_SetSpecifier_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(p.GetMetadata("specifier", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(Overlay.SdfSpecifierDef))
        
        expectingSomeNotifications([token], p.SetSpecifier(Overlay.SdfSpecifierClass))
        XCTAssertTrue(p.GetMetadata("specifier", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(Overlay.SdfSpecifierClass))
    }

    // MARK: SetTypeName
    
    func test_SetTypeName_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(p.GetMetadata("typeName", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("Cube" as pxr.TfToken))
        
        expectingSomeNotifications([token], p.SetTypeName("Sphere"))
        XCTAssertTrue(p.GetMetadata("typeName", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("Sphere" as pxr.TfToken))
    }
    
    // MARK: ClearTypeName
    
    func test_ClearTypeName_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(p.HasMetadata("typeName"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertFalse(p.HasMetadata("typeName"))
    }
    
    // MARK: SetActive
    
    func test_SetActive_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        let p = main.DefinePrim("/foo/p", "Sphere")

        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.SetActive(false))
        XCTAssertFalse(Bool(p))
    }
    
    // MARK: ClearActive
    
    func test_ClearActive_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        foo.SetActive(true)

        let (token, value) = registerNotification(foo.HasAuthoredMetadata("active"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearActive())
        XCTAssertFalse(foo.HasAuthoredMetadata("active"))
    }
    
    // MARK: SetPropertyOrder
    
    func test_SetPropertyOrder_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(foo.HasAuthoredMetadata("propertyOrder"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetPropertyOrder(["alpha"]))
        XCTAssertTrue(foo.HasAuthoredMetadata("propertyOrder"))
    }
    
    // MARK: ClearPropertyOrder
    
    func test_ClearPropertyOrder_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        foo.SetPropertyOrder(["alpha"])

        let (token, value) = registerNotification(foo.HasAuthoredMetadata("propertyOrder"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearPropertyOrder())
        XCTAssertFalse(foo.HasAuthoredMetadata("propertyOrder"))
    }
    
    // MARK: RemoveProperty
    
    func test_RemoveProperty_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        var p = main.DefinePrim("/foo", "Cube")
        let attr = p.CreateAttribute("alpha", .Double, true, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attr.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.RemoveProperty("alpha"))
        XCTAssertFalse(attr.IsValid())
    }
    
    // MARK: SetKind
    
    func test_SetKind_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(p.HasMetadata("kind"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetKind("component"))
        XCTAssertTrue(p.HasMetadata("kind"))
    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(p.HasAuthoredMetadata("apiSchemas"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(p.HasAuthoredMetadata("apiSchemas"))
    }
    
    // MARK: RemoveAppliedSchema
    
    func test_RemoveAppliedSchema_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        var vtValue = pxr.VtValue()
        var listOp = pxr.SdfTokenListOp()
        listOp.SetItems(["PhysicsRigidBodyAPI"], Overlay.SdfListOpTypeExplicit, nil)
        let (token, value) = registerNotification(p.GetMetadata("apiSchemas", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(listOp))
        
        expectingSomeNotifications([token], p.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        listOp.Clear()
        listOp.SetItems([], Overlay.SdfListOpTypeExplicit, nil)
        XCTAssertTrue(p.GetMetadata("apiSchemas", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(listOp))
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(p.HasAuthoredMetadata("apiSchemas"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(p.HasAuthoredMetadata("apiSchemas"))
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        var vtValue = pxr.VtValue()
        var listOp = pxr.SdfTokenListOp()
        listOp.SetItems(["PhysicsRigidBodyAPI"], Overlay.SdfListOpTypeExplicit, nil)
        let (token, value) = registerNotification(p.GetMetadata("apiSchemas", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(listOp))
        
        expectingSomeNotifications([token], p.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        listOp.Clear()
        listOp.SetItems([], Overlay.SdfListOpTypeExplicit, nil)
        XCTAssertTrue(p.GetMetadata("apiSchemas", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(listOp))
    }
    
    // MARK: SetChildrenReorder
    
    func test_SetChildrenReorder_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        main.DefinePrim("/foo/delta", "Sphere")
        
        
        let (token, value) = registerNotification(foo.HasMetadata("primOrder"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetChildrenReorder(["delta", "bar"]))
        XCTAssertTrue(foo.HasMetadata("primOrder"))
    }
    
    // MARK: ClearChildrenReorder
    
    func test_ClearChildrenReorder_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        main.DefinePrim("/foo/delta", "Sphere")
        foo.SetChildrenReorder(["delta", "bar"])
        
        let (token, value) = registerNotification(foo.HasMetadata("primOrder"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearChildrenReorder())
        XCTAssertFalse(foo.HasMetadata("primOrder"))
    }
    
    // MARK: CreateAttribute
    
    func test_CreateAttribute_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let attr = foo.GetAttribute("myAttr")

        let (token, value) = registerNotification(Bool(attr))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertTrue(Bool(attr))
    }
    
    // MARK: CreateRelationship
    
    func test_CreateRelationship_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let rel = foo.GetRelationship("myRel")

        let (token, value) = registerNotification(Bool(rel))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertTrue(Bool(rel))
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_HasMetadata() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        
        
        let (token, value) = registerNotification(foo.HasMetadata("payload"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertFalse(foo.HasMetadata("payload"))
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_HasMetadata() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        
        
        let (token, value) = registerNotification(foo.HasMetadata("payload"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertTrue(foo.HasMetadata("payload"))
    }
    
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
        
        expectingSomeNotifications([token], scopePrim.Load(Overlay.UsdLoadWithDescendants))
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
        
        expectingSomeNotifications([token], scopePrim.Unload())
        XCTAssertFalse(Bool(mainStage.GetPrimAtPath("/smallModel/bigModel")))
    }
    
    // MARK: SetInstanceable
    
    func test_SetInstanceable_HasAuthoredMetadata() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")

        let (token, value) = registerNotification(scopePrim.HasAuthoredMetadata("instanceable"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], scopePrim.SetInstanceable(true))
        XCTAssertTrue(scopePrim.HasAuthoredMetadata("instanceable"))
    }
    
    // MARK: ClearInstanceable
    
    func test_ClearInstanceable_HasAuthoredMetadata() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.SetInstanceable(true)

        let (token, value) = registerNotification(scopePrim.HasAuthoredMetadata("instanceable"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], scopePrim.ClearInstanceable())
        XCTAssertFalse(scopePrim.HasAuthoredMetadata("instanceable"))
    }
}
