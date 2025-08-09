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

final class Observation_MutateUsdRelationship_ReadUsdRelationship: ObservationHelper {

    // MARK: AddTarget
    
    func test_AddTarget_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }
        
    func test_AddTarget_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }
        
    func test_AddTarget_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(rel.HasAuthoredTargets())
    }
    
    // MARK: RemoveTarget
    
    func test_RemoveTarget_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    func test_RemoveTarget_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    // MARK: SetTargets
    
    func test_SetTargets_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(rel.GetTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }

    func test_SetTargets_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertFalse(value)
        XCTAssertEqual(targets, [])
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, ["/foo.radius"])
    }
    
    func test_SetTargets_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(rel.HasAuthoredTargets())
    }
    
    // MARK: ClearTargets
    
    func test_ClearTargets_GetTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(rel.GetTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    func test_ClearTargets_GetForwardedTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        var targets = pxr.SdfPathVector()
        let (token, value) = registerNotification(rel.GetForwardedTargets(&targets))
        XCTAssertTrue(value)
        XCTAssertEqual(targets, ["/foo.radius"])

        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(rel.GetForwardedTargets(&targets))
        XCTAssertEqual(targets, [])
    }
    
    func test_ClearTargets_HasAuthoredTargets() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        let (token, value) = registerNotification(rel.HasAuthoredTargets())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(rel.HasAuthoredTargets())
    }
}
