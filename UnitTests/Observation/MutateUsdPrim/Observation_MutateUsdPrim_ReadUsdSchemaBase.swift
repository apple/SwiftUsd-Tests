//
//  Observation_MutateUsdPrim_ReadUsdSchemaBase.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/11/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdPrim_ReadUsdSchemaBase: ObservationHelper {

    // MARK: SetTypeName
    
    func test_SetTypeName_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let schema = pxr.UsdGeomSphere(p)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.SetTypeName("Cube"))
        XCTAssertFalse(Bool(schema))
    }

    // MARK: ClearTypeName
    
    func test_ClearTypeName_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let schema = pxr.UsdGeomSphere(p)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: SetActive
    
    func test_SetActive_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let schema = pxr.UsdGeomSphere(main.DefinePrim("/foo/bar", "Sphere"))
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.SetActive(false))
        XCTAssertFalse(Bool(schema))

    }
    
    // MARK: ClearActive
    
    func test_ClearActive_operatorBool() {
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
        
        let schema = pxr.UsdGeomCube(main.DefinePrim("/foo/bar", "Cube"))

        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
                
        expectingSomeNotifications([token], foo.ClearActive())
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        let schema = pxr.UsdPhysicsRigidBodyAPI(foo)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(Bool(schema))
    }
    
    // MARK: RemoveAppliedSchema
    
    func test_RemoveAppliedSchema_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let schema = pxr.UsdPhysicsRigidBodyAPI(foo)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        let schema = pxr.UsdPhysicsRigidBodyAPI(foo)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertTrue(Bool(schema))
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Cube")
        foo.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let schema = pxr.UsdPhysicsRigidBodyAPI(foo)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_operatorBool() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "")
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        let schema = pxr.UsdGeomSphere(foo)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_operatorBool() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "")
        let schema = pxr.UsdGeomSphere(foo)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertTrue(Bool(schema))
    }
    
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
        
        expectingSomeNotifications([token], scopePrim.Load(Overlay.UsdLoadWithDescendants))
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
        
        expectingSomeNotifications([token], scopePrim.Unload())
        XCTAssertFalse(Bool(pxr.UsdGeomPlane.Get(mainStagePtr, "/smallModel/bigModel")))

    }
    
    // MARK: SetInstanceable
    
    func test_SetInstanceable_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        mainStage.DefinePrim("/instanceTarget", "Scope")
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetReferences().AddInternalReference("/instanceTarget", pxr.SdfLayerOffset(0, 1), Overlay.UsdListPositionBackOfPrependList)
        let schema = pxr.UsdGeomSphere(mainStage.DefinePrim("/smallModel/belowInstanceable", "Sphere"))

        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], scopePrim.SetInstanceable(true))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: ClearInstanceable
    
    func test_ClearInstanceable_operatorBool() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        mainStage.DefinePrim("/instanceTarget", "Scope")
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetReferences().AddInternalReference("/instanceTarget", pxr.SdfLayerOffset(0, 1), Overlay.UsdListPositionBackOfPrependList)
        mainStage.DefinePrim("/smallModel/belowInstanceable", "Sphere")
        scopePrim.SetInstanceable(true)

        let (token, value) = registerNotification(Bool(pxr.UsdGeomSphere(mainStage.GetPrimAtPath("/smallModel/belowInstanceable"))))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], scopePrim.ClearInstanceable())
        XCTAssertTrue(Bool(pxr.UsdGeomSphere(mainStage.GetPrimAtPath("/smallModel/belowInstanceable"))))
    }
}
