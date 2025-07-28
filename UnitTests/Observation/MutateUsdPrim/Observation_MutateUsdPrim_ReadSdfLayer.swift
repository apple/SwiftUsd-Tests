//
//  Observation_MutateUsdPrim_ReadSdfLayer.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/11/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdPrim_ReadSdfLayer: ObservationHelper {

    // MARK: SetSpecifier

    func test_SetSpecifier_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(layer.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0

        def Cube "foo"
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.SetSpecifier(Overlay.SdfSpecifierOver))
        XCTAssertEqual(layer.ExportToString(), #"""
        #usda 1.0

        over Cube "foo"
        {
        }


        """#)
    }
    
    // MARK: SetTypeName
    
    func test_SetTypeName_GetFieldAs() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(layer.GetFieldAs("/foo", "typeName", pxr.TfToken()))
        XCTAssertEqual(value, "Cube")
        
        expectingSomeNotifications([token], p.SetTypeName("Sphere"))
        XCTAssertEqual(layer.GetFieldAs("/foo", "typeName", pxr.TfToken()), "Sphere")
    }
    
    // MARK: ClearTypeName
    
    func test_ClearTypeName_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(layer.HasField("/foo", "typeName", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertFalse(layer.HasField("/foo", "typeName", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetActive
    
    func test_SetActive_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(layer.HasField("/foo", "active", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetActive(false))
        XCTAssertTrue(layer.HasField("/foo", "active", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearActive
    
    func test_ClearActive_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        p.SetActive(true)

        let (token, value) = registerNotification(layer.HasField("/foo", "active", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.ClearActive())
        XCTAssertFalse(layer.HasField("/foo", "active", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetPropertyOrder
    
    func test_SetPropertyOrder_ListFields() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(layer.ListFields("/foo"))
        XCTAssertEqual(value, ["specifier", "typeName"])
        
        expectingSomeNotifications([token], p.SetPropertyOrder(["fizz"]))
        XCTAssertEqual(layer.ListFields("/foo"), ["specifier", "typeName", "propertyOrder"])
    }
    
    // MARK: ClearPropertyOrder
    
    func test_ClearPropertyOrder_ListFields() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        p.SetPropertyOrder(["fizz"])
        
        let (token, value) = registerNotification(layer.ListFields("/foo"))
        XCTAssertEqual(value, ["specifier", "typeName", "propertyOrder"])
        
        expectingSomeNotifications([token], p.ClearPropertyOrder())
        XCTAssertEqual(layer.ListFields("/foo"), ["specifier", "typeName"])
    }
    
    // MARK: RemoveProperty
    
    func test_RemoveProperty_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        var p = main.DefinePrim("/foo", "Cube")
        p.CreateRelationship("alpha", true)
        
        let (token, value) = registerNotification(layer.HasSpec("/foo.alpha"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], p.RemoveProperty("alpha"))
        XCTAssertFalse(layer.HasSpec("/foo.alpha"))
    }
    
    // MARK: SetKind
    
    func test_SetKind_ListFields() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(layer.ListFields("/foo"))
        XCTAssertEqual(value, ["specifier", "typeName"])
        
        expectingSomeNotifications([token], p.SetKind("component"))
        XCTAssertEqual(layer.ListFields("/foo"), ["specifier", "typeName", "kind"])
    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(layer.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0

        def Cube "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(layer.ExportToString(), #"""
        #usda 1.0

        def Cube "foo" (
            prepend apiSchemas = ["PhysicsRigidBodyAPI"]
        )
        {
        }

        
        """#)

    }
    
    // MARK: RemoveAppliedSchmea
    
    func test_RemoveAppliedSchema_GetFieldAs() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        
        var listOp = pxr.SdfTokenListOp()
        listOp.SetItems(["PhysicsRigidBodyAPI"], Overlay.SdfListOpTypePrepended, nil)

        let (token, value) = registerNotification(layer.GetField("/foo", "apiSchemas"))
        XCTAssertEqual(value, pxr.VtValue(listOp))
        
        expectingSomeNotifications([token], p.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        listOp.Clear()
        listOp.SetItems(["PhysicsRigidBodyAPI"], Overlay.SdfListOpTypeDeleted, nil)
        XCTAssertEqual(layer.GetField("/foo", "apiSchemas"), pxr.VtValue(listOp))
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(layer.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0

        def Cube "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(layer.ExportToString(), #"""
        #usda 1.0

        def Cube "foo" (
            prepend apiSchemas = ["PhysicsRigidBodyAPI"]
        )
        {
        }

        
        """#)
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_GetFieldAs() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let p = main.DefinePrim("/foo", "Cube")
        p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        
        var listOp = pxr.SdfTokenListOp()
        listOp.SetItems(["PhysicsRigidBodyAPI"], Overlay.SdfListOpTypePrepended, nil)

        let (token, value) = registerNotification(layer.GetField("/foo", "apiSchemas"))
        XCTAssertEqual(value, pxr.VtValue(listOp))
        
        expectingSomeNotifications([token], p.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        listOp.Clear()
        listOp.SetItems(["PhysicsRigidBodyAPI"], Overlay.SdfListOpTypeDeleted, nil)
        XCTAssertEqual(layer.GetField("/foo", "apiSchemas"), pxr.VtValue(listOp))
    }
    
    // MARK: SetChildrenReorder
    
    func test_SetChildrenReorder_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        main.DefinePrim("/foo/delta", "Sphere")
        
        
        let (token, value) = registerNotification(layer.GetField("/foo", "primOrder"))
        XCTAssertTrue(value.IsEmpty())
        
        expectingSomeNotifications([token], foo.SetChildrenReorder(["delta", "bar"]))
        XCTAssertEqual(layer.GetField("/foo", "primOrder"), pxr.VtValue(["delta", "bar"] as pxr.TfTokenVector))
    }
    
    // MARK: ClearChildrenReorder
    
    func test_ClearChildrenReorder_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/foo/bar", "Sphere")
        main.DefinePrim("/foo/delta", "Sphere")
        foo.SetChildrenReorder(["delta", "bar"])
        
        let (token, value) = registerNotification(layer.GetField("/foo", "primOrder"))
        XCTAssertEqual(value, pxr.VtValue(["delta", "bar"] as pxr.TfTokenVector))
        
        expectingSomeNotifications([token], foo.ClearChildrenReorder())
        XCTAssertTrue(layer.GetField("/foo", "primOrder").IsEmpty())
    }
    
    // MARK: CreateAttribute
    
    func test_CreateAttribute_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(layer.HasSpec("/foo.myAttr"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertTrue(layer.HasSpec("/foo.myAttr"))
    }
    
    // MARK: CreateRelationship
    
    func test_CreateRelationship_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(layer.HasSpec("/foo.myRel"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertTrue(layer.HasSpec("/foo.myRel"))
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_ListFields() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let layer = Overlay.Dereference(main.GetRootLayer())
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        
        
        let (token, value) = registerNotification(layer.ListFields("/foo"))
        XCTAssertEqual(value, ["specifier", "typeName", "payload"])
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertEqual(layer.ListFields("/foo"), ["specifier", "typeName"])
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_ListFields() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        
        let (token, value) = registerNotification(layer.ListFields("/foo"))
        XCTAssertEqual(value, ["specifier", "typeName"])
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertEqual(layer.ListFields("/foo"), ["specifier", "typeName", "payload"])
    }
    
    // MARK: SetInstanceable
    
    func test_SetInstanceable_ListFields() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(mainStage.GetRootLayer())
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")

        let (token, value) = registerNotification(layer.ListFields("/smallModel"))
        XCTAssertEqual(value, ["specifier", "typeName"])
        
        expectingSomeNotifications([token], scopePrim.SetInstanceable(true))
        XCTAssertEqual(layer.ListFields("/smallModel"), ["specifier", "typeName", "instanceable"])
    }
    
    // MARK: ClearInstanceable
    
    func test_ClearInstanceable_ListFields() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(mainStage.GetRootLayer())
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.SetInstanceable(true)

        let (token, value) = registerNotification(layer.ListFields("/smallModel"))
        XCTAssertEqual(value, ["specifier", "typeName", "instanceable"])
        
        expectingSomeNotifications([token], scopePrim.ClearInstanceable())
        XCTAssertEqual(layer.ListFields("/smallModel"), ["specifier", "typeName"])
    }
}
