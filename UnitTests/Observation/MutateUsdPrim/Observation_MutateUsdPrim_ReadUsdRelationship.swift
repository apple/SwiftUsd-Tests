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

final class Observation_MutateUsdPrim_ReadUsdRelationship: ObservationHelper {

    // MARK: SetTypeName
    
    func test_SetTypeName_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let rel = p.CreateRelationship("myRel", true)
        rel.AddTarget(".prototypes", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.prototypes"])
        
        expectingSomeNotifications([token], p.SetTypeName("PointInstancer"))
        XCTAssertFalse(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: ClearTypeName
    
    func test_ClearTypeName_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "PointInstancer")
        let rel = p.CreateRelationship("myRel", true)
        rel.AddTarget(".prototypes", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.prototypes"])
    }
    
    // MARK: SetActive
    
    func test_SetActive_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/p", "Sphere")
        let rel = p.CreateRelationship("myRel", true)
        rel.AddTarget("/foo/bar.prototypes", Overlay.UsdListPositionBackOfPrependList)
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "PointInstancer")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], foo.SetActive(false))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo/bar.prototypes"])
    }
    
    // MARK: ClearActive
    
    func test_ClearActive_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/p", "Sphere")
        let rel = p.CreateRelationship("myRel", true)
        rel.AddTarget("/foo/bar.prototypes", Overlay.UsdListPositionBackOfPrependList)
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "PointInstancer")
        foo.SetActive(false)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo/bar.prototypes"])
        
        expectingSomeNotifications([token], foo.ClearActive())
        XCTAssertFalse(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: RemoveProperty
    
    func test_RemoveProperty_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        var p = main.DefinePrim("/p", "Sphere")
        
        let myRel = p.CreateRelationship("myRel", true)
        myRel.AddTarget(".otherRel", Overlay.UsdListPositionBackOfPrependList)
        let otherRel = p.CreateRelationship("otherRel", true)
        otherRel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(myRel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/p.radius"])
        
        expectingSomeNotifications([token], p.RemoveProperty("otherRel"))
        XCTAssertTrue(myRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/p.otherRel"])

    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let myRel = foo.CreateRelationship("myRel", true)
        myRel.AddTarget(".physics:simulationOwner", Overlay.UsdListPositionBackOfPrependList)
        

        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(myRel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.physics:simulationOwner"])
        
        expectingSomeNotifications([token], foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(myRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: RemoveAppliedSchema
    
    func test_RemoveAppliedSchema_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let myRel = foo.CreateRelationship("myRel", true)
        myRel.AddTarget(".physics:simulationOwner", Overlay.UsdListPositionBackOfPrependList)
        

        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(myRel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], foo.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(myRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.physics:simulationOwner"])
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let myRel = foo.CreateRelationship("myRel", true)
        myRel.AddTarget(".physics:simulationOwner", Overlay.UsdListPositionBackOfPrependList)
        

        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(myRel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.physics:simulationOwner"])
        
        expectingSomeNotifications([token], foo.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(myRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let myRel = foo.CreateRelationship("myRel", true)
        myRel.AddTarget(".physics:simulationOwner", Overlay.UsdListPositionBackOfPrependList)
        

        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(myRel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], foo.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(myRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.physics:simulationOwner"])
    }
    
    // MARK: CreateRelationship
    
    func test_CreateRelationship_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let firstRel = foo.CreateRelationship("firstRel", true)
        firstRel.AddTarget(".secondRel", Overlay.UsdListPositionBackOfPrependList)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(firstRel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.secondRel"])
        
        expectingSomeNotifications([token], foo.CreateRelationship("secondRel", true))
        XCTAssertFalse(firstRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_HasAuthoredTargets() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        let payloadRel = payload.DefinePrim("/root/model", "Sphere").CreateRelationship("myRel", true)
        payloadRel.AddTarget("myTarget", Overlay.UsdListPositionBackOfPrependList)
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        main.OverridePrim("/foo/model").CreateRelationship("myRel", true)
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        let rel = foo.GetRelationshipAtPath("model.myRel")
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_HasAuthoredTargets() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        let payloadRel = payload.DefinePrim("/root/model", "Sphere").CreateRelationship("myRel", true)
        payloadRel.AddTarget("myTarget", Overlay.UsdListPositionBackOfPrependList)
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        main.OverridePrim("/foo/model").CreateRelationship("myRel", true)
        let rel = foo.GetRelationshipAtPath("model.myRel")
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertTrue(rel.HasAuthoredTargets())
    }
    
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
        
        expectingSomeNotifications([token], scopePrim.Load(Overlay.UsdLoadWithDescendants))
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
        
        expectingSomeNotifications([token], scopePrim.Unload())
        XCTAssertTrue(relationship.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/bigModel.otherRel"])

    }
    
    // MARK: SetInstanceable
    
    func test_SetInstanceable_GetForwardedTargets() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        mainStage.DefinePrim("/instanceTarget", "Scope")
        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetReferences().AddInternalReference("/instanceTarget", pxr.SdfLayerOffset(0, 1), Overlay.UsdListPositionBackOfPrependList)
        let firstRel = scopePrim.CreateRelationship("firstRel", true)
        firstRel.AddTarget("child.myProperty", Overlay.UsdListPositionBackOfPrependList)
        mainStage.DefinePrim("/smallModel/child", "Sphere").CreateRelationship("myProperty", true)
            .AddTarget(".fizz", Overlay.UsdListPositionBackOfPrependList)

        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(firstRel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/smallModel/child.fizz"])
        
        expectingSomeNotifications([token], scopePrim.SetInstanceable(true))
        XCTAssertTrue(firstRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/child.myProperty"])
    }
    
    // MARK: ClearInstanceable
    
    func test_ClearInstanceable_GetForwardedTargets() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        mainStage.DefinePrim("/instanceTarget", "Scope")
        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetReferences().AddInternalReference("/instanceTarget", pxr.SdfLayerOffset(0, 1), Overlay.UsdListPositionBackOfPrependList)
        let firstRel = scopePrim.CreateRelationship("firstRel", true)
        firstRel.AddTarget("child.myProperty", Overlay.UsdListPositionBackOfPrependList)
        mainStage.DefinePrim("/smallModel/child", "Sphere").CreateRelationship("myProperty", true)
            .AddTarget(".fizz", Overlay.UsdListPositionBackOfPrependList)
        scopePrim.SetInstanceable(true)

        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(firstRel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/smallModel/child.myProperty"])
        
        expectingSomeNotifications([token], scopePrim.ClearInstanceable())
        XCTAssertTrue(firstRel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/smallModel/child.fizz"])
    }
}
