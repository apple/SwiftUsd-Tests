//
//  TypeConversionTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/15/23.
//

import XCTest
import OpenUSD

final class TypeConversionTests: TemporaryDirectoryHelper {

    func test_Float_from_GfHalf() {
        let x: pxr.GfHalf = pxr.GfHalf(1.25)
        let y: Float = Float(x)
        XCTAssertEqual(y, 1.25)
    }
    
    func test_String_from_TfToken() {
        XCTAssertEqual(String(pxr.TfToken.UsdGeomTokens.Cube), "Cube")
    }
    
    func test_String_from_SdfPath() {
        XCTAssertEqual(String(pxr.SdfPath("/foo/bar.fizz")), "/foo/bar.fizz")
    }

    func test_stdstring_from_TfToken() {
        XCTAssertEqual(std.string(pxr.TfToken.UsdGeomTokens.Cube), "Cube")
    }
    
    func test_String_from_ArResolvedPath() {
        XCTAssertEqual(String(pxr.ArResolvedPath("/foo/bar")), "/foo/bar")
    }
    
    func test_stdstring_from_ArResolvedPath() {
        XCTAssertEqual(std.string(pxr.ArResolvedPath("/fizz/buzz")), "/fizz/buzz" as std.string)
    }
    
    func test_SdfAssetPath_from_String() {
        XCTAssertEqual(pxr.SdfAssetPath("/foo" as String), "/foo" as pxr.SdfAssetPath)
    }
}
