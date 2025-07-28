//
//  Observation_MutateUsdObject_ReadUsdSchemaBase.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/16/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdObject_ReadUsdSchemaBase: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let schema = pxr.UsdPhysicsRigidBodyAPI(p)
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertFalse(value)
        
        var listOp = pxr.SdfTokenListOp()
        listOp.SetItems(["PhysicsRigidBodyAPI"], Overlay.SdfListOpTypeExplicit, nil)
        expectingSomeNotifications([token], p.SetMetadata("apiSchemas", pxr.VtValue(listOp)))
        XCTAssertTrue(Bool(schema))
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        
        let schema = pxr.UsdPhysicsRigidBodyAPI(p)
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("apiSchemas"))
        XCTAssertFalse(Bool(schema))
    }
}
