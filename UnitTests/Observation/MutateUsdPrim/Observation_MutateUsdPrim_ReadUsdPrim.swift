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

final class Observation_MutateUsdPrim_ReadUsdPrim: ObservationHelper {

    // MARK: SetSpecifier

    func test_SetSpecifier_GetSpecifier() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(p.GetSpecifier())
        XCTAssertEqual(value, Overlay.SdfSpecifierDef)
        
        expectingSomeNotifications([token], p.SetSpecifier(Overlay.SdfSpecifierClass))
        XCTAssertEqual(p.GetSpecifier(), Overlay.SdfSpecifierClass)
    }

    // MARK: SetTypeName
    
    func test_SetTypeName_GetTypeName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(p.GetTypeName())
        XCTAssertEqual(value, "Cube")
        
        expectingSomeNotifications([token], p.SetTypeName("Sphere"))
        XCTAssertEqual(p.GetTypeName(), "Sphere")
    }
    
    // MARK: ClearTypeName
    
    func test_ClearTypeName_HasProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(p.HasProperty("size"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertFalse(p.HasProperty("size"))
    }
    
    // MARK: SetActive
    
    func test_SetActive_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(p.IsActive())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.SetActive(false))
        XCTAssertFalse(p.IsActive())
    }
    
    func test_SetActive_GetChildrenNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        let p = main.DefinePrim("/foo/p", "Sphere")

        let (token, value) = registerNotification(foo.GetChildrenNames())
        XCTAssertEqual(value, ["p"])
        
        expectingSomeNotifications([token], p.SetActive(false))
        XCTAssertEqual(foo.GetChildrenNames(), [])
    }
    
    // MARK: ClearActive
    
    func test_ClearActive_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.SetActive(false)

        let (token, value) = registerNotification(p.IsActive())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.ClearActive())
        XCTAssertTrue(p.IsActive())
    }
    
    // MARK: SetPropertyOrder
    
    func test_SetPropertyOrder_GetPropertyNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "")
        p.CreateRelationship("alpha", true)
        p.CreateRelationship("beta", true)
        
        
        let (token, value) = registerNotification(p.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc))
        XCTAssertEqual(value, ["alpha", "beta"])
        
        expectingSomeNotifications([token], p.SetPropertyOrder(["beta", "alpha"]))
        XCTAssertEqual(p.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc), ["beta", "alpha"])
    }
    
    func test_SetPropertyOrder_GetProperties() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "")
        let alpha = p.CreateRelationship("alpha", true)
        let beta = p.CreateRelationship("beta", true)
        
        
        let (token, value) = registerNotification(p.GetProperties(Overlay.DefaultPropertyPredicateFunc))
        XCTAssertEqual(value.map { Overlay.UsdProperty_As($0) }, [alpha, beta])
        
        expectingSomeNotifications([token], p.SetPropertyOrder(["beta", "alpha"]))
        XCTAssertEqual(p.GetProperties(Overlay.DefaultPropertyPredicateFunc).map { Overlay.UsdProperty_As($0) }, [beta, alpha])
    }
    
    func test_SetPropertyOrder_GetPropertyOrder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.CreateRelationship("alpha", true)
        p.CreateRelationship("beta", true)
        
        
        let (token, value) = registerNotification(p.GetPropertyOrder())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], p.SetPropertyOrder(["beta", "alpha"]))
        XCTAssertEqual(p.GetPropertyOrder(), ["beta", "alpha"])
    }
    
    // MARK: ClearPropertyOrder
    
    func test_ClearPropertyOrder_GetPropertyOrder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.CreateRelationship("alpha", true)
        p.CreateRelationship("beta", true)
        p.SetPropertyOrder(["beta", "alpha"])
        
        
        let (token, value) = registerNotification(p.GetPropertyOrder())
        XCTAssertEqual(value, ["beta", "alpha"])
        
        expectingSomeNotifications([token], p.ClearPropertyOrder())
        XCTAssertEqual(p.GetPropertyOrder(), [])
    }
    
    // MARK: RemoveProperty
    
    func test_RemoveProperty_HasProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        var p = main.DefinePrim("/foo", "Cube")
        p.CreateRelationship("alpha", true)
        
        let (token, value) = registerNotification(p.HasProperty("alpha"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.RemoveProperty("alpha"))
        XCTAssertFalse(p.HasProperty("alpha"))
    }
    
    // MARK: SetKind
    
    func test_SetKind_IsModel_reliesOnSelf() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(p.IsModel())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetKind("component"))
        XCTAssertTrue(p.IsModel())
    }
    
    func test_SetKind_IsModel_reliesOnParent() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        main.DefinePrim("/foo", "Cube").SetKind("group")
        let bar = main.DefinePrim("/foo/bar", "Cube")
        let p = main.DefinePrim("/foo/bar/p", "Cube")
        p.SetKind("component")
        
        let (token, value) = registerNotification(p.IsModel())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], bar.SetKind("assembly"))
        XCTAssertTrue(p.IsModel())
    }
    
    func test_SetKind_IsGroup_reliesOnSelf() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))

        let foo = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(foo.IsGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetKind("group"))
        XCTAssertTrue(foo.IsGroup())
    }
    
    func test_SetKind_IsGroup_reliesOnParent() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        main.DefinePrim("/foo", "Cube").SetKind("group")
        let bar = main.DefinePrim("/foo/bar", "Cube")
        bar.SetKind("component")
        let fizz = main.DefinePrim("/foo/bar/fizz", "Cube")
        fizz.SetKind("group")
        
        let (token, value) = registerNotification(fizz.IsGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], bar.SetKind("group"))
        XCTAssertTrue(fizz.IsGroup())
    }
    
    func test_SetKind_IsComponent_reliesOnSelf() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(foo.IsComponent())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetKind("component"))
        XCTAssertTrue(foo.IsComponent())
    }
    
    func test_SetKind_IsComponent_reliesOnParent_becomeAssembly() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.DefinePrim("/foo", "Cube").SetKind("group")
        let bar = main.DefinePrim("/foo/bar", "Cube")
        let fizz = main.DefinePrim("/foo/bar/fizz", "Cube")
        fizz.SetKind("component")
        
        let (token, value) = registerNotification(fizz.IsComponent())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], bar.SetKind("assembly"))
        XCTAssertTrue(fizz.IsComponent())
    }
    
    func test_SetKind_IsComponent_reliesOnParent_componentToGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.DefinePrim("/foo", "Cube").SetKind("group")
        let bar = main.DefinePrim("/foo/bar", "Cube")
        bar.SetKind("component")
        let fizz = main.DefinePrim("/foo/bar/fizz", "Cube")
        fizz.SetKind("component")
        
        let (token, value) = registerNotification(fizz.IsComponent())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], bar.SetKind("group"))
        XCTAssertTrue(fizz.IsComponent())
    }
    
    func test_SetKind_IsSubComponent() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(foo.IsSubComponent())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetKind("subcomponent"))
        XCTAssertTrue(foo.IsSubComponent())
    }
    
    func test_SetKind_GetKind() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")

        var kind = pxr.TfToken()
        let (token, value) = registerNotification(foo.GetKind(&kind))
        XCTAssertFalse(value)
        XCTAssertEqual(kind, "")
        
        expectingSomeNotifications([token], foo.SetKind("group"))
        XCTAssertTrue(foo.GetKind(&kind))
        XCTAssertEqual(kind, "group")
    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_GetAppliedSchemas() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(p.GetAppliedSchemas())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(p.GetAppliedSchemas(), [.UsdPhysicsTokens.PhysicsRigidBodyAPI])
    }
    
    // MARK: RemoveAppliedSchema
    
    func test_RemoveAppliedSchema_GetAppliedSchemas() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        let (token, value) = registerNotification(p.GetAppliedSchemas())
        XCTAssertEqual(value, [.UsdPhysicsTokens.PhysicsRigidBodyAPI])
        
        expectingSomeNotifications([token], p.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(p.GetAppliedSchemas(), [])
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_GetAppliedSchemas() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(p.GetAppliedSchemas())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(p.GetAppliedSchemas(), [.UsdPhysicsTokens.PhysicsRigidBodyAPI])
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_GetAppliedSchemas() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        let (token, value) = registerNotification(p.GetAppliedSchemas())
        XCTAssertEqual(value, [.UsdPhysicsTokens.PhysicsRigidBodyAPI])
        
        expectingSomeNotifications([token], p.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(p.GetAppliedSchemas(), [])
    }
    
    // MARK: SetChildrenReorder
    
    func test_SetChildrenReorder_GetChildren() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        let delta = main.DefinePrim("/foo/delta", "Sphere")
        
        
        let (token, value) = registerNotification(Array(foo.GetChildren()))
        XCTAssertEqual(value, [bar, delta])
        
        expectingSomeNotifications([token], foo.SetChildrenReorder(["delta", "bar"]))
        XCTAssertEqual(Array(foo.GetChildren()), [delta, bar])
    }
    
    func test_SetChildrenReorder_GetChildrenReorder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        main.DefinePrim("/foo/delta", "Sphere")
        
        
        let (token, value) = registerNotification(foo.GetChildrenReorder())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], foo.SetChildrenReorder(["delta", "bar"]))
        XCTAssertEqual(foo.GetChildrenReorder(), ["delta", "bar"])
    }
    
    // MARK: ClearChildrenReorder
    
    func test_ClearChildrenReorder_GetChildren() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        let delta = main.DefinePrim("/foo/delta", "Sphere")
        foo.SetChildrenReorder(["delta", "bar"])
        
        let (token, value) = registerNotification(Array(foo.GetChildren()))
        XCTAssertEqual(value, [delta, bar])
        
        expectingSomeNotifications([token], foo.ClearChildrenReorder())
        XCTAssertEqual(Array(foo.GetChildren()), [bar, delta])
    }
    
    func test_ClearChildrenReorder_GetChildrenReorder() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        main.DefinePrim("/foo/delta", "Sphere")
        foo.SetChildrenReorder(["delta", "bar"])
        
        let (token, value) = registerNotification(foo.GetChildrenReorder())
        XCTAssertEqual(value, ["delta", "bar"])
        
        expectingSomeNotifications([token], foo.ClearChildrenReorder())
        XCTAssertEqual(foo.GetChildrenReorder(), [])
    }
    
    // MARK: CreateAttribute
    
    func test_CreateAttribute_GetAuthoredPropertyNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(foo.GetAuthoredPropertyNames(Overlay.DefaultPropertyPredicateFunc))
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertEqual(foo.GetAuthoredPropertyNames(Overlay.DefaultPropertyPredicateFunc), ["myAttr"])
    }
    
    func test_CreateAttribute_GetAttributes() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Scope")

        let (token, value) = registerNotification(foo.GetAttributes())
        XCTAssertEqual(value, [foo.GetAttribute("purpose"), foo.GetAttribute("visibility")])
        
        let attr = expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertEqual(foo.GetAttributes(), [attr, foo.GetAttribute("purpose"), foo.GetAttribute("visibility")])
    }
    
    func test_CreateAttribute_GetAuthoredAttributes() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Scope")

        let (token, value) = registerNotification(foo.GetAuthoredAttributes())
        XCTAssertEqual(value, [])
        
        let attr = expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertEqual(foo.GetAuthoredAttributes(), [attr])
    }
    
    func test_CreateAttribute_HasAttribute() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(foo.HasAttribute("myAttr"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertTrue(foo.HasAttribute("myAttr"))
    }
    
    // MARK: CreateRelationship
    
    func test_CreateRelationship_GetAuthoredPropertyNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(foo.GetAuthoredPropertyNames(Overlay.DefaultPropertyPredicateFunc))
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertEqual(foo.GetAuthoredPropertyNames(Overlay.DefaultPropertyPredicateFunc), ["myRel"])
    }
    
    func test_CreateRelationship_GetRelationships() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(foo.GetRelationships())
        XCTAssertEqual(value, [foo.GetRelationship("proxyPrim")])
        
        let rel = expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertEqual(foo.GetRelationships(), [rel, foo.GetRelationship("proxyPrim")])
    }
    
    func test_CreateRelationship_GetAuthoredRelationships() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(foo.GetAuthoredRelationships())
        XCTAssertEqual(value, [])
        
        let rel = expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertEqual(foo.GetAuthoredRelationships(), [rel])
    }
    
    func test_CreateRelationship_HasRelationship() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(foo.HasRelationship("myRel"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertTrue(foo.HasRelationship("myRel"))
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_HasPayload() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        
        
        let (token, value) = registerNotification(foo.HasPayload())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertFalse(foo.HasPayload())
    }
    
    func test_ClearPayload_HasAuthoredPayloads() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        
        
        let (token, value) = registerNotification(foo.HasAuthoredPayloads())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertFalse(foo.HasAuthoredPayloads())
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_HasPayload() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        
        
        let (token, value) = registerNotification(foo.HasPayload())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertTrue(foo.HasPayload())
    }
    
    func test_SetPayload_HasAuthoredPayloads() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
                
        
        let (token, value) = registerNotification(foo.HasAuthoredPayloads())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertTrue(foo.HasAuthoredPayloads())
    }
    
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
        
        expectingSomeNotifications([token], scopePrim.Load(Overlay.UsdLoadWithDescendants))
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
        
        expectingSomeNotifications([token], scopePrim.Unload())
        XCTAssertEqual(Array(rootPrim.GetAllDescendants()), [mainStage.GetPrimAtPath("/root/smallModel")])
    }
    
    // MARK: SetInstanceable
    
    func test_SetInstanceable_IsInstanceable() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")

        let (token, value) = registerNotification(scopePrim.IsInstanceable())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], scopePrim.SetInstanceable(true))
        XCTAssertTrue(scopePrim.IsInstanceable())
    }
    
    // MARK: ClearInstanceable
    
    func test_ClearInstanceable_HasAuthoredInstanceable() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.SetInstanceable(true)

        let (token, value) = registerNotification(scopePrim.HasAuthoredInstanceable())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], scopePrim.ClearInstanceable())
        XCTAssertFalse(scopePrim.HasAuthoredInstanceable())
    }
}
