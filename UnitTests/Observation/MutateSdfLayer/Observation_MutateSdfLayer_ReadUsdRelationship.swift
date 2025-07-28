//
//  Observation_MutateSdfLayer_ReadUsdRelationship.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/5/24.
//

import XCTest
import OpenUSD

final class Observation_MutateSdfLayer_ReadUsdRelationship: ObservationHelper {

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        
        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let bigRelationship = bigModelPrim.CreateRelationship("otherRel", true)
        
        let overPrim = model.OverridePrim("/bigModel")
        let overRelationship = overPrim.CreateRelationship("otherRel", true)
        overRelationship.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(bigRelationship.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Model.usda"))))
        XCTAssertTrue(bigRelationship.HasAuthoredTargets())
    }
    
    // MARK: EraseField
    
    func test_EraseField_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let prim = main.DefinePrim("/foo", "Plane")
        let rel = prim.CreateRelationship("myRel", true)
        rel.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.doubleSided"])
        
        expectingSomeNotifications([token], layer.EraseField("/foo.myRel", "targetPaths"))
        XCTAssertFalse(rel.GetTargets(&targets))
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Model.usda")))
        
        let bigModelPrim = main.DefinePrim("/bigModel", "Plane")
        let bigRelationship = bigModelPrim.CreateRelationship("otherRel", true)
        
        let overPrim = model.OverridePrim("/bigModel")
        let overRelationship = overPrim.CreateRelationship("otherRel", true)
        overRelationship.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(bigRelationship.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertFalse(bigRelationship.HasAuthoredTargets())
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        let rel = main.DefinePrim("/foo", "Plane").CreateRelationship("rel", true)
        let overAttr = sub2.OverridePrim("/foo").CreateRelationship("rel", true)
        overAttr.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)

        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertTrue(rel.HasAuthoredTargets())
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub2.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda")))
        let rel = main.DefinePrim("/foo", "Plane").CreateRelationship("rel", true)
        let overAttr = sub2.OverridePrim("/foo").CreateRelationship("rel", true)
        overAttr.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)

        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "Cube").CreateRelationship("myRel", true)
        let overRel = model.OverridePrim("/foo").CreateRelationship("myRel", true)
        overRel.AddTarget(".displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.SetSubLayerPaths([pathForStage(named: "Model.usda")]))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.displayColor"])
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("fizz", true)
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let overRel = model.OverridePrim("/foo").CreateRelationship("fizz", true)
        overRel.AddTarget(".displayColor", Overlay.UsdListPositionBackOfPrependList)

        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertTrue(rel.HasAuthoredTargets())
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        let rel = main.DefinePrim("/foo", "Plane").CreateRelationship("fizzy", true)
        let overRel = model.OverridePrim("/foo").CreateRelationship("fizzy", true)
        overRel.AddTarget(".displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.displayColor"])
        
        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertFalse(rel.GetTargets(&targets))
    }
    
    // MARK: Apply
    
    func test_Apply_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("fizzy", true)
        let otherRel = main.DefinePrim("/foo/child", "Plane").CreateRelationship("otherRel", true)
        rel.AddTarget("child.otherRel", Overlay.UsdListPositionBackOfPrependList)
        otherRel.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo/child.doubleSided"])

                
        var batchEdit = pxr.SdfBatchNamespaceEdit()
        batchEdit.Add(pxr.SdfNamespaceEdit.Rename("/foo/child", "bar"))
        expectingSomeNotifications([token], layer.Apply(batchEdit))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo/child.otherRel"])
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let copySrc = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "CopySrc.usda"), Overlay.UsdStage.LoadAll))
        let copyDest = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "CopyDest.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "CopyDest.usda"), 0)
        
        let rel = main.DefinePrim("/foo", "Plane").CreateRelationship("myRel", true)
        let overRel = copySrc.OverridePrim("/foo").CreateRelationship("myRel", true)
        overRel.AddTarget(".doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], Overlay.Dereference(copyDest.GetRootLayer()).TransferContent(copySrc.GetRootLayer()))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.doubleSided"])
    }
    
    // MARK: SetRootPrims
    
    func test_SetRootPrims_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let rel = main.DefinePrim("/foo", "Plane").CreateRelationship("myRel", true)
        rel.AddTarget("/bar.fizz", Overlay.UsdListPositionBackOfPrependList)
        let otherRel = main.DefinePrim("/foo/bar", "Sphere").CreateRelationship("fizz", true)
        otherRel.AddTarget("/foo.doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/bar.fizz"])
        
        expectingSomeNotifications([token], layer.SetRootPrims([layer.GetPrimAtPath("/foo"), layer.GetPrimAtPath("/foo/bar")]))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.doubleSided"])
    }
    
    // MARK: InsertRootPrim
    
    func test_InsertRootPrim_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let rel = main.DefinePrim("/foo", "Plane").CreateRelationship("myRel", true)
        rel.AddTarget("/bar.fizz", Overlay.UsdListPositionBackOfPrependList)
        let otherRel = main.DefinePrim("/foo/bar", "Sphere").CreateRelationship("fizz", true)
        otherRel.AddTarget("/foo.doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/bar.fizz"])
        
        expectingSomeNotifications([token], layer.InsertRootPrim(layer.GetPrimAtPath("/foo/bar"), 0))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.doubleSided"])
    }
    
    // MARK: RemoveRootPrim
    
    func test_RemoveRootPrim_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let rel = main.DefinePrim("/foo", "Plane").CreateRelationship("myRel", true)
        rel.AddTarget("/bar.fizz", Overlay.UsdListPositionBackOfPrependList)
        let otherRel = main.DefinePrim("/bar", "Sphere").CreateRelationship("fizz", true)
        otherRel.AddTarget("/foo.doubleSided", Overlay.UsdListPositionBackOfPrependList)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.doubleSided"])
        
        expectingSomeNotifications([token], layer.RemoveRootPrim(layer.GetPrimAtPath("/bar")))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/bar.fizz"])
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("myAttr", true)
        
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0

        def Sphere "foo"
        {
            custom rel myAttr
            prepend rel myAttr = </foo.radius>
        }

        
        """#)))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }
    
    // MARK: Clear
    
    func test_Clear_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("myAttr", true)
        let overRel = sub.OverridePrim("/foo").CreateRelationship("myAttr", true)
        overRel.AddTarget("/foo.radius", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Clear())
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
    
    // MARK: Reload
    
    func test_Reload_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("myAttr", true)
        let overRel = sub.OverridePrim("/foo").CreateRelationship("myAttr", true)
        overRel.AddTarget("/foo.radius", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Reload(true))
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
    
    // MARK: Import
    
    func test_Import_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()

        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("myAttr", true)
        let overRel = sub.OverridePrim("/foo").CreateRelationship("myAttr", true)
        overRel.AddTarget("/foo.radius", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("myAttr", true)
        let overRel = sub.OverridePrim("/foo").CreateRelationship("myAttr", true)
        overRel.AddTarget("/foo.radius", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([sub.GetRootLayer()], true))
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let sub = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub.usda"), Overlay.UsdStage.LoadAll))
        let subLayer = Overlay.Dereference(sub.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Sub.usda"), 0)

        let rel = main.DefinePrim("/foo", "Sphere").CreateRelationship("myAttr", true)
        let overRel = sub.OverridePrim("/foo").CreateRelationship("myAttr", true)
        overRel.AddTarget("/foo.radius", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], subLayer.SetIdentifier(pathForStage(named: "NewSub.usda")))
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
}
