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


final class EquatableTests: TemporaryDirectoryHelper {
    
    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any Equatable.Type)
    }

    func test_GfHalf() {
        let a = pxr.GfHalf(2.718)
        let b = pxr.GfHalf(3.1415)
        let c = pxr.GfHalf(2.718)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfHalf.self)
    }
    
    func test_GfVec3d() {
        let a = pxr.GfVec3d(1.414, 1.618, -1)
        let b = pxr.GfVec3d(2, 3, 5)
        let c = pxr.GfVec3d(1.414, 1.618, -1)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec3d.self)
    }
    
    func test_GfVec3f() {
        let a = pxr.GfVec3f(1.414, 1.618, -1)
        let b = pxr.GfVec3f(2, 3, 5)
        let c = pxr.GfVec3f(1.414, 1.618, -1)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec3f.self)
    }
    
    func test_GfVec3h() {
        let a = pxr.GfVec3h(1.414, 1.618, -1)
        let b = pxr.GfVec3h(2, 3, 5)
        let c = pxr.GfVec3h(1.414, 1.618, -1)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec3h.self)
    }
    
    func test_GfVec4d() {
        let a = pxr.GfVec4d(1.414, 1.618, -1, 7)
        let b = pxr.GfVec4d(2, 3, 5, 7)
        let c = pxr.GfVec4d(1.414, 1.618, -1, 7)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec4d.self)
    }
    
    func test_GfVec4f() {
        let a = pxr.GfVec4f(1.414, 1.618, -1, 7)
        let b = pxr.GfVec4f(2, 3, 5, 7)
        let c = pxr.GfVec4f(1.414, 1.618, -1, 7)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec4f.self)
    }
    
    func test_GfVec4h() {
        let a = pxr.GfVec4h(1.414, 1.618, -1, 7)
        let b = pxr.GfVec4h(2, 3, 5, 7)
        let c = pxr.GfVec4h(1.414, 1.618, -1, 7)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec4h.self)
    }
    
    func test_SdfAssetPath() {
        let a = pxr.SdfAssetPath("/foo/bar")
        let b = pxr.SdfAssetPath("/foo/bar/fizz/buzz")
        let c = pxr.SdfAssetPath("/foo/bar")
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfAssetPath.self)
    }
    
    func test_SdfPath() {
        let a: pxr.SdfPath = "/foo/bar"
        let b: pxr.SdfPath = "/foo/bar/fizz/buzz"
        let c: pxr.SdfPath = "/foo/bar"
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfPath.self)
    }
    
    func test_TfRefPtr_UsdStage() {
        let a = pxr.UsdStage.CreateInMemory(.LoadAll)
        let b = pxr.UsdStage.CreateInMemory(.LoadAll)
        let c = a
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.UsdStageRefPtr.self)
    }
    
    func test_TfRefPtr_SdfLayer() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let a = Overlay.TfRefPtr(stage1.GetRootLayer())
        let b = Overlay.TfRefPtr(stage2.GetRootLayer())
        let c = Overlay.TfRefPtr(stage1.GetRootLayer())
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfLayerRefPtr.self)
    }
    
    func test_TfWeakPtr_UsdStage() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let a = Overlay.TfWeakPtr(stage1)
        let b = Overlay.TfWeakPtr(stage2)
        let c = Overlay.TfWeakPtr(stage1)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.UsdStagePtr.self)
    }
    
    func test_TfWeakPtr_SdfLayer() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let a = stage1.GetRootLayer()
        let b = stage2.GetRootLayer()
        let c = stage1.GetRootLayer()
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfLayerHandle.self)
    }
    
    func test_SdfTimeCode() {
        let a = pxr.SdfTimeCode(2.718)
        let b = pxr.SdfTimeCode(3.1415)
        let c = pxr.SdfTimeCode(2.718)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfTimeCode.self)
    }
    
    func test_TfToken() {
        let a = pxr.TfToken.UsdGeomTokens.Cube
        let b: pxr.TfToken = "Sphere"
        let c: pxr.TfToken = "Cube"
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.TfToken.self)
    }
    
    func test_UsdAttribute() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim1")
        let cube2 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim2")
        
        let a = cube1.GetExtentAttr()
        let b = cube2.GetExtentAttr()
        let c = stage.GetAttributeAtPath("/myPrim1.extent")
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        
        let d = cube1.GetSizeAttr()
        XCTAssertNotEqual(a, d)
        XCTAssertNotEqual(b, d)
        XCTAssertNotEqual(c, d)
        assertConforms(pxr.UsdAttribute.self)
    }
    
    func test_UsdPrim() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube1 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim1")
        let cube2 = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myPrim2")
        
        let a = Overlay.GetPrim(cube1)
        let b = Overlay.GetPrim(cube2)
        let c = stage.GetPrimAtPath("/myPrim1")
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        
        let d = stage.GetPrimAtPath("/myPrim2")
        XCTAssertNotEqual(a, d)
        XCTAssertEqual(b, d)
        XCTAssertNotEqual(c, d)
        assertConforms(pxr.UsdPrim.self)
    }
    
    // UsdTimeCode
    func test_UsdTimeCode() {
        let a = pxr.UsdTimeCode(2.718)
        let b = pxr.UsdTimeCode(3.1415)
        let c = pxr.UsdTimeCode(2.718)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        
        let d = pxr.UsdTimeCode.EarliestTime()
        let e = pxr.UsdTimeCode.Default()
        let f = pxr.UsdTimeCode.EarliestTime()
        let g = pxr.UsdTimeCode.Default()
        
        XCTAssertNotEqual(a, d)
        XCTAssertNotEqual(a, e)
        XCTAssertNotEqual(a, f)
        XCTAssertNotEqual(a, g)
        XCTAssertNotEqual(b, d)
        XCTAssertNotEqual(b, e)
        XCTAssertNotEqual(b, f)
        XCTAssertNotEqual(b, g)
        XCTAssertNotEqual(c, d)
        XCTAssertNotEqual(c, e)
        XCTAssertNotEqual(c, f)
        XCTAssertNotEqual(c, g)
        
        XCTAssertNotEqual(d, e)
        XCTAssertEqual(d, f)
        XCTAssertNotEqual(d, g)
        XCTAssertNotEqual(e, f)
        XCTAssertEqual(e, g)
        XCTAssertNotEqual(f, g)
        assertConforms(pxr.UsdTimeCode.self)
    }

    // MARK: std.vector specializations
    
    func test_StringVector() {
        var a = Overlay.String_Vector()
        a.push_back("hi")
        var b = Overlay.String_Vector()
        b.push_back("there")
        var c = Overlay.String_Vector()
        c.push_back("hi")
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(Overlay.String_Vector.self)
    }
    
    func test_UsdAttributeVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a_attr = p.GetAttribute("radius")
        let b_attr = p.CreateAttribute("myAttr", .Float, true, .SdfVariabilityVarying)
        let c_attr = main.GetAttributeAtPath("/foo.radius")
        
        var a = Overlay.UsdAttribute_Vector()
        a.push_back(a_attr)
        var b = Overlay.UsdAttribute_Vector()
        b.push_back(b_attr)
        var c = Overlay.UsdAttribute_Vector()
        c.push_back(c_attr)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(Overlay.UsdAttribute_Vector.self)
    }
    
    func test_UsdRelationshipVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a_rel = p.CreateRelationship("firstRel", true)
        let b_rel = p.CreateRelationship("secondRel", true)
        let c_rel = main.GetRelationshipAtPath("/foo.firstRel")
        
        var a = Overlay.UsdRelationship_Vector()
        a.push_back(a_rel)
        var b = Overlay.UsdRelationship_Vector()
        b.push_back(b_rel)
        var c = Overlay.UsdRelationship_Vector()
        c.push_back(c_rel)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(Overlay.UsdRelationship_Vector.self)
    }
    
    func test_TfTokenVector() {
        var a = pxr.TfTokenVector()
        a.push_back("hi")
        var b = pxr.TfTokenVector()
        b.push_back("there")
        var c = pxr.TfTokenVector()
        c.push_back("hi")

        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.TfTokenVector.self)
    }
    
    func test_Double_Vector() {
        var a = Overlay.Double_Vector()
        a.push_back(1.2)
        var b = Overlay.Double_Vector()
        b.push_back(3.4)
        var c = Overlay.Double_Vector()
        c.push_back(1.2)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(Overlay.Double_Vector.self)
    }
    
    func test_SdfPathVector() {
        var a = pxr.SdfPathVector()
        a.push_back("/hi")
        var b = pxr.SdfPathVector()
        b.push_back("/there")
        var c = pxr.SdfPathVector()
        c.push_back("/hi")

        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfPathVector.self)
    }
    
    func test_SdfLayerOffsetVector() {
        var a = pxr.SdfLayerOffsetVector()
        a.push_back(.init(0, 1))
        var b = pxr.SdfLayerOffsetVector()
        b.push_back(.init(1, 2))
        var c = pxr.SdfLayerOffsetVector()
        c.push_back(.init(0, 1))

        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfLayerOffsetVector.self)
    }
    
    func test_SdfPropertySpecHandleVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.GetAttribute("radius").Set(5.0, 2.0)
        p.CreateAttribute("myAttr", .Float, true, .SdfVariabilityVarying)
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        var a = pxr.SdfPropertySpecHandleVector()
        a.push_back(layer.GetPropertyAtPath("/foo.radius"))
        var b = pxr.SdfPropertySpecHandleVector()
        b.push_back(layer.GetPropertyAtPath("/foo.myAttr"))
        var c = pxr.SdfPropertySpecHandleVector()
        c.push_back(layer.GetPropertyAtPath("/foo.radius"))
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfPropertySpecHandleVector.self)
    }
    
    func test_SdfPrimSpecHandleVector() throws {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        let layer = Overlay.Dereference(main.GetRootLayer())

        var a = pxr.SdfPrimSpecHandleVector()
        a.push_back(layer.GetPrimAtPath("/foo"))
        var b = pxr.SdfPrimSpecHandleVector()
        b.push_back(layer.GetPrimAtPath("/bar"))
        var c = pxr.SdfPrimSpecHandleVector()
        c.push_back(layer.GetPrimAtPath("/foo"))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfPrimSpecHandleVector.self)
    }
    
    func test_UsdGeomXformOpVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        let p = pxr.UsdGeomXformable.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let op1 = p.AddTranslateOp(.PrecisionDouble, "op1", false)
        let op2 = p.AddTranslateOp(.PrecisionDouble, "op2", false)
        
        var a = Overlay.UsdGeomXformOp_Vector()
        a.push_back(op1)
        a.push_back(op2)
        var b = Overlay.UsdGeomXformOp_Vector()
        b.push_back(op2)
        b.push_back(op1)
        var c = Overlay.UsdGeomXformOp_Vector()
        c.push_back(p.GetTranslateOp("op1", false))
        c.push_back(p.GetTranslateOp("op2", false))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(Overlay.UsdGeomXformOp_Vector.self)
    }
    
    func test_GfVec4f_Vector() {
        let a: Overlay.GfVec4f_Vector = [pxr.GfVec4f(1, 2, 3, 4)]
        let b: Overlay.GfVec4f_Vector = [pxr.GfVec4f(5, 6, 7, 8)]
        let c: Overlay.GfVec4f_Vector = [pxr.GfVec4f(1, 2, 3, 4)]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(Overlay.GfVec4f_Vector.self)
    }
    
    // MARK: VtArray specializations
    
    func test_VtBoolArray() {
        let a: pxr.VtBoolArray = [true, false]
        let b: pxr.VtBoolArray = [false, false]
        let c: pxr.VtBoolArray = [true, false]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtBoolArray.self)
    }
    
    func test_VtDoubleArray() {
        let a: pxr.VtDoubleArray = [1, 2]
        let b: pxr.VtDoubleArray = [4, 3]
        let c: pxr.VtDoubleArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtDoubleArray.self)
    }
    
    func test_VtFloatArray() {
        let a: pxr.VtFloatArray = [1, 2]
        let b: pxr.VtFloatArray = [4, 3]
        let c: pxr.VtFloatArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtFloatArray.self)
    }
    
    func test_VtHalfArray() {
        let a: pxr.VtHalfArray = [1.0, 2.5]
        let b: pxr.VtHalfArray = [4.0, 3.5]
        let c: pxr.VtHalfArray = [1.0, 2.5]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtHalfArray.self)
    }
    
    func test_VtCharArray() {
        let a: pxr.VtCharArray = [1, 2]
        let b: pxr.VtCharArray = [4, 3]
        let c: pxr.VtCharArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtCharArray.self)
    }
    
    func test_VtUCharArray() {
        let a: pxr.VtUCharArray = [1, 2]
        let b: pxr.VtUCharArray = [4, 3]
        let c: pxr.VtUCharArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtUCharArray.self)
    }
    
    func test_VtShortArray() {
        let a: pxr.VtShortArray = [1, 2]
        let b: pxr.VtShortArray = [4, 3]
        let c: pxr.VtShortArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtShortArray.self)
    }
    
    func test_VtUShortArray() {
        let a: pxr.VtUShortArray = [1, 2]
        let b: pxr.VtUShortArray = [4, 3]
        let c: pxr.VtUShortArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtUShortArray.self)
    }
    
    func test_VtIntArray() {
        let a: pxr.VtIntArray = [1, 2]
        let b: pxr.VtIntArray = [4, 3]
        let c: pxr.VtIntArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtIntArray.self)
    }
    
    func test_VtUIntArray() {
        let a: pxr.VtUIntArray = [1, 2]
        let b: pxr.VtUIntArray = [4, 3]
        let c: pxr.VtUIntArray = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtUIntArray.self)
    }
    
    func test_VtInt64Array() {
        let a: pxr.VtInt64Array = [1, 2]
        let b: pxr.VtInt64Array = [4, 3]
        let c: pxr.VtInt64Array = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtInt64Array.self)
    }
    
    func test_VtUInt64Array() {
        let a: pxr.VtUInt64Array = [1, 2]
        let b: pxr.VtUInt64Array = [4, 3]
        let c: pxr.VtUInt64Array = [1, 2]
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtUInt64Array.self)
    }
    
    func test_VtVec4iArray() {
        let a: pxr.VtVec4iArray = [pxr.GfVec4i(1, 2, 3, 4)]
        let b: pxr.VtVec4iArray = []
        let c: pxr.VtVec4iArray = [pxr.GfVec4i(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec4iArray.self)
    }
    
    func test_VtVec3iArray() {
        let a: pxr.VtVec3iArray = [pxr.GfVec3i(1, 2, 3)]
        let b: pxr.VtVec3iArray = []
        let c: pxr.VtVec3iArray = [pxr.GfVec3i(1, 2, 3)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec3iArray.self)
    }
    
    func test_VtVec2iArray() {
        let a: pxr.VtVec2iArray = [pxr.GfVec2i(1, 2)]
        let b: pxr.VtVec2iArray = []
        let c: pxr.VtVec2iArray = [pxr.GfVec2i(1, 2)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec2iArray.self)
    }
    
    func test_VtVec4hArray() {
        let a: pxr.VtVec4hArray = [pxr.GfVec4h(1, 2, 3, 4)]
        let b: pxr.VtVec4hArray = []
        let c: pxr.VtVec4hArray = [pxr.GfVec4h(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec4hArray.self)
    }
    
    func test_VtVec3hArray() {
        let a: pxr.VtVec3hArray = [pxr.GfVec3h(1, 2, 3)]
        let b: pxr.VtVec3hArray = []
        let c: pxr.VtVec3hArray = [pxr.GfVec3h(1, 2, 3)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec3hArray.self)
    }
    
    func test_VtVec2hArray() {
        let a: pxr.VtVec2hArray = [pxr.GfVec2h(1, 2)]
        let b: pxr.VtVec2hArray = []
        let c: pxr.VtVec2hArray = [pxr.GfVec2h(1, 2)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec2hArray.self)
    }
    
    func test_VtVec4fArray() {
        let a: pxr.VtVec4fArray = [pxr.GfVec4f(1, 2, 3, 4)]
        let b: pxr.VtVec4fArray = []
        let c: pxr.VtVec4fArray = [pxr.GfVec4f(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec4fArray.self)
    }
    
    func test_VtVec3fArray() {
        let a: pxr.VtVec3fArray = [pxr.GfVec3f(1, 2, 3)]
        let b: pxr.VtVec3fArray = []
        let c: pxr.VtVec3fArray = [pxr.GfVec3f(1, 2, 3)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec3fArray.self)
    }
    
    func test_VtVec2fArray() {
        let a: pxr.VtVec2fArray = [pxr.GfVec2f(1, 2)]
        let b: pxr.VtVec2fArray = []
        let c: pxr.VtVec2fArray = [pxr.GfVec2f(1, 2)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec2fArray.self)
    }
    
    func test_VtVec4dArray() {
        let a: pxr.VtVec4dArray = [pxr.GfVec4d(1, 2, 3, 4)]
        let b: pxr.VtVec4dArray = []
        let c: pxr.VtVec4dArray = [pxr.GfVec4d(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec4dArray.self)
    }
    
    func test_VtVec3dArray() {
        let a: pxr.VtVec3dArray = [pxr.GfVec3d(1, 2, 3)]
        let b: pxr.VtVec3dArray = []
        let c: pxr.VtVec3dArray = [pxr.GfVec3d(1, 2, 3)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec3dArray.self)
    }
    
    func test_VtVec2dArray() {
        let a: pxr.VtVec2dArray = [pxr.GfVec2d(1, 2)]
        let b: pxr.VtVec2dArray = []
        let c: pxr.VtVec2dArray = [pxr.GfVec2d(1, 2)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtVec2dArray.self)
    }
    
    func test_VtMatrix4fArray() {
        let a: pxr.VtMatrix4fArray = [pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        let b: pxr.VtMatrix4fArray = []
        let c: pxr.VtMatrix4fArray = [pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtMatrix4fArray.self)
    }
    
    func test_VtMatrix3fArray() {
        let a: pxr.VtMatrix3fArray = [pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        let b: pxr.VtMatrix3fArray = []
        let c: pxr.VtMatrix3fArray = [pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtMatrix3fArray.self)
    }
    
    func test_VtMatrix2fArray() {
        let a: pxr.VtMatrix2fArray = [pxr.GfMatrix2f(1, 2, 3, 4)]
        let b: pxr.VtMatrix2fArray = []
        let c: pxr.VtMatrix2fArray = [pxr.GfMatrix2f(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtMatrix2fArray.self)
    }
    
    func test_VtMatrix4dArray() {
        let a: pxr.VtMatrix4dArray = [pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        let b: pxr.VtMatrix4dArray = []
        let c: pxr.VtMatrix4dArray = [pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtMatrix4dArray.self)
    }
    
    func test_VtMatrix3dArray() {
        let a: pxr.VtMatrix3dArray = [pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        let b: pxr.VtMatrix3dArray = []
        let c: pxr.VtMatrix3dArray = [pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtMatrix3dArray.self)
    }
    
    func test_VtMatrix2dArray() {
        let a: pxr.VtMatrix2dArray = [pxr.GfMatrix2d(1, 2, 3, 4)]
        let b: pxr.VtMatrix2dArray = []
        let c: pxr.VtMatrix2dArray = [pxr.GfMatrix2d(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtMatrix2dArray.self)
    }
    
    func test_VtRange3fArray() {
        let a: pxr.VtRange3fArray = [pxr.GfRange3f(pxr.GfVec3f(1, 2, 3), pxr.GfVec3f(4, 5, 6))]
        let b: pxr.VtRange3fArray = []
        let c: pxr.VtRange3fArray = [pxr.GfRange3f(pxr.GfVec3f(1, 2, 3), pxr.GfVec3f(4, 5, 6))]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtRange3fArray.self)
    }
    
    func test_VtRange3dArray() {
        let a: pxr.VtRange3dArray = [pxr.GfRange3d(pxr.GfVec3d(1, 2, 3), pxr.GfVec3d(4, 5, 6))]
        let b: pxr.VtRange3dArray = []
        let c: pxr.VtRange3dArray = [pxr.GfRange3d(pxr.GfVec3d(1, 2, 3), pxr.GfVec3d(4, 5, 6))]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtRange3dArray.self)
    }
    
    func test_VtRange2fArray() {
        let a: pxr.VtRange2fArray = [pxr.GfRange2f(pxr.GfVec2f(1, 2), pxr.GfVec2f(4, 5))]
        let b: pxr.VtRange2fArray = []
        let c: pxr.VtRange2fArray = [pxr.GfRange2f(pxr.GfVec2f(1, 2), pxr.GfVec2f(4, 5))]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtRange2fArray.self)
    }
    
    func test_VtRange2dArray() {
        let a: pxr.VtRange2dArray = [pxr.GfRange2d(pxr.GfVec2d(1, 2), pxr.GfVec2d(4, 5))]
        let b: pxr.VtRange2dArray = []
        let c: pxr.VtRange2dArray = [pxr.GfRange2d(pxr.GfVec2d(1, 2), pxr.GfVec2d(4, 5))]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtRange2dArray.self)
    }
    
    func test_VtRange1fArray() {
        let a: pxr.VtRange1fArray = [pxr.GfRange1f(1, 2)]
        let b: pxr.VtRange1fArray = []
        let c: pxr.VtRange1fArray = [pxr.GfRange1f(1, 2)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtRange1fArray.self)
    }
    
    func test_VtRange1dArray() {
        let a: pxr.VtRange1dArray = [pxr.GfRange1d(1, 2)]
        let b: pxr.VtRange1dArray = []
        let c: pxr.VtRange1dArray = [pxr.GfRange1d(1, 2)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtRange1dArray.self)
    }
    
    func test_VtIntervalArray() {
        let a: pxr.VtIntervalArray = [pxr.GfInterval(0, 1, true, true)]
        let b: pxr.VtIntervalArray = []
        let c: pxr.VtIntervalArray = [pxr.GfInterval(0, 1, true, true)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtIntervalArray.self)
    }
    
    func test_VtRect2iArray() {
        let a: pxr.VtRect2iArray = [pxr.GfRect2i(pxr.GfVec2i(0, 1), pxr.GfVec2i(2, 3))]
        let b: pxr.VtRect2iArray = []
        let c: pxr.VtRect2iArray = [pxr.GfRect2i(pxr.GfVec2i(0, 1), pxr.GfVec2i(2, 3))]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtRect2iArray.self)
    }
    
    func test_VtStringArray() {
        let a: pxr.VtStringArray = ["hi"]
        let b: pxr.VtStringArray = ["there"]
        let c: pxr.VtStringArray = ["hi"]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtStringArray.self)
    }
    
    func test_VtTokenArray() {
        let a: pxr.VtTokenArray = [.UsdGeomTokens.Sphere]
        let b: pxr.VtTokenArray = [.UsdGeomTokens.Cube]
        let c: pxr.VtTokenArray = [.UsdGeomTokens.Sphere]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtTokenArray.self)
    }
    
    func test_VtQuathArray() {
        let a: pxr.VtQuathArray = [pxr.GfQuath(1, 2, 3, 4)]
        let b: pxr.VtQuathArray = []
        let c: pxr.VtQuathArray = [pxr.GfQuath(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtQuathArray.self)
    }
    
    func test_VtQuatfArray() {
        let a: pxr.VtQuatfArray = [pxr.GfQuatf(1, 2, 3, 4)]
        let b: pxr.VtQuatfArray = []
        let c: pxr.VtQuatfArray = [pxr.GfQuatf(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtQuatfArray.self)
    }
    
    func test_VtQuatdArray() {
        let a: pxr.VtQuatdArray = [pxr.GfQuatd(1, 2, 3, 4)]
        let b: pxr.VtQuatdArray = []
        let c: pxr.VtQuatdArray = [pxr.GfQuatd(1, 2, 3, 4)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtQuatdArray.self)
    }
    
    func test_VtQuaternionArray() {
        let a: pxr.VtQuaternionArray = [pxr.GfQuaternion(1, pxr.GfVec3d(2, 3, 4))]
        let b: pxr.VtQuaternionArray = []
        let c: pxr.VtQuaternionArray = [pxr.GfQuaternion(1, pxr.GfVec3d(2, 3, 4))]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtQuaternionArray.self)
    }
    
    // MARK: Other things
    
    func test_GfInterval() {
        let a: pxr.GfInterval = pxr.GfInterval(0, 1, true, true)
        let b: pxr.GfInterval = pxr.GfInterval(0, 1, true, false)
        let c: pxr.GfInterval = pxr.GfInterval(0, 1, true, true)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfInterval.self)
    }
    
    func test_GfVec2d() {
        let a: pxr.GfVec2d = pxr.GfVec2d(1, 2)
        let b: pxr.GfVec2d = pxr.GfVec2d(1, 3)
        let c: pxr.GfVec2d = pxr.GfVec2d(1, 2)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec2d.self)
    }
    
    func test_GfVec2f() {
        let a: pxr.GfVec2f = pxr.GfVec2f(1, 2)
        let b: pxr.GfVec2f = pxr.GfVec2f(1, 3)
        let c: pxr.GfVec2f = pxr.GfVec2f(1, 2)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec2f.self)
    }
    
    func test_GfVec2h() {
        let a: pxr.GfVec2h = pxr.GfVec2h(1, 2)
        let b: pxr.GfVec2h = pxr.GfVec2h(1, 3)
        let c: pxr.GfVec2h = pxr.GfVec2h(1, 2)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec2h.self)
    }
    
    func test_GfRange3d() {
        let a: pxr.GfRange3d = pxr.GfRange3d(pxr.GfVec3d(1, 2, 3), pxr.GfVec3d(4, 5, 6))
        let b: pxr.GfRange3d = pxr.GfRange3d(pxr.GfVec3d(1, 2, 3), pxr.GfVec3d(4, 5, 7))
        let c: pxr.GfRange3d = pxr.GfRange3d(pxr.GfVec3d(1, 2, 3), pxr.GfVec3d(4, 5, 6))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRange3d.self)
    }
    
    func test_GfRange3f() {
        let a: pxr.GfRange3f = pxr.GfRange3f(pxr.GfVec3f(1, 2, 3), pxr.GfVec3f(4, 5, 6))
        let b: pxr.GfRange3f = pxr.GfRange3f(pxr.GfVec3f(1, 2, 3), pxr.GfVec3f(4, 5, 7))
        let c: pxr.GfRange3f = pxr.GfRange3f(pxr.GfVec3f(1, 2, 3), pxr.GfVec3f(4, 5, 6))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRange3f.self)
    }
    
    func test_GfRange2d() {
        let a: pxr.GfRange2d = pxr.GfRange2d(pxr.GfVec2d(1, 2), pxr.GfVec2d(4, 5))
        let b: pxr.GfRange2d = pxr.GfRange2d(pxr.GfVec2d(1, 2), pxr.GfVec2d(4, 7))
        let c: pxr.GfRange2d = pxr.GfRange2d(pxr.GfVec2d(1, 2), pxr.GfVec2d(4, 5))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRange2d.self)
    }
    
    func test_GfRange2f() {
        let a: pxr.GfRange2f = pxr.GfRange2f(pxr.GfVec2f(1, 2), pxr.GfVec2f(4, 5))
        let b: pxr.GfRange2f = pxr.GfRange2f(pxr.GfVec2f(1, 2), pxr.GfVec2f(4, 7))
        let c: pxr.GfRange2f = pxr.GfRange2f(pxr.GfVec2f(1, 2), pxr.GfVec2f(4, 5))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRange2f.self)
    }
    
    func test_GfRange1d() {
        let a: pxr.GfRange1d = pxr.GfRange1d(1, 2)
        let b: pxr.GfRange1d = pxr.GfRange1d(1, 7)
        let c: pxr.GfRange1d = pxr.GfRange1d(1, 2)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRange1d.self)
    }

    func test_GfRange1f() {
        let a: pxr.GfRange1f = pxr.GfRange1f(1, 2)
        let b: pxr.GfRange1f = pxr.GfRange1f(1, 7)
        let c: pxr.GfRange1f = pxr.GfRange1f(1, 2)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRange1f.self)
    }
    
    func test_GfQuath() {
        let a: pxr.GfQuath = pxr.GfQuath(1, 2, 3, 4)
        let b: pxr.GfQuath = pxr.GfQuath(1, 2, 3, 7)
        let c: pxr.GfQuath = pxr.GfQuath(1, 2, 3, 4)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfQuath.self)
    }
    
    func test_GfQuatf() {
        let a: pxr.GfQuatf = pxr.GfQuatf(1, 2, 3, 4)
        let b: pxr.GfQuatf = pxr.GfQuatf(1, 2, 3, 7)
        let c: pxr.GfQuatf = pxr.GfQuatf(1, 2, 3, 4)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfQuatf.self)
    }
    
    func test_GfQuatd() {
        let a: pxr.GfQuatd = pxr.GfQuatd(1, 2, 3, 4)
        let b: pxr.GfQuatd = pxr.GfQuatd(1, 2, 3, 7)
        let c: pxr.GfQuatd = pxr.GfQuatd(1, 2, 3, 4)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfQuatd.self)
    }
    
    func test_GfQuaternion() {
        let a: pxr.GfQuaternion = pxr.GfQuaternion(1, pxr.GfVec3d(2, 3, 4))
        let b: pxr.GfQuaternion = pxr.GfQuaternion(1, pxr.GfVec3d(2, 3, 7))
        let c: pxr.GfQuaternion = pxr.GfQuaternion(1, pxr.GfVec3d(2, 3, 4))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfQuaternion.self)
    }
    
    func test_GfRotation() {
        let a: pxr.GfRotation = pxr.GfRotation(pxr.GfVec3d(2, 3, 4), 1)
        let b: pxr.GfRotation = pxr.GfRotation(pxr.GfVec3d(2, 3, 7), 1)
        let c: pxr.GfRotation = pxr.GfRotation(pxr.GfVec3d(2, 3, 4), 1)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRotation.self)

    }

    func test_GfVec4i() {
        let a: pxr.GfVec4i = pxr.GfVec4i(1, 2, 3, 4)
        let b: pxr.GfVec4i = pxr.GfVec4i(1, 2, 3, 7)
        let c: pxr.GfVec4i = pxr.GfVec4i(1, 2, 3, 4)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec4i.self)
    }
    
    func test_GfVec3i() {
        let a: pxr.GfVec3i = pxr.GfVec3i(1, 2, 4)
        let b: pxr.GfVec3i = pxr.GfVec3i(1, 2, 7)
        let c: pxr.GfVec3i = pxr.GfVec3i(1, 2, 4)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec3i.self)
    }
    
    func test_GfVec2i() {
        let a: pxr.GfVec2i = pxr.GfVec2i(1, 4)
        let b: pxr.GfVec2i = pxr.GfVec2i(1, 7)
        let c: pxr.GfVec2i = pxr.GfVec2i(1, 4)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfVec2i.self)
    }
    
    func test_GfMatrix4d() {
        let a: pxr.GfMatrix4d = pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        let b: pxr.GfMatrix4d = pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17)
        let c: pxr.GfMatrix4d = pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfMatrix4d.self)
    }
    
    func test_GfMatrix4f() {
        let a: pxr.GfMatrix4f = pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        let b: pxr.GfMatrix4f = pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17)
        let c: pxr.GfMatrix4f = pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfMatrix4f.self)
    }
    
    func test_GfMatrix3d() {
        let a: pxr.GfMatrix3d = pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 16)
        let b: pxr.GfMatrix3d = pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 17)
        let c: pxr.GfMatrix3d = pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 16)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfMatrix3d.self)
    }
    
    func test_GfMatrix3f() {
        let a: pxr.GfMatrix3f = pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 16)
        let b: pxr.GfMatrix3f = pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 17)
        let c: pxr.GfMatrix3f = pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 16)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfMatrix3f.self)
    }
    
    func test_GfMatrix2d() {
        let a: pxr.GfMatrix2d = pxr.GfMatrix2d(1, 2, 3, 16)
        let b: pxr.GfMatrix2d = pxr.GfMatrix2d(1, 2, 3, 17)
        let c: pxr.GfMatrix2d = pxr.GfMatrix2d(1, 2, 3, 16)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfMatrix2d.self)
    }
    
    func test_GfMatrix2f() {
        let a: pxr.GfMatrix2f = pxr.GfMatrix2f(1, 2, 3, 16)
        let b: pxr.GfMatrix2f = pxr.GfMatrix2f(1, 2, 3, 17)
        let c: pxr.GfMatrix2f = pxr.GfMatrix2f(1, 2, 3, 16)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfMatrix2f.self)
    }

    func test_VtValue() {
        let a: pxr.VtValue = pxr.VtValue(1.0)
        let b: pxr.VtValue = pxr.VtValue("foo" as pxr.TfToken)
        let c: pxr.VtValue = pxr.VtValue(1.0)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtValue.self)
    }
    
    func test_SdfLayerOffset() {
        let a: pxr.SdfLayerOffset = pxr.SdfLayerOffset(0, 1)
        let b: pxr.SdfLayerOffset = pxr.SdfLayerOffset(0, 2)
        let c: pxr.SdfLayerOffset = pxr.SdfLayerOffset(0, 1)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfLayerOffset.self)
    }
    
    func test_SdfValueTypeName() {
        let a: pxr.SdfValueTypeName = .Float
        let b: pxr.SdfValueTypeName = .Token
        let c: pxr.SdfValueTypeName = .Float
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfValueTypeName.self)
    }
    
    func test_UsdStageLoadRules() {
        let a: pxr.UsdStageLoadRules = pxr.UsdStageLoadRules.LoadAll()
        let b: pxr.UsdStageLoadRules = pxr.UsdStageLoadRules.LoadNone()
        let c: pxr.UsdStageLoadRules = pxr.UsdStageLoadRules.LoadAll()
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.UsdStageLoadRules.self)
    }
    
    func test_UsdStagePopulationMask() {
        let a: pxr.UsdStagePopulationMask = pxr.UsdStagePopulationMask()
        let b: pxr.UsdStagePopulationMask = pxr.UsdStagePopulationMask.All()
        let c: pxr.UsdStagePopulationMask = pxr.UsdStagePopulationMask()
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.UsdStagePopulationMask.self)
    }
    
    func test_UsdEditTarget() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let a: pxr.UsdEditTarget = pxr.UsdEditTarget(main.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        let b: pxr.UsdEditTarget = pxr.UsdEditTarget(main.GetRootLayer(), pxr.SdfLayerOffset(0, 2))
        let c: pxr.UsdEditTarget = pxr.UsdEditTarget(main.GetRootLayer(), pxr.SdfLayerOffset(0, 1))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.UsdEditTarget.self)
    }
    
    func test_GfRect2i() {
        let a: pxr.GfRect2i = pxr.GfRect2i(pxr.GfVec2i(0, 1), pxr.GfVec2i(2, 3))
        let b: pxr.GfRect2i = pxr.GfRect2i(pxr.GfVec2i(0, 1), pxr.GfVec2i(2, 7))
        let c: pxr.GfRect2i = pxr.GfRect2i(pxr.GfVec2i(0, 1), pxr.GfVec2i(2, 3))
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.GfRect2i.self)
    }
    
    func test_VtDictionary() {
        let a: pxr.VtDictionary = ["" : pxr.VtValue(1.0)]
        let b: pxr.VtDictionary = [:]
        let c: pxr.VtDictionary = ["" : pxr.VtValue(1.0)]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.VtDictionary.self)
    }
    
    func test_SdfPrimSpecHandle() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        let a: pxr.SdfPrimSpecHandle = layer.GetPrimAtPath("/foo")
        let b: pxr.SdfPrimSpecHandle = layer.GetPrimAtPath("/bar")
        let c: pxr.SdfPrimSpecHandle = layer.GetPrimAtPath("/foo")
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfPrimSpecHandle.self)
    }
    
    func test_SdfPropertySpecHandle() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Sphere")
        foo.GetAttribute("radius").Set(2.0, 1)
        bar.GetAttribute("radius").Set(2.0, 1)
        let a: pxr.SdfPropertySpecHandle = layer.GetPropertyAtPath("/foo.radius")
        let b: pxr.SdfPropertySpecHandle = layer.GetPropertyAtPath("/bar.radius")
        let c: pxr.SdfPropertySpecHandle = layer.GetPropertyAtPath("/foo.radius")
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfPropertySpecHandle.self)
    }
    
    func test_SdfLayerStateDelegateBasePtr() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let a: pxr.SdfLayerStateDelegateBasePtr = layer.GetStateDelegate()
        let b: pxr.SdfLayerStateDelegateBasePtr = Overlay.TfWeakPtr(Overlay.Dereference(pxr.SdfSimpleLayerStateDelegate.New()).as(pxr.SdfLayerStateDelegateBase.self))
        let c: pxr.SdfLayerStateDelegateBasePtr = layer.GetStateDelegate()
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfLayerStateDelegateBasePtr.self)
    }
    
    func test_SdfPathSet() {
        let a: pxr.SdfPathSet = ["/foo", "/bar"]
        let b: pxr.SdfPathSet = ["/fizz", "/buzz"]
        let c: pxr.SdfPathSet = ["/bar", "/foo"]
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.SdfPathSet.self)
    }
    
    func test_UsdRelationship() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a = p.CreateRelationship("firstRel", true)
        let b = p.CreateRelationship("secondRel", true)
        let c = main.GetRelationshipAtPath("/foo.firstRel")
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.UsdRelationship.self)
    }
    
    func test_TfType() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a = p.GetAttribute("radius").GetTypeName().GetType()
        let b = p.GetAttribute("visibility").GetTypeName().GetType()
        let c = pxr.VtValue(6.0).GetType()
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.TfType.self)
    }
    
    func test_UsdPrimTypeInfoWrapper() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let foo = main.DefinePrim("/foo", "Sphere")
        let bar = main.DefinePrim("/bar", "Cube")
        let fizz = main.DefinePrim("/fizz", "Sphere")
        let a = Overlay.UsdPrimTypeInfoWrapper(foo)
        let b = Overlay.UsdPrimTypeInfoWrapper(bar)
        let c = Overlay.UsdPrimTypeInfoWrapper(fizz)
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(Overlay.UsdPrimTypeInfoWrapper.self)
    }
    
    func test_UsdGeomXformOp() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        let p = pxr.UsdGeomXformable.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let a = p.AddTranslateOp(.PrecisionDouble, "op1", false)
        let b = p.AddTranslateOp(.PrecisionDouble, "op2", false)
        let c = p.GetTranslateOp("op1", false)
        
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
        assertConforms(pxr.UsdGeomXformOp.self)
    }
}
