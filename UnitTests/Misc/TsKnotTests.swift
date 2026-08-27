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

final class TsKnotTests: TemporaryDirectoryHelper {
    func test_Overlay_GetValue() {
        var knot = pxr.TsKnot()
        knot.SetTime(1)
        knot.SetValue(pxr.VtValue(5 as Double))
        knot.SetPreValue(pxr.VtValue(4 as Double))
        knot.SetPreTanSlope(pxr.VtValue(3 as Double))
        knot.SetPostTanSlope(pxr.VtValue(2 as Double))
        
        var outValue = pxr.VtValue()
        Overlay.GetValue(knot, &outValue)
        XCTAssertEqual(outValue, pxr.VtValue(5 as Double))
    }
    
    func test_Overlay_GetPreValue() {
        var knot = pxr.TsKnot()
        knot.SetTime(1)
        knot.SetValue(pxr.VtValue(5 as Double))
        knot.SetPreValue(pxr.VtValue(4 as Double))
        knot.SetPreTanSlope(pxr.VtValue(3 as Double))
        knot.SetPostTanSlope(pxr.VtValue(2 as Double))
        
        var outValue = pxr.VtValue()
        Overlay.GetPreValue(knot, &outValue)
        XCTAssertEqual(outValue, pxr.VtValue(4 as Double))
    }
    
    func test_Overlay_GetPreTanSlope() {
        var knot = pxr.TsKnot()
        knot.SetTime(1)
        knot.SetValue(pxr.VtValue(5 as Double))
        knot.SetPreValue(pxr.VtValue(4 as Double))
        knot.SetPreTanSlope(pxr.VtValue(3 as Double))
        knot.SetPostTanSlope(pxr.VtValue(2 as Double))
        
        var outValue = pxr.VtValue()
        Overlay.GetPreTanSlope(knot, &outValue)
        XCTAssertEqual(outValue, pxr.VtValue(3 as Double))
    }

    func test_Overlay_GetPostTanSlope() {
        var knot = pxr.TsKnot()
        knot.SetTime(1)
        knot.SetValue(pxr.VtValue(5 as Double))
        knot.SetPreValue(pxr.VtValue(4 as Double))
        knot.SetPreTanSlope(pxr.VtValue(3 as Double))
        knot.SetPostTanSlope(pxr.VtValue(2 as Double))
        
        var outValue = pxr.VtValue()
        Overlay.GetPostTanSlope(knot, &outValue)
        XCTAssertEqual(outValue, pxr.VtValue(2 as Double))
    }
}
