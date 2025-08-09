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

final class Observation_MutateUsdRelationship_ReadUsdObject: ObservationHelper {

    // MARK: AddTarget
    
    func test_AddTarget_HasMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(Overlay.HasMetadata(rel, "targetPaths"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(Overlay.HasMetadata(rel, "targetPaths"))
    }
    
    // MARK: RemoveTarget
    
    func test_RemoveTarget_GetMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        var vtValue = pxr.VtValue()
        let (token, value) = registerNotification(Overlay.GetMetadata(rel, "targetPaths", &vtValue))
        XCTAssertTrue(value)
        XCTAssertEqual(vtValue, pxr.VtValue(pxr.SdfPathListOp.Create(["/foo.radius"], [], [])))
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertTrue(Overlay.GetMetadata(rel, "targetPaths", &vtValue))
        XCTAssertEqual(vtValue, pxr.VtValue(pxr.SdfPathListOp.Create([], [], ["/foo.radius"])))
    }

    // MARK: SetTargets
    
    func test_SetTargets_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
    }
    
    // MARK: ClearTargets
    
    func test_ClearTargets_HasAuthoredMetadata() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        let (token, value) = registerNotification(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(Overlay.HasAuthoredMetadata(rel, "targetPaths"))
    }
}
