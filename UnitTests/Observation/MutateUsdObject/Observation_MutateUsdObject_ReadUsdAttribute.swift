//
//  Observation_MutateUsdObject_ReadUsdAttribute.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/16/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdObject_ReadUsdAttribute: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")

        let (token, value) = registerNotification(attr.GetColorSpace())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.SetMetadata("colorSpace", pxr.VtValue("foo" as pxr.TfToken)))
        XCTAssertEqual(attr.GetColorSpace(), "foo")
    }

    // MARK: ClearMetadata
    
    func test_ClearMetadata_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        attr.SetMetadata("colorSpace", pxr.VtValue("foo" as pxr.TfToken))

        let (token, value) = registerNotification(attr.GetColorSpace())
        XCTAssertEqual(value, "foo")
        
        expectingSomeNotifications([token], attr.ClearMetadata("colorSpace"))
        XCTAssertEqual(attr.GetColorSpace(), "")
    }
}
