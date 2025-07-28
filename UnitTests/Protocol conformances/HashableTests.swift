//
//  HashableTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/13/23.
//

import XCTest
import OpenUSD

final class HashableTests: TemporaryDirectoryHelper {

    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any Hashable.Type)
    }
        
    func test_GfHalf() {
        let a = pxr.GfHalf(2.718)
        let b = pxr.GfHalf(2.718)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfHalf.self)
    }
        
    func test_GfRange1d() {
        let a = pxr.GfRange1d(1.414, 1.618)
        let b = pxr.GfRange1d(1.414, 1.618)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfRange1d.self)
    }
    
    func test_GfRange2d() {
        let a = pxr.GfRange2d(pxr.GfVec2d(1.414, 1.618), pxr.GfVec2d(5.3, 6.5))
        let b = pxr.GfRange2d(pxr.GfVec2d(1.414, 1.618), pxr.GfVec2d(5.3, 6.5))
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfRange2d.self)
    }
    
    func test_GfRange3d() {
        let a = pxr.GfRange3d(pxr.GfVec3d(1.414, 1.618, 6.35), pxr.GfVec3d(5.3, 6.5, 8.09))
        let b = pxr.GfRange3d(pxr.GfVec3d(1.414, 1.618, 6.35), pxr.GfVec3d(5.3, 6.5, 8.09))
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfRange3d.self)
    }
    
    func test_GfRange1f() {
        let a = pxr.GfRange1f(1.414, 1.618)
        let b = pxr.GfRange1f(1.414, 1.618)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfRange1f.self)
    }
    
    func test_GfRange2f() {
        let a = pxr.GfRange2f(pxr.GfVec2f(1.414, 1.618), pxr.GfVec2f(5.3, 6.5))
        let b = pxr.GfRange2f(pxr.GfVec2f(1.414, 1.618), pxr.GfVec2f(5.3, 6.5))
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfRange2f.self)
    }
    
    func test_GfRange3f() {
        let a = pxr.GfRange3f(pxr.GfVec3f(1.414, 1.618, 6.35), pxr.GfVec3f(5.3, 6.5, 8.09))
        let b = pxr.GfRange3f(pxr.GfVec3f(1.414, 1.618, 6.35), pxr.GfVec3f(5.3, 6.5, 8.09))
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfRange3f.self)
    }
    
    func test_GfVec2d() {
        let a = pxr.GfVec2d(1.414, 1.618)
        let b = pxr.GfVec2d(1.414, 1.618)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec2d.self)
    }
    
    func test_GfVec2f() {
        let a = pxr.GfVec2f(1.414, 1.618)
        let b = pxr.GfVec2f(1.414, 1.618)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec2f.self)
    }
    
    func test_GfVec2h() {
        let a = pxr.GfVec2h(1.414, 1.618)
        let b = pxr.GfVec2h(1.414, 1.618)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec2h.self)
    }
    
    func test_GfVec2i() {
        let a = pxr.GfVec2i(1, 18)
        let b = pxr.GfVec2i(1, 18)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec2i.self)
    }
    
    func test_GfVec3d() {
        let a = pxr.GfVec3d(1.414, 1.618, -1)
        let b = pxr.GfVec3d(1.414, 1.618, -1)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec3d.self)
    }
    
    func test_GfVec3f() {
        let a = pxr.GfVec3f(1.414, 1.618, -1)
        let b = pxr.GfVec3f(1.414, 1.618, -1)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec3f.self)
    }
    
    func test_GfVec3h() {
        let a = pxr.GfVec3h(1.414, 1.618, -1)
        let b = pxr.GfVec3h(1.414, 1.618, -1)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec3h.self)
    }
    
    func test_GfVec4d() {
        let a = pxr.GfVec4d(1.414, 1.618, -1, 7)
        let b = pxr.GfVec4d(1.414, 1.618, -1, 7)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec4d.self)
    }
    
    func test_GfVec4f() {
        let a = pxr.GfVec4f(1.414, 1.618, -1, 7)
        let b = pxr.GfVec4f(1.414, 1.618, -1, 7)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec4f.self)
    }
    
    func test_GfVec4h() {
        let a = pxr.GfVec4h(1.414, 1.618, -1, 7)
        let b = pxr.GfVec4h(1.414, 1.618, -1, 7)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.GfVec4h.self)
    }
    
    func test_SdfAssetPath() {
        let a = pxr.SdfAssetPath("/foo/bar")
        let b = pxr.SdfAssetPath("/foo/bar")
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.SdfAssetPath.self)
    }
    
    func test_SdfPath() {
        let a: pxr.SdfPath = "/foo/bar"
        let b: pxr.SdfPath = "/foo/bar"
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.SdfPath.self)
    }
    
    func test_SdfTimeCode() {
        let a = pxr.SdfTimeCode(2.718)
        let b = pxr.SdfTimeCode(2.718)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.SdfTimeCode.self)
    }

    func test_TfToken() {
        let a = pxr.TfToken.UsdGeomTokens.Cube
        let b: pxr.TfToken = "Cube"
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.TfToken.self)
    }
    
    func test_UsdAttribute() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim1")
        
        let a = cube1.GetExtentAttr()
        let b = stage.GetAttributeAtPath("/myPrim1.extent")
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.UsdAttribute.self)
    }
    
    func test_UsdPrim() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim1")
        let cube2 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim2")
        
        let a = Overlay.GetPrim(cube1)
        let b = Overlay.GetPrim(cube2)
        let c = stage.GetPrimAtPath("/myPrim1")
        let d = stage.GetPrimAtPath("/myPrim2")
        
        XCTAssertEqual(a.hashValue, c.hashValue)
        XCTAssertEqual(b.hashValue, d.hashValue)
        assertConforms(pxr.UsdPrim.self)
        stage.DefinePrim("/myPrim3/fizz", "Cube")
    }
    
    func test_UsdTimeCode() {
        let a = pxr.UsdTimeCode(2.718)
        let b = pxr.UsdTimeCode(2.718)
        XCTAssertEqual(a.hashValue, b.hashValue)
        assertConforms(pxr.UsdTimeCode.self)
    }
}
