//
//  Observation_MutateUsdObject_ReadUsdProperty.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/16/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdObject_ReadUsdProperty: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")

        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetMetadata("displayGroup", pxr.VtValue("foo" as std.string)))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        attr.SetMetadata("displayGroup", pxr.VtValue("foo" as std.string))

        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearMetadata("displayGroup"))
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }

}
