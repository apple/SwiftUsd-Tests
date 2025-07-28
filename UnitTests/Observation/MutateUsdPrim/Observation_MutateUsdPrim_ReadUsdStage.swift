//
//  Observation_MutateUsdPrim_ReadUsdStage.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/11/24.
//

import XCTest
import OpenUSD

final class Observation_MutateUsdPrim_ReadUsdStage: ObservationHelper {
    // MARK: SetSpecifier

    func test_SetSpecifier_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [p])
        
        expectingSomeNotifications([token], p.SetSpecifier(Overlay.SdfSpecifierOver))
        XCTAssertEqual(Array(main.Traverse()), [])
    }
    
    // MARK: SetTypeName
    
    func test_SetTypeName_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.SetTypeName("Sphere"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }

        
        """#)
    }
    
    // MARK: CleatTypeName
    
    func test_ClearTypeName_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.ClearTypeName())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def "foo"
        {
        }

        
        """#)
    }
    
    // MARK: SetActive
    
    func test_SetActive_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [p])
        
        expectingSomeNotifications([token], p.SetActive(false))
        XCTAssertEqual(Array(main.Traverse()), [])
    }
    
    // MARK: ClearActive
    
    func test_ClearActive_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.SetActive(false)

        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], p.ClearActive())
        XCTAssertEqual(Array(main.Traverse()), [p])
    }
    
    // MARK: SetPropertyOrder
    
    func test_SetProperyOrder_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.CreateRelationship("alpha", true)
        p.CreateRelationship("beta", true)
        
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
            custom rel alpha
            custom rel beta
        }

        
        """#)
        
        expectingSomeNotifications([token], p.SetPropertyOrder(["beta", "alpha"]))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
            reorder properties = ["beta", "alpha"]
            custom rel alpha
            custom rel beta
        }

        
        """#)
    }
    
    // MARK: ClearPropertyOrder
    
    func test_ClearProperyOrder_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.CreateRelationship("alpha", true)
        p.CreateRelationship("beta", true)
        p.SetPropertyOrder(["beta", "alpha"])
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
            reorder properties = ["beta", "alpha"]
            custom rel alpha
            custom rel beta
        }

        
        """#)
        
        expectingSomeNotifications([token], p.ClearPropertyOrder())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
            custom rel alpha
            custom rel beta
        }

        
        """#)
    }
    
    // MARK: RemoveProperty
    
    func test_RemoveProperty_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        var p = main.DefinePrim("/foo", "Cube")
        p.CreateRelationship("alpha", true)
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
            custom rel alpha
        }


        """#)
        
        expectingSomeNotifications([token], p.RemoveProperty("alpha"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
        }


        """#)
    }
    
    // MARK: SetKind
    
    func test_SetKind_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.SetKind("assembly"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo" (
            kind = "assembly"
        )
        {
        }

        
        """#)
    }
    
    // MARK: AddAppliedSchema
    
    func test_AddAppliedSchema_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo" (
            apiSchemas = ["PhysicsRigidBodyAPI"]
        )
        {
        }

        
        """#)
    }
    
    // MARK: RemoveAppliedSchmea
    
    func test_RemoveAppliedSchema_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.AddAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo" (
            apiSchemas = ["PhysicsRigidBodyAPI"]
        )
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.RemoveAppliedSchema(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo" (
            apiSchemas = None
        )
        {
        }

        
        """#)
    }
    
    // MARK: ApplyAPI
    
    func test_ApplyAPI_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo" (
            apiSchemas = ["PhysicsRigidBodyAPI"]
        )
        {
        }

        
        """#)
    }
    
    // MARK: RemoveAPI
    
    func test_RemoveAPI_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Cube")
        p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo" (
            apiSchemas = ["PhysicsRigidBodyAPI"]
        )
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], p.RemoveAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Cube "foo" (
            apiSchemas = None
        )
        {
        }

        
        """#)
    }
    
    // MARK: SetChildrenReorder
    
    func test_SetChildrenReorder_Traverse() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        let delta = main.DefinePrim("/foo/delta", "Sphere")
        
        
        let (token, value) = registerNotification(Array(main.Traverse()))
        XCTAssertEqual(value, [foo, bar, delta])
        
        expectingSomeNotifications([token], foo.SetChildrenReorder(["delta", "bar"]))
        XCTAssertEqual(Array(main.Traverse()), [foo, delta, bar])
    }
    
    // MARK: ClearChildrenReorder
    
    func test_ClearChildrenReorder_TraverseAll() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/foo/bar", "Sphere")
        let delta = main.DefinePrim("/foo/delta", "Sphere")
        foo.SetChildrenReorder(["delta", "bar"])
        
        let (token, value) = registerNotification(Array(main.TraverseAll()))
        XCTAssertEqual(value, [foo, delta, bar])
        
        expectingSomeNotifications([token], foo.ClearChildrenReorder())
        XCTAssertEqual(Array(main.Traverse()), [foo, bar, delta])
    }
    
    // MARK: CreateAttribute
    
    func test_CreateAttribute_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], foo.CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            custom double myAttr
        }

        
        """#)
    }
    
    // MARK: CreateRelationship
    
    func test_CreateRelationship_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")

        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], foo.CreateRelationship("myRel", true))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            custom rel myRel
        }

        
        """#)
    }
    
    // MARK: ClearPayload
    
    func test_ClearPayload_ExportToString() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        foo.SetPayload(pathForStage(named: "Payload.usda"), "/root")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            def Sphere "model"
            {
            }
        }

        
        """#)
        
        expectingSomeNotifications([token], foo.ClearPayload())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }

        
        """#)
    }
    
    // MARK: SetPayload
    
    func test_SetPayload_ExportToString() {
        let payload = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payload.DefinePrim("/root", "")
        payload.DefinePrim("/root/model", "Sphere")
        payload.Save()
        
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }

        
        """#)
        
        expectingSomeNotifications([token], foo.SetPayload(pathForStage(named: "Payload.usda"), "/root"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            def Sphere "model"
            {
            }
        }

        
        """#)
    }
    
    // MARK: Load
    
    func test_Load_Traverse() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadNone))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadNone))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        // With LoadNone, this prim isn't loadable, so it's still loaded
        XCTAssertEqual(Array(mainStage.Traverse()), [mainStage.GetPrimAtPath("/smallModel")])
        
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.Traverse())
        // After AddPayload, the prim is loadable, so with LoadNone it isn't loaded and doesn't get caught by Traverse()
        XCTAssertEqual(Array(value), [])
        
        expectingSomeNotifications([token], scopePrim.Load(Overlay.UsdLoadWithDescendants))
        XCTAssertEqual(Array(mainStage.Traverse()), [mainStage.GetPrimAtPath("/smallModel"), mainStage.GetPrimAtPath("/smallModel/bigModel")])
    }
    
    // MARK: Unload
    
    func test_Unload_Traverse() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let payloadStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Payload.usda"), Overlay.UsdStage.LoadAll))
        payloadStage.DefinePrim("/scope", "Scope")
        payloadStage.DefinePrim("/scope/bigModel", "Plane")
        payloadStage.Save()
        
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.GetPayloads().AddPayload(pxr.SdfPayload(pathForStage(named: "Payload.usda"), "/scope", pxr.SdfLayerOffset(0, 1)),
                                           Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(mainStage.Traverse())
        XCTAssertEqual(Array(value), [mainStage.GetPrimAtPath("/smallModel"), mainStage.GetPrimAtPath("/smallModel/bigModel")])
        
        expectingSomeNotifications([token], scopePrim.Unload())
        XCTAssertEqual(Array(mainStage.Traverse()), [])
    }
    
    // MARK: SetInstanceable
    
    func test_SetInstanceable_ExportToString() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")

        let (token, value) = registerNotification(mainStage.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Scope "smallModel"
        {
        }


        """#)
        
        expectingSomeNotifications([token], scopePrim.SetInstanceable(true))
        XCTAssertEqual(mainStage.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Scope "smallModel" (
            instanceable = true
        )
        {
        }


        """#)
    }
    
    // MARK: ClearInstanceable
    
    func test_ClearInstanceable_ExportToString() {
        let mainStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let scopePrim = mainStage.DefinePrim("/smallModel", "Scope")
        scopePrim.SetInstanceable(true)

        let (token, value) = registerNotification(mainStage.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Scope "smallModel" (
            instanceable = true
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], scopePrim.ClearInstanceable())
        XCTAssertEqual(mainStage.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Scope "smallModel"
        {
        }


        """#)
    }
}
