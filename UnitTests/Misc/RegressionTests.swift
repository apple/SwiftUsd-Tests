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

// For any regressions in Swift/Swift-Cxx interop that weren't caught by anything else in this test suite,
// and for radars that were verified.
final class RegressionTests: TemporaryDirectoryHelper {
    // MARK: pxr.UsdGeomXformOp.`Type`
    // rdar://124171248 (pxr.UsdGeomXformOp.`Type` values can't be assigned to variables of the same type (5.10 regression))
    // Fixed in Swift 6.0
    func test_UsdGeomXformOp_Type() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadNone))
        
        // Setup
        let srcPrim = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/hello")
        let srcXformable = pxr.UsdGeomXformable(srcPrim.GetPrim())
        
        let destPrim = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/world")
        let destXformable = pxr.UsdGeomXformable(destPrim.GetPrim())
        
        srcXformable.AddTranslateOp(.PrecisionDouble, "", false)
            .Set(pxr.GfVec3d(4, 5, 6), .Default())
        
        XCTAssertFalse(Bool(destXformable.GetTranslateOp("", false)))
        
        // Copy xformable from scrXformable to destXformable
        Self._copyXformable(srcXformable: srcXformable, srcTime: .Default(),
                      destXformable: destXformable, destTime: .Default())
        
        let destOp = destXformable.GetTranslateOp("", false)
        XCTAssertTrue(Bool(destOp))
        var translation = pxr.GfVec3d()
        destOp.Get(&translation, .Default())
        XCTAssertEqual(translation, pxr.GfVec3d(4, 5, 6))
    }
    
    // Helper function to copy the xformOps from `srcXformable` to `destXformable`, using the values read at the given time to write at the given time
    private static func _copyXformable(srcXformable: pxr.UsdGeomXformable, srcTime: pxr.UsdTimeCode,
                                       destXformable: pxr.UsdGeomXformable, destTime: pxr.UsdTimeCode) {
        
        var resetsXformStack = false
        var destXformOpOrder: Overlay.UsdGeomXformOp_Vector = []
        
        let srcXformOpOrder = srcXformable.GetOrderedXformOps(&resetsXformStack)
        for srcXformOp in srcXformOpOrder {
            let suffix = Self._getSuffixOfXformOp(srcXformOp)
            
            // Try to find an existing xformOp, or else add a new one
            var destXformOp = destXformable.GetXformOp(srcXformOp.GetOpType(),
                                                       suffix,
                                                       srcXformOp.IsInverseOp())
            if !Bool(destXformOp) {
                destXformOp = destXformable.AddXformOp(srcXformOp.GetOpType(),
                                                       srcXformOp.GetPrecision(),
                                                       suffix,
                                                       srcXformOp.IsInverseOp())
            }
            destXformOpOrder.push_back(destXformOp)
            
            // Copy over the value in the xformOp
            if !srcXformOp.IsInverseOp() {
                var value = pxr.VtValue()
                
                Overlay.Get(srcXformOp.GetAttr(), &value, srcTime)
                if !value.IsEmpty() {
                    Overlay.Set(destXformOp.GetAttr(), value, destTime)
                }
            }
        }
        
        destXformable.SetXformOpOrder(destXformOpOrder, resetsXformStack)
    }
    
    // Helper function to get the `suffix` argument passed when creating/retrieving an xformOp
    private static func _getSuffixOfXformOp(_ xformOp: pxr.UsdGeomXformOp) -> pxr.TfToken {
        // nameComponents can be xformOp:<opType>, xformOp:<opType>:<opSuffix>, !invert!:xformOp:<opType>, or !invert!:xformOp:<opType>:<opSuffix>
        // if opSuffix is specified, we want that, otherwise the empty token
        let nameComponents = xformOp.SplitName()
        // Todo: without this `as`, this == is ambiguous
        let isXformOp = nameComponents[nameComponents.size() - 2] == "xformOp" as std.string
        if isXformOp {
            // xformOp:<opType> or !invert!:xformOp:<opType>
            return ""
        } else {
            // xformOp:<opType>:<opSuffix> or !invert!:xformOp:<opType>:<opSuffix>
            return pxr.TfToken(nameComponents[nameComponents.size() - 1])
        }
    }
    
    // MARK: UsdAttribute
    
    // attr.Get(&vtBoolArray) crashed the Swift 5.9 compiler
    func test_getBoolArrayFromAttr() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myprim")
        let customAttr = Overlay.GetPrim(cube).CreateAttribute("customAttr", .BoolArray, .SdfVariabilityVarying)
        
        let firstValue: pxr.VtBoolArray = [true, false, true, false, false, true]
        XCTAssertTrue(customAttr.Set(firstValue, 5))
        XCTAssertEqual(stage.ExportToString()!, try contentsOfResource(subPath: "Wrapping/Function/Overlay_GetBoolArrayFromAttr_0.txt"))
        
        var secondValue: pxr.VtBoolArray = []
        customAttr.Get(&secondValue, 5)
        XCTAssertEqual(firstValue, secondValue)
        
        var thirdValue: pxr.VtBoolArray = []
        var success = false
        success = customAttr.Get(&thirdValue, 5)
        XCTAssertTrue(success)
        XCTAssertEqual(firstValue, thirdValue)
        
        
        let displayColor = cube.GetDisplayColorAttr()
        success = false
        success = displayColor.Get(&thirdValue, 5)
        XCTAssertFalse(success)
    }
    
    // attr.Get(&bool) crashed the Swift 5.9 compiler
    func test_getBoolFromAttr_withSuccess_succeeds() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let plane = pxr.UsdGeomPlane.Define(Overlay.TfWeakPtr(stage), "/plane")
        let attr = plane.GetDoubleSidedAttr()
        var success = false
        var result = false
        success = attr.Get(&result, .Default())
        XCTAssertTrue(success)
        XCTAssertTrue(result)
    }
    
    // attr.Get(&bool) crashed the Swift 5.9 compiler
    func test_getBoolFromAttr_withSuccess_fails() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let plane = pxr.UsdGeomPlane.Define(Overlay.TfWeakPtr(stage), "/plane")
        let attr = plane.GetDisplayColorAttr()
        var success = false
        var result = false
        success = attr.Get(&result, .Default())
        XCTAssertFalse(success)
    }
    
    // attr.Get(&bool) crashed the Swift 5.9 compiler
    func test_getBoolFromAttr_withoutSuccess_succeeds() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let plane = pxr.UsdGeomPlane.Define(Overlay.TfWeakPtr(stage), "/plane")
        let attr = plane.GetDoubleSidedAttr()
        var success = false
        attr.Get(&success, .Default())
        XCTAssertTrue(success)
    }
    
    // attr.Get(&bool) crashed the Swift 5.9 compiler
    func test_getBoolFromAttr_withoutSuccess_fails() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let plane = pxr.UsdGeomPlane.Define(Overlay.TfWeakPtr(stage), "/plane")
        let attr = plane.GetDisplayColorAttr()
        var success = false
        XCTAssertFalse(attr.Get(&success, .Default()))
    }
    
    func test_GfMatrix4d_Int_subscript() {
        let x = pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        XCTAssertEqual(x[0][0], 1)
        XCTAssertEqual(x[0][1], 2)
        XCTAssertEqual(x[0][2], 3)
        XCTAssertEqual(x[0][3], 4)
        XCTAssertEqual(x[1][0], 5)
        XCTAssertEqual(x[1][1], 6)
        XCTAssertEqual(x[1][2], 7)
        XCTAssertEqual(x[1][3], 8)
        XCTAssertEqual(x[2][0], 9)
        XCTAssertEqual(x[2][1], 10)
        XCTAssertEqual(x[2][2], 11)
        XCTAssertEqual(x[2][3], 12)
        XCTAssertEqual(x[3][0], 13)
        XCTAssertEqual(x[3][1], 14)
        XCTAssertEqual(x[3][2], 15)
        XCTAssertEqual(x[3][3], 16)
    }
}
