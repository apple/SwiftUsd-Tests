//
//  Observation_MutateSdfLayer_ReadUsdObject.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/5/24.
//

import XCTest
import OpenUSD

final class Observation_MutateSdfLayer_ReadUsdObject: ObservationHelper {

    // MARK: SetField
    
    func test_SetField_GetDisplayName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
                
        let (token, value) = registerNotification(p.GetDisplayName())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], layer.SetField("/foo", "displayName", pxr.VtValue("fizzbuzz" as std.string)))
        XCTAssertEqual(p.GetDisplayName(), "fizzbuzz")
    }
    
    func test_SetField_HasAuthoredDisplayName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
                
        let (token, value) = registerNotification(p.HasAuthoredDisplayName())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetField("/foo", "displayName", pxr.VtValue("fizzbuzz" as std.string)))
        XCTAssertTrue(p.HasAuthoredDisplayName())
    }
    
    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(sub1) {}
        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let p = main.DefinePrim("/foo", "Cube")
        sub2.OverridePrim("/foo").SetAssetInfoByKey("name", pxr.VtValue("foo" as std.string))

        
        var metadataOut = pxr.VtValue()
        let (token, value) = registerNotification(p.GetMetadataByDictKey("assetInfo", "name", &metadataOut))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        XCTAssertTrue(p.GetMetadataByDictKey("assetInfo", "name", &metadataOut))
        XCTAssertEqual(metadataOut, pxr.VtValue("foo" as std.string))
    }
    
    // MARK: EraseField
    
    func test_EraseField_HasAuthoredMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfoByKey("name", pxr.VtValue("foo" as std.string))
                
        let (token, value) = registerNotification(p.HasAuthoredMetadataDictKey("assetInfo", "name"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseField("/foo", "assetInfo"))
        XCTAssertFalse(p.HasAuthoredMetadataDictKey("assetInfo", "name"))
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_HasMetadataKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(sub1) {}
        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda")))
        
        let p = main.DefinePrim("/foo", "Cube")
        sub2.OverridePrim("/foo").SetAssetInfoByKey("name", pxr.VtValue("foo" as std.string))

        let (token, value) = registerNotification(p.HasMetadataDictKey("assetInfo", "name"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertFalse(p.HasMetadataDictKey("assetInfo", "name"))
    }
    
    // MARK: SetColorConfiguration
    
    func test_SetColorConfiguration_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("colorConfiguration"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetColorConfiguration(pxr.SdfAssetPath("foo")))
        XCTAssertTrue(p.HasAuthoredMetadata("colorConfiguration"))
    }

    // MARK: ClearColorConfiguration
    
    func test_ClearColorConfiguration_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetColorConfiguration(pxr.SdfAssetPath("foo"))
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("colorConfiguration"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearColorConfiguration())
        XCTAssertFalse(p.HasAuthoredMetadata("colorConfiguration"))
    }
    
    // MARK: SetColorManagementSystem
    
    func test_SetColorManagementSystem_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("colorManagementSystem"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetColorManagementSystem("foo"))
        XCTAssertTrue(p.HasAuthoredMetadata("colorManagementSystem"))
    }
    
    // MARK: ClearColorManagementSystem
    
    func test_ClearColorManagementSystem_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetColorManagementSystem("foo")
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("colorManagementSystem"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearColorManagementSystem())
        XCTAssertFalse(p.HasAuthoredMetadata("colorManagementSystem"))
    }
    
    // MARK: SetComment
    
    func test_SetComment_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("comment"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetComment("foo"))
        XCTAssertTrue(p.HasAuthoredMetadata("comment"))
    }
    
    // MARK: SetDefaultPrim
    
    func test_SetDefaultPrim_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("defaultPrim"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetDefaultPrim("foo"))
        XCTAssertTrue(p.HasAuthoredMetadata("defaultPrim"))
    }
    
    // MARK: ClearDefaultPrim
    
    func test_ClearDefaultPrim_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetDefaultPrim("foo")
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("defaultPrim"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearDefaultPrim())
        XCTAssertFalse(p.HasAuthoredMetadata("defaultPrim"))
    }
    
    // MARK: SetDocumentation
    
    func test_SetDocumentation_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("documentation"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetDocumentation("foo"))
        XCTAssertTrue(p.HasAuthoredMetadata("documentation"))
    }
    
    // MARK: SetStartTimeCode
    
    func test_SetStartTimeCode_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("startTimeCode"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetStartTimeCode(7))
        XCTAssertTrue(p.HasAuthoredMetadata("startTimeCode"))
    }
    
    // MARK: ClearStartTimeCode
    
    func test_ClearStartTimeCode_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetStartTimeCode(7)
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("startTimeCode"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearStartTimeCode())
        XCTAssertFalse(p.HasAuthoredMetadata("startTimeCode"))
    }
    
    // MARK: SetEndTimeCode
    
    func test_SetEndTimeCode_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("endTimeCode"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetEndTimeCode(7))
        XCTAssertTrue(p.HasAuthoredMetadata("endTimeCode"))
    }
    
    // MARK: ClearEndTimeCode
    
    func test_ClearEndTimeCode_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetEndTimeCode(7)
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("endTimeCode"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearEndTimeCode())
        XCTAssertFalse(p.HasAuthoredMetadata("endTimeCode"))
    }
    
    // MARK: SetTimeCodesPerSecond
    
    func test_SetTimeCodesPerSecond_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("timeCodesPerSecond"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetTimeCodesPerSecond(7))
        XCTAssertTrue(p.HasAuthoredMetadata("timeCodesPerSecond"))
    }
    
    // MARK: ClearTimeCodesPerSecond
    
    func test_ClearTimeCodesPerSecond_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetTimeCodesPerSecond(7)
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("timeCodesPerSecond"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearTimeCodesPerSecond())
        XCTAssertFalse(p.HasAuthoredMetadata("timeCodesPerSecond"))
    }
    
    // MARK: SetFramesPerSecond
    
    func test_SetFramesPerSecond_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("framesPerSecond"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFramesPerSecond(7))
        XCTAssertTrue(p.HasAuthoredMetadata("framesPerSecond"))
    }
    
    // MARK: ClearFramesPerSecond
    
    func test_ClearFramesPerSecond_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetFramesPerSecond(7)
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("framesPerSecond"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearFramesPerSecond())
        XCTAssertFalse(p.HasAuthoredMetadata("framesPerSecond"))
    }
    
    // MARK: SetFramePrecision
    
    func test_SetFramePrecision_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("framePrecision"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFramePrecision(7))
        XCTAssertTrue(p.HasAuthoredMetadata("framePrecision"))
    }
    
    // MARK: ClearFramePrecision
    
    func test_ClearFramePrecision_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetFramePrecision(7)
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("framePrecision"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearFramePrecision())
        XCTAssertFalse(p.HasAuthoredMetadata("framePrecision"))
    }
    
    // MARK: SetOwner
    
    func test_SetOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("owner"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetOwner("foo"))
        XCTAssertTrue(p.HasAuthoredMetadata("owner"))
    }
    
    // MARK: ClearOwner
    
    func test_ClearOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetOwner("foo")
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("owner"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearOwner())
        XCTAssertFalse(p.HasAuthoredMetadata("owner"))
    }
    
    // MARK: SetSessionOwner
    
    func test_SetSessionOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("sessionOwner"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetSessionOwner("foo"))
        XCTAssertTrue(p.HasAuthoredMetadata("sessionOwner"))
    }
    
    // MARK: ClearSessionOwner
    
    func test_ClearSessionOwner_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetSessionOwner("foo")
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("sessionOwner"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearSessionOwner())
        XCTAssertFalse(p.HasAuthoredMetadata("sessionOwner"))
    }
    
    // MARK: SetHasOwnedSubLayers
    
    func test_SetHasOwnedSubLayers_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("hasOwnedSubLayers"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetHasOwnedSubLayers(true))
        XCTAssertTrue(p.HasAuthoredMetadata("hasOwnedSubLayers"))
    }
    
    // MARK: SetCustomLayerData
    
    func test_SetCustomLayerData_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("customLayerData"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetCustomLayerData(pxr.VtDictionary()))
        XCTAssertTrue(p.HasAuthoredMetadata("customLayerData"))
    }
    
    // MARK: ClearCustomLayerData
    
    func test_ClearCustomLayerData_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.GetPseudoRoot()
        layer.SetCustomLayerData(pxr.VtDictionary())
        
        let (token, value) = registerNotification(p.HasAuthoredMetadata("customLayerData"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearCustomLayerData())
        XCTAssertFalse(p.HasAuthoredMetadata("customLayerData"))
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_HasAuthoredHidden() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        let p = main.DefinePrim("/foo", "Plane")
        sub2.OverridePrim("/foo").SetHidden(true)

        
        let (token, value) = registerNotification(p.HasAuthoredHidden())
        XCTAssertFalse(value)
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertTrue(p.HasAuthoredHidden())
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_HasCustomDataKeyProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda")))
        let p = main.DefinePrim("/foo", "Plane")
        var dict = pxr.VtDictionary()
        dict["foo"] = pxr.VtValue("bar" as std.string)
        sub2.OverridePrim("/foo").SetCustomData(dict)

        
        let (token, value) = registerNotification(p.HasCustomDataKey("foo"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(p.HasCustomDataKey("foo"))
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_GetAllMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        model.OverridePrim("/foo").SetActive(false)
        
        
        let (token, value) = registerNotification(p.GetAllMetadata())
        XCTAssertNil(value["active"])
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        let dict = p.GetAllMetadata()
        XCTAssertEqual(dict["active"], pxr.VtValue(false))
    }
    
    func test_SetSubLayerPaths_GetAllAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        model.OverridePrim("/foo").SetActive(false)
        
        
        let (token, value) = registerNotification(p.GetAllAuthoredMetadata())
        XCTAssertEqual(value.size(), 2)
        XCTAssertEqual(value["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(value["typeName"], pxr.VtValue("Cube" as pxr.TfToken))
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        let dict = p.GetAllAuthoredMetadata()
        XCTAssertEqual(dict.size(), 3)
        XCTAssertEqual(dict["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(dict["typeName"], pxr.VtValue("Cube" as pxr.TfToken))
        XCTAssertEqual(dict["active"], pxr.VtValue(false))
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_GetCustomDataByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Cube")
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        model.OverridePrim("/foo").SetCustomDataByKey("myKey", pxr.VtValue("foo" as std.string))

        let (token, value) = registerNotification(p.GetCustomDataByKey("myKey"))
        XCTAssertTrue(value.IsEmpty())
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertEqual(p.GetCustomDataByKey("myKey"), pxr.VtValue("foo" as std.string))
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_HasAuthoredCustomData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        let p = main.DefinePrim("/foo", "Cube")
        model.OverridePrim("/foo").SetCustomDataByKey("fizz:buzz", pxr.VtValue("foo" as std.string))
        
        
        let (token, value) = registerNotification(p.HasAuthoredCustomData())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertFalse(p.HasAuthoredCustomData())
    }
    
    // MARK: Apply
    
    func test_Apply_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let p = main.DefinePrim("/beta", "Sphere")
        
        
        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        var batchEdit = pxr.SdfBatchNamespaceEdit()
        batchEdit.Add(pxr.SdfNamespaceEdit.Rename("/beta", "delta"))
        expectingSomeNotifications([token], layer.Apply(batchEdit))
        XCTAssertFalse(Bool(p))
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let other = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Other.usda"), Overlay.UsdStage.LoadAll))
        
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.TransferContent(other.GetRootLayer()))
        XCTAssertFalse(p.IsValid())
    }
    
    // MARK: SetRootPrims
    
    func test_SetRootPrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(Bool(foo))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetRootPrims([layer.GetPrimAtPath("/bar")]))
        XCTAssertFalse(Bool(foo))
    }
    
    // MARK: InsertRootPrim
    
    func test_InsertRootPrim_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        
        let (token, value) = registerNotification(bar.IsValid())
        XCTAssertTrue(value)
                
        expectingSomeNotifications([token], layer.InsertRootPrim(layer.GetPrimAtPath("/foo/bar"), 0))
        XCTAssertFalse(bar.IsValid())
    }
    
    // MARK: RemoveRootPrim
    
    func test_RemoveRootPrim_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(foo.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemoveRootPrim(layer.GetPrimAtPath("/foo")))
        XCTAssertFalse(foo.IsValid())
    }
    
    // MARK: ScheduleRemoveIfInert
    
    func test_ScheduleRemoveIfInert_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.OverridePrim("/foo")
        
        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ScheduleRemoveIfInert(layer.GetObjectAtPath("/foo").GetSpec()))
        XCTAssertFalse(Bool(p))
    }
    
    // MARK: RemovePrimIfInert
    
    func test_RemovePrimIfInert_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.OverridePrim("/foo")
        
        let (token, value) = registerNotification(p.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemovePrimIfInert(layer.GetPrimAtPath("/foo")))
        XCTAssertFalse(p.IsValid())
    }
    
    // MARK: RemovePropertyIfHasOnlyRequiredFields
    
    func test_RemovePropertyIfHasOnlyRequiredFields_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(Bool(attr))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemovePropertyIfHasOnlyRequiredFields(layer.GetPropertyAtPath("/foo.myAttr")))
        XCTAssertFalse(Bool(attr))
    }
    
    // MARK: RemoveInertSceneDescription
    
    func test_RemoveInertSceneDescription_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Sphere")
        let bar = main.OverridePrim("/foo/bar")
        
        
        let (token, value) = registerNotification(Bool(bar))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemoveInertSceneDescription())
        XCTAssertFalse(Bool(bar))
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.IsValid())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0
        

        """#)))
        XCTAssertFalse(p.IsValid())
    }
    
    // MARK: Clear
    
    func test_Clear_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Clear())
        XCTAssertFalse(p.IsValid())
    }
    
    // MARK: Reload
    
    func test_Reload_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Reload(true))
        XCTAssertFalse(Bool(p))
    }
    
    // MARK: Import
    
    func test_Import_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()

        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(Bool(p))
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))

        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(Bool(p))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([main.GetRootLayer()], true))
        XCTAssertFalse(Bool(p))
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let overStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "OverStage.usda"), Overlay.UsdStage.LoadAll))
        let overLayer = Overlay.Dereference(overStage.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "OverStage.usda"), 0)
        
        overStage.OverridePrim("/foo")
        let p = main.GetPrimAtPath("/foo")
        
        
        let (token, value) = registerNotification(p.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], overLayer.SetIdentifier(pathForStage(named: "NewOverStage.usda")))
        XCTAssertFalse(p.IsValid())
    }
}
