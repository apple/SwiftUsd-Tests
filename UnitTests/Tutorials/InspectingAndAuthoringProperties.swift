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

// This file is a translation of https://openusd.org/release/tut_inspect_and_author_props.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/InspectingAndAuthoringProperties` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/authoringProperties.

final class InspectingAndAuthoringProperties: TutorialsHelper {
    override class var name: String { "InspectingAndAuthoringProperties" }
    
    func testTutorial() throws {
        let stagePath = try copyResourceToWorkingDirectory(subPath: "Tutorials/InspectingAndAuthoringProperties/1.txt", destName: "HelloWorld.usda")
        
        let stage = Overlay.Dereference(pxr.UsdStage.Open(stagePath, .LoadAll))
        let xform = stage.GetPrimAtPath("/hello")
        let sphere = stage.GetPrimAtPath("/hello/world")
        
        var propertyNames = xform.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc)
        XCTAssertEqual(String(describing: propertyNames), try expected(2))
        
        propertyNames = sphere.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc)
        XCTAssertEqual(String(describing: propertyNames), try expected(3))
        
        let extentAttr = sphere.GetAttribute(.UsdGeomTokens.extent)
        var extentValue = pxr.VtVec3fArray()
        extentAttr.Get(&extentValue, pxr.UsdTimeCode.Default())
        XCTAssertEqual(String(describing: extentValue), try expected(4))
        
        let radiusAttr = sphere.GetAttribute(.UsdGeomTokens.radius)
        radiusAttr.Set(2.0, pxr.UsdTimeCode.Default())
        extentAttr.Get(&extentValue, pxr.UsdTimeCode.Default())
        for i in 0..<extentValue.size() {
            extentValue[i] *= 2
        }
        extentAttr.Set(extentValue, pxr.UsdTimeCode.Default())
        let rootLayer = Overlay.Dereference(stage.GetRootLayer())
        XCTAssertEqual(rootLayer.ExportToString(), try expected(5))
        
        let sphereSchema = pxr.UsdGeomSphere(sphere)
        let color = sphereSchema.GetDisplayColorAttr()
        let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(0, 0, 1)]
        color.Set(colorValue, pxr.UsdTimeCode.Default())
        rootLayer.Save(false)
                                       
        try XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), expected(6))
    }
}
