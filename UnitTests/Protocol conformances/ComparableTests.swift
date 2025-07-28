//
//  ComparableTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/26/24.
//

import XCTest
import OpenUSD

final class ComparableTests: TemporaryDirectoryHelper {

    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any Comparable.Type)
    }
    
    func test_SdfPath() {
        let a: pxr.SdfPath = "/foo/bar"
        let b: pxr.SdfPath = "/alpha"
        let c: pxr.SdfPath = "/foo/bar/baz"
        XCTAssertGreaterThan(a, b)
        XCTAssertLessThan(b, c)
        XCTAssertLessThan(a, c)
        assertConforms(pxr.SdfPath.self)
    }
    
    func test_SdfLayerHandle() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        
        let a: pxr.SdfLayerHandle = stage.GetRootLayer()
        let b: pxr.SdfLayerHandle = stage.GetSessionLayer()
        let c: pxr.SdfLayerHandle = stage.GetRootLayer()
        
        if a < b {
            XCTAssertLessThan(a, b)
            XCTAssertGreaterThan(b, c)
            XCTAssertEqual(a, c)
        } else if a > b {
            XCTAssertGreaterThan(a, b)
            XCTAssertLessThan(b, c)
            XCTAssertEqual(a, c)
        } else if a == b {
            // Should never be possible, because root layer and session layer should be different
            XCTAssertNotEqual(a, b)
        }
        assertConforms(pxr.SdfLayerHandle.self)
    }
}
