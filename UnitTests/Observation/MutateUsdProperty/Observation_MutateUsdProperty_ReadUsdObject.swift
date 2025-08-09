//===----------------------------------------------------------------------===//
// This source file is part of github.com/apple/SwiftUsd-Tests
//
// Copyright © 2025 Apple Inc. and the SwiftUsd-Tests project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0
//===----------------------------------------------------------------------===//

import XCTest
import OpenUSD

final class Observation_MutateUsdProperty_ReadUsdObject: ObservationHelper {

    // MARK: SetDisplayGroup
    
    func test_SetDisplayGroup_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("buzz" as std.string))
    }
    
    func test_SetDisplayGroup_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.HasMetadata("displayGroup"))
    }

    func test_SetDisplayGroup_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.HasAuthoredMetadata("displayGroup"))
    }
    
    // MARK: ClearDisplayGroup
    
    func test_ClearDisplayGroup_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue("buzz" as std.string))
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.GetMetadata("displayGroup", &vtValue))
    }
    
    func test_ClearDisplayGroup_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.HasMetadata("displayGroup"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.HasMetadata("displayGroup"))
    }
    
    func test_ClearDisplayGroup_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("displayGroup"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.HasAuthoredMetadata("displayGroup"))
    }
    
    // MARK: SetNestedDisplayGroups
    
    func test_SetNestedDisplayGroups_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertFalse(value)
        XCTAssertTrue(vtValue.IsEmpty())
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.GetMetadata("displayGroup", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue("buzz:bar" as std.string))
    }
    
    func test_SetNestedDisplayGroups_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.HasMetadata("displayGroup"))
    }

    func test_SetNestedDisplayGroups_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredMetadata("displayGroup"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.HasAuthoredMetadata("displayGroup"))
    }
    
    // MARK: SetCustom
    
    func test_SetCustom_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(attr.GetMetadata("custom", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(false))
        
        expectingSomeNotifications([token], attr.SetCustom(true))
        XCTAssertTrue(attr.GetMetadata("custom", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(true))
    }
    
    // MARK: FlattenTo
    
    func test_FlattenTo_operatorBool() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.GetAttribute("myAttr")
        
        let (token, value) = registerNotification(Bool(attrDest))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertTrue(Bool(attrDest))
    }
}
