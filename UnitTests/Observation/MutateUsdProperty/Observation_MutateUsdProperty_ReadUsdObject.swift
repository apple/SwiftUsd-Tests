//
//  Observation_MutateUsdProperty_ReadUsdObject.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/18/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdProperty_ReadUsdObject: ObservationHelper {

    // MARK: SetDisplayGroup
    
    func test_SetDisplayGroup_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("buzz" as std.string))
    }
    
    func test_SetDisplayGroup_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.HasMetadata("displayGroup"))
    }

    func test_SetDisplayGroup_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.HasAuthoredMetadata("displayGroup"))
    }
    
    // MARK: ClearDisplayGroup
    
    func test_ClearDisplayGroup_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("buzz" as std.string))
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.GetMetadata("displayGroup", &vtValue))
    }
    
    func test_ClearDisplayGroup_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.HasMetadata("displayGroup"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.HasMetadata("displayGroup"))
    }
    
    func test_ClearDisplayGroup_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("displayGroup"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.HasAuthoredMetadata("displayGroup"))
    }
    
    // MARK: SetNestedDisplayGroups
    
    func test_SetNestedDisplayGroups_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("buzz:bar" as std.string))
    }
    
    func test_SetNestedDisplayGroups_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.HasMetadata("displayGroup"))
    }

    func test_SetNestedDisplayGroups_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.HasAuthoredMetadata("displayGroup"))
    }
    
    // MARK: SetCustom
    
    func test_SetCustom_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("custom", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(false))
        
        expectingSomeNotifications([token], attr.SetCustom(true))
        XCTAssertTrue(attr.GetMetadata("custom", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(true))
    }
    
    // MARK: FlattenTo
    
    func test_FlattenTo_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.GetAttribute("myAttr")
        
        let (token, value) = registerNotification(Bool(attrDest))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertTrue(Bool(attrDest))
    }
}
