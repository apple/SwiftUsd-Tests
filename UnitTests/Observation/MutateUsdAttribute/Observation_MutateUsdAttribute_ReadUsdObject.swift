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

final class Observation_MutateUsdAttribute_ReadUsdObject: ObservationHelper {

    // MARK: SetVariability
    
    func test_SetVariability_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("variability", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(Overlay.SdfVariabilityVarying))
        
        expectingSomeNotifications([token], attr.SetVariability(Overlay.SdfVariabilityUniform))
        XCTAssertTrue(attr.GetMetadata("variability", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(Overlay.SdfVariabilityUniform))
    }
    
    // MARK: SetTypeName
    
    func test_SetTypeName_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, true, Overlay.SdfVariabilityVarying)
        
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("typeName", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("double" as pxr.TfToken))
        
        expectingSomeNotifications([token], attr.SetTypeName(.Float))
        XCTAssertTrue(attr.GetMetadata("typeName", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("float" as pxr.TfToken))
    }
    
    // MARK: AddConnection
    
    func test_AddConnection_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        
        let (token, value) = registerNotification(attr.HasMetadata("connectionPaths"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(attr.HasMetadata("connectionPaths"))
    }

    // MARK: RemoveConnection
    
    func test_RemoveConnection_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("connectionPaths", &vtValue))
        XCTAssertTrue(value)
        var listOp = pxr.SdfPathListOp()
        listOp.SetPrependedItems(["/foo.displayColor"], nil)
        XCTAssertEqual(vtValue, pxr.VtValue(listOp))
        
        expectingSomeNotifications([token], attr.RemoveConnection("/foo.displayColor"))
        XCTAssertTrue(attr.GetMetadata("connectionPaths", &vtValue))
        listOp.Clear()
        listOp.SetDeletedItems(["/foo.displayColor"], nil)
        XCTAssertEqual(vtValue, pxr.VtValue(listOp))
    }
    
    // MARK: SetConnections
    
    func test_SetConnections_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        
        let (token, value) = registerNotification(attr.HasMetadata("connectionPaths"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetConnections(["/foo.displayColor"]))
        XCTAssertTrue(attr.HasMetadata("connectionPaths"))
    }
    
    // MARK: ClearConnections
    
    func test_ClearConnections_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.AddConnection("/foo.displayColor", Overlay.UsdListPositionBackOfPrependList)
        
        
        let (token, value) = registerNotification(attr.HasMetadata("connectionPaths"))
        XCTAssertTrue(value)

        expectingSomeNotifications([token], attr.ClearConnections())
        XCTAssertFalse(attr.HasMetadata("connectionPaths"))
    }
    
    // MARK: SetColorSpace
    
    func test_SetColorSpace_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("colorSpace", &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], attr.SetColorSpace("bar"))
        XCTAssertTrue(attr.GetMetadata("colorSpace", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("bar" as pxr.TfToken))
    }
    
    // MARK: ClearColorSpace
    
    func test_ClearColorSpace_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetColorSpace("bar")

        let (token, value) = registerNotification(attr.HasMetadata("colorSpace"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearColorSpace())
        XCTAssertFalse(attr.HasMetadata("colorSpace"))
    }
    
    // MARK: Set
    
    func test_Set_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("default", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(1.0))
        
        expectingSomeNotifications([token], attr.Set(2.718, .Default()))
        XCTAssertTrue(attr.GetMetadata("default", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(2.718))
    }
    
    // MARK: Clear
    
    func test_Clear_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(2.718, .Default())
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("default"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.Clear())
        XCTAssertFalse(attr.HasAuthoredMetadata("default"))
    }
    
    // MARK: ClearAtTime
    
    func test_ClearAtTime_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, 5)
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("timeSamples"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearAtTime(5))
        XCTAssertFalse(attr.HasAuthoredMetadata("timeSamples"))
    }
    
    // MARK: ClearDefault
    
    func test_ClearDefault_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, .Default())
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("default"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDefault())
        XCTAssertFalse(attr.HasAuthoredMetadata("default"))
    }
    
    // MARK: Block
    
    func test_Block_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.Set(3.0, 7)
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("timeSamples"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.Block())
        XCTAssertFalse(attr.HasAuthoredMetadata("timeSamples"))
    }
}
