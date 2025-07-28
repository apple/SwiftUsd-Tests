//
//  Observation_MutateUsdObject_ReadUsdRelationship.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/16/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdObject_ReadUsdRelationship: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let rel = p.CreateRelationship("myRel", true)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        var listOp = pxr.SdfPathListOp()
        listOp.SetPrependedItems(["/foo.fizzbuzz"], nil)
        expectingSomeNotifications([token], Overlay.SetMetadata(rel, "targetPaths", pxr.VtValue(listOp)))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.fizzbuzz"])
    }
    
    func test_SetMetadata_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let rel = p.CreateRelationship("myRel", true)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        var listOp = pxr.SdfPathListOp()
        listOp.SetPrependedItems(["/foo.fizzbuzz"])
        expectingSomeNotifications([token], Overlay.SetMetadata(rel, "targetPaths", pxr.VtValue(listOp)))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.fizzbuzz"])
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let rel = p.CreateRelationship("myRel", true)
        rel.AddTarget("/foo.fizzbuzz", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.fizzbuzz"])
        
        expectingSomeNotifications([token], Overlay.ClearMetadata(rel, "targetPaths"))
        XCTAssertFalse(rel.GetTargets(&targets))
        XCTAssertEqual(targets, [])
    }
}

