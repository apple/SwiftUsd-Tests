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

final class UsdStageTests: TemporaryDirectoryHelper {
    // MARK: ARC tests
    // Creating a new stage when a stage with the same file path is currently open is an error in Usd, causing console logging (and a
    // crash on null pointer dereferencing). We can use this to test how Swift ARC manages the lifetime of a Swift pxr.UsdStage
    // (i.e. a C++ pxr::UsdStage*), by not holding on to the TfRefPtr to the stage.

    func testSuccessfullyCreateAStageOnce() {
        // Nothing special. Creating a stage once should always work. If `Dereference` succeeds, no error was thrown in Usd so the test succeeds.
        let stage: pxr.UsdStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        stage.SetStartTimeCode(5)
    }
    
    func testSuccessfullyCreateAStageTwice() {
        do {
            let stage1: pxr.UsdStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            stage1.SetStartTimeCode(5)
        } // <-- stage1 guaranteed to go out of scope here
        // No crash or logging expected. If `Dereference` succeeds, no error was thrown in Usd so the test succeeds.
        let stage2: pxr.UsdStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        stage2.SetStartTimeCode(5)
    }

    func testUnsuccesfullyCreateAStageTwice() {
        var stage: pxr.UsdStage?
        do {
            let tempStage: pxr.UsdStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            stage = tempStage
            stage!.SetStartTimeCode(5)
        } // <-- tempStage goes out of scope, but stage is still open
        // Expected to log: Coding Error: in _CreateNew at line 616 of /Users/maddyadams/OpenUSD/pxr/usd/sdf/layer.cpp -- A layer already exists with identifier '/Users/maddyadams/Documents/UsdSwiftTutorials/HelloWorld.usda'
        let stage2: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
        XCTAssertFalse(Bool(stage2))
    }

    func testAmbiguousCreateAStageTwice() {
        let stage1: pxr.UsdStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        stage1.SetStartTimeCode(5)
        // No guarantee about whether stage1 disappears before stage2 is created
        // Could behave like SuccessfullyCreateAStageTwice or UnsuccesfullyCreateAStageTwice.
        let stage2: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
        // If this test case fails, this may not be a big deal.
        XCTAssertFalse(Bool(stage2))
    }
    
    func testNilledOutStageGoesAway() {
        var stage1: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        stage1!.SetStartTimeCode(5)
        stage1 = nil
        // last reference to stage1 is gone
        let stage2: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
        XCTAssertTrue(Bool(stage2))
        Overlay.Dereference(stage2).SetStartTimeCode(5)
    }
    
    func testOverlayTfRefPtrBumpsRefCount() {
        var stage1: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        stage1!.SetStartTimeCode(5)
        var stage2: pxr.UsdStageRefPtr? = Overlay.TfRefPtr(stage1!)
        Overlay.Dereference(stage2!).SetStartTimeCode(5)
        stage1 = nil
        withExtendedLifetime(stage2) {
            // stage2 keeps the stage alive
            let stage3: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
            XCTAssertFalse(Bool(stage3))
        }
        stage2 = nil
        // last reference to stage is gone
        let stage4: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
        XCTAssertTrue(Bool(stage4))
        Overlay.Dereference(stage4).SetStartTimeCode(5)
    }
    
    private func helperMakeAStage() -> pxr.UsdStage {
        Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
    }
    
    func testMakeAndReturnStageFromFunction() {
        let stage = helperMakeAStage()
        stage.SetStartTimeCode(5)
    }
    
    private func helperTakeAStage(stage: pxr.UsdStage) {
        stage.SetStartTimeCode(5)
    }
    
    func testPassAStageToFunction() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        helperTakeAStage(stage: stage)
        XCTAssertEqual(stage.GetStartTimeCode(), 5.0)
    }
    
    func testPassAStageToFunction2() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        // Don't use the stage after this point in time,
        // so that it could be released earlier
        helperTakeAStage(stage: stage)
    }
    
    func testPassAStageToFunction3() {
        // Never hold on to a stage directly, but should still be fine
        helperTakeAStage(stage: helperMakeAStage())
    }
    
    // MARK: TfRefPtr.pointee
    // On Swift 5.9, `TfRefPtr.pointee` is unsafe, causing a use-after-free in Release mode.
    // `Overlay.Dereference(_:)` correctly avoids this safety issue. But, because the bug
    // is subtle enough in the first place, it's useful to have some (usually disabled)
    // tests that demonstrates what failing would look like, so that we can test the workaround
    // and see that it doesn't fail.
    //
    // In the Scheme editor, when SwiftUsdTests is selected, in the Test section,
    // changing the Build Configuration to Release will run the tests in release
    //
    // - When running on Release, if `testTfRefPtrPointeeCrashesOnRelease` crashes and
    // `testOverlayDereferenceDoesntCrashOnRelease` does not, that means
    // that `Overlay.Dereference(_:)` is correct.
    //
    // - If neither crash, the test is inconclusive.
    //
    // - If both crash, `Overlay.Dereference(_:)` is incorrect.
    //
    // - If only the latter crashes, `Overlay.Dereference(_:)`
    // is somehow wrong while `TfRefPtr.pointee` is right, which
    // should be impossible.
//    func testTfRefPtrPointeeCrashesOnRelease() {
//        let stage = pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll).pointee
//        stage.SetStartTimeCode(5)
//    }
//    
//    func testOverlayDereferenceDoesntCrashOnRelease() {
//        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(Overlay.UsdStage.LoadAll))
//        stage.SetStartTimeCode(5)
//    }
}
