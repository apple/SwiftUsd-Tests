//
//  ExpressibleByIntegerLiteralTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 2/9/24.
//

import XCTest
import OpenUSD

final class ExpressibleByIntegerLiteralTests: TemporaryDirectoryHelper {

    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any ExpressibleByIntegerLiteral.Type)
    }

    func test_GfHalf() {
        let x: pxr.GfHalf = 4
        let y: pxr.GfHalf = 4
        let z: pxr.GfHalf = 5
        XCTAssertEqual(x, pxr.GfHalf(4))
        XCTAssertEqual(y, pxr.GfHalf(4))
        XCTAssertEqual(z, pxr.GfHalf(5))
        assertConforms(pxr.GfHalf.self)
    }

}
