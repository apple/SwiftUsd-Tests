//
//  Observation_MutateUsdPrim_ReadUsdAttribute.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/11/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdPrim_ReadUsdAttribute: ObservationHelper {

    // MARK: SetTypeName
    
    func test_SetTypeName_GetTypeName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "")
        let attr = p.CreateAttribute("radius", .Float3, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attr.GetTypeName())
        XCTAssertEqual(value, .Float3)
        
        expectingSomeNotifications([token], p.SetTypeName("Sphere"))
        XCTAssertEqual(attr.GetTypeName(), .Double)
    }

    // MARK: ClearTypeName
    
    func test_ClearTypeName_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetTypeName())
        XCTAssertEqual(value, .Double)
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertEqual(attr.GetTypeName(), .init())
    }
    
    // MARK: RemoveProperty
    
    func test_RemoveProperty_GetTypeName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Sub1.usda"), 0)
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Sub2.usda"), 0)
        
        main.SetEditTarget(pxr.UsdEditTarget(sub1.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        
        var p = main.DefinePrim("/foo", "Cube")
        let attr = p.CreateAttribute("alpha", .Double, true, Overlay.SdfVariabilityVarying)
        
        main.SetEditTarget(pxr.UsdEditTarget(sub2.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        attr.SetTypeName(.Bool)
        
        let (token, value) = registerNotification(attr.GetTypeName())
        XCTAssertEqual(value, .Bool)
        
        expectingSomeNotifications([token], p.RemoveProperty("alpha"))
        XCTAssertEqual(attr.GetTypeName(), .Double)
    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let attr = foo.CreateAttribute("physics:velocity", .Vector3f, false, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(attr.HasValue())
    }
    
    // MARK: RemoveAppliedSchema
    
    func test_RemoveAppliedSchema_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let attr = foo.CreateAttribute("physics:velocity", .Vector3f, false, Overlay.SdfVariabilityVarying)
        foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let attr = foo.CreateAttribute("physics:velocity", .Vector3f, false, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(attr.HasValue())
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Cube")
        let attr = foo.CreateAttribute("physics:velocity", .Vector3f, false, Overlay.SdfVariabilityVarying)
        foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(attr.HasValue())
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_Get() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.GetAttributeAtPath("/root/model.radius").Set(7.0, 5)
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        main.OverridePrim("/foo/model").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying)
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        let attr = foo.GetAttributeAtPath("model.radius")
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 5))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 7)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertFalse(attr.Get(&radius, 5))
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_Get() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.GetAttributeAtPath("/root/model.radius").Set(7.0, 5)
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        main.OverridePrim("/foo/model").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying)
        let attr = foo.GetAttributeAtPath("model.radius")
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 5))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertTrue(attr.Get(&radius, 5))
        XCTAssertEqual(radius, 7)
    }
    

    
    
}
