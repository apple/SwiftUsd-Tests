//
//  Observation_MutateUsdProperty_ReadSdfLayer.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/18/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdProperty_ReadSdfLayer: ObservationHelper {

    // MARK: SetDisplayGroup
    
    func test_SetDisplayGroup_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearDisplayGroup
    
    func test_ClearDisplayGroup_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }

    // MARK: SetNestedDisplayGroups
    
    func test_SetNestedDisplayGroups_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetCustom
    
    func test_SetCustom_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(layer.GetField("/foo.myAttr", "custom"))
        XCTAssertEqual(value, pxr.VtValue(false))
        
        expectingSomeNotifications([token], attr.SetCustom(true))
        XCTAssertEqual(layer.GetField("/foo.myAttr", "custom"), pxr.VtValue(true))
    }
    
    // MARK: FlattenTo
    
    func test_FlattenTo_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(layer.HasSpec("/bar.myAttr"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertTrue(layer.HasSpec("/bar.myAttr"))
    }
}
