//
//  Observation_MutateUsdProperty_ReadUsdPrim.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/19/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdProperty_ReadUsdPrim: ObservationHelper {

    // MARK: FlattenTo
    
    func test_FlattenTo_HasProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(otherPrim.HasProperty("myAttr"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertTrue(otherPrim.HasProperty("myAttr"))
    }

}
