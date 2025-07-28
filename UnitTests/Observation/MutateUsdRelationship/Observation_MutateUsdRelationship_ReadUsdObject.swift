//
//  Observation_MutateUsdRelationship_ReadUsdObject.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/22/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdRelationship_ReadUsdObject: ObservationHelper {

    // MARK: AddTarget
    
    func test_AddTarget_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(Overlay.HasMetadata(rel, "targetPaths"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(Overlay.HasMetadata(rel, "targetPaths"))
    }
    
    // MARK: RemoveTarget
    
    func test_RemoveTarget_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(Overlay.GetMetadata(rel, "targetPaths", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(pxr.SdfPathListOp.Create(["/foo.radius"], [], [])))
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertTrue(Overlay.GetMetadata(rel, "targetPaths", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(pxr.SdfPathListOp.Create([], [], ["/foo.radius"])))
    }

    // MARK: SetTargets
    
    func test_SetTargets_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
    }
    
    // MARK: ClearTargets
    
    func test_ClearTargets_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        let (token, value) = registerNotification(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
    }
}
