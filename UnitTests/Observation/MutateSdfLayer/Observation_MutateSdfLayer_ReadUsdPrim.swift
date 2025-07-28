//
//  Observation_MutateSdfLayer_ReadUsdPrim.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/5/24.
//

import XCTest
import OpenUSD

final class Observation_MutateSdfLayer_ReadUsdPrim: ObservationHelper {

    // MARK: SetField
    
    func test_SetField_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
                
        let (token, value) = registerNotification(p.IsActive())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetField("/foo", "active", pxr.VtValue(false)))
        XCTAssertFalse(p.IsActive())
    }

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_GetAppliedSchemas() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        withExtendedLifetime(sub1) {}
        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let p = main.DefinePrim("/foo", "Cube")
        sub2.OverridePrim("/foo").ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        
        let (token, value) = registerNotification(p.GetAppliedSchemas())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        XCTAssertEqual(p.GetAppliedSchemas(), [.UsdPhysicsTokens.PhysicsRigidBodyAPI])
    }
    
    // MARK: EraseField
    
    func test_EraseField_IsModel() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetKind("model")
                
        let (token, value) = registerNotification(p.IsModel())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseField("/foo", "kind"))
        XCTAssertFalse(p.IsModel())
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_GetAppliedSchemas() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        let p = main.DefinePrim("/foo", "Cube")
        sub1.OverridePrim("/foo").ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        
        let (token, value) = registerNotification(p.GetAppliedSchemas())
        XCTAssertEqual(value, [.UsdPhysicsTokens.PhysicsRigidBodyAPI])
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertEqual(p.GetAppliedSchemas(), [])
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_HasAuthoredActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        let p = main.DefinePrim("/foo", "Plane")
        sub2.OverridePrim("/foo").SetActive(true)

        
        let (token, value) = registerNotification(p.HasAuthoredActive())
        XCTAssertFalse(value)
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertTrue(p.HasAuthoredActive())
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_HasProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda")))
        let p = main.DefinePrim("/foo", "Plane")
        sub2.OverridePrim("/foo").CreateAttribute("myAttr", .Float, true, Overlay.SdfVariabilityVarying)

        
        let (token, value) = registerNotification(p.HasProperty("myAttr"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(p.HasProperty("myAttr"))
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_HasAuthoredTypeName() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "")
        model.OverridePrim("/foo").SetTypeName("Cube")
        
        
        let (token, value) = registerNotification(p.HasAuthoredTypeName())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        XCTAssertTrue(p.HasAuthoredTypeName())
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_GetChildrenNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Cube")
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        model.DefinePrim("/foo/bar", "Cube")

        let (token, value) = registerNotification(p.GetChildrenNames())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertEqual(p.GetChildrenNames(), ["bar"])
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        model.OverridePrim("/foo").SetActive(false)
        let p = main.DefinePrim("/foo", "Cube")
        
        
        let (token, value) = registerNotification(p.IsActive())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertTrue(p.IsActive())
    }
    
    // MARK: SetSubLayerOffset
    
    func test_SetSubLayerOffset_GetPrimStackWithLayerOffsets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let modelLayer = Overlay.Dereference(model.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        let p = main.DefinePrim("/foo", "Sphere")
        model.OverridePrim("/foo").CreateAttribute("radius", .Double, false, Overlay.SdfVariabilityVarying).Set(5.0, 2.0)

        var (token, value) = registerNotification(p.GetPrimStackWithLayerOffsets())
        XCTAssertEqual(value.size(), 2)
        XCTAssertEqual(value[0].first, layer.GetPrimAtPath("/foo"))
        XCTAssertEqual(value[0].second, pxr.SdfLayerOffset(0, 1))
        XCTAssertEqual(value[1].first, modelLayer.GetPrimAtPath("/foo"))
        XCTAssertEqual(value[1].second, pxr.SdfLayerOffset(0, 1))

        
        expectingSomeNotifications([token], layer.SetSubLayerOffset(pxr.SdfLayerOffset(2, 3), 0))
        value = p.GetPrimStackWithLayerOffsets()
        XCTAssertEqual(value.size(), 2)
        XCTAssertEqual(value[0].first, layer.GetPrimAtPath("/foo"))
        XCTAssertEqual(value[0].second, pxr.SdfLayerOffset(0, 1))
        XCTAssertEqual(value[1].first, modelLayer.GetPrimAtPath("/foo"))
        XCTAssertEqual(value[1].second, pxr.SdfLayerOffset(2, 3))
    }
    
    // MARK: Apply
    
    func test_Apply_GetChildrenNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let p = main.DefinePrim("/beta", "Sphere")
        main.DefinePrim("/beta/alpha", "Sphere")
        
        
        let (token, value) = registerNotification(p.GetChildrenNames())
        XCTAssertEqual(value, ["alpha"])
        
        var batchEdit = pxr.SdfBatchNamespaceEdit()
        batchEdit.Add(pxr.SdfNamespaceEdit.Rename("/beta/alpha", "delta"))
        expectingSomeNotifications([token], layer.Apply(batchEdit))
        XCTAssertEqual(p.GetChildrenNames(), ["delta"])
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let other = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Other.usda"), Overlay.UsdStage.LoadAll))
        
        let p = main.DefinePrim("/foo", "Sphere")
        other.DefinePrim("/foo", "Sphere").SetActive(false)
        
        let (token, value) = registerNotification(p.IsActive())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.TransferContent(other.GetRootLayer()))
        XCTAssertFalse(p.IsActive())
    }
    
    // MARK: SetRootPrims
    
    func test_SetRootPrim_GetNextSibling() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        let fizz = main.DefinePrim("/fizz", "Sphere")
        
        let (token, value) = registerNotification(bar.GetNextSibling())
        XCTAssertEqual(value, fizz)
        
        expectingSomeNotifications([token], layer.SetRootPrims([layer.GetPrimAtPath("/bar"), layer.GetPrimAtPath("/foo"), layer.GetPrimAtPath("/fizz")]))
        XCTAssertEqual(bar.GetNextSibling(), foo)
    }
    
    // MARK: InsertRootPrim
    
    func test_InsertRootPrim_GetAllChildren() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        
        let (token, value) = registerNotification(Array(foo.GetAllChildren()))
        XCTAssertEqual(value, [bar])
                
        expectingSomeNotifications([token], layer.InsertRootPrim(layer.GetPrimAtPath("/foo/bar"), 0))
        XCTAssertEqual(Array(foo.GetAllChildren()), [])
    }
    
    // MARK: RemoveRootPrim
    
    func test_RemoveRootPrim_GetNextSibling() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        let fizz = main.DefinePrim("/fizz", "Sphere")
        
        let (token, value) = registerNotification(foo.GetNextSibling())
        XCTAssertEqual(value, bar)
        
        expectingSomeNotifications([token], layer.RemoveRootPrim(layer.GetPrimAtPath("/bar")))
        XCTAssertEqual(foo.GetNextSibling(), fizz)
    }
    
    // MARK: ScheduleRemoveIfInert
    
    func test_ScheduleRemoveIfInert_GetAllChildrenNames() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        main.OverridePrim("/foo/bar")
        
        let (token, value) = registerNotification(p.GetAllChildrenNames())
        XCTAssertEqual(value, ["bar"])
        
        expectingSomeNotifications([token], layer.ScheduleRemoveIfInert(layer.GetObjectAtPath("/foo/bar").GetSpec()))
        XCTAssertEqual(p.GetAllChildrenNames(), [])
    }
    
    // MARK: RemovePrimIfInert
    
    func test_RemovePrimIfInert_GetAllDescendants() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        let bar = main.OverridePrim("/foo/bar")
        
        let (token, value) = registerNotification(Array(p.GetAllDescendants()))
        XCTAssertEqual(value, [bar])
        
        expectingSomeNotifications([token], layer.RemovePrimIfInert(layer.GetPrimAtPath("/foo/bar")))
        XCTAssertEqual(Array(p.GetAllDescendants()), [])
    }
    
    // MARK: RemovePropertyIfHasOnlyRequiredFields
    
    func test_RemovePropertyIfHasOnlyRequiredFields_HasProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Sphere")
        p.CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        
        let (token, value) = registerNotification(p.HasProperty("myAttr"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemovePropertyIfHasOnlyRequiredFields(layer.GetPropertyAtPath("/foo.myAttr")))
        XCTAssertFalse(p.HasProperty("myAttr"))
    }
    
    // MARK: RemoveInertSceneDescription
    
    func test_RemoveInertSceneDescription_GetAllChildren() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.OverridePrim("/foo/bar")
        
        
        let (token, value) = registerNotification(Array(foo.GetAllChildren()))
        XCTAssertEqual(value, [bar])
        
        expectingSomeNotifications([token], layer.RemoveInertSceneDescription())
        XCTAssertEqual(Array(foo.GetAllChildren()), [])
    }
    
    // MARK: SetRootPrimOrder
    
    func test_SetRootPrimOrder_GetNextSibling() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        let fizz = main.DefinePrim("/fizz", "Sphere")
        
        
        let (token, value) = registerNotification(bar.GetNextSibling())
        XCTAssertEqual(value, fizz)
        
        expectingSomeNotifications([token], layer.SetRootPrimOrder(["bar", "foo", "fizz"]))
        XCTAssertEqual(bar.GetNextSibling(), foo)
    }
    
    // MARK: InsertInRootPrimOrder
    
    func test_InsertInRootPrimOrder_GetNextSibling() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        let fizz = main.DefinePrim("/fizz", "Sphere")
        layer.SetRootPrimOrder(["foo", "fizz"])

        
        let (token, value) = registerNotification(bar.GetNextSibling())
        XCTAssertEqual(value, fizz)

        expectingSomeNotifications([token], layer.InsertInRootPrimOrder("bar", 0))
        XCTAssertEqual(bar.GetNextSibling(), foo)
    }
    
    // MARK: RemoveFromRootPrimOrder
    
    func test_RemoveFromRootPrimOrder_GetNextSibling() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        let fizz = main.DefinePrim("/fizz", "Sphere")
        layer.SetRootPrimOrder(["bar", "foo", "fizz"])

        
        let (token, value) = registerNotification(bar.GetNextSibling())
        XCTAssertEqual(value, foo)

        expectingSomeNotifications([token], layer.RemoveFromRootPrimOrder("bar"))
        XCTAssertEqual(bar.GetNextSibling(), fizz)
    }
    
    // MARK: RemoveFromRootPrimOrderByIndex
    
    func test_RemoveFromRootPrimOrderByIndex_GetNextSibling() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        let fizz = main.DefinePrim("/fizz", "Sphere")
        layer.SetRootPrimOrder(["bar", "foo", "fizz"])

        
        let (token, value) = registerNotification(bar.GetNextSibling())
        XCTAssertEqual(value, foo)

        expectingSomeNotifications([token], layer.RemoveFromRootPrimOrderByIndex(0))
        XCTAssertEqual(bar.GetNextSibling(), fizz)
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_HasAuthoredActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetActive(false)
        
        let (token, value) = registerNotification(p.HasAuthoredActive())
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0
        
        def Sphere "foo"
        {
        }
        

        """#)))
        XCTAssertFalse(p.HasAuthoredActive())
    }
    
    // MARK: Clear
    
    func test_Clear_IsActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let p = main.DefinePrim("/foo", "Sphere")
        sub.OverridePrim("/foo").SetActive(false)
        
        let (token, value) = registerNotification(p.IsActive())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], subLayer.Clear())
        XCTAssertTrue(p.IsActive())
    }
    
    // MARK: Reload
    
    func test_Reload_HasAuthoredActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let p = main.DefinePrim("/foo", "Sphere")
        sub.OverridePrim("/foo").SetActive(false)
        
        let (token, value) = registerNotification(p.HasAuthoredActive())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Reload(true))
        XCTAssertFalse(p.HasAuthoredActive())
    }
    
    // MARK: Import
    
    func test_Import_HasAuthoredActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()

        let p = main.DefinePrim("/foo", "Sphere")
        sub.OverridePrim("/foo").SetActive(false)
        
        let (token, value) = registerNotification(p.HasAuthoredActive())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(p.HasAuthoredActive())
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_HasAuthoredActive() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let p = main.DefinePrim("/foo", "Sphere")
        sub.OverridePrim("/foo").SetActive(false)
        
        let (token, value) = registerNotification(p.HasAuthoredActive())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([sub.GetRootLayer()], true))
        XCTAssertFalse(p.HasAuthoredActive())
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_HasProperty() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let overStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "OverStage.usda"), Overlay.UsdStage.LoadAll))
        let overLayer = Overlay.Dereference(overStage.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "OverStage.usda"), 0)
        
        let p = main.DefinePrim("/foo", "Sphere")
        overStage.OverridePrim("/foo").CreateRelationship("myRel", true)
        
        
        let (token, value) = registerNotification(p.HasProperty("myRel"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], overLayer.SetIdentifier(pathForStage(named: "NewOverStage.usda")))
        XCTAssertFalse(p.HasProperty("myRel"))
    }
}
