//
//  Observation_MutateUsdAttribute_ReadSdfLayer.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/19/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdAttribute_ReadSdfLayer: ObservationHelper {

    // MARK: SetVariability
    
    func test_SetVariability_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(layer.GetField("/foo.myAttr", "variability"))
        XCTAssertEqual(value, pxr.VtValue(Overlay.SdfVariabilityVarying))
        
        expectingSomeNotifications([token], attr.SetVariability(Overlay.SdfVariabilityUniform))
        XCTAssertEqual(layer.GetField("/foo.myAttr", "variability"), pxr.VtValue(Overlay.SdfVariabilityUniform))
    }
    
    // MARK: SetTypeName
    
    func test_SetTypeName_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(layer.GetField("/foo.myAttr", "typeName"))
        XCTAssertEqual(value, pxr.VtValue("double" as pxr.TfToken))
        
        expectingSomeNotifications([token], attr.SetTypeName(.Float))
        XCTAssertEqual(layer.GetField("/foo.myAttr", "typeName"), pxr.VtValue("float" as pxr.TfToken))
    }
    
    // MARK: AddConnection
    
    func test_AddConnection_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "connectionPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(layer.HasField("/foo.radius", "connectionPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: RemoveConnection
    
    func test_RemoveConnection_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(layer.GetField("/foo.radius", "connectionPaths"))
        var listOp = pxr.SdfPathListOp()
        listOp.SetPrependedItems(["/foo.displayColor"], nil)
        XCTAssertEqual(value, pxr.VtValue(listOp))
        
        expectingSomeNotifications([token], attr.RemoveConnection("/foo.displayColor"))
        listOp.Clear()
        listOp.SetDeletedItems(["/foo.displayColor"], nil)
        XCTAssertEqual(layer.GetField("/foo.radius", "connectionPaths"), pxr.VtValue(listOp))
    }
    
    // MARK: SetConnections
    
    func test_SetConnections_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "connectionPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetConnections(["/foo.displayColor"]))
        XCTAssertTrue(layer.HasField("/foo.radius", "connectionPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearConnections
    
    func test_ClearConnections_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "connectionPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearConnections())
        XCTAssertFalse(layer.HasField("/foo.radius", "connectionPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    func test_ClearConnections_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(layer.GetField("/foo.radius", "connectionPaths"))
        var listOp = pxr.SdfPathListOp()
        listOp.SetPrependedItems(["/foo.displayColor"], nil)
        XCTAssertEqual(value, pxr.VtValue(listOp))
        
        expectingSomeNotifications([token], attr.ClearConnections())
        XCTAssertTrue(layer.GetField("/foo.radius", "connectionPaths").IsEmpty())
    }
    
    // MARK: SetColorSpace
    
    func test_SetColorSpace_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetColorSpace("bar"))
        XCTAssertTrue(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearColorSpace
    
    func test_ClearColorSpace_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetColorSpace("bar")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearColorSpace())
        XCTAssertFalse(layer.HasField("/foo.radius", "colorSpace", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: Set
    
    func test_Set_HasField_timeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "timeSamples", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.Set(2.718, 1.059462309))
        XCTAssertTrue(layer.HasField("/foo.radius", "timeSamples", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    func test_Set_HasField_default() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "default", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.Set(2.718, .Default()))
        XCTAssertTrue(layer.HasField("/foo.radius", "default", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    func test_Set_ListAllTimeSamples() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        let (token, value) = registerNotification(layer.ListAllTimeSamples())
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], attr.Set(2.718, 1.059462309))
        XCTAssertEqual(Array(layer.ListAllTimeSamples()), [1.059462309])
    }
    
    func test_Set_ListTimeSamplesForPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        let (token, value) = registerNotification(layer.ListTimeSamplesForPath("/foo.radius"))
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], attr.Set(2.718, 1.059462309))
        XCTAssertEqual(Array(layer.ListTimeSamplesForPath("/foo.radius")), [1.059462309])
    }
    
    func test_Set_GetNumTimeSamplesForPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        let (token, value) = registerNotification(layer.GetNumTimeSamplesForPath("/foo.radius"))
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], attr.Set(2.718, 1.059462309))
        XCTAssertEqual(layer.GetNumTimeSamplesForPath("/foo.radius"), 1)
    }
    
    func test_Set_QueryTimeSample() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")

        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(layer.QueryTimeSample("/foo.radius", 1.059462309, &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], attr.Set(2.718, 1.059462309))
        XCTAssertTrue(layer.QueryTimeSample("/foo.radius", 1.059462309, &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(2.718 as Double))
    }
    
    // MARK: Clear
    
    func test_Clear_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(2.718, 1.059462309)
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "timeSamples", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.Clear())
        XCTAssertFalse(layer.HasField("/foo.radius", "timeSamples", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearAtTime
    
    func test_ClearAtTime_ListTimeSamplesForPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, 5)
        attr.Set(4.0, 6)
        
        let (token, value) = registerNotification(layer.ListTimeSamplesForPath("/foo.radius"))
        XCTAssertEqual(Array(value).sorted(), [5, 6])
        
        expectingSomeNotifications([token], attr.ClearAtTime(6))
        XCTAssertEqual(Array(layer.ListTimeSamplesForPath("/foo.radius")), [5])
    }
    
    // MARK: ClearDefault
    
    func test_ClearDefault_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, .Default())
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "default", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDefault())
        XCTAssertFalse(layer.HasField("/foo.radius", "default", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: Block
    
    func test_Block_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, 7)
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "timeSamples", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.Block())
        XCTAssertFalse(layer.HasField("/foo.radius", "timeSamples", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
}
