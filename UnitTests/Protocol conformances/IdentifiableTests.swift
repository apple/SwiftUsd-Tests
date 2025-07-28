//
//  IdentifiableTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/13/23.
//

import XCTest
import OpenUSD

final class IdentifiableTests: TemporaryDirectoryHelper {
    
    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any Identifiable.Type)
    }
    func assertIDIsSelf<T: Identifiable>(_ t: T.Type) {
        XCTAssertTrue(T.ID.self is T.Type)
    }
    
    func test_SdfPath() {
        let p: pxr.SdfPath = "/hello/world"
        let id: pxr.SdfPath = p.id
        XCTAssertEqual(p, id)
        assertConforms(pxr.SdfPath.self)
        assertIDIsSelf(pxr.SdfPath.self)
    }
    
    func test_TfToken() {
        let t: pxr.TfToken = "Cube"
        let id: pxr.TfToken = t.id
        XCTAssertEqual(t, id)
        assertConforms(pxr.TfToken.self)
        assertIDIsSelf(pxr.TfToken.ID.self)
    }
    
    func test_UsdAttribute() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim1")
        let a: pxr.UsdAttribute = cube1.GetExtentAttr()
        let id: pxr.UsdAttribute = a.id
        XCTAssertEqual(a, id)
        assertConforms(pxr.UsdAttribute.self)
        assertIDIsSelf(pxr.UsdAttribute.ID.self)
    }
    
    func test_UsdPrim() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1: pxr.UsdPrim = stage.DefinePrim("/myPrim1", "Cube")
        let id: pxr.UsdPrim = cube1.id
        XCTAssertEqual(cube1, id)
        assertConforms(pxr.UsdPrim.self)
        assertIDIsSelf(pxr.UsdPrim.ID.self)
    }
}
