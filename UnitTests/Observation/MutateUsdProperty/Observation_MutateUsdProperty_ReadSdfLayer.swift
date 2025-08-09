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

final class Observation_MutateUsdProperty_ReadSdfLayer: ObservationHelper {

    // MARK: SetDisplayGroup
    
    func test_SetDisplayGroup_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertTrue(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearDisplayGroup
    
    func test_ClearDisplayGroup_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertFalse(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }

    // MARK: SetNestedDisplayGroups
    
    func test_SetNestedDisplayGroups_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertTrue(layer.HasField("/foo.radius", "displayGroup", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: SetCustom
    
    func test_SetCustom_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(layer.GetField("/foo.myAttr", "custom"))
        XCTAssertEqual(value, pxr.VtValue(false))
        
        expectingSomeNotifications([token], attr.SetCustom(true))
        XCTAssertEqual(layer.GetField("/foo.myAttr", "custom"), pxr.VtValue(true))
    }
    
    // MARK: FlattenTo
    
    func test_FlattenTo_HasSpec() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(layer.HasSpec("/bar.myAttr"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertTrue(layer.HasSpec("/bar.myAttr"))
    }
}
