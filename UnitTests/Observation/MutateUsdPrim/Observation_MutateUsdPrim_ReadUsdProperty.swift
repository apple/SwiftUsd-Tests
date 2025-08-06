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

final class Observation_MutateUsdPrim_ReadUsdProperty: ObservationHelper {

    // MARK: SetTypeName
    
    func test_SetTypeName_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        let attr = p.GetAttribute("size")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.SetTypeName("Sphere"))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: ClearTypeName
    
    func test_ClearTypeName_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        let attr = p.GetAttribute("size")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: SetActive
    
    func test_SetActive_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let bar = main.DefinePrim("/bar", "Cube")
        let foo = main.DefinePrim("/bar/foo", "Cube")
        let attr = foo.GetAttribute("size")

        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], bar.SetActive(false))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: ClearActive
    
    func test_ClearActive_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let alpha = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "alpha.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "alpha.usda"), 0)
        let beta = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "beta.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "beta.usda"), 0)

        
        main.SetEditTarget(pxr.UsdEditTarget(alpha.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        let foo = main.DefinePrim("/foo", "Cube")
        foo.SetActive(false)
        
        main.SetEditTarget(pxr.UsdEditTarget(beta.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        foo.SetActive(true)
        
        let attr = main.DefinePrim("/foo/bar", "Cube").GetAttribute("size")

        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
                
        expectingSomeNotifications([token], foo.ClearActive())
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: RemoveProperty
    
    func test_RemoveProperty_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        var p = main.DefinePrim("/foo", "Cube")
        let rel = p.CreateRelationship("alpha", true)
        
        let (token, value) = registerNotification(rel.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.RemoveProperty("alpha"))
        XCTAssertFalse(rel.IsDefined())
    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_IsCustom() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let attr = foo.CreateAttribute("physics:velocity", .Vector3f, true, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(attr.IsCustom())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(attr.IsCustom())
    }
    
    // MARK: RemoveAppliedSchema
    
    func test_RemoveAppliedSchema_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let attr = p.GetAttribute("physics:velocity")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_IsCustom() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let attr = foo.CreateAttribute("physics:velocity", .Vector3f, true, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(attr.IsCustom())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(attr.IsCustom())
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let attr = p.GetAttribute("physics:velocity")
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: CreateAttribute
    
    func test_CreateAttribute_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let attr = foo.GetAttribute("myAttr")

        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertTrue(attr.IsDefined())
    }
    
    // MARK: CreateRelationship
    
    func test_CreateRelationship_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let rel = foo.GetRelationship("myRel")

        let (token, value) = registerNotification(rel.IsDefined())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertTrue(rel.IsDefined())
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_IsDefined() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        let attr = foo.GetAttributeAtPath("model.radius")
        
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_GetPropertyStack() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        let payloadLayer = Overlay.Dereference(payload.GetRootLayer())
        payload.DefinePrim("/root", "")
        let payloadAttr = payload.DefinePrim("/root/model", "Sphere").GetAttribute("radius")
        payloadAttr.Set(7.0, 6.0)
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/model", "Sphere")
        
        let attr = foo.GetAttributeAtPath("model.radius")
        
        
        let (token, value) = registerNotification(attr.GetPropertyStack(6.0))
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertEqual(attr.GetPropertyStack(6.0), [payloadLayer.GetPropertyAtPath("/root/model.radius")])
    }
    
    // MARK: Load

    func test_Load_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], scopePrim.Load(Overlay.UsdLoadWithDescendants))
        XCTAssertTrue(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
    }
    
    // MARK: Unload

    func test_Unload_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], scopePrim.Unload())
        XCTAssertFalse(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
    }
    
    // MARK: SetInstanceable
    
    func test_SetInstanceable_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        mainStage.DefinePrim("/instanceTarget", "Scope")
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetReferences().AddInternalReference("/instanceTarget", pxr.SdfLayerOffset(0, 1), Overlay.UsdListPositionBackOfPrependList)
        let attr = mainStage.DefinePrim("/smallModel/belowInstanceable", "Sphere").GetAttribute("radius")

        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], scopePrim.SetInstanceable(true))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: ClearInstanceable
    
    func test_ClearInstanceable_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        mainStage.DefinePrim("/instanceTarget", "Scope")
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetReferences().AddInternalReference("/instanceTarget", pxr.SdfLayerOffset(0, 1), Overlay.UsdListPositionBackOfPrependList)
        mainStage.DefinePrim("/smallModel/belowInstanceable", "Sphere")
        scopePrim.SetInstanceable(true)

        let (token, value) = registerNotification(mainStage.GetAttributeAtPath("/smallModel/belowInstanceable.radius").IsDefined())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], scopePrim.ClearInstanceable())
        XCTAssertTrue(mainStage.GetAttributeAtPath("/smallModel/belowInstanceable.radius").IsDefined())
    }
}
