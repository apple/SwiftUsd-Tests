// ===-------------------------------------------------------------------===//
// This source file is part of github.com/apple/SwiftUsd-Tests
//
// Copyright © 2025 Apple Inc. and the SwiftUsd-Tests authors. All Rights Reserved. 
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at: 
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.     
// 
// SPDX-License-Identifier: Apache-2.0
// ===-------------------------------------------------------------------===//

import XCTest
import OpenUSD

final class Observation_MutateSdfLayer_ReadUsdSchemaBase: ObservationHelper {
    

    // MARK: SetFieldDictValueByKey
    
    func test_SetFieldDictValueByKey_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))

        var s = pxr.UsdGeomCube(pxr.UsdPrim())
        Overlay.withUsdEditContext(main, pxr.UsdEditTarget(sub1.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            s = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(main), "/foo")
        }

        
        let (token, value) = registerNotification(Bool(s))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub2.usda"))))
        XCTAssertFalse(Bool(s))
    }
    
    // MARK: EraseField
    
    func test_EraseField_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let prim = main.DefinePrim("/foo", "Plane")
        prim.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        
        let schema = pxr.UsdPhysicsRigidBodyAPI(prim)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseField("/foo", "apiSchemas"))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: EraseFieldDictValueByKey
    
    func test_EraseFieldDictValueByKey_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))

        var s = pxr.UsdGeomCube(pxr.UsdPrim())
        Overlay.withUsdEditContext(main, pxr.UsdEditTarget(sub1.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            s = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(main), "/foo")
        }

        
        let (token, value) = registerNotification(Bool(s))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.EraseFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER"))
        XCTAssertFalse(Bool(s))
    }
    
    // MARK: SetExpressionVariables
    
    func test_SetExpressionVariables_operatorBool_cube() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        sub1.DefinePrim("/foo", "Cube")
        let schema = pxr.UsdGeomCube(main.GetPrimAtPath("/foo"))
        
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertFalse(Bool(schema))
    }
    
    func test_SetExpressionVariables_operatorBool_physicsRigidBodyAPI() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        main.DefinePrim("/foo", "Cube")
        sub1.OverridePrim("/foo").ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        let schema = pxr.UsdPhysicsRigidBodyAPI(main.GetPrimAtPath("/foo"))
        
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        var dict = pxr.VtDictionary()
        dict["WHICH_SUBLAYER"] = pxr.VtValue(pathForStage(named: "Sub2.usda"))
        expectingSomeNotifications([token], layer.SetExpressionVariables(dict))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: ClearExpressionVariables
    
    func test_ClearExpressionVariables_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let sub1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Sub1.usda"), Overlay.UsdStage.LoadAll))
        layer.InsertSubLayerPath("`${WHICH_SUBLAYER}`", 0)
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        
        sub1.DefinePrim("/foo", "Cube")
        let schema = pxr.UsdGeomCube(main.GetPrimAtPath("/foo"))
        
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ClearExpressionVariables())
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: SetSubLayerPaths
    
    func test_SetSubLayerPaths_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        
        main.DefinePrim("/foo", "")
        model.OverridePrim("/foo").SetTypeName("Cube")
        let schema = pxr.UsdGeomCube.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.SetSubLayerPaths([]))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: InsertSubLayerPath
    
    func test_InsertSubLayerPath_operatorBool() throws {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        model.OverridePrim("/foo").ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)

        
        let (token, value) = registerNotification(Bool(pxr.UsdPhysicsRigidBodyAPI(p)))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0))
        XCTAssertTrue(Bool(pxr.UsdPhysicsRigidBodyAPI(p)))
    }
    
    // MARK: RemoveSubLayerPath
    
    func test_RemoveSubLayerPath_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        layer.SetSubLayerPaths([pathForStage(named: "Model.usda")])
        
        main.DefinePrim("/foo", "")
        model.OverridePrim("/foo").SetTypeName("Cube")
        let schema = pxr.UsdGeomCube.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], layer.RemoveSubLayerPath(0))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: Apply
    
    func test_Apply_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
                
        let schema = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)

                
        var batchEdit = pxr.SdfBatchNamespaceEdit()
        batchEdit.Add(pxr.SdfNamespaceEdit.Rename("/foo", "bar"))
        expectingSomeNotifications([token], layer.Apply(batchEdit))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: TransferContent
    
    func test_TransferContent_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let other = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Other.usda"), Overlay.UsdStage.LoadAll))
        
        let p = main.DefinePrim("/foo", "Sphere")
        let schema = pxr.UsdGeomSphere(p)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.TransferContent(other.GetRootLayer()))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: SetRootPrims
    
    func test_SetRootPrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = pxr.UsdGeomSphere(main.DefinePrim("/foo", "Sphere"))
        main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(Bool(foo))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.SetRootPrims([layer.GetPrimAtPath("/bar")]))
        XCTAssertFalse(Bool(foo))
    }
    
    // MARK: InsertRootPrim
    
    func test_InsertRootPrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        main.DefinePrim("/foo", "Sphere")
        let bar = pxr.UsdGeomSphere(main.DefinePrim("/foo/bar", "Sphere"))
        
        let (token, value) = registerNotification(Bool(bar))
        XCTAssertTrue(value)
                
        expectingSomeNotifications([token], layer.InsertRootPrim(layer.GetPrimAtPath("/foo/bar"), 0))
        XCTAssertFalse(Bool(bar))
    }
    
    // MARK: RemoveRootPrim
    
    func test_RemoveRootPrim_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let foo = pxr.UsdGeomSphere(main.DefinePrim("/foo", "Sphere"))
        
        let (token, value) = registerNotification(Bool(foo))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.RemoveRootPrim(layer.GetPrimAtPath("/foo")))
        XCTAssertFalse(Bool(foo))
    }
    
    // MARK: ImportFromString
    
    func test_ImportFromString_operatorBool_sphere() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0

        
        """#)))
        XCTAssertFalse(Bool(schema))
    }
    
    func test_ImportFromString_operatorBool_physicsRigidBodyAPI() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let p = main.DefinePrim("/foo", "Sphere")
        p.ApplyAPI(.UsdPhysicsTokens.PhysicsRigidBodyAPI)
        
        let schema = pxr.UsdPhysicsRigidBodyAPI(p)
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.ImportFromString(std.string(#"""
        #usda 1.0

        def Sphere "foo" 
        {
        }
        
        
        """#)))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: Clear
    
    func test_Clear_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Clear())
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: Reload
    
    func test_Reload_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Reload(true))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: Import
    
    func test_Import_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Empty.usda"), Overlay.UsdStage.LoadAll)).Save()
        
        let schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], layer.Import(pathForStage(named: "Empty.usda")))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: ReloadLayers
    
    func test_ReloadLayers_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        
        let schema = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], pxr.SdfLayer.ReloadLayers([main.GetRootLayer()], true))
        XCTAssertFalse(Bool(schema))
    }
    
    // MARK: SetIdentifier
    
    func test_SetIdentifier_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
        let modelLayer = Overlay.Dereference(model.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        
        model.DefinePrim("/foo", "Sphere")
        let schema = pxr.UsdGeomSphere.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let (token, value) = registerNotification(Bool(schema))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], modelLayer.SetIdentifier(pathForStage(named: "NewModel.usda")))
        XCTAssertFalse(Bool(schema))
    }
}
