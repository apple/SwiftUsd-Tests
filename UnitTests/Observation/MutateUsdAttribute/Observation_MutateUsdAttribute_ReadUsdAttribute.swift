//
//  Observation_MutateUsdAttribute_ReadUsdAttribute.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/19/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdAttribute_ReadUsdAttribute: ObservationHelper {

    // MARK: SetVariability
    
    func test_SetVariability_GetVariability() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(attr.GetVariability())
        XCTAssertEqual(value, Overlay.SdfVariabilityVarying)
        
        expectingSomeNotifications([token], attr.SetVariability(Overlay.SdfVariabilityUniform))
        XCTAssertEqual(attr.GetVariability(), Overlay.SdfVariabilityUniform)
    }

    // MARK: SetTypeName
    
    func test_SetTypeName_GetTypeName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attr.GetTypeName())
        XCTAssertEqual(value, .Double)
        
        expectingSomeNotifications([token], attr.SetTypeName(.Float))
        XCTAssertEqual(attr.GetTypeName(), .Float)
    }
    
    // MARK: AddConnection
    
    func test_AddConnection_GetConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var connections = pxr.SdfPathVector()
        let (token, value) = registerNotification(attr.GetConnections(&connections))
        XCTAssertFalse(value)
        XCTAssertEqual(connections, [])
        
        expectingSomeNotifications([token], attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(attr.GetConnections(&connections))
        XCTAssertEqual(connections, ["/foo.displayColor"])
    }
    
    func test_AddConnection_HasAuthoredConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredConnections())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(attr.HasAuthoredConnections())
    }
    
    // MARK: RemoveConnection
    
    func test_RemoveConnection_GetConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        
        var connections = pxr.SdfPathVector()
        let (token, value) = registerNotification(attr.GetConnections(&connections))
        XCTAssertTrue(value)
        XCTAssertEqual(connections, ["/foo.displayColor"])
        
        expectingSomeNotifications([token], attr.RemoveConnection("/foo.displayColor"))
        XCTAssertTrue(attr.GetConnections(&connections))
        XCTAssertEqual(connections, [])
    }       
    
    // MARK: SetConnections
    
    func test_SetConnections_GetConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var connections = pxr.SdfPathVector()
        let (token, value) = registerNotification(attr.GetConnections(&connections))
        XCTAssertFalse(value)
        XCTAssertEqual(connections, [])
        
        expectingSomeNotifications([token], attr.SetConnections(["/foo.displayColor"]))
        XCTAssertTrue(attr.GetConnections(&connections))
        XCTAssertEqual(connections, ["/foo.displayColor"])
    }
    
    func test_SetConnections_HasAuthoredConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredConnections())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetConnections(["/foo.displayColor"]))
        XCTAssertTrue(attr.HasAuthoredConnections())
    }
    
    // MARK: ClearConnections
    
    func test_ClearConnections_GetConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetConnections(["/foo.displayColor"])
        
        var connections = pxr.SdfPathVector()
        let (token, value) = registerNotification(attr.GetConnections(&connections))
        XCTAssertTrue(value)
        XCTAssertEqual(connections, ["/foo.displayColor"])

        expectingSomeNotifications([token], attr.ClearConnections())
        XCTAssertFalse(attr.GetConnections(&connections))
        XCTAssertEqual(connections, [])
    }
    
    func test_ClearConnections_HasAuthoredConnections() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetConnections(["/foo.displayColor"])
        
        let (token, value) = registerNotification(attr.HasAuthoredConnections())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], attr.ClearConnections())
        XCTAssertFalse(attr.HasAuthoredConnections())
    }
    
    // MARK: SetColorSpace
    
    func test_SetColorSpace_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetColorSpace())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.SetColorSpace("bar"))
        XCTAssertEqual(attr.GetColorSpace(), "bar")
    }
    
    func test_SetColorSpace_HasColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasColorSpace())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetColorSpace("bar"))
        XCTAssertTrue(attr.HasColorSpace())
    }
    
    // MARK: ClearColorSpace
    
    func test_ClearColorSpace_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetColorSpace("bar")
        
        let (token, value) = registerNotification(attr.GetColorSpace())
        XCTAssertEqual(value, "bar")
        
        expectingSomeNotifications([token], attr.ClearColorSpace())
        XCTAssertEqual(attr.GetColorSpace(), "")
    }
    
    func test_ClearColorSpace_HasColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetColorSpace("bar")
        
        let (token, value) = registerNotification(attr.HasColorSpace())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearColorSpace())
        XCTAssertFalse(attr.HasColorSpace())
    }
    
    // MARK: Set
    
    func test_Set_GetTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        var timeSamples = Overlay.Double_Vector()
        let (token, value) = registerNotification(attr.GetTimeSamples(&timeSamples))
        XCTAssertTrue(value)
        #warning("assert commented out to avoid compiler crash")
        //XCTAssertEqual(Array(timeSamples), [])
        
        expectingSomeNotifications([token], attr.Set(2.718, 1.059462309))
        XCTAssertTrue(attr.GetTimeSamples(&timeSamples))
        #warning("assert commented out to avoid compiler crash")
        //XCTAssertEqual(Array(timeSamples), [1.059462309])
    }
    
    func test_Set_GetTimeSamplesInInterval() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        var timeSamples = Overlay.Double_Vector()
        let (token, value) = registerNotification(attr.GetTimeSamplesInInterval(pxr.GfInterval(3, 4, true, true), &timeSamples))
        XCTAssertTrue(value)
        #warning("assert commented out to avoid compiler crash")
        //XCTAssertEqual(Array(timeSamples), [])
        
        expectingSomeNotifications([token], attr.Set(2.718, 3.1415))
        XCTAssertTrue(attr.GetTimeSamplesInInterval(pxr.GfInterval(3, 4, true, true), &timeSamples))
        #warning("assert commented out to avoid compiler crash")
        //XCTAssertEqual(Array(timeSamples), [3.1415])
    }
    
    func test_Set_GetNumTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        let (token, value) = registerNotification(attr.GetNumTimeSamples())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], attr.Set(2.718, 3.1415))
        XCTAssertEqual(attr.GetNumTimeSamples(), 1)
    }
    
    func test_Set_GetBracketingTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        var lower = 0.0
        var upper = 0.0
        var hasTimeSamples = true
        let (token, value) = registerNotification(attr.GetBracketingTimeSamples(3, &lower, &upper, &hasTimeSamples))
        XCTAssertTrue(value)
        XCTAssertEqual(lower, 0.0)
        XCTAssertEqual(upper, 0.0)
        XCTAssertFalse(hasTimeSamples)
        
        expectingSomeNotifications([token], attr.Set(2.718, 3.1415))
        XCTAssertTrue(attr.GetBracketingTimeSamples(3, &lower, &upper, &hasTimeSamples))
        XCTAssertEqual(lower, 3.1415)
        XCTAssertEqual(upper, 3.1415)
        XCTAssertTrue(hasTimeSamples)
    }
    
    func test_Set_HasValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "PointInstancer").GetAttribute("protoIndices")
        
        let (token, value) = registerNotification(attr.HasValue())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.Set([1, 2, 3] as pxr.VtIntArray, .Default()))
        XCTAssertTrue(attr.HasValue())
    }
    
    func test_Set_HasAuthoredValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "PointInstancer").GetAttribute("protoIndices")
        
        let (token, value) = registerNotification(attr.HasAuthoredValue())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.Set([1, 2, 3] as pxr.VtIntArray, .Default()))
        XCTAssertTrue(attr.HasAuthoredValue())
    }
    
    func test_Set_ValueMightBeTimeVarying() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(5.0, 5)

        let (token, value) = registerNotification(attr.ValueMightBeTimeVarying())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.Set(2.718, 3.1415))
        XCTAssertTrue(attr.ValueMightBeTimeVarying())
    }
    
    func test_Set_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 2))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 1)
        
        expectingSomeNotifications([token], attr.Set(2.718, 3.1415))
        XCTAssertTrue(attr.Get(&radius, 2))
        XCTAssertEqual(radius, 2.718)
    }
    
    // MARK: Clear
    
    func test_Clear_HasAuthoredValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "PointInstancer").GetAttribute("protoIndices")
        attr.Set([1, 2, 3] as pxr.VtIntArray, .Default())
        
        let (token, value) = registerNotification(attr.HasAuthoredValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.Clear())
        XCTAssertFalse(attr.HasAuthoredValue())
    }
    
    // MARK: ClearAtTime
    
    func test_ClearAtTime_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, 5)
        attr.Set(4.0, 6)

        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, 6))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 4)
        
        expectingSomeNotifications([token], attr.ClearAtTime(6))
        XCTAssertTrue(attr.Get(&radius, 6))
        XCTAssertEqual(radius, 3)
    }
    
    // MARK: ClearDefault
    
    func test_ClearDefault_Get() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, .Default())
        
        var radius = 0.0
        let (token, value) = registerNotification(attr.Get(&radius, .Default()))
        XCTAssertTrue(value)
        XCTAssertEqual(radius, 3)
        
        expectingSomeNotifications([token], attr.ClearDefault())
        XCTAssertTrue(attr.Get(&radius, .Default()))
        XCTAssertEqual(radius, 1)
    }
    
    // MARK: Block
    
    func test_Block_HasAuthoredValue() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, 7)
        
        let (token, value) = registerNotification(attr.HasAuthoredValue())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.Block())
        XCTAssertFalse(attr.HasAuthoredValue())
    }
}
