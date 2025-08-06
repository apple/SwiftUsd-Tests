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

// This file is a translation of https://openusd.org/release/tut_authoring_variants.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/AuthoringVariants` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/authoringVariants.


final class AuthoringVariants: TutorialsHelper {
    override class var name: String { "AuthoringVariants" }
    
    func testTutorial() throws {
        let stagePath = try copyResourceToWorkingDirectory(subPath: "Tutorials/AuthoringVariants/1.txt", destName: "HelloWorld.usda")
        
        let stage = Overlay.Dereference(pxr.UsdStage.Open(stagePath, .LoadAll))
        let colorAttr = pxr.UsdGeomGprim.Get(Overlay.TfWeakPtr(stage), "/hello/world").GetDisplayColorAttr()
        colorAttr.Clear()
        let layer = Overlay.Dereference(stage.GetRootLayer())
        XCTAssertEqual(layer.ExportToString(), try expected(2))
        
        let rootPrim = stage.GetPrimAtPath("/hello")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        XCTAssertEqual(layer.ExportToString(), try expected(3))

        vset.AddVariant("red", .UsdListPositionBackOfPrependList)
        vset.AddVariant("blue", .UsdListPositionBackOfPrependList)
        vset.AddVariant("green", .UsdListPositionBackOfPrependList)
        XCTAssertEqual(layer.ExportToString(), try expected(4))

        vset.SetVariantSelection("red")
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(1, 0, 0)]
            colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
        }
        XCTAssertEqual(layer.ExportToString(), try expected(5))

        vset.SetVariantSelection("blue")
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(0, 0, 1)]
            colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
        }
        vset.SetVariantSelection("green")
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(0, 1, 0)]
            colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
        }
        XCTAssertEqual(layer.ExportToString(), try expected(6))

        var exportValue = std.string()
        stage.ExportToString(&exportValue, false)
        XCTAssertEqual(String(describing: exportValue), try expected(7))

        layer.Export(pathForStage(named: "HelloWorldWithVariants.usda"), "", pxr.SdfLayer.FileFormatArguments())
        XCTAssertEqual(try contentsOfStage(named: "HelloWorldWithVariants.usda"), try expected(8))
    }
}
