//
//  Observation_MutateUsdProperty_ReadUsdAttribute.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/19/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdProperty_ReadUsdAttribute: ObservationHelper {

    // MARK: FlattenTo
    
    func test_FlattenTo_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        attr.SetDisplayGroup("fizz")
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.CreateAttribute("myAttr", .Float, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attrDest.GetTypeName())
        XCTAssertEqual(value, .Float)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertEqual(attrDest.GetTypeName(), .Double)
    }
    
    func test_FlattenTo_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        attr.SetColorSpace("fizz")
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attrDest.GetColorSpace())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertEqual(attrDest.GetColorSpace(), "fizz")
    }

}
