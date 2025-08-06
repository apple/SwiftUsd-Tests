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

final class UsdTimeCodeTests: TemporaryDirectoryHelper {
    
    func assertConformsTo<T>(_ t: T.Type) {
        XCTAssertTrue(pxr.UsdTimeCode.Default() is T)
    }

    func test_AdditiveArithmetic() {
        var a = pxr.UsdTimeCode(3)
        a += pxr.UsdTimeCode(2)
        XCTAssertEqual(a, 5)
        a -= a
        XCTAssertEqual(a, .zero)
        assertConformsTo((any AdditiveArithmetic).self)
    }

    func test_BinaryFloatingPoint() {
        XCTAssertEqual(pxr.UsdTimeCode.Default().formatted(), "NaN")
        XCTAssertEqual(pxr.UsdTimeCode(4.56).formatted(), "4.56")
        assertConformsTo((any BinaryFloatingPoint).self)
    }
    
    func test_Comparable() {
        XCTAssertEqual(pxr.UsdTimeCode.Default(), pxr.UsdTimeCode.Default())
        XCTAssertLessThan(pxr.UsdTimeCode.Default(), pxr.UsdTimeCode.EarliestTime())
        XCTAssertLessThan(pxr.UsdTimeCode.Default(), pxr.UsdTimeCode(-100))
        XCTAssertLessThan(pxr.UsdTimeCode.Default(), pxr.UsdTimeCode(-1.5))
        XCTAssertLessThan(pxr.UsdTimeCode.Default(), pxr.UsdTimeCode(0))
        XCTAssertLessThan(pxr.UsdTimeCode.Default(), pxr.UsdTimeCode(1.414))
        XCTAssertLessThan(pxr.UsdTimeCode.Default(), pxr.UsdTimeCode(100))
        
        XCTAssertEqual(pxr.UsdTimeCode.EarliestTime(), pxr.UsdTimeCode.EarliestTime())
        XCTAssertLessThan(pxr.UsdTimeCode.EarliestTime(), pxr.UsdTimeCode(-100))
        XCTAssertLessThan(pxr.UsdTimeCode.EarliestTime(), pxr.UsdTimeCode(-1.5))
        XCTAssertLessThan(pxr.UsdTimeCode.EarliestTime(), pxr.UsdTimeCode(0))
        XCTAssertLessThan(pxr.UsdTimeCode.EarliestTime(), pxr.UsdTimeCode(1.414))
        XCTAssertLessThan(pxr.UsdTimeCode.EarliestTime(), pxr.UsdTimeCode(100))
        
        XCTAssertEqual(pxr.UsdTimeCode(-100), pxr.UsdTimeCode(-100))
        XCTAssertLessThan(pxr.UsdTimeCode(-100), pxr.UsdTimeCode(-1.5))
        XCTAssertLessThan(pxr.UsdTimeCode(-100), pxr.UsdTimeCode(0))
        XCTAssertLessThan(pxr.UsdTimeCode(-100), pxr.UsdTimeCode(1.414))
        XCTAssertLessThan(pxr.UsdTimeCode(-100), pxr.UsdTimeCode(100))

        XCTAssertEqual(pxr.UsdTimeCode(-1.5), pxr.UsdTimeCode(-1.5))
        XCTAssertLessThan(pxr.UsdTimeCode(-1.5), pxr.UsdTimeCode(0))
        XCTAssertLessThan(pxr.UsdTimeCode(-1.5), pxr.UsdTimeCode(1.414))
        XCTAssertLessThan(pxr.UsdTimeCode(-1.5), pxr.UsdTimeCode(100))
        
        XCTAssertEqual(pxr.UsdTimeCode(0), pxr.UsdTimeCode(0))
        XCTAssertLessThan(pxr.UsdTimeCode(0), pxr.UsdTimeCode(1.414))
        XCTAssertLessThan(pxr.UsdTimeCode(0), pxr.UsdTimeCode(100))

        XCTAssertEqual(pxr.UsdTimeCode(1.414), pxr.UsdTimeCode(1.414))
        XCTAssertLessThan(pxr.UsdTimeCode(1.414), pxr.UsdTimeCode(100))
        
        XCTAssertEqual(pxr.UsdTimeCode(100), pxr.UsdTimeCode(100))
        
        assertConformsTo((any Comparable).self)
    }
    
    func test_CustomStringConvertible() {
        XCTAssertEqual(pxr.UsdTimeCode.Default().description, "DEFAULT")
        XCTAssertEqual(pxr.UsdTimeCode(2.718).description, "2.718")
        assertConformsTo((any CustomStringConvertible).self)
    }
    
    func test_Decodable_succeeds() {
        guard let data = "[\"nan\", 2.718, \"pre1.23\"]".data(using: .utf8) else { XCTFail(); return }
        guard let actual = try? JSONDecoder().decode([pxr.UsdTimeCode].self, from: data) else { XCTFail(); return }
        XCTAssertEqual(actual, [.Default(), 2.718, .PreTime(1.23)])
        assertConformsTo((any Decodable).self)
    }
    
    func test_Decodable_fails() {
        guard let data = "[fizzbuzz]".data(using: .utf8) else { XCTFail(); return }
        XCTAssertThrowsError(try JSONDecoder().decode([pxr.UsdTimeCode].self, from: data))
        assertConformsTo((any Decodable).self)
    }
    
    func test_Encodable() {
        let array = [pxr.UsdTimeCode.Default(), 2.718, .PreTime(1.23)]
        guard let encoded = try? String(data: JSONEncoder().encode(array), encoding: .utf8) else { XCTFail(); return }
        XCTAssertEqual(encoded, "[\"nan\",2.718,\"pre1.23\"]")
        assertConformsTo((any Encodable).self)
    }
    
    func test_ExpressibleByFloatLiteral() {
        let x: pxr.UsdTimeCode = .nan
        let y: pxr.UsdTimeCode = 2.718
        XCTAssertEqual(x, .Default())
        XCTAssertEqual(y, pxr.UsdTimeCode(2.718))
        assertConformsTo((any ExpressibleByFloatLiteral).self)
    }
    
    func test_ExpressibleByIntegerLiteral() {
        let x: pxr.UsdTimeCode = 7
        XCTAssertEqual(x, pxr.UsdTimeCode(7))
        assertConformsTo((any ExpressibleByIntegerLiteral).self)
    }
    
    func test_FloatingPoint() {
        let x: pxr.UsdTimeCode = 2.718
        let y: pxr.UsdTimeCode = 3.1415
        XCTAssertEqual(x + y, 5.859500000000001)
        assertConformsTo((any FloatingPoint).self)
    }
    
    func test_Hashable() {
        var x: Set<pxr.UsdTimeCode> = []
        XCTAssertFalse(x.contains(.Default()))
        XCTAssertFalse(x.contains(5))
        x.insert(.Default())
        XCTAssertTrue(x.contains(.Default()))
        XCTAssertFalse(x.contains(5))
        x.insert(5)
        XCTAssertTrue(x.contains(.Default()))
        XCTAssertTrue(x.contains(5))
        assertConformsTo((any Hashable).self)
    }
    
    func test_Numeric() {
        let x: pxr.UsdTimeCode = 5
        let y: pxr.UsdTimeCode = 1/24
        let z = x * y
        XCTAssertEqual(z, 5/24, accuracy: 0.0000001)
        assertConformsTo((any Numeric).self)
    }
    
    func test_SignedNumeric() {
        let x: pxr.UsdTimeCode = 5
        let y: pxr.UsdTimeCode = -x
        XCTAssertEqual(y, -5)
        assertConformsTo((any SignedNumeric).self)
    }
    
    func test_Stridable() {
        XCTAssertEqual(pxr.UsdTimeCode(5).advanced(by: 2), 7)
        XCTAssertEqual(pxr.UsdTimeCode(5).distance(to: 2), -3)
        assertConformsTo((any Strideable).self)
    }
}
