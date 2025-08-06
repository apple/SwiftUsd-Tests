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

final class OverlayTfPtr: TemporaryDirectoryHelper {
    // Make ref or weak?
    // Make stage or layer?
    // From raw or smart?
    // If from smart=from weak, from closed or open?
    
    func test_ref_stage_from_raw() {
        do {
            var stageP: pxr.UsdStageRefPtr!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                stageP = Overlay.TfRefPtr(stage)
                assertOpen("HelloWorld.usda")
                Overlay.Dereference(stageP).SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            Overlay.Dereference(stageP).SetEndTimeCode(9)

        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_ref_stage_from_weak_closed() {
        do {
            var stageP: pxr.UsdStageRefPtr!
            withExtendedLifetime(stageP) {
                var stageWeakP: pxr.UsdStagePtr!
                do {
                    let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                    assertOpen("HelloWorld.usda")
                    stageWeakP = Overlay.TfWeakPtr(stage)
                    assertOpen("HelloWorld.usda")
                    Overlay.Dereference(stageWeakP).SetStartTimeCode(5)
                }
                assertClosed("HelloWorld.usda")
                stageP = Overlay.TfRefPtr(stageWeakP)
                assertClosed("HelloWorld.usda")
            }
            assertClosed("HelloWorld.usda")
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_ref_stage_from_weak_open() {
        do {
            var stageP: pxr.UsdStageRefPtr!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                let stageWeakP = Overlay.TfWeakPtr(stage)
                stageP = Overlay.TfRefPtr(stageWeakP)
                Overlay.Dereference(stageP).SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            Overlay.Dereference(stageP).SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_ref_layer_from_raw() {
        do {
            var layerP: pxr.SdfLayerRefPtr!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let layer = Overlay.Dereference(stage.GetRootLayer())
                layerP = Overlay.TfRefPtr(layer)
                assertOpen("HelloWorld.usda")
                Overlay.Dereference(layerP).SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            Overlay.Dereference(layerP).SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_ref_layer_from_weak_closed() {
        do {
            var layerP: pxr.SdfLayerRefPtr!
            withExtendedLifetime(layerP) {
                var layerWeakP: pxr.SdfLayerHandle!
                do {
                    let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                    assertOpen("HelloWorld.usda")
                    layerWeakP = stage.GetRootLayer()
                    assertOpen("HelloWorld.usda")
                    Overlay.Dereference(layerWeakP).SetStartTimeCode(5)
                }
                assertClosed("HelloWorld.usda")
                layerP = Overlay.TfRefPtr(layerWeakP)
                assertClosed("HelloWorld.usda")
            }
            assertClosed("HelloWorld.usda")
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_ref_layer_from_weak_open() {
        do {
            var layerP: pxr.SdfLayerRefPtr!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                let layerWeakP = stage.GetRootLayer()
                layerP = Overlay.TfRefPtr(layerWeakP)
                Overlay.Dereference(layerP).SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            Overlay.Dereference(layerP).SetEndTimeCode(5)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_stage_from_raw() {
        do {
            var stageWeakP: pxr.UsdStagePtr!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                stageWeakP = Overlay.TfWeakPtr(stage)
                assertOpen("HelloWorld.usda")
                Overlay.Dereference(stageWeakP).SetStartTimeCode(5)
            }
            assertClosed("HelloWorld.usda")
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_stage_from_strong() {
        do {
            var stageWeakP: pxr.UsdStagePtr!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let stageP = Overlay.TfRefPtr(stage)
                Overlay.Dereference(stageP).SetStartTimeCode(5)
                assertOpen("HelloWorld.usda")
                stageWeakP = Overlay.TfWeakPtr(stageP)
                Overlay.Dereference(stageWeakP).SetEndTimeCode(9)
            }
            assertClosed("HelloWorld.usda")
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_layer_from_raw() {
        do {
            var layerWeakP: pxr.SdfLayerHandle!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let layer = Overlay.Dereference(stage.GetRootLayer())
                assertOpen("HelloWorld.usda")
                layerWeakP = Overlay.TfWeakPtr(layer)
                assertOpen("HelloWorld.usda")
                Overlay.Dereference(layerWeakP).SetStartTimeCode(5)
            }
            assertClosed("HelloWorld.usda")
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_layer_from_strong() {
        do {
            var layerWeakP: pxr.SdfLayerHandle!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let layerP = Overlay.TfRefPtr(stage.GetRootLayer())
                assertOpen("HelloWorld.usda")
                Overlay.Dereference(layerP).SetStartTimeCode(5)
                layerWeakP = Overlay.TfWeakPtr(layerP)
                Overlay.Dereference(layerWeakP).SetEndTimeCode(9)
            }
            assertClosed("HelloWorld.usda")
        }
        assertClosed("HelloWorld.usda")
    }
}
