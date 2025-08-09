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

final class Observation_MutateUsdProperty_ReadUsdProperty: ObservationHelper {

    // MARK: SetDisplayGroup
    
    func test_SetDisplayGroup_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertEqual(attr.GetDisplayGroup(), "buzz")
    }
    
    func test_SetDisplayGroup_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    func test_SetDisplayGroup_GetNestedDisplayGroups() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetNestedDisplayGroups())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz:foo"))
        XCTAssertEqual(attr.GetNestedDisplayGroups(), ["buzz", "foo"])
    }
    
    // MARK: ClearDisplayGroup
    
    func test_ClearDisplayGroup_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "buzz")
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertEqual(attr.GetDisplayGroup(), "")
    }
    
    func test_ClearDisplayGroup_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }
    
    func test_ClearDisplayGroup_GetNestedDisplayGroups() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz:foo")
        
        let (token, value) = registerNotification(attr.GetNestedDisplayGroups())
        XCTAssertEqual(value, ["buzz", "foo"])
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertEqual(attr.GetNestedDisplayGroups(), [])
    }
    
    // MARK: SetNestedDisplayGroups
    
    func test_SetNestedDisplayGroups_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertEqual(attr.GetDisplayGroup(), "buzz:bar")
    }
    
    func test_SetNestedDisplayGroups_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    func test_SetNestedDisplayGroups_GetNestedDisplayGroups() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(attr.GetNestedDisplayGroups())
        XCTAssertEqual(value, [])
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "foo"]))
        XCTAssertEqual(attr.GetNestedDisplayGroups(), ["buzz", "foo"])
    }
    
    // MARK: SetCustom
    
    func test_SetCustom_IsCustom() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attr.IsCustom())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetCustom(true))
        XCTAssertTrue(attr.IsCustom())
    }
    
    // MARK: FlattenTo
    
    func test_FlattenTo_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        attr.SetDisplayGroup("fizz")
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attrDest.GetDisplayGroup())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertEqual(attrDest.GetDisplayGroup(), "fizz")
    }
}
