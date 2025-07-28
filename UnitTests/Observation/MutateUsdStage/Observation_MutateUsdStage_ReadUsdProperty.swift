//
//  Observation_MutateUsdStage_ReadUsdProperty.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/3/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdStage_ReadUsdProperty: ObservationHelper {
    
    // MARK: Load

    func test_Load_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], mainStage.Load("/smallModel", Overlay.UsdLoadWithDescendants))
        XCTAssertTrue(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())

    }
    
    // MARK: Unload

    func test_Unload_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.Unload("/smallModel"))
        XCTAssertFalse(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())

    }
    
    // MARK: LoadAndUnload

    func test_LoadAndUnload_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.LoadAndUnload([], ["/smallModel"], Overlay.UsdLoadWithDescendants))
        XCTAssertFalse(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())

    }

    // MARK: SetLoadRules

    func test_SetLoadRules_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], mainStage.SetLoadRules(pxr.UsdStageLoadRules.LoadAll()))
        XCTAssertTrue(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())

    }
    
    // MARK: SetPopulationMask

    func test_SetPopulationMask_IsDefined() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
                        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], mainStage.SetPopulationMask(pxr.UsdStagePopulationMask()))
        XCTAssertFalse(mainStage.GetPropertyAtPath("/smallModel/bigModel.doubleSided").IsDefined())

    }
    
    // MARK: MuteLayer
    
    func test_MuteLayer_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var attr = pxr.UsdAttribute()
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            attr = spherePrim.CreateAttribute("myCustomAttr", .Float3, true, Overlay.SdfVariabilityVarying)
        }
        
        let (token, value) = registerNotification(attr.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.MuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertFalse(attr.IsDefined())
    }
    
    // MARK: UnmuteLayer
    
    func test_UnmuteLayer_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let sphere = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        let radiusAttr = sphere.GetRadiusAttr()
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            radiusAttr.SetDisplayGroup("myDisplayGroup")
        }
        
        main.MuteLayer(pathForStage(named: "Model.usda"))
        
        let (token, value) = registerNotification(radiusAttr.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], main.UnmuteLayer(pathForStage(named: "Model.usda")))
        XCTAssertEqual(radiusAttr.GetDisplayGroup(), "myDisplayGroup")
    }
    
    // MARK: MuteAndUnmuteLayers
    
    func test_MuteAndUnmuteLayers_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let sphere = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/hi")
        let radiusAttr = sphere.GetRadiusAttr()
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        Overlay.withUsdEditContext(main, modelEditTarget) {
            radiusAttr.SetDisplayGroup("myDisplayGroup")
        }
                
        let (token, value) = registerNotification(radiusAttr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.MuteAndUnmuteLayers([pathForStage(named: "Model.usda")], []))
        XCTAssertFalse(radiusAttr.HasAuthoredDisplayGroup())
    }
    
    // MARK: SetMetadata
    
    func test_SetMetadata_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).SetDisplayGroup("foo")
                        
        let attr = spherePrim.GetAttribute("radius")
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.SetMetadata("subLayers", pxr.VtValue([] as Overlay.String_Vector)))
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)

        let spherePrim = main.DefinePrim("/hi", "Sphere")
                
        let sphereOver = model.OverridePrim("/hi")
        sphereOver.CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).SetDisplayGroup("foo")
                        
        let attr = spherePrim.GetAttribute("radius")
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.ClearMetadata("subLayers"))
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }
    
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("noAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        let radiusAttr = spherePrim.GetAttribute("radius")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            radiusAttr.SetDisplayGroup("myDisplayGroup")
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        let (token, value) = registerNotification(radiusAttr.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string)))
        XCTAssertEqual(radiusAttr.GetDisplayGroup(), "myDisplayGroup")
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        main.SetMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR", pxr.VtValue("hasAttr" as std.string))
        
        let spherePrim = main.DefinePrim("/hi", "Sphere")
        var vset = spherePrim.GetVariantSet("myVset")
        vset.AddVariant("noAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.AddVariant("hasAttr", Overlay.UsdListPositionBackOfPrependList)
        vset.SetVariantSelection("hasAttr")
        let radiusAttr = spherePrim.GetAttribute("radius")
        
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            radiusAttr.SetDisplayGroup("myDisplayGroup")
        }
        vset.SetVariantSelection("`${EXPR_HAS_ATTR}`")
        
        let (token, value) = registerNotification(radiusAttr.GetDisplayGroup())
        XCTAssertEqual(value, "myDisplayGroup")
        
        expectingSomeNotifications([token], main.ClearMetadataByDictKey("expressionVariables", "EXPR_HAS_ATTR"))
        XCTAssertEqual(radiusAttr.GetDisplayGroup(), "")
    }
    
    // MARK: Reload
    
    func test_Reload_IsDefined() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
                        
        _ = main.DefinePrim("/smallModel", "Plane")
        let prop = main.GetPropertyAtPath("/smallModel.doubleSided")
        let (token, value) = registerNotification(prop.IsDefined())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.Reload())
        XCTAssertFalse(prop.IsDefined())
    }
    
    // MARK: RemovePrim
    
    func test_RemovePrim_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        
        let modelEditTarget = pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        main.SetEditTarget(modelEditTarget)
        attr.SetDisplayGroup("hi")
        
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "hi")
        
        expectingSomeNotifications([token], main.RemovePrim("/foo"))
        XCTAssertEqual(attr.GetDisplayGroup(), "")
    }
}
