//
//  Observation_MutateUsdProperty_ReadUsdRelationship.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/19/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdProperty_ReadUsdRelationship: ObservationHelper {

    // MARK: FlattenTo
    
    func test_FlattenTo_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("myRel", true)
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let relDest = otherPrim.CreateRelationship("myRel", true)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(relDest.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.FlattenTo(otherPrim))
        XCTAssertTrue(relDest.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/bar.radius"])
    }

}
