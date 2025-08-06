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

final class OverlayDereference: TemporaryDirectoryHelper {    
    func test_ref_stage() {
        do {
            var stage: pxr.UsdStage!
            do {
                let stageP: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
                assertOpen("HelloWorld.usda")
                stage = Overlay.Dereference(stageP)
                stage.SetStartTimeCode(5)
                assertOpen("HelloWorld.usda")
            }
            assertOpen("HelloWorld.usda")
            stage.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_ref_layer() {
        do {
            var layer: pxr.SdfLayer!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let layerP: pxr.SdfLayerRefPtr = Overlay.TfRefPtr(stage.GetRootLayer())
                layer = Overlay.Dereference(layerP)
                assertOpen("HelloWorld.usda")
                layer.SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            layer.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_stage() {
        do {
            var stage: pxr.UsdStage!
            do {
                let stageP: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
                assertOpen("HelloWorld.usda")
                let stageWeakP: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(stageP)
                stage = Overlay.Dereference(stageWeakP)
                assertOpen("HelloWorld.usda")
                stage.SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            stage.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_weak_layer() {
        do {
            var layer: pxr.SdfLayer!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                let layerWeakP: pxr.SdfLayerHandle = stage.GetRootLayer()
                layer = Overlay.Dereference(layerWeakP)
                assertOpen("HelloWorld.usda")
                layer.SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            layer.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
}
