//
//  ExpressibleByDictionaryLiteralTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/26/24.
//

import XCTest
import OpenUSD

final class ExpressibleByDictionaryLiteralTests: TemporaryDirectoryHelper {

    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any ExpressibleByDictionaryLiteral.Type)
    }

    func test_VtDictionary() {
        let x: pxr.VtDictionary = ["foo" : pxr.VtValue(7.0)]
        XCTAssertEqual(x.description, "{'foo': 7}")
        assertConforms(pxr.VtDictionary.self)
    }
}
