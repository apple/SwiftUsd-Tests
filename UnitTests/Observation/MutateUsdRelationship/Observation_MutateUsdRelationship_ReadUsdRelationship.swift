//
//  Observation_MutateUsdRelationship_ReadUsdRelationship.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/22/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdRelationship_ReadUsdRelationship: ObservationHelper {

    // MARK: AddTarget
    
    func test_AddTarget_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }
        
    func test_AddTarget_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }
        
    func test_AddTarget_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(rel.HasAuthoredTargets())
    }
    
    // MARK: RemoveTarget
    
    func test_RemoveTarget_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    func test_RemoveTarget_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: SetTargets
    
    func test_SetTargets_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }

    func test_SetTargets_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }
    
    func test_SetTargets_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(rel.HasAuthoredTargets())
    }
    
    // MARK: ClearTargets
    
    func test_ClearTargets_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(rel.GetTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    func test_ClearTargets_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])

        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    func test_ClearTargets_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
}
