//
//  Observation_MutateUsdProperty_ReadUsdProperty.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/18/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdProperty_ReadUsdProperty: ObservationHelper {

    // MARK: SetDisplayGroup
    
    func test_SetDisplayGroup_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertEqual(attr.GetDisplayGroup(), "buzz")
    }
    
    func test_SetDisplayGroup_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    func test_SetDisplayGroup_GetNestedDisplayGroups() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetNestedDisplayGroups())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz:foo"))
        XCTAssertEqual(attr.GetNestedDisplayGroups(), ["buzz", "foo"])
    }
    
    // MARK: ClearDisplayGroup
    
    func test_ClearDisplayGroup_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "buzz")
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertEqual(attr.GetDisplayGroup(), "")
    }
    
    func test_ClearDisplayGroup_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }
    
    func test_ClearDisplayGroup_GetNestedDisplayGroups() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz:foo")
        
        let (token, value) = registerNotification(attr.GetNestedDisplayGroups())
        XCTAssertEqual(value, ["buzz", "foo"])
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertEqual(attr.GetNestedDisplayGroups(), [])
    }
    
    // MARK: SetNestedDisplayGroups
    
    func test_SetNestedDisplayGroups_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertEqual(attr.GetDisplayGroup(), "buzz:bar")
    }
    
    func test_SetNestedDisplayGroups_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    func test_SetNestedDisplayGroups_GetNestedDisplayGroups() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetNestedDisplayGroups())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "foo"]))
        XCTAssertEqual(attr.GetNestedDisplayGroups(), ["buzz", "foo"])
    }
    
    // MARK: SetCustom
    
    func test_SetCustom_IsCustom() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attr.IsCustom())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetCustom(true))
        XCTAssertTrue(attr.IsCustom())
    }
    
    // MARK: FlattenTo
    
    func test_FlattenTo_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        attr.SetDisplayGroup("fizz")
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attrDest.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertEqual(attrDest.GetDisplayGroup(), "fizz")
    }
}
