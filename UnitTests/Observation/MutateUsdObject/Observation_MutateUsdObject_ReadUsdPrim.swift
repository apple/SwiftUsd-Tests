//
//  Observation_MutateUsdObject_ReadUsdPrim.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/16/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdObject_ReadUsdPrim: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(p.IsActive())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.SetMetadata("active", pxr.VtValue(false)))
        XCTAssertFalse(p.IsActive())
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadata("active", pxr.VtValue(false))

        let (token, value) = registerNotification(p.IsActive())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("active"))
        XCTAssertTrue(p.IsActive())
    }

}
