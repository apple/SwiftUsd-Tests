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

final class Observation_MutateUsdRelationship_ReadSdfLayer: ObservationHelper {

    // MARK: AddTarget
    
    func test_AddTarget_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(layer.HasField("/foo.prototypes", "targetPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList))
        XCTAssertTrue(layer.HasField("/foo.prototypes", "targetPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: RemoveTarget
    
    func test_RemoveTarget_GetField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.AddTarget(".radius", Overlay.UsdListPositionBackOfPrependList)
        
        let (token, value) = registerNotification(layer.GetField("/foo.prototypes", "targetPaths"))
        XCTAssertEqual(value, pxr.VtValue(pxr.SdfPathListOp.Create(["/foo.radius"], [], [])))
        
        expectingSomeNotifications([token], rel.RemoveTarget(".radius"))
        XCTAssertEqual(layer.GetField("/foo.prototypes", "targetPaths"),
                       pxr.VtValue(pxr.SdfPathListOp.Create([], [], ["/foo.radius"])))
    }
    
    // MARK: SetTargets
    
    func test_SetTargets_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        
        let (token, value) = registerNotification(layer.HasField("/foo.prototypes", "targetPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], rel.SetTargets([".radius"]))
        XCTAssertTrue(layer.HasField("/foo.prototypes", "targetPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
    
    // MARK: ClearTargets
    
    func test_ClearTargets_HasField() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let rel = main.DefinePrim("/foo", "PointInstancer").GetRelationship("prototypes")
        rel.SetTargets([".radius"])
        
        let (token, value) = registerNotification(layer.HasField("/foo.prototypes", "targetPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], rel.ClearTargets(false))
        XCTAssertFalse(layer.HasField("/foo.prototypes", "targetPaths", nil as UnsafeMutablePointer<pxr.VtValue>?))
    }
}
