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

final class Observation_MutateUsdStage_ReadUsdEditTarget: ObservationHelper {
    
    // MARK: Reload
    
    func test_Reload_IsValid() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        var model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
                
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        main.SetEditTarget(pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll))
        // Model.usda is still open because Main.usda points to it
        
        let editTarget = main.GetEditTarget()

        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.Reload())
        // Main.usda lets go of Model.usda and the edit target's layer goes away
        XCTAssertFalse(editTarget.IsValid())
    }
    
    func test_Reload_GetLayer() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        var model = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), Overlay.UsdStage.LoadAll))
                
        Overlay.Dereference(main.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        main.SetEditTarget(pxr.UsdEditTarget(model.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        model = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll))
        // Model.usda is still open because Main.usda points to it
        
        let editTarget = main.GetEditTarget()

        let (token, value) = registerNotification(Bool(editTarget.GetLayer()))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], main.Reload())
        // Main.usda lets go of Model.usda and the edit target's layer goes away
        XCTAssertFalse(Bool(editTarget.GetLayer()))
    }

    // MARK: dtor
    
    func test_dtor_IsValid() {
        var main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let editTarget = main.GetEditTarget()
        
        let (token, value) = registerNotification(editTarget.IsValid())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token]) { main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll)) }
        XCTAssertFalse(editTarget.IsValid())
    }

    func test_dtor_GetLayer() {
        var main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let editTarget = main.GetEditTarget()
        
        let (token, value) = registerNotification(Bool(editTarget.GetLayer()))
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token]) { main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll)) }
        XCTAssertFalse(Bool(editTarget.GetLayer()))
    }
}
