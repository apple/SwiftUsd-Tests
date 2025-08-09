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

final class MathOperatorUtilitiesTests: TemporaryDirectoryHelper {
    // MARK: Multiply
    
    func test_multiply_GfVec3f_Float() {
        let a = pxr.GfVec3f(1, 2, 3)
        let b = 4 as Float
        XCTAssertEqual(a * b, pxr.GfVec3f(4, 8, 12))
    }
    
    func test_multiply_GfMatrix4d_GfMatrix4d() {
        // Rotate Z-90
        let l = pxr.GfMatrix4d(0, -1, 0, 0,
                               1, 0, 0, 0,
                               0, 0, 1, 0,
                               0, 0, 0, 1)
        // Rotate Y-90
        let r = pxr.GfMatrix4d(0, 0, 1, 0,
                               0, 1, 0, 0,
                               -1, 0, 0, 0,
                               0, 0, 0, 1)
        // Rotate Y, then rotate Z locally
        XCTAssertEqual(l * r,
                       pxr.GfMatrix4d(0, -1, 0, 0,
                                      0, 0, 1, 0,
                                      -1, 0, 0, 0,
                                      0, 0, 0, 1)
        )
    }
    
    func test_multiply_Double_GfVec3d() {
        let a = 2.5 as Double
        let b = pxr.GfVec3d(0.25, 4, 2)
        XCTAssertEqual(a * b, pxr.GfVec3d(5/8, 10, 5))
    }
    
    func test_multiply_Float_GfVec3f() {
        let a = 4 as Float
        let b = pxr.GfVec3f(1, 2, 3)
        XCTAssertEqual(a * b, pxr.GfVec3f(4, 8, 12))
    }
    
    func test_multiply_GfRotation_GfRotation() {
        let a = pxr.GfRotation(pxr.GfVec3d(1, 0, 0), 180)
        let b = pxr.GfRotation(pxr.GfVec3d(0, 1, 0), 180)
        XCTAssertEqual(a * b, pxr.GfRotation(pxr.GfVec3d(6.123233995736766e-17, 6.123233995736766e-17, -1.0), 180))
    }
    
    // MARK: Plus
    
    func test_plus_GfVec3f_GfVec3f() {
        let a = pxr.GfVec3f(1, 2, 3)
        let b = pxr.GfVec3f(4, 5, 6)
        XCTAssertEqual(a + b, pxr.GfVec3f(5, 7, 9))
    }
    
    func test_plus_GfVec3d_GfVec3d() {
        let a = pxr.GfVec3d(1, 2, 3)
        let b = pxr.GfVec3d(4, 5, 6)
        XCTAssertEqual(a + b, pxr.GfVec3d(5, 7, 9))
    }
    
    func test_plus_GfVec2i_GfVec2i() {
        let a = pxr.GfVec2i(1, 2)
        let b = pxr.GfVec2i(3, 4)
        XCTAssertEqual(a + b, pxr.GfVec2i(4, 6))
    }
    
    func test_plus_half_half() {
        let a = pxr.GfHalf(1.25)
        let b = pxr.GfHalf(3)
        XCTAssertEqual(a + b, pxr.GfHalf(4.25))
    }
    
    // MARK: Minus
    
    func test_minus_GfVec3f_GfVec3f() {
        let a = pxr.GfVec3f(1, 2, 3)
        let b = pxr.GfVec3f(4, 5, 6)
        XCTAssertEqual(a - b, pxr.GfVec3f(-3, -3, -3))
    }
    
    func test_minus_GfVec2i_GfVec2i() {
        let a = pxr.GfVec2i(1, 2)
        let b = pxr.GfVec2i(4, 5)
        XCTAssertEqual(a - b, pxr.GfVec2i(-3, -3))
    }
}


