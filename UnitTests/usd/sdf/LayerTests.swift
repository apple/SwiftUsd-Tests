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

final class SdfLayerTests: TemporaryDirectoryHelper {
    func testUseBeforeStageUse() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let layer = Overlay.Dereference(stage.GetRootLayer())
        layer.SetStartTimeCode(5)
        // The stage can't go away until after this line executes
        stage.SetEndTimeCode(7)
    }
    
    func testUseAroundStageUse() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let layer = Overlay.Dereference(stage.GetRootLayer())
        layer.SetStartTimeCode(5)
        stage.SetEndTimeCode(7)
        // The stage could go away here
        layer.SetStartTimeCode(10)
    }
    
    // This test crashes on Release mode due to what's probably a use-after-free,
    // if Overlay.Dereference(TfWeakPtr<SdfLayer>) is not annotated cf_returns_retained, like the refptr version is
    func testUseNoRefStage() {
        var stage: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        // The compiler doesn't know that the intermediate TfWeakPtr from GetRootLayer() is dependent on UsdStage,
        // so it can put the `stage = nil` between GetRootLayer() and Dereference(TfWeakPtr),
        // which leads to a use-after-free
        let layer = Overlay.Dereference(stage!.GetRootLayer())
        stage = nil
        layer.SetStartTimeCode(5)
        XCTAssertEqual(layer.GetStartTimeCode(), 5.0)
    }
    
    func testUsePartialRefStage() {
        var stage: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let layer = Overlay.Dereference(stage!.GetRootLayer())
        layer.SetStartTimeCode(5)
        // The stage can't be set to nil until after this line executes,
        // so the TfWeakPtr<SdfLayer> can be dereferenced without a crash
        stage!.SetEndTimeCode(7)
        layer.SetStartTimeCode(10)
        stage = nil
        layer.SetStartTimeCode(13)
    }
        
    func testSave() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let layer = Overlay.Dereference(stage.GetRootLayer())
        stage.DefinePrim("/Hello", .UsdGeomTokens.Sphere)
        layer.Save(true)
        try XCTAssertEqual(contentsOfStage(named: "HelloWorld.usda"), contentsOfResource(subPath: "sdf/layer/1.txt"))
    }
    
    func testExportToString() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let layer = Overlay.Dereference(stage.GetRootLayer())
        stage.DefinePrim("/Hello", .UsdGeomTokens.Sphere)
        try XCTAssertEqual(layer.ExportToString(), contentsOfResource(subPath: "sdf/layer/2.txt"))
    }
    
    func testSuccessfullyCreateALayerOnce() {
        // Nothing special. Creating a layer once should always work. If `Deference` succeeds, no error was thrown in Usd so the test succeeds.
        let layer: pxr.SdfLayer = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
        layer.SetStartTimeCode(5)
    }
    
    func testSuccessfullyCreateALayerTwice() {
        do {
            let layer1: pxr.SdfLayer = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
            layer1.SetStartTimeCode(5)
        } // <-- layer1 guaranteed to go out of scope here
        // No crash or logging expected. If `Dereference` succeeds, no error was thrown in Usd so the test succeeds.
        let layer2: pxr.SdfLayer = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
        layer2.SetStartTimeCode(5)
    }
    
    func testUnsuccessfullyCreateALayerTwice() {
        var layer: pxr.SdfLayer?
        do {
            let tempLayer: pxr.SdfLayer = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
            layer = tempLayer
            layer!.SetStartTimeCode(5)
        } // <-- tempLayer goes out of scope, but layer is still open
        // Expected to log: Coding Error: in _CreateNew at line 616 of /Users/maddyadams/OpenUSD/pxr/usd/sdf/layer.cpp -- A layer already exists with identifier '/Users/maddyadams/Documents/UsdSwiftTutorials/HelloWorld.usda'
        let layer2: pxr.SdfLayerRefPtr = pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments())
        XCTAssertFalse(Bool(layer2))
    }
    
    func testAmbiguousCreateALayerTwice() {
        let layer1: pxr.SdfLayer = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
        layer1.SetStartTimeCode(5)
        // No guarantee about whether layer1 disappears before layer2 is created
        // Could behave like SuccessfullyCreateALayerTwice of UnsuccessfullyCreateALayerTwice.
        let layer2: pxr.SdfLayerRefPtr = pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments())
        // If this test case fails, this may not be a big deal
        XCTAssertFalse(Bool(layer2))
    }
    
    func testNilledOutLayerGoesAway() {
        var layer1: pxr.SdfLayer? = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
        layer1!.SetStartTimeCode(5)
        layer1 = nil
        // last reference to layer1 is gone
        let layer2: pxr.SdfLayerRefPtr = pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments())
        XCTAssertTrue(Bool(layer2))
        Overlay.Dereference(layer2).SetStartTimeCode(5)
    }
    
    func testOverlayTfRefPtrBumpsRefCount() {
        var layer1: pxr.SdfLayer? = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
        layer1!.SetStartTimeCode(5)
        var layer2: pxr.SdfLayerRefPtr? = Overlay.TfRefPtr(layer1!)
        Overlay.Dereference(layer2!).SetStartTimeCode(5)
        layer1 = nil
        withExtendedLifetime(layer2) {
            // layer2 keeps the layer alive
            let layer3: pxr.SdfLayerRefPtr = pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments())
            XCTAssertFalse(Bool(layer3))
        }
        layer2 = nil
        // last reference to layer is gone
        let layer4: pxr.SdfLayerRefPtr = pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments())
        XCTAssertTrue(Bool(layer4))
        Overlay.Dereference(layer4).SetStartTimeCode(5)
    }
    
    private func helperMakeALayer() -> pxr.SdfLayer {
        Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
    }
    
    func testMakeAndReturnLayerFromFunction() {
        let layer = helperMakeALayer()
        layer.SetStartTimeCode(5)
    }
    
    private func helperTakeALayer(layer: pxr.SdfLayer) {
        layer.SetStartTimeCode(5)
    }
    
    func testPassALayerToFunction() {
        let layer = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
        helperTakeALayer(layer: layer)
        XCTAssertEqual(layer.GetStartTimeCode(), 5.0)
    }
    
    func testPassALayerToFunction2() {
        let layer = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
        // Don't use the layer after this point in time,
        // so that it could be released earlier
        helperTakeALayer(layer: layer)
    }
    
    func testPassALayerToFunction3() {
        // Never hold on to a layer directly, but should still be fine
        helperTakeALayer(layer: helperMakeALayer())
    }
}
