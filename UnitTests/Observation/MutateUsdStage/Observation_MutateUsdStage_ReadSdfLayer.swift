//
//  Observation_MutateUsdStage_ReadSdfLayer.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/3/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdStage_ReadSdfLayer: ObservationHelper {

    // MARK: Save
    
    func test_Save_IsDirty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rootLayer = Overlay.Dereference(stage.GetRootLayer())
        let (token, value) = registerNotification(rootLayer.IsDirty())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], stage.DefinePrim("/hello", "Plane"))
        XCTAssertTrue(rootLayer.IsDirty())
    }


    // MARK: SaveSessionLayers
    
    func test_SaveSessionLayers_IsDirty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let sessionLayer = Overlay.Dereference(stage.GetSessionLayer())
        let (token, value) = registerNotification(sessionLayer.IsDirty())
        XCTAssertFalse(value)
        
        Overlay.withUsdEditContext(stage, pxr.UsdEditTarget(Overlay.TfWeakPtr(sessionLayer), pxr.SdfLayerOffset(0, 1))) {
            expectingSomeNotifications([token], stage.DefinePrim("/hello", "Plane"))
            XCTAssertTrue(sessionLayer.IsDirty())
        }
    }
        
    // MARK: SetMetadata
    
    func test_SetMetadata_IsDirty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.IsDirty())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetMetadata("startTimeCode", 4.0))
        XCTAssertTrue(layer.IsDirty())
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetDefaultPrim(main.DefinePrim("/hi", "Cube"))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasDefaultPrim())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadata("defaultPrim"))
        XCTAssertFalse(layer.HasDefaultPrim())
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_GetFieldDictValueByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetFieldDictValueByKey("/", "expressionVariables", "VARIANT_CHOICE"))
        XCTAssertTrue(value.IsEmpty())
        
        XCTAssertTrue(expectingSomeNotifications([token], main.SetMetadataByDictKey("expressionVariables", "VARIANT_CHOICE", "variantA" as std.string)))
        
        var choice = layer.GetFieldDictValueByKey("/", "expressionVariables", "VARIANT_CHOICE")
        XCTAssertTrue(choice.IsHolding(T: std.string.self))
        XCTAssertEqual(choice.Get() as std.string, "variantA")
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_GetFieldDictValueByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "VARIANT_CHOICE", "variantA" as std.string)
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var (token, value) = registerNotification(layer.GetFieldDictValueByKey("/", "expressionVariables", "VARIANT_CHOICE"))
        XCTAssertTrue(value.IsHolding(T: std.string.self))
        XCTAssertEqual(value.Get() as std.string, "variantA")
        
        XCTAssertTrue(expectingSomeNotifications([token], main.ClearMetadataByDictKey("expressionVariables", "VARIANT_CHOICE")))
        
        let choice = layer.GetFieldDictValueByKey("/", "expressionVariables", "VARIANT_CHOICE")
        XCTAssertTrue(choice.IsEmpty())
    }
    
    // MARK: SetStartTimeCode
    
    func test_SetStartTimeCode_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasField("/", "startTimeCode", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], main.SetStartTimeCode(7))
        XCTAssertTrue(layer.HasField("/", "startTimeCode", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    func test_SetStartTimeCode_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetField("/", "startTimeCode"))
        XCTAssertTrue(value.IsEmpty())
        
        expectingSomeNotifications([token], main.SetStartTimeCode(7))
        XCTAssertEqual(layer.GetField("/", "startTimeCode"), pxr.VtValue(7.0))
    }
    
    func test_SetStartTimeCode_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetStartTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], main.SetStartTimeCode(7))
        XCTAssertEqual(layer.GetStartTimeCode(), 7)
    }
    
    // MARK: SetEndTimeCode
    
    func test_SetEndTimeCode_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetEndTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], main.SetEndTimeCode(7))
        XCTAssertEqual(layer.GetEndTimeCode(), 7)
    }
    
    // MARK: SetTimeCodesPerSecond
    
    func test_SetTimeCodesPerSecond_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let (token, value) = registerNotification(layer.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 24)
                
        expectingSomeNotifications([token], main.SetTimeCodesPerSecond(7))
        XCTAssertEqual(layer.GetTimeCodesPerSecond(), 7)
    }
    
    // MARK: SetFramesPerSecond
    
    func test_SetFramesPerSecond_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let (token, value) = registerNotification(layer.GetFramesPerSecond())
        XCTAssertEqual(value, 24)
                
        expectingSomeNotifications([token], main.SetFramesPerSecond(7))
        XCTAssertEqual(layer.GetFramesPerSecond(), 7)
    }
    
    // MARK: Reload
    
    func test_Reload_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.SetEndTimeCode(4)
        
        let (token, value) = registerNotification(layer.GetEndTimeCode())
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], main.Reload())
        XCTAssertEqual(layer.GetEndTimeCode(), 0)
    }
    
    // MARK: SetColorConfiguration
    
    func test_SetColorConfiguration_GetColorConfiguration() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.SetColorConfiguration(pxr.SdfAssetPath("/foo/bar"))
        let (token, value) = registerNotification(layer.GetColorConfiguration())
        XCTAssertEqual(value, pxr.SdfAssetPath("/foo/bar"))
        
        expectingSomeNotifications([token], main.SetColorConfiguration(pxr.SdfAssetPath("/bar/foo")))
        XCTAssertEqual(layer.GetColorConfiguration(), pxr.SdfAssetPath("/bar/foo"))
    }
    
    // MARK: SetColorManagementSystem
    
    func test_SetColorManagementSystem_GetColorManagementSystem() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.SetColorManagementSystem("fizzbuzz")
        let (token, value) = registerNotification(layer.GetColorManagementSystem())
        XCTAssertEqual(value, "fizzbuzz")
        
        expectingSomeNotifications([token], main.SetColorManagementSystem("buzzfizz"))
        XCTAssertEqual(layer.GetColorManagementSystem(), "buzzfizz")
    }
    
    // MARK: SetDefaultPrim
    
    func test_SetDefaultPrim_GetDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        main.SetDefaultPrim(foo)
        
        let (token, value) = registerNotification(layer.GetDefaultPrim())
        XCTAssertEqual(value, "foo")
        
        expectingSomeNotifications([token], main.SetDefaultPrim(bar))
        XCTAssertEqual(layer.GetDefaultPrim(), "bar")
    }
    
    // MARK: ClearDefaultPrim
    
    func test_ClearDefaultPrim_HasDefaultPrim() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let foo = main.DefinePrim("/foo", "Sphere")
        main.SetDefaultPrim(foo)
        
        let (token, value) = registerNotification(layer.HasDefaultPrim())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearDefaultPrim())
        XCTAssertFalse(layer.HasDefaultPrim())
    }
    
    // MARK: OverridePrim
    
    func test_OverridePrim_IsDirty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.IsDirty())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.OverridePrim("/foo"))
        XCTAssertTrue(layer.IsDirty())
    }
    
    // MARK: DefinePrim
    
    func test_DefinePrim_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.DefinePrim("/foo", "Plane"))
        XCTAssertTrue(layer.HasSpec("/foo"))
    }
    
    func test_DefinePrim_GetPrimAtPath() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetPrimAtPath("/foo"))
        XCTAssertFalse(Bool(value))

        expectingSomeNotifications([token], main.DefinePrim("/foo", "Plane"))
        XCTAssertTrue(Bool(layer.GetPrimAtPath("/foo")))
    }
    
    func test_DefinePrim_IsDirty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.IsDirty())
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.DefinePrim("/foo", "Plane"))
        XCTAssertTrue(layer.IsDirty())
    }
    
    func test_DefinePrim_IsEmpty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.IsEmpty())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], main.DefinePrim("/foo", "Plane"))
        XCTAssertFalse(layer.IsEmpty())
    }
    
    #if os(Linux)
    #warning("test_DefinePrim_Traverse disabled on Linux because it relies on Objc blocks")
    // rdar://146138311 (Swift closure wrapped in ObjC block wrapped in std::function crashes at runtime on Linux)
    #else
    func test_DefinePrim_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification {
            var result = [pxr.SdfPath]()
            layer.Traverse("/", Overlay.SdfLayer.TraversalFunction({ path in result.append(path) }))
            return result
        }
        XCTAssertEqual(value, ["/"])
        
        expectingSomeNotifications([token], main.DefinePrim("/foo", "Plane"))
        
        var result = [pxr.SdfPath]()
        layer.Traverse("/", Overlay.SdfLayer.TraversalFunction({ path in result.append(path) }))
        XCTAssertEqual(result, ["/foo", "/"])
    }
    #endif // #if os(Linux)
    
    // MARK: CreateClassPrim
    
    func test_CreateClassPrim_GetSpecType() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.GetSpecType("/_class_foo"))
        XCTAssertEqual(value, Overlay.SdfSpecTypeUnknown)

        expectingSomeNotifications([token], main.CreateClassPrim("/_class_foo"))
        XCTAssertEqual(layer.GetSpecType("/_class_foo"), Overlay.SdfSpecTypePrim)
    }
    
    func test_CreateClassPrim_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let (token, value) = registerNotification(layer.HasSpec("/_class_foo"))
        XCTAssertFalse(value)

        expectingSomeNotifications([token], main.CreateClassPrim("/_class_foo"))
        XCTAssertTrue(layer.HasSpec("/_class_foo"))
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(layer.HasSpec("/foo"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.RemovePrim("/foo"))
        XCTAssertFalse(layer.HasSpec("/foo"))
    }
}
