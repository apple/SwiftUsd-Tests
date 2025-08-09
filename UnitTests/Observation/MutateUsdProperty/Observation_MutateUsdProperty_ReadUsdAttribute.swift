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

final class Observation_MutateUsdProperty_ReadUsdAttribute: ObservationHelper {

    // MARK: FlattenTo
    
    func test_FlattenTo_GetDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        attr.SetDisplayGroup("fizz")
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.CreateAttribute("myAttr", .Float, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attrDest.GetTypeName())
        XCTAssertEqual(value, .Float)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertEqual(attrDest.GetTypeName(), .Double)
    }
    
    func test_FlattenTo_GetColorSpace() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        attr.SetColorSpace("fizz")
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        let attrDest = otherPrim.CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(attrDest.GetColorSpace())
        XCTAssertEqual(value, "")
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertEqual(attrDest.GetColorSpace(), "fizz")
    }

}
