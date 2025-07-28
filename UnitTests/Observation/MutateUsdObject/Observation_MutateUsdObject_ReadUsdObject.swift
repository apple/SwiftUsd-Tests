//
//  Observation_MutateUsdObject_ReadUsdObject.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/16/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdObject_ReadUsdObject: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")

        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(p.GetMetadata("active", &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], p.SetMetadata("active", pxr.VtValue(false)))
        XCTAssertTrue(p.GetMetadata("active", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(false))
    }
    
    func test_SetMetadata_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(p.HasMetadata("active"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("active", pxr.VtValue(false)))
        XCTAssertTrue(p.HasMetadata("active"))
    }

    func test_SetMetadata_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(p.HasAuthoredMetadata("active"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("active", pxr.VtValue(false)))
        XCTAssertTrue(p.HasAuthoredMetadata("active"))
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadata("active", pxr.VtValue(false))

        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(p.GetMetadata("active", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(false))
        
        expectingSomeNotifications([token], p.ClearMetadata("active"))
        XCTAssertFalse(p.GetMetadata("active", &vtValue))
    }

    func test_ClearMetadata_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadata("active", pxr.VtValue(false))

        let (token, value) = registerNotification(p.HasMetadata("active"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("active"))
        XCTAssertFalse(p.HasMetadata("active"))
    }
    
    func test_ClearMetadata_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadata("active", pxr.VtValue(false))

        let (token, value) = registerNotification(p.HasAuthoredMetadata("active"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadata("active"))
        XCTAssertFalse(p.HasAuthoredMetadata("active"))
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(p.GetMetadataByDictKey("assetInfo", "name", &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertTrue(p.GetMetadataByDictKey("assetInfo", "name", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("fizzy" as std.string))
    }
    
    func test_SetMetadataByDictKey_HasMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasMetadataDictKey("assetInfo", "name"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertTrue(p.HasMetadataDictKey("assetInfo", "name"))
    }
    
    func test_SetMetadataByDictKey_HasAuthoredMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasAuthoredMetadataDictKey("assetInfo", "name"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertTrue(p.HasAuthoredMetadataDictKey("assetInfo", "name"))
    }
    
    func test_SetMetadataByDictKey_GetAllMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        
        let (token, value) = registerNotification(p.GetAllMetadata())
        XCTAssertEqual(value.size(), 3)
        XCTAssertEqual(value["documentation"], pxr.VtValue("""
        Defines a primitive sphere centered at the origin.
            
            The fallback values for Cube, Sphere, Cone, and Cylinder are set so that
            they all pack into the same volume/bounds.
        """ as std.string))
        XCTAssertEqual(value["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(value["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))

        expectingSomeNotifications([token], p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string)))
        let newValue = p.GetAllMetadata()
        XCTAssertEqual(newValue.size(), 4)
        XCTAssertEqual(newValue["assetInfo"], pxr.VtValue(["name" : pxr.VtValue("fizzy" as std.string)] as pxr.VtDictionary))
        XCTAssertEqual(newValue["documentation"], pxr.VtValue("""
        Defines a primitive sphere centered at the origin.
            
            The fallback values for Cube, Sphere, Cone, and Cylinder are set so that
            they all pack into the same volume/bounds.
        """ as std.string))
        XCTAssertEqual(newValue["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(newValue["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))
    }
    
    func test_SetMetadataByDictKey_GetAllAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        
        let (token, value) = registerNotification(p.GetAllAuthoredMetadata())
        XCTAssertEqual(value.size(), 2)
        XCTAssertEqual(value["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(value["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))

        expectingSomeNotifications([token], p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string)))
        let newValue = p.GetAllAuthoredMetadata()
        XCTAssertEqual(newValue.size(), 3)
        XCTAssertEqual(newValue["assetInfo"], pxr.VtValue(["name" : pxr.VtValue("fizzy" as std.string)] as pxr.VtDictionary))
        XCTAssertEqual(newValue["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(newValue["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_GetMetadataByDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string))
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(p.GetMetadataByDictKey("assetInfo", "name", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("fizzy" as std.string))

        expectingSomeNotifications([token], p.ClearMetadataByDictKey("assetInfo", "name"))
        XCTAssertFalse(p.GetMetadataByDictKey("assetInfo", "name", &vtValue))
    }
    
    func test_ClearMetadataByDictKey_HasMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(p.HasMetadataDictKey("assetInfo", "name"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadataByDictKey("assetInfo", "name"))
        XCTAssertFalse(p.HasMetadataDictKey("assetInfo", "name"))
    }
    
    func test_ClearMetadataByDictKey_HasAuthoredMetadataDictKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(p.HasAuthoredMetadataDictKey("assetInfo", "name"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearMetadataByDictKey("assetInfo", "name"))
        XCTAssertFalse(p.HasAuthoredMetadataDictKey("assetInfo", "name"))
    }
    
    func test_ClearMetadataByDictKey_GetAllMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(p.GetAllMetadata())
        XCTAssertEqual(value.size(), 4)
        XCTAssertEqual(value["assetInfo"], pxr.VtValue(["name" : pxr.VtValue("fizzy" as std.string)] as pxr.VtDictionary))
        XCTAssertEqual(value["documentation"], pxr.VtValue("""
        Defines a primitive sphere centered at the origin.
            
            The fallback values for Cube, Sphere, Cone, and Cylinder are set so that
            they all pack into the same volume/bounds.
        """ as std.string))
        XCTAssertEqual(value["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(value["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))

        expectingSomeNotifications([token], p.ClearMetadataByDictKey("assetInfo", "name"))
        let newValue = p.GetAllMetadata()
        XCTAssertEqual(newValue.size(), 3)
        XCTAssertEqual(newValue["documentation"], pxr.VtValue("""
        Defines a primitive sphere centered at the origin.
            
            The fallback values for Cube, Sphere, Cone, and Cylinder are set so that
            they all pack into the same volume/bounds.
        """ as std.string))
        XCTAssertEqual(newValue["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(newValue["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))
    }
    
    func test_ClearMetadataByDictKey_GetAllAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(p.GetAllAuthoredMetadata())
        XCTAssertEqual(value.size(), 3)
        XCTAssertEqual(value["assetInfo"], pxr.VtValue(["name" : pxr.VtValue("fizzy" as std.string)] as pxr.VtDictionary))
        XCTAssertEqual(value["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(value["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))

        expectingSomeNotifications([token], p.ClearMetadataByDictKey("assetInfo", "name"))
        let newValue = p.GetAllAuthoredMetadata()
        XCTAssertEqual(newValue.size(), 2)
        XCTAssertEqual(newValue["specifier"], pxr.VtValue(Overlay.SdfSpecifierDef))
        XCTAssertEqual(newValue["typeName"], pxr.VtValue("Sphere" as pxr.TfToken))
    }
    
    // MARK: SetHidden
    
    func test_SetHidden_IsHidden() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.IsHidden())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetHidden(true))
        XCTAssertTrue(p.IsHidden())
    }
    
    func test_SetHidden_HasAuthoredHidden() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasAuthoredHidden())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetHidden(true))
        XCTAssertTrue(p.HasAuthoredHidden())
    }
    
    // MARK: ClearHidden
    
    func test_ClearHidden_IsHidden() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetHidden(true)
        
        let (token, value) = registerNotification(p.IsHidden())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearHidden())
        XCTAssertFalse(p.IsHidden())
    }
    
    func test_ClearHidden_HasAuthoredHidden() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetHidden(true)
        
        let (token, value) = registerNotification(p.HasAuthoredHidden())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearHidden())
        XCTAssertFalse(p.HasAuthoredHidden())
    }
    
    // MARK: SetCustomData
    
    func test_SetCustomData_GetCustomData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.GetCustomData())
        XCTAssertEqual(value, [:])
        
        expectingSomeNotifications([token], p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)]))
        XCTAssertEqual(p.GetCustomData(), ["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
    }
    
    func test_SetCustomData_HasCustomData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasCustomData())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)]))
        XCTAssertTrue(p.HasCustomData())
    }
    
    // MARK: SetCustomDataByKey
    
    func test_SetCustomDataByKey_GetCustomDataByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.GetCustomDataByKey("fizz"))
        XCTAssertTrue(value.IsEmpty())
        
        expectingSomeNotifications([token], p.SetCustomDataByKey("fizz", pxr.VtValue("buzz" as pxr.TfToken)))
        XCTAssertEqual(p.GetCustomDataByKey("fizz"), pxr.VtValue("buzz" as pxr.TfToken))
    }
    
    func test_SetCustomDataByKey_HasCustomDataByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasCustomDataKey("fizz"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetCustomDataByKey("fizz", pxr.VtValue("buzz" as pxr.TfToken)))
        XCTAssertTrue(p.HasCustomDataKey("fizz"))
    }
    
    // MARK: ClearCustomData
    
    func test_ClearCustomData_GetCustomData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        let (token, value) = registerNotification(p.GetCustomData())
        XCTAssertEqual(value, ["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        expectingSomeNotifications([token], p.ClearCustomData())
        XCTAssertEqual(p.GetCustomData(), [:])
    }
    
    func test_ClearCustomData_HasCustomData() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        let (token, value) = registerNotification(p.HasCustomData())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearCustomData())
        XCTAssertFalse(p.HasCustomData())
    }
    
    // MARK: ClearCustomDataByKey
    
    func test_ClearCustomDataByKey_GetCustomDataByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        let (token, value) = registerNotification(p.GetCustomDataByKey("fizz"))
        XCTAssertEqual(value, pxr.VtValue("buzz" as pxr.TfToken))
        
        expectingSomeNotifications([token], p.ClearCustomDataByKey("fizz"))
        XCTAssertTrue(p.GetCustomDataByKey("fizz").IsEmpty())
    }
    
    func test_ClearCustomDataByKey_HasCustomDataKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        let (token, value) = registerNotification(p.HasCustomDataKey("fizz"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearCustomDataByKey("fizz"))
        XCTAssertFalse(p.HasCustomDataKey("fizz"))
    }
    
    // MARK: SetAssetInfo
    
    func test_SetAssetInfo_GetAssetInfo() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.GetAssetInfo())
        XCTAssertEqual(value, [:])
        
        expectingSomeNotifications([token], p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)]))
        XCTAssertEqual(p.GetAssetInfo(), ["name" : pxr.VtValue("fizzy" as std.string)])
    }
    
    func test_SetAssetInfo_HasAssetInfo() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasAssetInfo())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)]))
        XCTAssertTrue(p.HasAssetInfo())
    }
    
    // MARK: SetAssetInfoByKey
    
    func test_SetAssetInfoByKey_GetAssetInfoByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.GetAssetInfoByKey("name"))
        XCTAssertTrue(value.IsEmpty())
        
        expectingSomeNotifications([token], p.SetAssetInfoByKey("name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertEqual(p.GetAssetInfoByKey("name"), pxr.VtValue("fizzy" as std.string))
    }
    
    func test_SetAssetInfoByKey_HasAssetInfoKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasAssetInfoKey("name"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetAssetInfoByKey("name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertTrue(p.HasAssetInfoKey("name"))
    }
    
    // MARK: ClearAssetInfo
    
    func test_ClearAssetInfo_GetAssetInfo() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)])
        
        let (token, value) = registerNotification(p.GetAssetInfo())
        XCTAssertEqual(value, ["name" : pxr.VtValue("fizzy" as std.string)])
        
        expectingSomeNotifications([token], p.ClearAssetInfo())
        XCTAssertEqual(p.GetAssetInfo(), [:])
    }
    
    func test_ClearAssetInfo_HasAssetInfo() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)])
        
        let (token, value) = registerNotification(p.HasAssetInfo())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearAssetInfo())
        XCTAssertFalse(p.HasAssetInfo())
    }
    
    // MARK: ClearAssetInfoByKey
    
    func test_ClearAssetInfoByKey_GetAssetInfoByKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfoByKey("name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(p.GetAssetInfoByKey("name"))
        XCTAssertEqual(value, pxr.VtValue("fizzy" as std.string))
        
        expectingSomeNotifications([token], p.ClearAssetInfo())
        XCTAssertTrue(p.GetAssetInfoByKey("name").IsEmpty())
    }
    
    func test_ClearAssetInfoByKey_HasAssetInfoKey() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfoByKey("name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(p.HasAssetInfoKey("name"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearAssetInfo())
        XCTAssertFalse(p.HasAssetInfoKey("name"))
    }
    
    // MARK: SetDocumentation
    
    func test_SetDocumentation_GetDocumentation() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.GetDocumentation())
        XCTAssertEqual(value, """
        Defines a primitive sphere centered at the origin.
            
            The fallback values for Cube, Sphere, Cone, and Cylinder are set so that
            they all pack into the same volume/bounds.
        """)
        
        expectingSomeNotifications([token], p.SetDocumentation("my documentation string"))
        XCTAssertEqual(p.GetDocumentation(), "my documentation string")
    }
    
    func test_SetDocumentation_HasAuthoredDocumentation() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasAuthoredDocumentation())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetDocumentation("my documentation string"))
        XCTAssertTrue(p.HasAuthoredDocumentation())
    }
    
    // MARK: ClearDocumentation
    
    func test_ClearDocumentation_GetDocumentation() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDocumentation("my documentation string")
        
        let (token, value) = registerNotification(p.GetDocumentation())
        XCTAssertEqual(value, "my documentation string")
        
        expectingSomeNotifications([token], p.ClearDocumentation())
        XCTAssertEqual(p.GetDocumentation(), """
        Defines a primitive sphere centered at the origin.
            
            The fallback values for Cube, Sphere, Cone, and Cylinder are set so that
            they all pack into the same volume/bounds.
        """)
    }
    
    func test_ClearDocumentation_HasAuthoredDocumentation() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDocumentation("my documentation string")
        
        let (token, value) = registerNotification(p.HasAuthoredDocumentation())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearDocumentation())
        XCTAssertFalse(p.HasAuthoredDocumentation())
    }
    
    // MARK: SetDisplayName
    
    func test_SetDisplayName_GetDisplayName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.GetDisplayName())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], p.SetDisplayName("bar"))
        XCTAssertEqual(p.GetDisplayName(), "bar")
    }
    
    func test_SetDisplayName_HasAuthoredDisplayName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(p.HasAuthoredDisplayName())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetDisplayName("bar"))
        XCTAssertTrue(p.HasAuthoredDisplayName())
    }
    
    // MARK: ClearDisplayName
    
    func test_ClearDisplayName_GetDisplayName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDisplayName("bar")
        
        let (token, value) = registerNotification(p.GetDisplayName())
        XCTAssertEqual(value, "bar")
        
        expectingSomeNotifications([token], p.ClearDisplayName())
        XCTAssertEqual(p.GetDisplayName(), "")
    }
    
    func test_ClearDisplayName_HasAuthoredDisplayName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDisplayName("bar")
        
        let (token, value) = registerNotification(p.HasAuthoredDisplayName())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearDisplayName())
        XCTAssertFalse(p.HasAuthoredDisplayName())
    }
}
