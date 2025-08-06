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

// This file is a translation of https://openusd.org/release/tut_helloworld_redux.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/HelloWorldRedux` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/authoringProperties.


final class HelloWorldRedux: TutorialsHelper {
    override class var name: String { "HelloWorldRedux" }
    
    func testTutorial() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorldRedux.usda"), .LoadAll))
        let _ = stage.DefinePrim("/hello", .UsdGeomTokens.Xform)
        let _ = stage.DefinePrim("/hello/world", .UsdGeomTokens.Sphere)
        let layer = Overlay.Dereference(stage.GetRootLayer())
        layer.Save(false)
        
        XCTAssertEqual(try contentsOfStage(named: "HelloWorldRedux.usda"), try expected(1))
    }
}
