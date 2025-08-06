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

// This file is a translation of https://openusd.org/release/tut_referencing_layers.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/ReferencingLayers` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/referencingLayers.

final class ReferencingLayers: TutorialsHelper {
    override class var name: String { "ReferencingLayers" }

    func testTutorial() throws {
        let stagePath = try copyResourceToWorkingDirectory(subPath: "Tutorials/ReferencingLayers/1.txt", destName: "HelloWorld.usda")
        
        let stage = Overlay.Dereference(pxr.UsdStage.Open(stagePath, .LoadAll))
        let hello = stage.GetPrimAtPath("/hello")
        stage.SetDefaultPrim(hello)
        pxr.UsdGeomXformCommonAPI(hello).SetTranslate(pxr.GfVec3d(4, 5, 6), pxr.UsdTimeCode.Default())
        var rootLayer = Overlay.Dereference(stage.GetRootLayer())
        XCTAssertEqual(rootLayer.ExportToString(), try expected(2))
        rootLayer.Save(false)
        try XCTAssertEqual(contentsOfStage(named: "HelloWorld.usda"), expected(3))
        
        let refStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "RefExample.usda"), .LoadAll))
        let refSphere = refStage.OverridePrim("/refSphere")
        rootLayer = Overlay.Dereference(refStage.GetRootLayer())
        XCTAssertEqual(rootLayer.ExportToString(), try expected(4))
        
        refSphere.GetReferences().AddReference("./HelloWorld.usda", pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        XCTAssertEqual(rootLayer.ExportToString(), try expected(5))
        rootLayer.Save(false)
        XCTAssertEqual(try contentsOfStage(named: "RefExample.usda"), try expected(6))
        
        let refXform = pxr.UsdGeomXformable(refSphere)
        refXform.SetXformOpOrder(Overlay.UsdGeomXformOp_Vector(), false)
        XCTAssertEqual(rootLayer.ExportToString(), try expected(7))

        let refSphere2 = refStage.OverridePrim("/refSphere2")
        refSphere2.GetReferences().AddReference("./HelloWorld.usda", pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        XCTAssertEqual(rootLayer.ExportToString(), try expected(8))
        rootLayer.Save(false)
        XCTAssertEqual(try contentsOfStage(named: "RefExample.usda"), try expected(9))
        
        let overSphere = pxr.UsdGeomSphere.Get(Overlay.TfWeakPtr(refStage), "/refSphere2/world")
        let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(1, 0, 0)]
        overSphere.GetDisplayColorAttr().Set(colorValue, pxr.UsdTimeCode.Default())
        XCTAssertEqual(rootLayer.ExportToString(), try expected(10))
        rootLayer.Save(false)
        XCTAssertEqual(try contentsOfStage(named: "RefExample.usda"), try expected(11))

        var exportValue = std.string()
        refStage.ExportToString(&exportValue, true)
        
        // due to the source file comment, the exported value looks like: doc = """Generated from Composed Stage of root layer /var/folders/rv/g4nkjpsj5yb7sbl2bdmsbctc0000gp/T/UsdInteropTests/D7ACEDC4-8782-47A3-AC58-A332849F8B74/RefExample.usda
        // so, we chop off the third line
        var swiftExportValue = String(describing: exportValue)
        var lines = swiftExportValue.components(separatedBy: .newlines)
        lines.remove(at: 2)
        swiftExportValue = lines.joined(separator: "\n")
        
        XCTAssertEqual(swiftExportValue, try expected(12))
    }
}
