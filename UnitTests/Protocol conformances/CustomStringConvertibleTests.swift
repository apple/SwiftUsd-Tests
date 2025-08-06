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

final class CustomStringConvertibleTests: TemporaryDirectoryHelper {
    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any CustomStringConvertible.Type)
    }
    
    func test_GfHalf() {
        let x = pxr.GfHalf(2.718)
        XCTAssertEqual(x.description, "2.71875")
        assertConforms(pxr.GfHalf.self)
    }
    
    func test_GfInterval() {
        let x = pxr.GfInterval(3, 4, false, true)
        XCTAssertEqual(x.description, "(3, 4]")
        assertConforms(pxr.GfInterval.self)
    }
    
    func test_GfRange1d() {
        let x = pxr.GfRange1d(4.0, 5.0)
        XCTAssertEqual(x.description, "[4...5]")
        assertConforms(pxr.GfRange1d.self)
    }
    
    func test_GfRange2d() {
        let x = pxr.GfRange2d(pxr.GfVec2d(4.0, 5.0), pxr.GfVec2d(6.4, 8.7))
        XCTAssertEqual(x.description, "[(4, 5)...(6.4, 8.7)]")
        assertConforms(pxr.GfRange2d.self)
    }
    
    func test_GfRange3d() {
        let x = pxr.GfRange3d(pxr.GfVec3d(4.0, 5.0, 6.0), pxr.GfVec3d(6.4, 8.7, 9.0))
        XCTAssertEqual(x.description, "[(4, 5, 6)...(6.4, 8.7, 9)]")
        assertConforms(pxr.GfRange3d.self)
    }
    
    func test_GfRange1f() {
        let x = pxr.GfRange1f(4.0, 5.0)
        XCTAssertEqual(x.description, "[4...5]")
        assertConforms(pxr.GfRange1f.self)
    }
    
    func test_GfRange2f() {
        let x = pxr.GfRange2f(pxr.GfVec2f(4.0, 5.0), pxr.GfVec2f(6.4, 8.7))
        XCTAssertEqual(x.description, "[(4, 5)...(6.4, 8.7)]")
        assertConforms(pxr.GfRange2f.self)
    }
    
    func test_GfRange3f() {
        let x = pxr.GfRange3f(pxr.GfVec3f(4.0, 5.0, 6.0), pxr.GfVec3f(6.4, 8.7, 9.0))
        XCTAssertEqual(x.description, "[(4, 5, 6)...(6.4, 8.7, 9)]")
        assertConforms(pxr.GfRange3f.self)
    }
    
    func test_GfMatrix2d() {
        let x = pxr.GfMatrix2d(1, 2, 3, 4)
        XCTAssertEqual(x.description, "( (1, 2), (3, 4) )")
        assertConforms(pxr.GfMatrix2d.self)
    }
    
    func test_GfMatrix2f() {
        let x = pxr.GfMatrix2f(1, 2, 3, 4)
        XCTAssertEqual(x.description, "( (1, 2), (3, 4) )")
        assertConforms(pxr.GfMatrix2f.self)
    }
    
    func test_GfMatrix3d() {
        let x = pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 9)
        XCTAssertEqual(x.description, "( (1, 2, 3), (4, 5, 6), (7, 8, 9) )")
        assertConforms(pxr.GfMatrix3d.self)
    }
    
    func test_GfMatrix3f() {
        let x = pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 9)
        XCTAssertEqual(x.description, "( (1, 2, 3), (4, 5, 6), (7, 8, 9) )")
        assertConforms(pxr.GfMatrix3f.self)
    }
    
    func test_GfMatrix4d() {
        let x = pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        XCTAssertEqual(x.description, "( (1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12), (13, 14, 15, 16) )")
        assertConforms(pxr.GfMatrix4d.self)
    }
    
    func test_GfMatrix4f() {
        let x = pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        XCTAssertEqual(x.description, "( (1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12), (13, 14, 15, 16) )")
        assertConforms(pxr.GfMatrix4f.self)
    }

    func test_GfQuatd() {
        let x = pxr.GfQuatd(2, 3, 4, 7)
        XCTAssertEqual(x.description, "(2, 3, 4, 7)")
        assertConforms(pxr.GfQuatd.self)
    }
    
    func test_GfQuatf() {
        let x = pxr.GfQuatf(2, 3, 4, 7)
        XCTAssertEqual(x.description, "(2, 3, 4, 7)")
        assertConforms(pxr.GfQuatf.self)
    }
    
    func test_GfQuath() {
        let x = pxr.GfQuath(2, 3, 4, 7)
        XCTAssertEqual(x.description, "(2, 3, 4, 7)")
        assertConforms(pxr.GfQuath.self)
    }
    
    func test_GfQuaternion() {
        let x = pxr.GfQuaternion(30, pxr.GfVec3d(0, 1, 0))
        XCTAssertEqual(x.description, "(30 + (0, 1, 0))")
        assertConforms(pxr.GfQuaternion.self)
    }
    
    func test_GfRotation() {
        let x = pxr.GfRotation(pxr.GfVec3d(0, 1, 0), 30)
        XCTAssertEqual(x.description, "[(0, 1, 0) 30]")
        assertConforms(pxr.GfRotation.self)
    }
    
    func test_GfVec2d() {
        let x = pxr.GfVec2d(5, 9)
        XCTAssertEqual(x.description, "(5, 9)")
        assertConforms(pxr.GfVec2d.self)
    }
    func test_GfVec2f() {
        let x = pxr.GfVec2f(5, 9)
        XCTAssertEqual(x.description, "(5, 9)")
        assertConforms(pxr.GfVec2f.self)
    }
    func test_GfVec2h() {
        let x = pxr.GfVec2h(5, 9)
        XCTAssertEqual(x.description, "(5, 9)")
        assertConforms(pxr.GfVec2h.self)
    }
    func test_GfVec2i() {
        let x = pxr.GfVec2i(5, 9)
        XCTAssertEqual(x.description, "(5, 9)")
        assertConforms(pxr.GfVec2i.self)
    }
    func test_GfVec3d() {
        let x = pxr.GfVec3d(5, 9, 1)
        XCTAssertEqual(x.description, "(5, 9, 1)")
        assertConforms(pxr.GfVec3d.self)
    }
    func test_GfVec3f() {
        let x = pxr.GfVec3f(5, 9, 1)
        XCTAssertEqual(x.description, "(5, 9, 1)")
        assertConforms(pxr.GfVec3f.self)
    }
    func test_GfVec3h() {
        let x = pxr.GfVec3h(5, 9, 1)
        XCTAssertEqual(x.description, "(5, 9, 1)")
        assertConforms(pxr.GfVec3h.self)
    }
    func test_GfVec3i() {
        let x = pxr.GfVec3i(5, 9, 1)
        XCTAssertEqual(x.description, "(5, 9, 1)")
        assertConforms(pxr.GfVec3i.self)
    }
    func test_GfVec4d() {
        let x = pxr.GfVec4d(5, 9, 1, -7)
        XCTAssertEqual(x.description, "(5, 9, 1, -7)")
        assertConforms(pxr.GfVec4d.self)
    }
    func test_GfVec4f() {
        let x = pxr.GfVec4f(5, 9, 1, -7)
        XCTAssertEqual(x.description, "(5, 9, 1, -7)")
        assertConforms(pxr.GfVec4f.self)
    }
    func test_GfVec4h() {
        let x = pxr.GfVec4h(5, 9, 1, -7)
        XCTAssertEqual(x.description, "(5, 9, 1, -7)")
        assertConforms(pxr.GfVec4h.self)
    }
    func test_GfVec4i() {
        let x = pxr.GfVec4i(5, 9, 1, -7)
        XCTAssertEqual(x.description, "(5, 9, 1, -7)")
        assertConforms(pxr.GfVec4i.self)
    }
    func test_SdfPath() {
        let x: pxr.SdfPath = "/fizz/buzz"
        XCTAssertEqual(x.description, "/fizz/buzz")
        assertConforms(pxr.SdfPath.self)
    }
    func test_TfToken() {
        let x: pxr.TfToken = .UsdGeomTokens.Cube
        XCTAssertEqual(x.description, "Cube")
        assertConforms(pxr.TfToken.self)
    }
    func test_UsdPrim() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let x: pxr.UsdPrim = stage.DefinePrim("/foo", "Cube")
        XCTAssertEqual(x.description, "'Cube' prim </foo> on stage with rootLayer @\(Overlay.Dereference(stage.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(stage.GetSessionLayer()).GetIdentifier())@")
        assertConforms(pxr.UsdPrim.self)
    }
    func test_UsdProperty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "sphere")
        let x: pxr.UsdProperty = stage.GetPropertyAtPath("/foo.radius")
        XCTAssertEqual(x.description, "property 'radius' on 'sphere' prim </foo> on stage with rootLayer @\(Overlay.Dereference(stage.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(stage.GetSessionLayer()).GetIdentifier())@")
        assertConforms(pxr.UsdProperty.self)
    }
    func test_UsdTimeCode() {
        let x: pxr.UsdTimeCode = 7
        let y: pxr.UsdTimeCode = .Default()
        XCTAssertEqual(x.description, "7")
        XCTAssertEqual(y.description, "DEFAULT")
        assertConforms(pxr.UsdTimeCode.self)
    }
    
    // MARK: VtArray specializations
    
    func test_VtArray_Bool() {
        var x = pxr.VtBoolArray(2)
        x[0] = false
        x[1] = true
        XCTAssertEqual(x.description, "[0, 1]")
        assertConforms(pxr.VtBoolArray.self)
    }
    func test_VtArray_Int8() {
        let x: pxr.VtCharArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtCharArray.self)
    }
    func test_VtArray_Double() {
        let x: pxr.VtDoubleArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtDoubleArray.self)
    }
    func test_VtArray_Float() {
        let x: pxr.VtFloatArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtFloatArray.self)
    }
    func test_VtArray_GfHalf() {
        let x: pxr.VtHalfArray = [5, 2, pxr.GfHalf(7)]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtHalfArray.self)
    }
    func test_VtArray_Int32() {
        let x: pxr.VtIntArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtIntArray.self)
    }
    func test_VtArray_Int64() {
        let x: pxr.VtInt64Array = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtInt64Array.self)
    }
    func test_VtArray_Int16() {
        let x: pxr.VtShortArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtShortArray.self)
    }
    func test_VtArray_stdString() {
        let x: pxr.VtStringArray = ["alpha", "beta", "gamma", "delta"]
        XCTAssertEqual(x.description, "[alpha, beta, gamma, delta]")
        assertConforms(pxr.VtStringArray.self)
    }
    func test_VtArray_TfToken() {
        let x: pxr.VtTokenArray = ["alpha", "beta", "gamma", "delta"]
        XCTAssertEqual(x.description, "[alpha, beta, gamma, delta]")
        assertConforms(pxr.VtTokenArray.self)
    }
    func test_VtArray_UInt8() {
        let x: pxr.VtUCharArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtUCharArray.self)
    }
    func test_VtArray_UInt16() {
        let x: pxr.VtUShortArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtUShortArray.self)
    }
    func test_VtArray_UInt32() {
        let x: pxr.VtUIntArray = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtUIntArray.self)
    }
    func test_VtArray_UInt64() {
        let x: pxr.VtUInt64Array = [5, 2, 7]
        XCTAssertEqual(x.description, "[5, 2, 7]")
        assertConforms(pxr.VtUInt64Array.self)
    }
    func test_VtArray_GfMatrix2d() {
        let x: pxr.VtMatrix2dArray = [pxr.GfMatrix2d(1, 2, 3, 4), pxr.GfMatrix2d(5, 6, 7, 8), pxr.GfMatrix2d(9, 10, 11, 12)]
        XCTAssertEqual(x.description, "[( (1, 2), (3, 4) ), ( (5, 6), (7, 8) ), ( (9, 10), (11, 12) )]")
        assertConforms(pxr.VtMatrix2dArray.self)
    }
    func test_VtArray_GfMatrix2f() {
        let x: pxr.VtMatrix2fArray = [pxr.GfMatrix2f(1, 2, 3, 4), pxr.GfMatrix2f(5, 6, 7, 8), pxr.GfMatrix2f(9, 10, 11, 12)]
        XCTAssertEqual(x.description, "[( (1, 2), (3, 4) ), ( (5, 6), (7, 8) ), ( (9, 10), (11, 12) )]")
        assertConforms(pxr.VtMatrix2fArray.self)
    }
    func test_VtArray_GfMatrix3d() {
        let x: pxr.VtMatrix3dArray = [pxr.GfMatrix3d(1, 2, 3, 4, 13, 14, 15, 16, 17), pxr.GfMatrix3d(5, 6, 7, 8, 18, 19, 20, 21, 22), pxr.GfMatrix3d(9, 10, 11, 12, 23, 24, 25, 26, 27)]
        XCTAssertEqual(x.description, "[( (1, 2, 3), (4, 13, 14), (15, 16, 17) ), ( (5, 6, 7), (8, 18, 19), (20, 21, 22) ), ( (9, 10, 11), (12, 23, 24), (25, 26, 27) )]")
        assertConforms(pxr.VtMatrix3dArray.self)
    }
    func test_VtArray_GfMatrix3f() {
        let x: pxr.VtMatrix3fArray = [pxr.GfMatrix3f(1, 2, 3, 4, 13, 14, 15, 16, 17), pxr.GfMatrix3f(5, 6, 7, 8, 18, 19, 20, 21, 22), pxr.GfMatrix3f(9, 10, 11, 12, 23, 24, 25, 26, 27)]
        XCTAssertEqual(x.description, "[( (1, 2, 3), (4, 13, 14), (15, 16, 17) ), ( (5, 6, 7), (8, 18, 19), (20, 21, 22) ), ( (9, 10, 11), (12, 23, 24), (25, 26, 27) )]")
        assertConforms(pxr.VtMatrix3fArray.self)
    }
    func test_VtArray_GfMatrix4d() {
        let x: pxr.VtMatrix4dArray = [pxr.GfMatrix4d(1, 2, 3, 4, 13, 14, 15, 16, 17, 28, 29, 30, 31, 32, 33, 34), pxr.GfMatrix4d(5, 6, 7, 8, 18, 19, 20, 21, 22, 35, 36, 37, 38, 39, 40, 41), pxr.GfMatrix4d(9, 10, 11, 12, 23, 24, 25, 26, 27, 42, 43, 44, 45, 46, 47, 48)]
        XCTAssertEqual(x.description, "[( (1, 2, 3, 4), (13, 14, 15, 16), (17, 28, 29, 30), (31, 32, 33, 34) ), ( (5, 6, 7, 8), (18, 19, 20, 21), (22, 35, 36, 37), (38, 39, 40, 41) ), ( (9, 10, 11, 12), (23, 24, 25, 26), (27, 42, 43, 44), (45, 46, 47, 48) )]")
        assertConforms(pxr.VtMatrix4dArray.self)
    }
    func test_VtArray_GfMatrix4f() {
        let x: pxr.VtMatrix4fArray = [pxr.GfMatrix4f(1, 2, 3, 4, 13, 14, 15, 16, 17, 28, 29, 30, 31, 32, 33, 34), pxr.GfMatrix4f(5, 6, 7, 8, 18, 19, 20, 21, 22, 35, 36, 37, 38, 39, 40, 41), pxr.GfMatrix4f(9, 10, 11, 12, 23, 24, 25, 26, 27, 42, 43, 44, 45, 46, 47, 48)]
        XCTAssertEqual(x.description, "[( (1, 2, 3, 4), (13, 14, 15, 16), (17, 28, 29, 30), (31, 32, 33, 34) ), ( (5, 6, 7, 8), (18, 19, 20, 21), (22, 35, 36, 37), (38, 39, 40, 41) ), ( (9, 10, 11, 12), (23, 24, 25, 26), (27, 42, 43, 44), (45, 46, 47, 48) )]")
        assertConforms(pxr.VtMatrix4fArray.self)
    }
    func test_VtArray_GfQuatd() {
        let x: pxr.VtQuatdArray = [pxr.GfQuatd(1, 2, 3, 4), pxr.GfQuatd(5, 6, 7, 8), pxr.GfQuatd(9, 10, 11, 12)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12)]")
        assertConforms(pxr.VtQuatdArray.self)
    }
    func test_VtArray_GfQuaternion() {
        let x: pxr.VtQuaternionArray = [pxr.GfQuaternion(1, pxr.GfVec3d(2, 3, 4)), pxr.GfQuaternion(5, pxr.GfVec3d(6, 7, 8))]
        XCTAssertEqual(x.description, "[(1 + (2, 3, 4)), (5 + (6, 7, 8))]")
        assertConforms(pxr.VtQuaternionArray.self)
    }
    func test_VtArray_GfQuatf() {
        let x: pxr.VtQuatfArray = [pxr.GfQuatf(1, 2, 3, 4), pxr.GfQuatf(5, 6, 7, 8), pxr.GfQuatf(9, 10, 11, 12)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12)]")
        assertConforms(pxr.VtQuatfArray.self)
    }
    func test_VtArray_GfQuath() {
        let x: pxr.VtQuathArray = [pxr.GfQuath(1, 2, 3, pxr.GfHalf(4)), pxr.GfQuath(5, 6, 7, 8), pxr.GfQuath(9, 10, 11, 12)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12)]")
        assertConforms(pxr.VtQuathArray.self)
    }
    func test_VtArray_GfVec2d() {
        let x: pxr.VtVec2dArray = [pxr.GfVec2d(1, 2)]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2dArray.self)
        let y: pxr.VtVec2dArray = []
        XCTAssertEqual(y.description, "[]")
    }
    func test_VtArray_GfVec2f() {
        let x: pxr.VtVec2fArray = [pxr.GfVec2f(1, 2)]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2fArray.self)
    }
    func test_VtArray_GfVec2h() {
        let x: pxr.VtVec2hArray = [pxr.GfVec2h(pxr.GfHalf(1), pxr.GfHalf(2))]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2hArray.self)
    }
    func test_VtArray_GfVec2i() {
        let x: pxr.VtVec2iArray = [pxr.GfVec2i(1, 2)]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2iArray.self)
    }
    func test_VtArray_GfVec3d() {
        let x: pxr.VtVec3dArray = [pxr.GfVec3d(1, 2, 3)]
        XCTAssertEqual(x.description, "[(1, 2, 3)]")
        assertConforms(pxr.VtVec3dArray.self)
    }
    func test_VtArray_GfVec3f() {
        let x: pxr.VtVec3fArray = [pxr.GfVec3f(1, 2, 3)]
        XCTAssertEqual(x.description, "[(1, 2, 3)]")
        assertConforms(pxr.VtVec3fArray.self)
    }
    func test_VtArray_GfVec3h() {
        let x: pxr.VtVec3hArray = [pxr.GfVec3h(pxr.GfHalf(1), pxr.GfHalf(2), pxr.GfHalf(3))]
        XCTAssertEqual(x.description, "[(1, 2, 3)]")
        assertConforms(pxr.VtVec3hArray.self)
    }
    func test_VtArray_GfVec3i() {
        let x: pxr.VtVec3iArray = [pxr.GfVec3i(1, 2, 3)]
        XCTAssertEqual(x.description, "[(1, 2, 3)]")
        assertConforms(pxr.VtVec3iArray.self)
    }
    func test_VtArray_GfVec4d() {
        let x: pxr.VtVec4dArray = [pxr.GfVec4d(1, 2, 3, 4)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4)]")
        assertConforms(pxr.VtVec4dArray.self)
    }
    func test_VtArray_GfVec4f() {
        let x: pxr.VtVec4fArray = [pxr.GfVec4f(1, 2, 3, 4)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4)]")
        assertConforms(pxr.VtVec4fArray.self)
    }
    func test_VtArray_GfVec4h() {
        let x: pxr.VtVec4hArray = [pxr.GfVec4h(pxr.GfHalf(1), pxr.GfHalf(2), pxr.GfHalf(3), pxr.GfHalf(4))]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4)]")
        assertConforms(pxr.VtVec4hArray.self)
    }
    func test_VtArray_GfVec4i() {
        let x: pxr.VtVec4iArray = [pxr.GfVec4i(1, 2, 3, 4)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4)]")
        assertConforms(pxr.VtVec4iArray.self)
    }
    func test_VtArray_GfInterval() {
        let x: pxr.VtIntervalArray = [pxr.GfInterval(1), pxr.GfInterval(2, 3, true, true)]
        XCTAssertEqual(x.description, "[[1, 1], [2, 3]]")
        assertConforms(pxr.VtIntervalArray.self)
    }
    func test_VtArray_GfRange1d() {
        let x: pxr.VtRange1dArray = [pxr.GfRange1d(5, 9)]
        XCTAssertEqual(x.description, "[[5...9]]")
        assertConforms(pxr.VtRange1dArray.self)
    }
    func test_VtArray_GfRange1f() {
        let x: pxr.VtRange1fArray = [pxr.GfRange1f(5, 9)]
        XCTAssertEqual(x.description, "[[5...9]]")
        assertConforms(pxr.VtRange1fArray.self)
    }
    func test_VtArray_GfRange2d() {
        let x: pxr.VtRange2dArray = [pxr.GfRange2d(pxr.GfVec2d(5, 9), pxr.GfVec2d(6, 10))]
        XCTAssertEqual(x.description, "[[(5, 9)...(6, 10)]]")
        assertConforms(pxr.VtRange2dArray.self)
    }
    func test_VtArray_GfRange2f() {
        let x: pxr.VtRange2fArray = [pxr.GfRange2f(pxr.GfVec2f(5, 9), pxr.GfVec2f(6, 10))]
        XCTAssertEqual(x.description, "[[(5, 9)...(6, 10)]]")
        assertConforms(pxr.VtRange2fArray.self)
    }
    func test_VtArray_GfRange3d() {
        let x: pxr.VtRange3dArray = [pxr.GfRange3d(pxr.GfVec3d(5, 9, -7), pxr.GfVec3d(6, 10, -6))]
        XCTAssertEqual(x.description, "[[(5, 9, -7)...(6, 10, -6)]]")
        assertConforms(pxr.VtRange3dArray.self)
    }
    func test_VtArray_GfRange3f() {
        let x: pxr.VtRange3fArray = [pxr.GfRange3f(pxr.GfVec3f(5, 9, -7), pxr.GfVec3f(6, 10, -6))]
        XCTAssertEqual(x.description, "[[(5, 9, -7)...(6, 10, -6)]]")
        assertConforms(pxr.VtRange3fArray.self)
    }
    func test_VtArray_GfRect2i() {
        let x: pxr.VtRect2iArray = [pxr.GfRect2i(pxr.GfVec2i(-5, -4), pxr.GfVec2i(3, 3))]
        XCTAssertEqual(x.description, "[[(-5, -4):(3, 3)]]")
        assertConforms(pxr.VtRect2iArray.self)
    }
    
    // MARK: std.vector specializations
    func test_StringVector() {
        let x: Overlay.String_Vector = ["hi"]
        XCTAssertEqual(x.description, "[hi]")
        assertConforms(Overlay.String_Vector.self)
    }
    
    func test_Double_Vector() {
        let x: Overlay.Double_Vector = [1.2]
        XCTAssertEqual(x.description, "[1.2]")
        assertConforms(Overlay.Double_Vector.self)
    }
    
    func test_UsdAttributeVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a_attr = p.GetAttribute("radius")
        
        let x: Overlay.UsdAttribute_Vector = [a_attr]
        XCTAssertEqual(x.description, "[attribute 'radius' on 'Sphere' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@]")
        assertConforms(Overlay.UsdAttribute_Vector.self)
    }
    
    func test_UsdRelationshipVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a_rel = p.CreateRelationship("firstRel", true)
        
        let x: Overlay.UsdRelationship_Vector = [a_rel]
        XCTAssertEqual(x.description, "[relationship 'firstRel' on 'Sphere' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@]")
        assertConforms(Overlay.UsdRelationship_Vector.self)
    }
    
    func test_TfTokenVector() {
        let x: pxr.TfTokenVector = ["hi"]
        XCTAssertEqual(x.description, "[hi]")
        assertConforms(pxr.TfTokenVector.self)
    }
    
    func test_SdfPathVector() {
        let x: pxr.SdfPathVector = ["/hi"]
        XCTAssertEqual(x.description, "[/hi]")
        assertConforms(pxr.SdfPathVector.self)
    }
    
    func test_SdfLayerOffsetVector() {
        let x: pxr.SdfLayerOffsetVector = [pxr.SdfLayerOffset(0, 1)]
        XCTAssertEqual(x.description, "[SdfLayerOffset(0, 1)]")
        assertConforms(pxr.SdfLayerOffsetVector.self)
    }
    
    func test_SdfPropertySpecHandleVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.GetAttribute("radius").Set(5.0, 2.0)
        p.CreateAttribute("myAttr", .Float, true, .SdfVariabilityVarying)
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let x: pxr.SdfPropertySpecHandleVector = [layer.GetPropertyAtPath("/foo.radius")]
        XCTAssertEqual(x.description, "[pxr::SdfPropertySpecHandle(pxr::SdfPropertySpec(\(pathForStage(named: "Main.usda")), /foo.radius))]")
        assertConforms(pxr.SdfPropertySpecHandleVector.self)
    }
    
    func test_SdfPrimSpecHandleVector() throws {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        let layer = Overlay.Dereference(main.GetRootLayer())

        let x: pxr.SdfPrimSpecHandleVector = [layer.GetPrimAtPath("/foo")]
        XCTAssertEqual(x.description, "[pxr::SdfPrimSpecHandle(pxr::SdfPrimSpec(\(pathForStage(named: "Main.usda")), /foo))]")
        assertConforms(pxr.SdfPrimSpecHandleVector.self)
    }
    
    func test_UsdGeomXformOpVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        let p = pxr.UsdGeomXformable.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let op1 = p.AddTranslateOp(.PrecisionDouble, "op1", false)
        
        let x: Overlay.UsdGeomXformOp_Vector = [op1]
        XCTAssertEqual(x.description, "[pxr::UsdGeomXformOp(/foo.xformOp:translate:op1)]")
        assertConforms(Overlay.UsdGeomXformOp_Vector.self)
    }
    
    func test_GfVec4f_Vector() {
        let x: Overlay.GfVec4f_Vector = [pxr.GfVec4f(1, 2, 3, 4)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4)]")
        assertConforms(Overlay.GfVec4f_Vector.self)
    }
    
    func test_VtValue() {
        let x: pxr.VtValue = pxr.VtValue(7.5)
        XCTAssertEqual(x.description, "7.5")
        assertConforms(pxr.VtValue.self)
    }
    
    func test_UsdMetadataValueMap() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetActive(false)
        let x: pxr.UsdMetadataValueMap = p.GetAllAuthoredMetadata()
        XCTAssertEqual(x.description, "< <active: 0> <specifier: SdfSpecifierDef> <typeName: Sphere> >")
        assertConforms(pxr.UsdMetadataValueMap.self)
    }
    
    func test_UsdAttribute() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let x: pxr.UsdAttribute = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        XCTAssertEqual(x.description, "attribute 'radius' on 'Sphere' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@")
        assertConforms(pxr.UsdAttribute.self)
    }
    
    func test_UsdRelationship() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let x: pxr.UsdRelationship = main.DefinePrim("/foo", "Sphere").CreateRelationship("myRel", true)
        XCTAssertEqual(x.description, "relationship 'myRel' on 'Sphere' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@")
        assertConforms(pxr.UsdRelationship.self)
    }
    
    func test_SdfValueTypeName() {
        let x: pxr.SdfValueTypeName = .Half
        XCTAssertEqual(x.description, "half")
        assertConforms(pxr.SdfValueTypeName.self)
    }
    
    func test_SdfLayerOffset() {
        let x: pxr.SdfLayerOffset = pxr.SdfLayerOffset(0, 1)
        XCTAssertEqual(x.description, "SdfLayerOffset(0, 1)")
        assertConforms(pxr.SdfLayerOffset.self)
    }
    
    func test_SdfAssetPath() {
        let x: pxr.SdfAssetPath = pxr.SdfAssetPath("/foo/bar")
        XCTAssertEqual(x.description, "@/foo/bar@")
        assertConforms(pxr.SdfAssetPath.self)
    }
    
    func test_SdfPrimSpecHandle() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Sphere")
        let x: pxr.SdfPrimSpecHandle = layer.GetPrimAtPath("/foo")
        XCTAssertEqual(x.description, "pxr::SdfPrimSpecHandle(pxr::SdfPrimSpec(\(pathForStage(named: "Main.usda")), /foo))")
        assertConforms(pxr.SdfPrimSpecHandle.self)
    }
    
    func test_SdfPropertySpecHandle() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Sphere").GetAttribute("radius").Set(7.0, 7.0)
        let x: pxr.SdfPropertySpecHandle = layer.GetPropertyAtPath("/foo.radius")
        XCTAssertEqual(x.description, "pxr::SdfPropertySpecHandle(pxr::SdfPropertySpec(\(pathForStage(named: "Main.usda")), /foo.radius))")
        assertConforms(pxr.SdfPropertySpecHandle.self)
    }
    
    func test_UsdGeomXformOp() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        let p = pxr.UsdGeomXformable.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let x = p.AddTranslateOp(.PrecisionDouble, "op1", false)
        
        XCTAssertEqual(x.description, "pxr::UsdGeomXformOp(/foo.xformOp:translate:op1)")
        assertConforms(pxr.UsdGeomXformOp.self)
    }
    
    func test_VtDictionary() {
        let x: pxr.VtDictionary = ["foo" : pxr.VtValue(7.1)]
        XCTAssertEqual(x.description, "{'foo': 7.1}")
        assertConforms(pxr.VtDictionary.self)
    }
    
    func test_SdfPathSet() {
        let x: pxr.SdfPathSet = ["/foo"]
        XCTAssertEqual(x.description, "[/foo]")
        assertConforms(pxr.SdfPathSet.self)
    }
    
    func test_ArResolvedPath() {
        let x: pxr.ArResolvedPath = pxr.ArResolvedPath("/foo/bar")
        XCTAssertEqual(x.description, "/foo/bar")
        assertConforms(pxr.ArResolvedPath.self)
    }
    
    func test_TfErrorMarkWrapper_ErrorSequence() {
        Overlay.withTfErrorMark { m in
            TF_WARN("My warning")
            TF_RUNTIME_ERROR("My runtime error")
            TF_CODING_ERROR("My coding error")
            
            XCTAssertEqual(m.errors.description, "[\"My runtime error\", \"My coding error\"]")
            assertConforms(Overlay.TfErrorMarkWrapper.ErrorSequence.self)
        }
    }
}
