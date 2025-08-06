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

// MARK: NanAwareEquals

fileprivate protocol NanAwareEquatable: Equatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool
}

fileprivate func XCTAssertNanAwareEqual<T: NanAwareEquatable>(_ expression1: @autoclosure () throws -> T,
                                                              _ expression2: @autoclosure () throws -> T,
                                                              _ message: @autoclosure () -> String = "",
                                                              file: StaticString = #filePath, line: UInt = #line) {
    guard let e1 = try? expression1() else {
        XCTFail("First argument threw. \(message())", file: file, line: line)
        return
    }
    guard let e2 = try? expression2() else {
        XCTFail("Second argument threw. \(message())", file: file, line: line)
        return
    }
    
    if T.nanAwareEquals(e1, e2) {
        // success. pass
    } else {
        XCTFail("'\(e1)' is not nan-aware equal to '\(e2)'. \(message())", file: file, line: line)
    }
}

extension Double: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        (lhs == rhs) || (lhs.isNaN && rhs.isNaN)
    }
}

extension Float: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        (lhs == rhs) || (lhs.isNaN && rhs.isNaN)
    }
}

extension pxr.GfHalf: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        (lhs == rhs) || (lhs.isNan() && rhs.isNan())
    }
}

extension pxr.GfVec2d: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        Double.nanAwareEquals(lhs[0], rhs[0]) &&
        Double.nanAwareEquals(lhs[1], rhs[1])
    }
}

extension pxr.GfVec2f: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        Float.nanAwareEquals(lhs[0], rhs[0]) &&
        Float.nanAwareEquals(lhs[1], rhs[1])
    }
}

extension pxr.GfVec2h: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        pxr.GfHalf.nanAwareEquals(lhs[0], rhs[0]) &&
        pxr.GfHalf.nanAwareEquals(lhs[1], rhs[1])
    }
}

extension pxr.GfVec3d: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        Double.nanAwareEquals(lhs[0], rhs[0]) &&
        Double.nanAwareEquals(lhs[1], rhs[1]) &&
        Double.nanAwareEquals(lhs[2], rhs[2])
    }
}

extension pxr.GfVec3f: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        Float.nanAwareEquals(lhs[0], rhs[0]) &&
        Float.nanAwareEquals(lhs[1], rhs[1]) &&
        Float.nanAwareEquals(lhs[2], rhs[2])
    }
}

extension pxr.GfVec3h: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        pxr.GfHalf.nanAwareEquals(lhs[0], rhs[0]) &&
        pxr.GfHalf.nanAwareEquals(lhs[1], rhs[1]) &&
        pxr.GfHalf.nanAwareEquals(lhs[2], rhs[2])
    }
}

extension pxr.GfVec4d: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        Double.nanAwareEquals(lhs[0], rhs[0]) &&
        Double.nanAwareEquals(lhs[1], rhs[1]) &&
        Double.nanAwareEquals(lhs[2], rhs[2]) &&
        Double.nanAwareEquals(lhs[3], rhs[3])
    }
}

extension pxr.GfVec4f: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        Float.nanAwareEquals(lhs[0], rhs[0]) &&
        Float.nanAwareEquals(lhs[1], rhs[1]) &&
        Float.nanAwareEquals(lhs[2], rhs[2]) &&
        Float.nanAwareEquals(lhs[3], rhs[3])
    }
}

extension pxr.GfVec4h: NanAwareEquatable {
    static func nanAwareEquals(_ lhs: Self, _ rhs: Self) -> Bool {
        pxr.GfHalf.nanAwareEquals(lhs[0], rhs[0]) &&
        pxr.GfHalf.nanAwareEquals(lhs[1], rhs[1]) &&
        pxr.GfHalf.nanAwareEquals(lhs[2], rhs[2]) &&
        pxr.GfHalf.nanAwareEquals(lhs[3], rhs[3])
    }
}







// MARK: CodableTests

final class CodableTests: TemporaryDirectoryHelper {
    var encoder: JSONEncoder {
        let result = JSONEncoder()
        result.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+Inf", negativeInfinity: "-Inf", nan: "nan")
        result.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
        return result
    }
    
    var decoder: JSONDecoder {
        let result = JSONDecoder()
        result.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Inf", negativeInfinity: "-Inf", nan: "nan")
        return result
    }
    
    func assertConforms<T>(_ t: T.Type,
                           file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(T.self is any Encodable.Type, file: file, line: line)
        XCTAssertTrue(T.self is any Decodable.Type, file: file, line: line)
    }
    
    func assertRoundTripsEqual<T: Codable & Equatable>(_ value: T,
                                                       file: StaticString = #filePath, line: UInt = #line) throws {
        let encoded = try encoder.encode(value)
        let decoded = try decoder.decode(T.self, from: encoded)
        
        // Casting `value` and `decoded` to the same `NanAwareEquatable` non-existential is tricky
        if let nanAwareValue = value as? any NanAwareEquatable {
            // f implicitly uses open existentials. Returned bool indicates if
            // the _cast_ succeeded, not the comparison
            func f<U: NanAwareEquatable>(_ lhs: U) -> Bool {
                guard let rhs = decoded as? U else { return false }
                XCTAssertNanAwareEqual(lhs, rhs)
                return true
            }
            
            if f(nanAwareValue) { return }
        }
        
        XCTAssertEqual(value, decoded, file: file, line: line)
    }
    
    // Calls assertRoundTripsEqual and assertEncodedJsonIsEquivalent
    func assertEncodedJsonIsIdentical<T: Codable & Equatable>(_ value: T, _ expectedJson: String,
                                                              file: StaticString = #filePath, line: UInt = #line) throws {
        let encodedValue = try encoder.encode(value)
        let s = String(data: encodedValue, encoding: .utf8)!
        XCTAssertEqual(s, expectedJson, file: file, line: line)
        
        try assertRoundTripsEqual(value, file: file, line: line)
        try assertEncodedJsonIsEquivalent(value, expectedJson, file: file, line: line)
    }
    
    // Calls assertRoundTripsEqual
    func assertEncodedJsonIsEquivalent<T: Codable & Equatable>(_ value: T, _ expectedJson: String,
                                                               file: StaticString = #filePath, line: UInt = #line) throws {
        let encodedValue = try encoder.encode(value)
        let encodedString = String(data: encodedValue, encoding: .utf8)!
        
        let decodedExpectedJson = try decoder.decode(T.self, from: expectedJson.data(using: .utf8)!)
        let reencodedExpectedJson = try encoder.encode(decodedExpectedJson)
        let reencodedExpectedJsonString = String(data: reencodedExpectedJson, encoding: .utf8)!
        
        XCTAssertEqual(encodedString, reencodedExpectedJsonString, file: file, line: line)
        
        try assertRoundTripsEqual(value, file: file, line: line)
    }
    
    func assertDecodingSucceeds<T: Codable>(_ type: T.Type, _ jsonString: String,
                                            file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertNoThrow(try decoder.decode(T.self, from: jsonString.data(using: .utf8)!))
    }
    
    func assertDecodingFails<T: Codable>(_ type: T.Type, _ jsonString: String,
                                         file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try decoder.decode(T.self, from: jsonString.data(using: .utf8)!), file: file, line: line)
    }
    
    // MARK: Tf
    
    func test_TfToken() throws {
        assertConforms(pxr.TfToken.self)
        let x: pxr.TfToken = .UsdGeomTokens.Cube
        try assertEncodedJsonIsIdentical(x, #""Cube""#)
        
        let y = pxr.TfToken("fizz buzz")
        try assertEncodedJsonIsIdentical(y, #""fizz buzz""#)
        
        let z = pxr.TfToken("")
        try assertEncodedJsonIsIdentical(z, #""""#)
        
        let w = pxr.TfToken("   ")
        try assertEncodedJsonIsIdentical(w, #""   ""#)
        
        assertDecodingFails(pxr.TfToken.self, #"string without quotes"#)
        assertDecodingFails(pxr.TfToken.self, #"3.5"#)
        assertDecodingFails(pxr.TfToken.self, #"nan"#)
        assertDecodingFails(pxr.TfToken.self, #"[]"#)
        assertDecodingFails(pxr.TfToken.self, #"{}"#)
    }
    
    // MARK: Gf
    
    func test_GfBBox3d() throws {
        assertConforms(pxr.GfBBox3d.self)
        var x: pxr.GfBBox3d = .init(
            .init(.init(1.1, 2.2, 3.3),
                  .init(4.4, 5.5, 6.6)),
            .init(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16))
        try assertEncodedJsonIsEquivalent(x,
        """
        { "box" : { "min" : [1.1, 2.2, 3.3], "max" : [4.4, 5.5, 6.6] },
        "matrix" : [ [1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]],
        "hasZeroAreaPrimitives" : false }
        """)
                                                  
        x.SetHasZeroAreaPrimitives(true)
        
        try assertEncodedJsonIsEquivalent(x,
        """
        { "box" : { "min" : [1.1, 2.2, 3.3], "max" : [4.4, 5.5, 6.6] },
        "matrix" : [ [1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16] ],
        "hasZeroAreaPrimitives" : true }
        """)
    }
    func test_GfCamera() throws {
        assertConforms(pxr.GfCamera.self)
        let x: pxr.GfCamera = .init(.init(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16), // transform
                                    .Perspective, // projection
                                    17, // horizontalAperture
                                    18, // verticalAperture
                                    19, // horizontalApertureOffset
                                    20, // verticalApertureOffset
                                    21, // focalLength
                                    .init(22, 23), // clippingRange
                                    [.init(24, 25, 26, 27)], // clippingPlanes
                                    28, // fStop
                                    29) // focusDistance
        try assertEncodedJsonIsEquivalent(x,
        """
        {
        "transform": [[1,2,3,4], [5,6,7,8], [9,10,11,12], [13,14,15,16]],
        "projection": 0,
        "horizontalAperture": 17,
        "verticalAperture": 18,
        "horizontalApertureOffset": 19,
        "verticalApertureOffset": 20,
        "focalLength": 21,
        "clippingRange": {"min": 22, "max": 23},
        "clippingPlanes": [[24, 25, 26, 27]],
        "fStop": 28,
        "focusDistance": 29
        }
        """)
        
        assertDecodingFails(pxr.GfCamera.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfCamera.self, #"[]"#)
        assertDecodingFails(pxr.GfCamera.self, #"{}"#)
        assertDecodingFails(pxr.GfCamera.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfCamera.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfCamera.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfCamera.self, #"[4]"#)
        assertDecodingFails(pxr.GfCamera.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfCamera.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfColor() throws {
        assertConforms(pxr.GfColor.self)
        let x: pxr.GfColor = .init(.init(.GfColorSpaceNames.LinearRec2020))
        try assertEncodedJsonIsIdentical(x, #"{"colorSpace":{"name":"lin_rec2020_scene"},"rgb":[0,0,0]}"#)
        
        let y: pxr.GfColor = .init(.init(0.5, 0.6, 0.7), .init(.GfColorSpaceNames.LinearRec2020))
        try assertEncodedJsonIsIdentical(y, #"{"colorSpace":{"name":"lin_rec2020_scene"},"rgb":[0.5,0.6,0.7]}"#)
        
        assertDecodingFails(pxr.GfColor.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfColor.self, #"[]"#)
        assertDecodingFails(pxr.GfColor.self, #"{}"#)
        assertDecodingFails(pxr.GfColor.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfColor.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfColor.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfColor.self, #"[4]"#)
        assertDecodingFails(pxr.GfColor.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfColor.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfColorSpace() throws {
        assertConforms(pxr.GfColorSpace.self)
        let x: pxr.GfColorSpace = .init(.GfColorSpaceNames.LinearRec2020)
        try assertEncodedJsonIsIdentical(x, #"{"name":"lin_rec2020_scene"}"#)
        
        let y: pxr.GfColorSpace = .init("customRGB", .init(1, 2, 3, 4, 5, 6, 7, 8, 9), 10, 11)
        try assertEncodedJsonIsIdentical(y, #"{"gamma":10,"linearBias":11,"name":"customRGB","rgbToXYZ":[[1,2,3],[4,5,6],[7,8,9]]}"#)
                
        assertDecodingFails(pxr.GfColorSpace.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"[]"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"{}"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"[4]"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfColorSpace.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfDualQuatd() throws {
        assertConforms(pxr.GfDualQuatd.self)
        let x: pxr.GfDualQuatd = .init(.init(1, .init(2, 3, 4)), .init(5, .init(6, 7, 8)))
        try assertEncodedJsonIsEquivalent(x, """
        {"real" : {"real" : 1, "imaginary": [2, 3, 4]},
         "dual" : {"real" : 5, "imaginary" : [6, 7, 8]}}
        """)
        
        assertDecodingFails(pxr.GfDualQuatd.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"[]"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"{}"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"[4]"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfDualQuatd.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfDualQuatf() throws {
        assertConforms(pxr.GfDualQuatf.self)
        let x: pxr.GfDualQuatf = .init(.init(1, .init(2, 3, 4)), .init(5, .init(6, 7, 8)))
        try assertEncodedJsonIsEquivalent(x, """
        {"real" : {"real" : 1, "imaginary": [2, 3, 4]},
         "dual" : {"real" : 5, "imaginary" : [6, 7, 8]}}
        """)
        
        assertDecodingFails(pxr.GfDualQuatf.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"[]"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"{}"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"[4]"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfDualQuatf.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfDualQuath() throws {
        assertConforms(pxr.GfDualQuath.self)
        let x: pxr.GfDualQuath = .init(.init(1, .init(2, 3, 4)), .init(5, .init(6, 7, 8)))
        try assertEncodedJsonIsEquivalent(x, """
        {"real" : {"real" : 1, "imaginary": [2, 3, 4]},
         "dual" : {"real" : 5, "imaginary" : [6, 7, 8]}}
        """)
        
        assertDecodingFails(pxr.GfDualQuath.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"[]"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"{}"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"[4]"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfDualQuath.self, #"[[1,2],[3,4]]"#)

    }
    func test_GfFrustum() throws {
        assertConforms(pxr.GfFrustum.self)
        let x: pxr.GfFrustum = .init(.init(1, 2, 3), // position
                                     .init(.init(4, 5, 6), 7), //rotation
                                     .init(.init(8, 9), .init(10, 11)), // window
                                     .init(12, 13), // nearFar
                                     .Perspective, //projectionType
                                     14) // viewDistance
        try assertEncodedJsonIsEquivalent(x,
        """
        {
        "position" : [1, 2, 3],
        "rotation" : {"axis" : [4, 5, 6], "angle" : 7},
        "window" : {"min" : [8, 9], "max" : [10, 11]},
        "nearFar" : {"min" : 12, "max" : 13},
        "projectionType" : 1,
        "viewDistance" : 14
        }
        """)
        
        assertDecodingFails(pxr.GfFrustum.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfFrustum.self, #"[]"#)
        assertDecodingFails(pxr.GfFrustum.self, #"{}"#)
        assertDecodingFails(pxr.GfFrustum.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfFrustum.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfFrustum.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfFrustum.self, #"[4]"#)
        assertDecodingFails(pxr.GfFrustum.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfFrustum.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfHalf() throws {
        assertConforms(pxr.GfHalf.self)
        let x: pxr.GfHalf = -3.125
        try assertEncodedJsonIsIdentical(x, "-3.125")
        
        let y = pxr.GfHalf(Float.nan)
        try assertEncodedJsonIsIdentical(y, #""nan""#)
        
        assertDecodingFails(pxr.GfHalf.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfHalf.self, #""string containing nan""#)
        assertDecodingFails(pxr.GfHalf.self, #"[]"#)
        assertDecodingFails(pxr.GfHalf.self, #"{}"#)
    }
    func test_GfInterval() throws {
        assertConforms(pxr.GfInterval.self)
        let x: pxr.GfInterval = .init(2.718, 3.14, true, false)
        try assertEncodedJsonIsIdentical(x, #"{"max":3.14,"maxClosed":false,"min":2.718,"minClosed":true}"#)
        
        assertDecodingFails(pxr.GfInterval.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfInterval.self, #"[]"#)
        assertDecodingFails(pxr.GfInterval.self, #"{}"#)
        assertDecodingFails(pxr.GfInterval.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfInterval.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfInterval.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfInterval.self, #"[4]"#)
        assertDecodingFails(pxr.GfInterval.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfInterval.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfLine() throws {
        assertConforms(pxr.GfLine.self)
        let x: pxr.GfLine = .init(.init(-7, 8, 9), .init(0, 1, 0))
        try assertEncodedJsonIsIdentical(x, #"{"direction":[0,1,0],"point":[-7,8,9]}"#)
        
        assertDecodingFails(pxr.GfLine.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfLine.self, #"[]"#)
        assertDecodingFails(pxr.GfLine.self, #"{}"#)
        assertDecodingFails(pxr.GfLine.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfLine.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfLine.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfLine.self, #"[4]"#)
        assertDecodingFails(pxr.GfLine.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfLine.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfLine2d() throws {
        assertConforms(pxr.GfLine2d.self)
        let x: pxr.GfLine2d = .init(.init(-7, 8), .init(0, 1))
        try assertEncodedJsonIsIdentical(x, #"{"direction":[0,1],"point":[-7,8]}"#)
        
        assertDecodingFails(pxr.GfLine2d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfLine2d.self, #"[]"#)
        assertDecodingFails(pxr.GfLine2d.self, #"{}"#)
        assertDecodingFails(pxr.GfLine2d.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfLine2d.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfLine2d.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfLine2d.self, #"[4]"#)
        assertDecodingFails(pxr.GfLine2d.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfLine2d.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfLineSeg() throws {
        assertConforms(pxr.GfLineSeg.self)
        let x: pxr.GfLineSeg = .init(.init(1, 2, 3), .init(4, 5, 6))
        try assertEncodedJsonIsIdentical(x, #"{"p0":[1,2,3],"p1":[4,5,6]}"#)
        
        assertDecodingFails(pxr.GfLineSeg.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"[]"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"{}"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"[4]"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfLineSeg.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfMatrix2d() throws {
        assertConforms(pxr.GfMatrix2d.self)
        let x: pxr.GfMatrix2d = pxr.GfMatrix2d(1, 2, 3, 4.4)
        try assertEncodedJsonIsIdentical(x, #"[[1,2],[3,4.4]]"#)
        
        assertDecodingFails(pxr.GfMatrix2d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfMatrix2d.self, #""string containing nan""#)
        assertDecodingFails(pxr.GfMatrix2d.self, #"[]"#)
        assertDecodingFails(pxr.GfMatrix2d.self, #"{}"#)
        assertDecodingFails(pxr.GfMatrix2d.self, #"[[1,2],[3]]"#)
        assertDecodingFails(pxr.GfMatrix2d.self, #"[[1,2],[3,4.4],[5,6]]"#)
        assertDecodingFails(pxr.GfMatrix2d.self, #"[[1,2,0],[3,4.4,0],[5,6,0]]"#)
    }
    func test_GfMatrix2f() throws {
        assertConforms(pxr.GfMatrix2f.self)
        let x: pxr.GfMatrix2f = pxr.GfMatrix2f(1, 2, 3, 4.4)
        try assertEncodedJsonIsIdentical(x, #"[[1,2],[3,4.4]]"#)
        
        assertDecodingFails(pxr.GfMatrix2f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfMatrix2f.self, #""string containing nan""#)
        assertDecodingFails(pxr.GfMatrix2f.self, #"[]"#)
        assertDecodingFails(pxr.GfMatrix2f.self, #"{}"#)
        assertDecodingFails(pxr.GfMatrix2f.self, #"[[1,2],[3]]"#)
        assertDecodingFails(pxr.GfMatrix2f.self, #"[[1,2],[3,4.4],[5,6]]"#)
        assertDecodingFails(pxr.GfMatrix2f.self, #"[[1,2,0],[3,4.4,0],[5,6,0]]"#)
    }
    func test_GfMatrix3d() throws {
        assertConforms(pxr.GfMatrix3d.self)
        let x: pxr.GfMatrix3d = pxr.GfMatrix3d(1, 2, 3, 4.4, 5, 6, 7, 8, 9)
        try assertEncodedJsonIsIdentical(x, #"[[1,2,3],[4.4,5,6],[7,8,9]]"#)
        
        assertDecodingFails(pxr.GfMatrix3d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfMatrix3d.self, #""string containing nan""#)
        assertDecodingFails(pxr.GfMatrix3d.self, #"[]"#)
        assertDecodingFails(pxr.GfMatrix3d.self, #"{}"#)
        assertDecodingFails(pxr.GfMatrix3d.self, #"[[1,2],[3]]"#)
        assertDecodingFails(pxr.GfMatrix3d.self, #"[[1,2],[3,4.4],[5,6]]"#)
        assertDecodingFails(pxr.GfMatrix3d.self, #"[[1,2,0],[3,4.4,0],[5,6,0,0]]"#)
        assertDecodingFails(pxr.GfMatrix3d.self, #"[[1,2],[3,4.4]]"#)
    }
    func test_GfMatrix3f() throws {
        assertConforms(pxr.GfMatrix3f.self)
        let x: pxr.GfMatrix3f = pxr.GfMatrix3f(1, 2, 3, 4.4, 5, 6, 7, 8, 9)
        try assertEncodedJsonIsIdentical(x, #"[[1,2,3],[4.4,5,6],[7,8,9]]"#)
        
        assertDecodingFails(pxr.GfMatrix3f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfMatrix3f.self, #""string containing nan""#)
        assertDecodingFails(pxr.GfMatrix3f.self, #"[]"#)
        assertDecodingFails(pxr.GfMatrix3f.self, #"{}"#)
        assertDecodingFails(pxr.GfMatrix3f.self, #"[[1,2],[3]]"#)
        assertDecodingFails(pxr.GfMatrix3f.self, #"[[1,2],[3,4.4],[5,6]]"#)
        assertDecodingFails(pxr.GfMatrix3f.self, #"[[1,2,0],[3,4.4,0],[5,6,0,0]]"#)
        assertDecodingFails(pxr.GfMatrix3f.self, #"[[1,2],[3,4.4]]"#)
    }
    func test_GfMatrix4d() throws {
        assertConforms(pxr.GfMatrix4d.self)
        let x: pxr.GfMatrix4d = pxr.GfMatrix4d(1, 2, 3, 4.4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        try assertEncodedJsonIsIdentical(x, #"[[1,2,3,4.4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]"#)
        
        assertDecodingFails(pxr.GfMatrix4d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfMatrix4d.self, #""string containing nan""#)
        assertDecodingFails(pxr.GfMatrix4d.self, #"[]"#)
        assertDecodingFails(pxr.GfMatrix4d.self, #"{}"#)
        assertDecodingFails(pxr.GfMatrix4d.self, #"[[1,2],[3]]"#)
        assertDecodingFails(pxr.GfMatrix4d.self, #"[[1,2],[3,4.4],[5,6]]"#)
        assertDecodingFails(pxr.GfMatrix4d.self, #"[[1,2,0],[3,4.4,0],[5,6,0,0]]"#)
        assertDecodingFails(pxr.GfMatrix4d.self, #"[[1,2],[3,4.4]]"#)
    }
    func test_GfMatrix4f() throws {
        assertConforms(pxr.GfMatrix4f.self)
        let x: pxr.GfMatrix4f = pxr.GfMatrix4f(1, 2, 3, 4.4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        try assertEncodedJsonIsIdentical(x, #"[[1,2,3,4.4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]"#)
        
        assertDecodingFails(pxr.GfMatrix4f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfMatrix4f.self, #""string containing nan""#)
        assertDecodingFails(pxr.GfMatrix4f.self, #"[]"#)
        assertDecodingFails(pxr.GfMatrix4f.self, #"{}"#)
        assertDecodingFails(pxr.GfMatrix4f.self, #"[[1,2],[3]]"#)
        assertDecodingFails(pxr.GfMatrix4f.self, #"[[1,2],[3,4.4],[5,6]]"#)
        assertDecodingFails(pxr.GfMatrix4f.self, #"[[1,2,0],[3,4.4,0],[5,6,0,0]]"#)
        assertDecodingFails(pxr.GfMatrix4f.self, #"[[1,2],[3,4.4]]"#)
    }
    func test_GfMultiInterval() throws {
        assertConforms(pxr.GfMultiInterval.self)
        let x: pxr.GfMultiInterval = .init([.init(1, 2, true, true), .init(3, 4, true, true)])
        try assertEncodedJsonIsEquivalent(x,
        """
        [{"min": 1, "max": 2, "minClosed": true, "maxClosed": true},
         {"min": 3, "max": 4, "minClosed": true, "maxClosed": true}]
        """)
        
        assertDecodingFails(pxr.GfMultiInterval.self, #"string without quotes"#)
        assertDecodingSucceeds(pxr.GfMultiInterval.self, #"[]"#)
        assertDecodingFails(pxr.GfMultiInterval.self, #"{}"#)
        assertDecodingFails(pxr.GfMultiInterval.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfMultiInterval.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfMultiInterval.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfMultiInterval.self, #"[4]"#)
        assertDecodingFails(pxr.GfMultiInterval.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfMultiInterval.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfPlane() throws {
        assertConforms(pxr.GfPlane.self)
        let x: pxr.GfPlane = .init(.init(0, 1, 0), 5)
        try assertEncodedJsonIsEquivalent(x, #"{"distance": 5, "normal" : [0, 1, 0]}"#)
        
        assertDecodingFails(pxr.GfPlane.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfPlane.self, #"[]"#)
        assertDecodingFails(pxr.GfPlane.self, #"{}"#)
        assertDecodingFails(pxr.GfPlane.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfPlane.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfPlane.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfPlane.self, #"[4]"#)
        assertDecodingFails(pxr.GfPlane.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfPlane.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfQuatd() throws {
        assertConforms(pxr.GfQuatd.self)
        let x: pxr.GfQuatd = .init(1, 2, 3, 4)
        try assertEncodedJsonIsIdentical(x, #"{"imaginary":[2,3,4],"real":1}"#)
        
        assertDecodingFails(pxr.GfQuatd.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfQuatd.self, #"[]"#)
        assertDecodingFails(pxr.GfQuatd.self, #"{}"#)
        assertDecodingFails(pxr.GfQuatd.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfQuatd.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfQuatd.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfQuatd.self, #"[4]"#)
        assertDecodingFails(pxr.GfQuatd.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfQuatd.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfQuaternion() throws {
        assertConforms(pxr.GfQuaternion.self)
        let x: pxr.GfQuaternion = .init(1, .init(2, 3, 4))
        try assertEncodedJsonIsIdentical(x, #"{"imaginary":[2,3,4],"real":1}"#)
        
        assertDecodingFails(pxr.GfQuaternion.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"[]"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"{}"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"[4]"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfQuaternion.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfQuatf() throws {
        assertConforms(pxr.GfQuatf.self)
        let x: pxr.GfQuatf = .init(1, 2, 3, 4)
        try assertEncodedJsonIsIdentical(x, #"{"imaginary":[2,3,4],"real":1}"#)
        
        assertDecodingFails(pxr.GfQuatf.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfQuatf.self, #"[]"#)
        assertDecodingFails(pxr.GfQuatf.self, #"{}"#)
        assertDecodingFails(pxr.GfQuatf.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfQuatf.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfQuatf.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfQuatf.self, #"[4]"#)
        assertDecodingFails(pxr.GfQuatf.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfQuatf.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfQuath() throws {
        assertConforms(pxr.GfQuath.self)
        let x: pxr.GfQuath = .init(1, 2, 3, 4)
        try assertEncodedJsonIsIdentical(x, #"{"imaginary":[2,3,4],"real":1}"#)
        
        assertDecodingFails(pxr.GfQuath.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfQuath.self, #"[]"#)
        assertDecodingFails(pxr.GfQuath.self, #"{}"#)
        assertDecodingFails(pxr.GfQuath.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfQuath.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfQuath.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfQuath.self, #"[4]"#)
        assertDecodingFails(pxr.GfQuath.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfQuath.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRange1d() throws {
        assertConforms(pxr.GfRange1d.self)
        let x: pxr.GfRange1d = .init(1, 2)
        try assertEncodedJsonIsEquivalent(x, #"{"max":2,"min":1}"#)
        
        assertDecodingFails(pxr.GfRange1d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRange1d.self, #"[]"#)
        assertDecodingFails(pxr.GfRange1d.self, #"{}"#)
        assertDecodingFails(pxr.GfRange1d.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRange1d.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRange1d.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRange1d.self, #"[4]"#)
        assertDecodingFails(pxr.GfRange1d.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRange1d.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRange1f() throws {
        assertConforms(pxr.GfRange1f.self)
        let x: pxr.GfRange1f = .init(1, 2)
        try assertEncodedJsonIsEquivalent(x, #"{"max":2,"min":1}"#)
        
        assertDecodingFails(pxr.GfRange1f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRange1f.self, #"[]"#)
        assertDecodingFails(pxr.GfRange1f.self, #"{}"#)
        assertDecodingFails(pxr.GfRange1f.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRange1f.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRange1f.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRange1f.self, #"[4]"#)
        assertDecodingFails(pxr.GfRange1f.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRange1f.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRange2d() throws {
        assertConforms(pxr.GfRange2d.self)
        let x: pxr.GfRange2d = .init(.init(1, 2), .init(4, 5))
        try assertEncodedJsonIsEquivalent(x, #"{"max":[4,5],"min":[1,2]}"#)
        
        assertDecodingFails(pxr.GfRange2d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRange2d.self, #"[]"#)
        assertDecodingFails(pxr.GfRange2d.self, #"{}"#)
        assertDecodingFails(pxr.GfRange2d.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRange2d.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRange2d.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRange2d.self, #"[4]"#)
        assertDecodingFails(pxr.GfRange2d.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRange2d.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRange2f() throws {
        assertConforms(pxr.GfRange2f.self)
        let x: pxr.GfRange2f = .init(.init(1, 2), .init(4, 5))
        try assertEncodedJsonIsEquivalent(x, #"{"max":[4,5],"min":[1,2]}"#)
        
        assertDecodingFails(pxr.GfRange2f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRange2f.self, #"[]"#)
        assertDecodingFails(pxr.GfRange2f.self, #"{}"#)
        assertDecodingFails(pxr.GfRange2f.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRange2f.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRange2f.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRange2f.self, #"[4]"#)
        assertDecodingFails(pxr.GfRange2f.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRange2f.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRange3d() throws {
        assertConforms(pxr.GfRange3d.self)
        let x: pxr.GfRange3d = .init(.init(1, 2, 3), .init(4, 5, 6))
        try assertEncodedJsonIsEquivalent(x, #"{"max":[4,5,6],"min":[1,2,3]}"#)
        
        assertDecodingFails(pxr.GfRange3d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRange3d.self, #"[]"#)
        assertDecodingFails(pxr.GfRange3d.self, #"{}"#)
        assertDecodingFails(pxr.GfRange3d.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRange3d.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRange3d.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRange3d.self, #"[4]"#)
        assertDecodingFails(pxr.GfRange3d.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRange3d.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRange3f() throws {
        assertConforms(pxr.GfRange3f.self)
        let x: pxr.GfRange3f = .init(.init(1, 2, 3), .init(4, 5, 6))
        try assertEncodedJsonIsEquivalent(x, #"{"max":[4,5,6],"min":[1,2,3]}"#)
        
        assertDecodingFails(pxr.GfRange3f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRange3f.self, #"[]"#)
        assertDecodingFails(pxr.GfRange3f.self, #"{}"#)
        assertDecodingFails(pxr.GfRange3f.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRange3f.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRange3f.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRange3f.self, #"[4]"#)
        assertDecodingFails(pxr.GfRange3f.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRange3f.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRay() throws {
        assertConforms(pxr.GfRay.self)
        let x: pxr.GfRay = .init(.init(1, 2, 3), .init(1, 0, 1))
        try assertEncodedJsonIsEquivalent(x, #"{"direction":[1, 0, 1], "startPoint" : [1, 2, 3]}"#)
        
        assertDecodingFails(pxr.GfRay.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRay.self, #"[]"#)
        assertDecodingFails(pxr.GfRay.self, #"{}"#)
        assertDecodingFails(pxr.GfRay.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRay.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRay.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRay.self, #"[4]"#)
        assertDecodingFails(pxr.GfRay.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRay.self, #"[[1,2],[3,4]]"#)

    }
    func test_GfRect2i() throws {
        assertConforms(pxr.GfRect2i.self)
        let x: pxr.GfRect2i = .init(.init(1, 2), .init(3, 4))
        try assertEncodedJsonIsIdentical(x, #"{"max":[3,4],"min":[1,2]}"#)
        
        assertDecodingFails(pxr.GfRect2i.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRect2i.self, #"[]"#)
        assertDecodingFails(pxr.GfRect2i.self, #"{}"#)
        assertDecodingFails(pxr.GfRect2i.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRect2i.self, #"[4]"#)
        assertDecodingFails(pxr.GfRect2i.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRect2i.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfRotation() throws {
        assertConforms(pxr.GfRotation.self)
        let x: pxr.GfRotation = .init(.init(0, 1, 1), 30)
        try assertEncodedJsonIsEquivalent(x, #"{"axis" : [0, 1, 1], "angle" : 30}"#)
        
        assertDecodingFails(pxr.GfRotation.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfRotation.self, #"[]"#)
        assertDecodingFails(pxr.GfRotation.self, #"{}"#)
        assertDecodingFails(pxr.GfRotation.self, #"{"angle" : 45}"#)
        assertDecodingFails(pxr.GfRotation.self, #"{"axis" : [1, 1], "angle" : 30}"#)
        assertDecodingFails(pxr.GfRotation.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfRotation.self, #"[4]"#)
        assertDecodingFails(pxr.GfRotation.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfRotation.self, #"[[1,2],[3,4]]"#)
    }
    func test_GfSize2() throws {
        assertConforms(pxr.GfSize2.self)
        let x: pxr.GfSize2 = .init(1, 2)
        try assertEncodedJsonIsEquivalent(x, #"[1,2]"#)
        
        assertDecodingFails(pxr.GfSize2.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfSize2.self, #"[]"#)
        assertDecodingFails(pxr.GfSize2.self, #"{}"#)
        assertDecodingFails(pxr.GfSize2.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfSize2.self, #"[4]"#)
        assertDecodingFails(pxr.GfSize2.self, #"[4, ]"#)
    }
    func test_GfSize3() throws {
        assertConforms(pxr.GfSize3.self)
        let x: pxr.GfSize3 = .init(1, 2, 3)
        try assertEncodedJsonIsEquivalent(x, #"[1,2,3]"#)
        
        assertDecodingFails(pxr.GfSize3.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfSize3.self, #"[]"#)
        assertDecodingFails(pxr.GfSize3.self, #"{}"#)
        assertDecodingFails(pxr.GfSize3.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfSize3.self, #"[4]"#)
        assertDecodingFails(pxr.GfSize3.self, #"[4, ]"#)
    }
    func test_GfTransform() throws {
        assertConforms(pxr.GfTransform.self)
        let x: pxr.GfTransform = .init(.init(1, 2, 3), // scale
                                       .init(.init(0, 1, 0), 7), // pivot orientation
                                       .init(.init(0, 0, -1), 11), // rotation
                                       .init(12, 13, 14), // pivot position
                                       .init(15, 16, 17)) // translation
        try assertEncodedJsonIsEquivalent(x,
        """
        {
        "scale" : [1, 2, 3],
        "pivotOrientation" : {"axis" : [0, 1, 0], "angle" : 7},
        "rotation" : {"axis" : [0, 0, -1], "angle" : 11},
        "pivotPosition" : [12, 13, 14],
        "translation" : [15, 16, 17]
        }
        """)
        
        // missing scale key
        assertDecodingFails(pxr.GfTransform.self, """
        {
        "pivotOrientation" : {"axis" : [4, 5, 6], "angle" : 7},
        "rotation" : {"axis" : [8, 9, 10], "angle" : 11},
        "pivotPosition" : [12, 13, 14],
        "translation" : [15, 16, 17]
        }
        """)
        // scale has only two elements
        assertDecodingFails(pxr.GfTransform.self, """
        {
        "scale" : [1, 2],
        "pivotOrientation" : {"axis" : [4, 5, 6], "angle" : 7},
        "rotation" : {"axis" : [8, 9, 10], "angle" : 11},
        "pivotPosition" : [12, 13, 14],
        "translation" : [15, 16, 17]
        }
        """)
        // pivotOrientation.angle is missing
        assertDecodingFails(pxr.GfTransform.self, """
        {
        "scale" : [1, 2, 3],
        "pivotOrientation" : {"axis" : [4, 5, 6]},
        "rotation" : {"axis" : [8, 9, 10], "angle" : 11},
        "pivotPosition" : [12, 13, 14],
        "translation" : [15, 16, 17]
        }
        """)
        // pivotOrientation.angle is a string
        assertDecodingFails(pxr.GfTransform.self, """
        {
        "scale" : [1, 2, 3],
        "pivotOrientation" : {"axis" : [4, 5, 6], "angle" : "7"},
        "rotation" : {"axis" : [8, 9, 10], "angle" : 11},
        "pivotPosition" : [12, 13, 14],
        "translation" : [15, 16, 17]
        }
        """)
        // pivotOrientation.axis has four elements
        assertDecodingFails(pxr.GfTransform.self, """
        {
        "scale" : [1, 2, 3],
        "pivotOrientation" : {"axis" : [4, 5, 6, 7], "angle" : 7},
        "rotation" : {"axis" : [8, 9, 10], "angle" : 11},
        "pivotPosition" : [12, 13, 14],
        "translation" : [15, 16, 17]
        }
        """)
        // scale is capitalized
        assertDecodingFails(pxr.GfTransform.self, """
        {
        "Scale" : [1, 2, 3],
        "pivotOrientation" : {"axis" : [4, 5, 6], "angle" : 7},
        "rotation" : {"axis" : [8, 9, 10], "angle" : 11},
        "pivotPosition" : [12, 13, 14],
        "translation" : [15, 16, 17]
        }
        """)
        assertDecodingFails(pxr.GfTransform.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfTransform.self, #"3.5"#)
        assertDecodingFails(pxr.GfTransform.self, #"nan"#)
        assertDecodingFails(pxr.GfTransform.self, #"[]"#)
        assertDecodingFails(pxr.GfTransform.self, #"{}"#)
        assertDecodingFails(pxr.GfTransform.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfTransform.self, #"[4]"#)
        assertDecodingFails(pxr.GfTransform.self, #"[4, ]"#)
    }
    func test_GfVec2d() throws {
        assertConforms(pxr.GfVec2d.self)
        let x: pxr.GfVec2d = pxr.GfVec2d(-3.12, 6)
        try assertEncodedJsonIsIdentical(x, #"[-3.12,6]"#)
        
        let y: pxr.GfVec2d = pxr.GfVec2d(0.0, .nan)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan"]"#)
        
        assertDecodingFails(pxr.GfVec2d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec2d.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec2d.self, #"nan"#)
        assertDecodingFails(pxr.GfVec2d.self, #"[]"#)
        assertDecodingFails(pxr.GfVec2d.self, #"{}"#)
        assertDecodingFails(pxr.GfVec2d.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec2d.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec2d.self, #"[4, ]"#)
    }
    func test_GfVec2f() throws {
        assertConforms(pxr.GfVec2f.self)
        let x: pxr.GfVec2f = pxr.GfVec2f(-3.12, 6)
        try assertEncodedJsonIsIdentical(x, #"[-3.12,6]"#)
        
        let y: pxr.GfVec2f = pxr.GfVec2f(0.0, .nan)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan"]"#)
        
        assertDecodingFails(pxr.GfVec2f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec2f.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec2f.self, #"nan"#)
        assertDecodingFails(pxr.GfVec2f.self, #"[]"#)
        assertDecodingFails(pxr.GfVec2f.self, #"{}"#)
        assertDecodingFails(pxr.GfVec2f.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec2f.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec2f.self, #"[4, ]"#)
    }
    func test_GfVec2h() throws {
        assertConforms(pxr.GfVec2h.self)
        let x: pxr.GfVec2h = pxr.GfVec2h(-3.125, 6)
        try assertEncodedJsonIsIdentical(x, #"[-3.125,6]"#)
        
        let y: pxr.GfVec2h = pxr.GfVec2h(0.0, .qNan())
        try assertEncodedJsonIsIdentical(y, #"[0,"nan"]"#)
        
        assertDecodingFails(pxr.GfVec2h.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec2h.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec2h.self, #"nan"#)
        assertDecodingFails(pxr.GfVec2h.self, #"[]"#)
        assertDecodingFails(pxr.GfVec2h.self, #"{}"#)
        assertDecodingFails(pxr.GfVec2h.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec2h.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec2h.self, #"[4, ]"#)
    }
    func test_GfVec2i() throws {
        assertConforms(pxr.GfVec2i.self)
        let x: pxr.GfVec2i = pxr.GfVec2i(-3, 6)
        try assertEncodedJsonIsIdentical(x, #"[-3,6]"#)
        
        let y: pxr.GfVec2i = pxr.GfVec2i(0, 0)
        try assertEncodedJsonIsIdentical(y, #"[0,0]"#)
        
        assertDecodingFails(pxr.GfVec2i.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec2i.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec2i.self, #"nan"#)
        assertDecodingFails(pxr.GfVec2i.self, #"[]"#)
        assertDecodingFails(pxr.GfVec2i.self, #"{}"#)
        assertDecodingFails(pxr.GfVec2i.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec2i.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec2i.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfVec2i.self, #"[-3.5,6]"#)
    }
    func test_GfVec3d() throws {
        assertConforms(pxr.GfVec3d.self)
        let x: pxr.GfVec3d = pxr.GfVec3d(-3.12, 6, 7.5)
        try assertEncodedJsonIsIdentical(x, #"[-3.12,6,7.5]"#)
        
        let y: pxr.GfVec3d = pxr.GfVec3d(0.0, .nan, 0.0)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan",0]"#)
        
        assertDecodingFails(pxr.GfVec3d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec3d.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec3d.self, #"nan"#)
        assertDecodingFails(pxr.GfVec3d.self, #"[]"#)
        assertDecodingFails(pxr.GfVec3d.self, #"{}"#)
        assertDecodingFails(pxr.GfVec3d.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec3d.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec3d.self, #"[4, ]"#)
    }
    func test_GfVec3f() throws {
        assertConforms(pxr.GfVec3f.self)
        let x: pxr.GfVec3f = pxr.GfVec3f(-3.12, 6, 7.5)
        try assertEncodedJsonIsIdentical(x, #"[-3.12,6,7.5]"#)
        
        let y: pxr.GfVec3f = pxr.GfVec3f(0.0, .nan, 0.0)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan",0]"#)
        
        assertDecodingFails(pxr.GfVec3f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec3f.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec3f.self, #"nan"#)
        assertDecodingFails(pxr.GfVec3f.self, #"[]"#)
        assertDecodingFails(pxr.GfVec3f.self, #"{}"#)
        assertDecodingFails(pxr.GfVec3f.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec3f.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec3f.self, #"[4, ]"#)
    }
    func test_GfVec3h() throws {
        assertConforms(pxr.GfVec3h.self)
        let x: pxr.GfVec3h = pxr.GfVec3h(-3.125, 6, 7.5)
        try assertEncodedJsonIsIdentical(x, #"[-3.125,6,7.5]"#)
        
        let y: pxr.GfVec3h = pxr.GfVec3h(0.0, .qNan(), 0.0)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan",0]"#)
        
        assertDecodingFails(pxr.GfVec3h.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec3h.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec3h.self, #"nan"#)
        assertDecodingFails(pxr.GfVec3h.self, #"[]"#)
        assertDecodingFails(pxr.GfVec3h.self, #"{}"#)
        assertDecodingFails(pxr.GfVec3h.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec3h.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec3h.self, #"[4, ]"#)
    }
    func test_GfVec3i() throws {
        assertConforms(pxr.GfVec3i.self)
        let x: pxr.GfVec3i = pxr.GfVec3i(-3, 6, 7)
        try assertEncodedJsonIsIdentical(x, #"[-3,6,7]"#)
        
        let y: pxr.GfVec3i = pxr.GfVec3i(0, 0, 0)
        try assertEncodedJsonIsIdentical(y, #"[0,0,0]"#)
        
        assertDecodingFails(pxr.GfVec3i.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec3i.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec3i.self, #"nan"#)
        assertDecodingFails(pxr.GfVec3i.self, #"[]"#)
        assertDecodingFails(pxr.GfVec3i.self, #"{}"#)
        assertDecodingFails(pxr.GfVec3i.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec3i.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec3i.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfVec3i.self, #"[-3.5,6,0]"#)
    }
    func test_GfVec4d() throws {
        assertConforms(pxr.GfVec4d.self)
        let x: pxr.GfVec4d = pxr.GfVec4d(-3.12, 6, 7.5, -1)
        try assertEncodedJsonIsIdentical(x, #"[-3.12,6,7.5,-1]"#)
        
        let y: pxr.GfVec4d = pxr.GfVec4d(0.0, .nan, 0.0, 1)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan",0,1]"#)
        
        assertDecodingFails(pxr.GfVec4d.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec4d.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec4d.self, #"nan"#)
        assertDecodingFails(pxr.GfVec4d.self, #"[]"#)
        assertDecodingFails(pxr.GfVec4d.self, #"{}"#)
        assertDecodingFails(pxr.GfVec4d.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec4d.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec4d.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec4d.self, #"[4, ]"#)
    }
    func test_GfVec4f() throws {
        assertConforms(pxr.GfVec4f.self)
        let x: pxr.GfVec4f = pxr.GfVec4f(-3.12, 6, 7.5, -1)
        try assertEncodedJsonIsIdentical(x, #"[-3.12,6,7.5,-1]"#)
        
        let y: pxr.GfVec4f = pxr.GfVec4f(0.0, .nan, 0.0, 1)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan",0,1]"#)
        
        assertDecodingFails(pxr.GfVec4f.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec4f.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec4f.self, #"nan"#)
        assertDecodingFails(pxr.GfVec4f.self, #"[]"#)
        assertDecodingFails(pxr.GfVec4f.self, #"{}"#)
        assertDecodingFails(pxr.GfVec4f.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec4f.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec4f.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec4f.self, #"[4, ]"#)
    }
    func test_GfVec4h() throws {
        assertConforms(pxr.GfVec4h.self)
        let x: pxr.GfVec4h = pxr.GfVec4h(-3.125, 6, 7.5, -1)
        try assertEncodedJsonIsIdentical(x, #"[-3.125,6,7.5,-1]"#)
        
        let y: pxr.GfVec4h = pxr.GfVec4h(0.0, .qNan(), 0.0, 1)
        try assertEncodedJsonIsIdentical(y, #"[0,"nan",0,1]"#)
        
        assertDecodingFails(pxr.GfVec4h.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec4h.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec4h.self, #"nan"#)
        assertDecodingFails(pxr.GfVec4h.self, #"[]"#)
        assertDecodingFails(pxr.GfVec4h.self, #"{}"#)
        assertDecodingFails(pxr.GfVec4h.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec4h.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec4h.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec4h.self, #"[4, ]"#)
    }
    func test_GfVec4i() throws {
        assertConforms(pxr.GfVec4i.self)
        let x: pxr.GfVec4i = pxr.GfVec4i(-3, 6, 7, -1)
        try assertEncodedJsonIsIdentical(x, #"[-3,6,7,-1]"#)
        
        let y: pxr.GfVec4i = pxr.GfVec4i(0, 0, 0, 1)
        try assertEncodedJsonIsIdentical(y, #"[0,0,0,1]"#)
        
        assertDecodingFails(pxr.GfVec4i.self, #"string without quotes"#)
        assertDecodingFails(pxr.GfVec4i.self, #"3.5"#)
        assertDecodingFails(pxr.GfVec4i.self, #"nan"#)
        assertDecodingFails(pxr.GfVec4i.self, #"[]"#)
        assertDecodingFails(pxr.GfVec4i.self, #"{}"#)
        assertDecodingFails(pxr.GfVec4i.self, #"[1, 2]"#)
        assertDecodingFails(pxr.GfVec4i.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.GfVec4i.self, #"[4]"#)
        assertDecodingFails(pxr.GfVec4i.self, #"[4, ]"#)
        assertDecodingFails(pxr.GfVec4i.self, #"[-3.5,6,0,0]"#)
    }
    
    // MARK: Vt
    
    func test_VtArray_Protocol() throws {
        assertConforms(pxr.VtBoolArray.self)
        assertConforms(Overlay.SdfAssetPath_VtArray.self)
        assertConforms(pxr.VtVec3fArray.self)
        assertConforms(pxr.VtStringArray.self)
        assertConforms(pxr.VtFloatArray.self)
        assertConforms(pxr.VtTokenArray.self)
        assertConforms(pxr.VtMatrix2fArray.self)
        
        let a: pxr.VtBoolArray = [true, false, false]
        try assertEncodedJsonIsIdentical(a, #"[true,false,false]"#)
        let b: pxr.VtBoolArray = []
        try assertEncodedJsonIsIdentical(b, #"[]"#)
        let c: Overlay.SdfAssetPath_VtArray = ["/foo", "/bar"]
        try assertEncodedJsonIsEquivalent(c,
            """
            [{"authoredPath": "/foo", "evaluatedPath": "", "resolvedPath": ""},
             {"authoredPath": "/bar", "evaluatedPath": "", "resolvedPath": ""}]
            """
        )
        let d: pxr.VtVec3fArray = [.init(-5.6, 0.0, 4)]
        try assertEncodedJsonIsIdentical(d, #"[[-5.6,0,4]]"#)
        let e: pxr.VtStringArray = ["hello", "there"]
        try assertEncodedJsonIsIdentical(e, #"["hello","there"]"#)
        let f: pxr.VtFloatArray = [3.1415, 2.718]
        try assertEncodedJsonIsIdentical(f, #"[3.1415,2.718]"#)
        let g: pxr.VtTokenArray = [.UsdGeomTokens.Cube, .UsdGeomTokens.Sphere, .UsdGeomTokens.Mesh]
        try assertEncodedJsonIsIdentical(g, #"["Cube","Sphere","Mesh"]"#)
        let h: pxr.VtMatrix2fArray = [.init(1, 2, 3, 4), .init(5, 6, 7, 8)]
        try assertEncodedJsonIsIdentical(h, #"[[[1,2],[3,4]],[[5,6],[7,8]]]"#)
        
        assertDecodingFails(pxr.VtQuatfArray.self, #"string without quotes"#)
        assertDecodingSucceeds(pxr.VtUIntArray.self, #"[]"#)
        assertDecodingFails(pxr.VtRect2iArray.self, #"{}"#)
        assertDecodingFails(pxr.VtIntArray.self, #"[1.5, 2, 3]"#)
        assertDecodingFails(pxr.VtUCharArray.self, #"[-4]"#)
        assertDecodingFails(pxr.VtShortArray.self, #"[4, ""]"#)

    }
    
    // MARK: Ar
    
    func test_ArResolvedPath() throws {
        assertConforms(pxr.ArResolvedPath.self)
        let x: pxr.ArResolvedPath = pxr.ArResolvedPath("/foo/bar")
        try assertEncodedJsonIsIdentical(x, #""/foo/bar""#)
        
        assertDecodingFails(pxr.ArResolvedPath.self, #"string without quotes"#)
        assertDecodingFails(pxr.ArResolvedPath.self, #"[]"#)
        assertDecodingFails(pxr.ArResolvedPath.self, #"{}"#)
        assertDecodingFails(pxr.ArResolvedPath.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.ArResolvedPath.self, #"[4]"#)
        assertDecodingFails(pxr.ArResolvedPath.self, #"[4, ]"#)
    }
    func test_ArTimestamp() throws {
        assertConforms(pxr.ArTimestamp.self)
        let x: pxr.ArTimestamp = pxr.ArTimestamp(5.6)
        try assertEncodedJsonIsIdentical(x, #"5.6"#)
        
        assertDecodingFails(pxr.ArTimestamp.self, #"string without quotes"#)
        assertDecodingFails(pxr.ArTimestamp.self, #"[]"#)
        assertDecodingFails(pxr.ArTimestamp.self, #"{}"#)
        assertDecodingFails(pxr.ArTimestamp.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.ArTimestamp.self, #"[4]"#)
        assertDecodingFails(pxr.ArTimestamp.self, #"[4, ]"#)
    }
    
    // MARK: Sdf
    
    func test_SdfAssetPath() throws {
        assertConforms(pxr.SdfAssetPath.self)
        let x: pxr.SdfAssetPath = pxr.SdfAssetPath("/foo")
        try assertEncodedJsonIsEquivalent(x, #"{"authoredPath":"/foo","evaluatedPath":"","resolvedPath":""}"#)
        
        let y: pxr.SdfAssetPath = pxr.SdfAssetPath(.init()
            .Authored("auth")
            .Evaluated("eval")
            .Resolved("res"))
        try assertEncodedJsonIsIdentical(y, #"{"authoredPath":"auth","evaluatedPath":"eval","resolvedPath":"res"}"#)
                
        assertDecodingFails(pxr.SdfAssetPath.self, #""/slash/string/within/quotes""#)
        assertDecodingFails(pxr.SdfAssetPath.self, #""string within quotes""#)
        assertDecodingFails(pxr.SdfAssetPath.self, #"string without quotes"#)
        assertDecodingFails(pxr.SdfAssetPath.self, #"[]"#)
        assertDecodingFails(pxr.SdfAssetPath.self, #"{}"#)
        assertDecodingFails(pxr.SdfAssetPath.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.SdfAssetPath.self, #"[4]"#)
        assertDecodingFails(pxr.SdfAssetPath.self, #"[4, ]"#)
    }
    
    func test_SdfPath() throws {
        assertConforms(pxr.SdfPath.self)
        let x: pxr.SdfPath = "/foo"
        try assertEncodedJsonIsIdentical(x, #""/foo""#)
        
        // These are invalid SdfPaths, but decoding shouldn't currently
        // check for that and error out, because that's application level logic
        assertDecodingSucceeds(pxr.SdfPath.self, #""quoted string""#)
        try assertEncodedJsonIsIdentical(#""quoted string""# as pxr.SdfPath, #""""#)
        assertDecodingSucceeds(pxr.SdfPath.self, #""/slash quoted string""#)
        try assertEncodedJsonIsIdentical(#""/slash quoted string""# as pxr.SdfPath, #""""#)
        
        assertDecodingFails(pxr.SdfPath.self, #"string without quotes"#)
        assertDecodingFails(pxr.SdfPath.self, #"[]"#)
        assertDecodingFails(pxr.SdfPath.self, #"{}"#)
        assertDecodingFails(pxr.SdfPath.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.SdfPath.self, #"[4]"#)
        assertDecodingFails(pxr.SdfPath.self, #"[4, ]"#)
    }
    func test_SdfTimeCode() throws {
        assertConforms(pxr.SdfTimeCode.self)
        let x: pxr.SdfTimeCode = pxr.SdfTimeCode(5.6)
        try assertEncodedJsonIsIdentical(x, #"5.6"#)
        
        assertDecodingFails(pxr.SdfTimeCode.self, #"string without quotes"#)
        assertDecodingFails(pxr.SdfTimeCode.self, #"[]"#)
        assertDecodingFails(pxr.SdfTimeCode.self, #"{}"#)
        assertDecodingFails(pxr.SdfTimeCode.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.SdfTimeCode.self, #"[4]"#)
        assertDecodingFails(pxr.SdfTimeCode.self, #"[4, ]"#)
    }
    
    // MARK: Usd
    
    func test_UsdTimeCode() throws {
        assertConforms(pxr.UsdTimeCode.self)
        let x: pxr.UsdTimeCode = 5.6
        try assertEncodedJsonIsIdentical(x, #"5.6"#)
        
        let y = pxr.UsdTimeCode.Default()
        try assertEncodedJsonIsIdentical(y, #""nan""#)
        
        let z = pxr.UsdTimeCode.PreTime(-1.2)
        try assertEncodedJsonIsIdentical(z, #""pre-1.2""#)
        
        assertDecodingFails(pxr.UsdTimeCode.self, #"string without quotes"#)
        assertDecodingFails(pxr.UsdTimeCode.self, #"[]"#)
        assertDecodingFails(pxr.UsdTimeCode.self, #"{}"#)
        assertDecodingFails(pxr.UsdTimeCode.self, #"[1, 2, 3]"#)
        assertDecodingFails(pxr.UsdTimeCode.self, #"[4]"#)
        assertDecodingFails(pxr.UsdTimeCode.self, #"[4, ]"#)
    }
}
