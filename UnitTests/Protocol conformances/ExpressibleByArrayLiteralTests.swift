//
//  ExpressibleByArrayLiteralTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/13/23.
//

import XCTest
import OpenUSD

final class ExpressibleByArrayLiteralTests: TemporaryDirectoryHelper {
    
    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any ExpressibleByArrayLiteral.Type)
    }
    
    func test_VtArray_Bool() {
        let a: pxr.VtBoolArray = [true, false]
        XCTAssertEqual(a.description, "[1, 0]")
        assertConforms(pxr.VtBoolArray.self)
    }
    
    func test_VtArray_Int8() {
        let x: pxr.VtCharArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtCharArray.self)
    }
    func test_VtArray_Double() {
        let x: pxr.VtDoubleArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtDoubleArray.self)
    }
    func test_VtArray_Float() {
        let x: pxr.VtFloatArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtFloatArray.self)
    }
    func test_VtArray_Half() {
        let x: pxr.VtHalfArray = [pxr.GfHalf(3), pxr.GfHalf(1), pxr.GfHalf(4)]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtHalfArray.self)
    }
    func test_VtArray_Int32() {
        let x: pxr.VtIntArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtIntArray.self)
    }
    func test_VtArray_Int64() {
        let x: pxr.VtInt64Array = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtInt64Array.self)
    }
    func test_VtArray_Int16() {
        let x: pxr.VtShortArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtShortArray.self)
    }
    func test_VtArray_stdString() {
        let x: pxr.VtStringArray = ["foo", "bar"]
        XCTAssertEqual(x.description, "[foo, bar]")
        assertConforms(pxr.VtStringArray.self)
    }
    func test_VtArray_TfToken() {
        let x: pxr.VtTokenArray = ["foo", "bar"]
        XCTAssertEqual(x.description, "[foo, bar]")
        assertConforms(pxr.VtTokenArray.self)
    }
    func test_VtArray_UInt8() {
        let x: pxr.VtUCharArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtUCharArray.self)
    }
    func test_VtArray_UInt16() {
        let x: pxr.VtUShortArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtUShortArray.self)
    }
    func test_VtArray_UInt32() {
        let x: pxr.VtUIntArray = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtUIntArray.self)
    }
    func test_VtArray_UInt64() {
        let x: pxr.VtUInt64Array = [3, 1, 4]
        XCTAssertEqual(x.description, "[3, 1, 4]")
        assertConforms(pxr.VtUInt64Array.self)
    }
    func test_VtArray_GfMatrix2d() {
        let x: pxr.VtMatrix2dArray = [pxr.GfMatrix2d(1, 2, 3, 4)]
        XCTAssertEqual(x.description, "[( (1, 2), (3, 4) )]")
        assertConforms(pxr.VtMatrix2dArray.self)
    }
    func test_VtArray_GfMatrix2f() {
        let x: pxr.VtMatrix2fArray = [pxr.GfMatrix2f(1, 2, 3, 4)]
        XCTAssertEqual(x.description, "[( (1, 2), (3, 4) )]")
        assertConforms(pxr.VtMatrix2fArray.self)
    }
    func test_VtArray_GfMatrix3d() {
        let x: pxr.VtMatrix3dArray = [pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        XCTAssertEqual(x.description, "[( (1, 2, 3), (4, 5, 6), (7, 8, 9) )]")
        assertConforms(pxr.VtMatrix3dArray.self)
    }
    func test_VtArray_GfMatrix3f() {
        let x: pxr.VtMatrix3fArray = [pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        XCTAssertEqual(x.description, "[( (1, 2, 3), (4, 5, 6), (7, 8, 9) )]")
        assertConforms(pxr.VtMatrix3fArray.self)
    }
    func test_VtArray_GfMatrix4d() {
        let x: pxr.VtMatrix4dArray = [pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        XCTAssertEqual(x.description, "[( (1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12), (13, 14, 15, 16) )]")
        assertConforms(pxr.VtMatrix4dArray.self)
    }
    func test_VtArray_GfMatrix4f() {
        let x: pxr.VtMatrix4fArray = [pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        XCTAssertEqual(x.description, "[( (1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12), (13, 14, 15, 16) )]")
        assertConforms(pxr.VtMatrix4fArray.self)
    }
    func test_VtArray_GfQuatd() {
        let x: pxr.VtQuatdArray = [pxr.GfQuatd(3, 1, 4, 1)]
        XCTAssertEqual(x.description, "[(3, 1, 4, 1)]")
        assertConforms(pxr.VtQuatdArray.self)
    }
    func test_VtArray_GfQuaternion() {
        let x: pxr.VtQuaternionArray = [pxr.GfQuaternion(3, pxr.GfVec3d(1, 4, 1))]
        XCTAssertEqual(x.description, "[(3 + (1, 4, 1))]")
        assertConforms(pxr.VtQuaternionArray.self)
    }
    func test_VtArray_GfQuatf() {
        let x: pxr.VtQuatfArray = [pxr.GfQuatf(3, 1, 4, 1)]
        XCTAssertEqual(x.description, "[(3, 1, 4, 1)]")
        assertConforms(pxr.VtQuatfArray.self)
    }
    func test_VtArray_GfQuath() {
        let x: pxr.VtQuathArray = [pxr.GfQuath(pxr.GfHalf(3), pxr.GfHalf(1), pxr.GfHalf(4), pxr.GfHalf(1))]
        XCTAssertEqual(x.description, "[(3, 1, 4, 1)]")
        assertConforms(pxr.VtQuathArray.self)
    }
    func test_VtArray_GfVec2d() {
        let x: pxr.VtVec2dArray = [pxr.GfVec2d(1, 2)]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2dArray.self)
    }
    func test_VtArray_GfVec2f() {
        let x: pxr.VtVec2fArray = [pxr.GfVec2f(1, 2)]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2fArray.self)
    }
    func test_VtArray_GfVec2h() {
        let x: pxr.VtVec2hArray = [pxr.GfVec2h(pxr.GfHalf(1), pxr.GfHalf(2))]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2hArray.self)
    }
    func test_VtArray_GfVec2i() {
        let x: pxr.VtVec2iArray = [pxr.GfVec2i(1, 2)]
        XCTAssertEqual(x.description, "[(1, 2)]")
        assertConforms(pxr.VtVec2iArray.self)
    }
    func test_VtArray_GfVec3d() {
        let x: pxr.VtVec3dArray = [pxr.GfVec3d(1, 2, 1)]
        XCTAssertEqual(x.description, "[(1, 2, 1)]")
        assertConforms(pxr.VtVec3dArray.self)
    }
    func test_VtArray_GfVec3f() {
        let x: pxr.VtVec3fArray = [pxr.GfVec3f(1, 2, 1)]
        XCTAssertEqual(x.description, "[(1, 2, 1)]")
        assertConforms(pxr.VtVec3fArray.self)
    }
    func test_VtArray_GfVec3h() {
        let x: pxr.VtVec3hArray = [pxr.GfVec3h(pxr.GfHalf(1), pxr.GfHalf(2), pxr.GfHalf(1))]
        XCTAssertEqual(x.description, "[(1, 2, 1)]")
        assertConforms(pxr.VtVec3hArray.self)
    }
    func test_VtArray_GfVec3i() {
        let x: pxr.VtVec3iArray = [pxr.GfVec3i(1, 2, 1)]
        XCTAssertEqual(x.description, "[(1, 2, 1)]")
        assertConforms(pxr.VtVec3iArray.self)
    }
    func test_VtArray_GfVec4d() {
        let x: pxr.VtVec4dArray = [pxr.GfVec4d(1, 2, 1, 0)]
        XCTAssertEqual(x.description, "[(1, 2, 1, 0)]")
        assertConforms(pxr.VtVec4dArray.self)
    }
    func test_VtArray_GfVec4f() {
        let x: pxr.VtVec4fArray = [pxr.GfVec4f(1, 2, 1, 0)]
        XCTAssertEqual(x.description, "[(1, 2, 1, 0)]")
        assertConforms(pxr.VtVec4fArray.self)
    }
    func test_VtArray_GfVec4h() {
        let x: pxr.VtVec4hArray = [pxr.GfVec4h(pxr.GfHalf(1), pxr.GfHalf(2), pxr.GfHalf(1), pxr.GfHalf(0))]
        XCTAssertEqual(x.description, "[(1, 2, 1, 0)]")
        assertConforms(pxr.VtVec4hArray.self)
    }
    func test_VtArray_GfVec4i() {
        let x: pxr.VtVec4iArray = [pxr.GfVec4i(1, 2, 1, 0)]
        XCTAssertEqual(x.description, "[(1, 2, 1, 0)]")
        assertConforms(pxr.VtVec4iArray.self)
    }
    func test_VtArray_GfInterval() {
        let x: pxr.VtIntervalArray = [pxr.GfInterval(2.718, 3.1415, true, false)]
        XCTAssertEqual(x.description, "[[2.718, 3.1415)]")
        assertConforms(pxr.VtIntervalArray.self)
    }
    func test_VtArray_GfRange1d() {
        let x: pxr.VtRange1dArray = [pxr.GfRange1d(2.718, 3.1415)]
        XCTAssertEqual(x.description, "[[2.718...3.1415]]")
        assertConforms(pxr.VtRange1dArray.self)
    }
    func test_VtArray_GfRange1f() {
        let x: pxr.VtRange1fArray = [pxr.GfRange1f(2.718, 3.1415)]
        XCTAssertEqual(x.description, "[[2.718...3.1415]]")
        assertConforms(pxr.VtRange1fArray.self)
    }
    func test_VtArray_GfRange2d() {
        let x: pxr.VtRange2dArray = [pxr.GfRange2d(pxr.GfVec2d(0, 1), pxr.GfVec2d(3, 4))]
        XCTAssertEqual(x.description, "[[(0, 1)...(3, 4)]]")
        assertConforms(pxr.VtRange2dArray.self)
    }
    func test_VtArray_GfRange2f() {
        let x: pxr.VtRange2fArray = [pxr.GfRange2f(pxr.GfVec2f(0, 1), pxr.GfVec2f(3, 4))]
        XCTAssertEqual(x.description, "[[(0, 1)...(3, 4)]]")
        assertConforms(pxr.VtRange2fArray.self)
    }
    func test_VtArray_GfRange3d() {
        let x: pxr.VtRange3dArray = [pxr.GfRange3d(pxr.GfVec3d(0, 1, 2), pxr.GfVec3d(3, 4, 5))]
        XCTAssertEqual(x.description, "[[(0, 1, 2)...(3, 4, 5)]]")
        assertConforms(pxr.VtRange3dArray.self)
    }
    func test_VtArray_GfRange3f() {
        let x: pxr.VtRange3fArray = [pxr.GfRange3f(pxr.GfVec3f(0, 1, 2), pxr.GfVec3f(3, 4, 5))]
        XCTAssertEqual(x.description, "[[(0, 1, 2)...(3, 4, 5)]]")
        assertConforms(pxr.VtRange3fArray.self)
    }

    func test_VtArray_GfRect2i() {
        let x: pxr.VtRect2iArray = [pxr.GfRect2i(pxr.GfVec2i(1, 2), pxr.GfVec2i(3, 4))]
        XCTAssertEqual(x.description, "[[(1, 2):(3, 4)]]")
        assertConforms(pxr.VtRect2iArray.self)
    }
    
    // MARK: std.vector specializations
    func test_StringVector() {
        let x: Overlay.String_Vector = ["hi"]
        XCTAssertEqual(x.description, "[hi]")
        assertConforms(Overlay.String_Vector.self)
    }
    
    func test_Double_Vector() {
        let x: Overlay.Double_Vector = [1.2]
        XCTAssertEqual(x.description, "[1.2]")
        assertConforms(Overlay.String_Vector.self)
    }
    
    func test_UsdAttributeVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a_attr = p.GetAttribute("radius")
        
        let x: Overlay.UsdAttribute_Vector = [a_attr]
        XCTAssertEqual(x.description, "[attribute 'radius' on 'Sphere' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@]")
        assertConforms(Overlay.UsdAttribute_Vector.self)
    }
    
    func test_UsdRelationshipVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let a_rel = p.CreateRelationship("firstRel", true)
        
        let x: Overlay.UsdRelationship_Vector = [a_rel]
        XCTAssertEqual(x.description, "[relationship 'firstRel' on 'Sphere' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@]")
        assertConforms(Overlay.UsdRelationship_Vector.self)
    }
    
    func test_TfTokenVector() {
        let x: pxr.TfTokenVector = ["hi"]
        XCTAssertEqual(x.description, "[hi]")
        assertConforms(pxr.TfTokenVector.self)
    }
    
    func test_SdfPathVector() {
        let x: pxr.SdfPathVector = ["/hi"]
        XCTAssertEqual(x.description, "[/hi]")
        assertConforms(pxr.SdfPathVector.self)
    }
    
    func test_SdfLayerOffsetVector() {
        let x: pxr.SdfLayerOffsetVector = [pxr.SdfLayerOffset(0, 1)]
        XCTAssertEqual(x.description, "[SdfLayerOffset(0, 1)]")
        assertConforms(pxr.SdfLayerOffsetVector.self)
    }
    
    func test_SdfPropertySpecHandleVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.GetAttribute("radius").Set(5.0, 2.0)
        p.CreateAttribute("myAttr", .Float, true, .SdfVariabilityVarying)
        let layer = Overlay.Dereference(main.GetRootLayer())
        
        let x: pxr.SdfPropertySpecHandleVector = [layer.GetPropertyAtPath("/foo.radius")]
        XCTAssertEqual(x.description, "[pxr::SdfPropertySpecHandle(pxr::SdfPropertySpec(\(pathForStage(named: "Main.usda")), /foo.radius))]")
        assertConforms(pxr.SdfPropertySpecHandleVector.self)
    }
    
    func test_SdfPrimSpecHandleVector() throws {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        let layer = Overlay.Dereference(main.GetRootLayer())

        let x: pxr.SdfPrimSpecHandleVector = [layer.GetPrimAtPath("/foo")]
        XCTAssertEqual(x.description, "[pxr::SdfPrimSpecHandle(pxr::SdfPrimSpec(\(pathForStage(named: "Main.usda")), /foo))]")
        assertConforms(pxr.SdfPrimSpecHandleVector.self)
    }
    
    func test_UsdGeomXformOpVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        main.DefinePrim("/foo", "Sphere")
        let p = pxr.UsdGeomXformable.Get(Overlay.TfWeakPtr(main), "/foo")
        
        let op1 = p.AddTranslateOp(.PrecisionDouble, "op1", false)
        
        let x: Overlay.UsdGeomXformOp_Vector = [op1]
        XCTAssertEqual(x.description, "[pxr::UsdGeomXformOp(/foo.xformOp:translate:op1)]")
        assertConforms(Overlay.UsdGeomXformOp_Vector.self)
    }
    
    func test_SdfPathSet() {
        let x: pxr.SdfPathSet = ["/foo"]
        XCTAssertEqual(x.description, "[/foo]")
        assertConforms(pxr.SdfPathSet.self)
    }
    
    func test_SdfLayerHandleSet() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let x: pxr.SdfLayerHandleSet = [main.GetRootLayer()]
        pxr.SdfLayer.ReloadLayers(x, true)
        assertConforms(pxr.SdfLayerHandleSet.self)
    }
    
    func test_GfVec4f_Vector() {
        let x: Overlay.GfVec4f_Vector = [pxr.GfVec4f(1, 2, 3, 4)]
        XCTAssertEqual(x.description, "[(1, 2, 3, 4)]")
        assertConforms(Overlay.GfVec4f_Vector.self)
    }
}
