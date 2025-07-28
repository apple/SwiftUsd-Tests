//
//  ExpressibleByStringLiteralTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/13/23.
//

import XCTest
import OpenUSD

final class ExpressibleByStringLiteralTests: TemporaryDirectoryHelper {
    
    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any ExpressibleByStringLiteral.Type)
    }

    func test_SdfPath() {
        let x: pxr.SdfPath = "/foo/bar"
        XCTAssertEqual(x, pxr.SdfPath(std.string("/foo/bar")))
        assertConforms(pxr.SdfPath.self)
    }

    func test_TfToken() {
        let x: pxr.TfToken = "foobar"
        XCTAssertEqual(x, pxr.TfToken(std.string("foobar")))
        assertConforms(pxr.TfToken.self)
    }
    
    func test_SdfAssetPath() {
        let x: pxr.SdfAssetPath = "/foo/bar"
        XCTAssertEqual(x, pxr.SdfAssetPath(std.string("/foo/bar")))
        assertConforms(pxr.SdfAssetPath.self)
    }
}
