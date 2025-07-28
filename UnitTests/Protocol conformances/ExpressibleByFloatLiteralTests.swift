//
//  ExpressibleByFloatLiteralTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 2/9/24.
//

import XCTest
import OpenUSD

final class ExpressibleByFloatLiteralTests: TemporaryDirectoryHelper {

    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any ExpressibleByFloatLiteral.Type)
    }

    func test_GfHalf() {
        let x: pxr.GfHalf = 4.0
        let y: pxr.GfHalf = 4
        let z: pxr.GfHalf = 5.6
        XCTAssertEqual(x, pxr.GfHalf(4.0))
        XCTAssertEqual(y, pxr.GfHalf(4.0))
        XCTAssertEqual(z, pxr.GfHalf(5.6))
        assertConforms(pxr.GfHalf.self)
    }
}
