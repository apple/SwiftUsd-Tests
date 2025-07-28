//
//  SWIFT_NAME_copy.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/12/23.
//

import XCTest
import OpenUSD

final class SWIFT_NAME_copy: TemporaryDirectoryHelper {
    func test_TfToken_GetString() {
        var s: std.string!
        do {
            let t: pxr.TfToken = .UsdGeomTokens.Cube
            s = t.GetString()
        }
        XCTAssertEqual(s, "Cube")
    }
    
    func test_GfBox3d_GetRange() {
        var r: pxr.GfRange3d!
        do {
            var b: pxr.GfBBox3d = pxr.GfBBox3d.init()
            b.SetRange(pxr.GfRange3d(pxr.GfVec3d(-1, -2, -3), pxr.GfVec3d(4, 5, 6)))
            r = b.GetRange()
        }
        
        XCTAssertEqual(r.GetMin(), pxr.GfVec3d(-1, -2, -3))
        XCTAssertEqual(r.GetMax(), pxr.GfVec3d(4, 5, 6))
        XCTAssertEqual(r, pxr.GfRange3d(pxr.GfVec3d(-1, -2, -3), pxr.GfVec3d(4, 5, 6)))
    }
    
    func test_GfRange2d_GetMin() {
        var v: pxr.GfVec2d!
        do {
            let r: pxr.GfRange2d = pxr.GfRange2d(pxr.GfVec2d(2, 7), pxr.GfVec2d(3, 8))
            v = r.GetMin()
        }
        XCTAssertEqual(v[0], 2)
        XCTAssertEqual(v[1], 7)
        XCTAssertEqual(v, pxr.GfVec2d(2, 7))
    }
    
    func test_GfRange2d_GetMax() {
        var v: pxr.GfVec2d!
        do {
            let r: pxr.GfRange2d = pxr.GfRange2d(pxr.GfVec2d(2, 7), pxr.GfVec2d(3, 8))
            v = r.GetMax()
        }
        XCTAssertEqual(v[0], 3)
        XCTAssertEqual(v[1], 8)
         XCTAssertEqual(v, pxr.GfVec2d(3, 8))
    }
    
    func test_GfRange2f_GetMin() {
        var v: pxr.GfVec2f!
        do {
            let r: pxr.GfRange2f = pxr.GfRange2f(pxr.GfVec2f(2, 7), pxr.GfVec2f(3, 8))
            v = r.GetMin()
        }
        XCTAssertEqual(v[0], 2)
        XCTAssertEqual(v[1], 7)
        XCTAssertEqual(v, pxr.GfVec2f(2, 7))
    }
    
    func test_GfRange2f_GetMax() {
        var v: pxr.GfVec2f!
        do {
            let r: pxr.GfRange2f = pxr.GfRange2f(pxr.GfVec2f(2, 7), pxr.GfVec2f(3, 8))
            v = r.GetMax()
        }
        XCTAssertEqual(v[0], 3)
        XCTAssertEqual(v[1], 8)
        XCTAssertEqual(v, pxr.GfVec2f(3, 8))
    }
    
    func test_GfRange3d_GetMin() {
        var v: pxr.GfVec3d!
        do {
            let r: pxr.GfRange3d = pxr.GfRange3d(pxr.GfVec3d(3, 1, 4), pxr.GfVec3d(7, 8, 9))
            v = r.GetMin()
        }
        XCTAssertEqual(v, pxr.GfVec3d(3, 1, 4))
    }
    
    func test_GfRange3d_GetMax() {
        var v: pxr.GfVec3d!
        do {
            let r: pxr.GfRange3d = pxr.GfRange3d(pxr.GfVec3d(3, 1, 4), pxr.GfVec3d(7, 8, 9))
            v = r.GetMax()
        }
        XCTAssertEqual(v, pxr.GfVec3d(7, 8, 9))
    }
    
    func test_GfRange3f_GetMin() {
        var v: pxr.GfVec3f!
        do {
            let r: pxr.GfRange3f = pxr.GfRange3f(pxr.GfVec3f(3, 1, 4), pxr.GfVec3f(7, 8, 9))
            v = r.GetMin()
        }
        XCTAssertEqual(v, pxr.GfVec3f(3, 1, 4))
    }
    
    func test_GfRange3f_GetMax() {
        var v: pxr.GfVec3f!
        do {
            let r: pxr.GfRange3f = pxr.GfRange3f(pxr.GfVec3f(3, 1, 4), pxr.GfVec3f(7, 8, 9))
            v = r.GetMax()
        }
        XCTAssertEqual(v, pxr.GfVec3f(7, 8, 9))
    }
    
    func test_GfQuath_GetImaginary() {
        var v: pxr.GfVec3h!
        do {
            let q: pxr.GfQuath = pxr.GfQuath(2.0, pxr.GfVec3h(7.0, 1.0, 8.0))
            v = q.GetImaginary()
        }
        XCTAssertEqual(v, pxr.GfVec3h(7.0, 1.0, 8.0))
    }
    
    func test_GfRotation_GetAxis() {
        var v: pxr.GfVec3d!
        do {
            let r: pxr.GfRotation = pxr.GfRotation(pxr.GfVec3d(2, 7, 1), 8)
            v = r.GetAxis()
        }
        XCTAssertEqual(v, pxr.GfVec3d(2, 7, 1).GetNormalized(GF_MIN_VECTOR_LENGTH))
    }
    
    func test_SdfLayer_GetIdentifier() {
        var s: std.string!
        do {
            let l = Overlay.Dereference(pxr.SdfLayer.CreateNew(pathForStage(named: "HelloWorld.usda"), pxr.SdfLayer.FileFormatArguments()))
            s = l.GetIdentifier()
        }
        XCTAssertEqual(s, pathForStage(named: "HelloWorld.usda"))
    }
    
    func test_SdfValueTypeName_GetCPPTypeName() {
        var s: std.string!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let cube = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/MyCube")
            let attr = cube.GetExtentAttr()
            let valueTypeName = attr.GetTypeName()
            s = valueTypeName.GetCPPTypeName()
        }
        XCTAssertEqual(s, "VtArray<GfVec3f>")
    }
    
    func test_UsdEditTarget_GetLayer() {
        do {
            var l: pxr.SdfLayer!
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                let editTarget = stage.GetEditTarget()
                l = Overlay.Dereference(editTarget.GetLayer())
                assertOpen("HelloWorld.usda")
                l.SetStartTimeCode(5)
            }
            assertOpen("HelloWorld.usda")
            l.SetEndTimeCode(9)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_UsdStage_GetEditTarget() {
        var editTarget: pxr.UsdEditTarget!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            editTarget = stage.GetEditTarget()
            XCTAssertTrue(editTarget.IsValid())
        }
        XCTAssertFalse(editTarget.IsValid())
    }
    
    func test_UsdStage_GetMutedLayers() {
        var l: Overlay.String_Vector!
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            let layer = Overlay.Dereference(main.GetRootLayer())
            let other = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Other.usda"), .LoadAll))
            layer.InsertSubLayerPath(pathForStage(named: "Other.usda"), 0)
            main.MuteLayer(pathForStage(named: "Other.usda"))
            l = main.GetMutedLayers()
            XCTAssertEqual(l, [pathForStage(named: "Other.usda")])
            withExtendedLifetime(other) {}
        }
        XCTAssertEqual(l, [pathForStage(named: "Other.usda")])
    }
    
    func test_UsdPrim_GetTypeName() {
        var t: pxr.TfToken!
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            t = main.DefinePrim("/foo", "Cube").GetTypeName()
            XCTAssertEqual(t, "Cube")
        }
        XCTAssertEqual(t, "Cube")
    }
    
    func test_SdfSpecHandle_GetSpec() {
        var s: pxr.SdfSpec!
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            let layer = Overlay.Dereference(main.GetRootLayer())
            main.OverridePrim("/foo")
            s = layer.GetObjectAtPath("/foo").GetSpec()
            XCTAssertFalse(s.IsDormant())
        }
        XCTAssertTrue(s.IsDormant())
    }
    
    func test_SdfValueTypeName_GetType() {
        var t: pxr.TfType!
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            let p = main.DefinePrim("/foo", "Sphere")
            t = p.GetAttribute("radius").GetTypeName().GetType()
            XCTAssertEqual(t.GetTypeName(), "double")
        }
        XCTAssertEqual(t.GetTypeName(), "double")
    }
    
    func test_UsdObject_GetName() {
        var x: pxr.TfToken
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            let p = main.DefinePrim("/foo", "Sphere")
            x = p.GetName()
            XCTAssertEqual(x, "foo")
        }
        XCTAssertEqual(x, "foo")
    }
    
    func test_UsdGeomXformOp_GetAttr() {
        var x: pxr.UsdAttribute
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            main.DefinePrim("/foo", "Sphere")
            let p = pxr.UsdGeomXformable.Get(Overlay.TfWeakPtr(main), "/foo")
            let op = p.AddTranslateOp(.PrecisionDouble, "op1", false)
            x = op.GetAttr()
            XCTAssertTrue(Bool(x))
        }
        XCTAssertFalse(Bool(x))     
    }
    
    func test_SdfValueTypeName_GetRole() {
        var x: pxr.TfToken
        do {
            let typeName: pxr.SdfValueTypeName = .Color3f
            x = typeName.GetRole()
            XCTAssertEqual(x, "Color")
        }
        XCTAssertEqual(x, "Color")
    }
    
    func test_UsdStagePopulationMask_Add_UsdStagePopulationMask() {
        var x: pxr.UsdStagePopulationMask
        do {
            x = pxr.UsdStagePopulationMask(["/hi"])
            x.Add(pxr.UsdStagePopulationMask(["/there"]))
            XCTAssertEqual(x, pxr.UsdStagePopulationMask(["/hi", "/there"]))
        }
        XCTAssertEqual(x, pxr.UsdStagePopulationMask(["/hi", "/there"]))
    }
    
    func test_UsdStagePopulationMask_Add_SdfPath() {
        var x: pxr.UsdStagePopulationMask
        do {
            x = pxr.UsdStagePopulationMask(["/hi"])
            x.Add("/there")
            XCTAssertEqual(x, pxr.UsdStagePopulationMask(["/hi", "/there"]))
        }
        XCTAssertEqual(x, pxr.UsdStagePopulationMask(["/hi", "/there"]))
    }
    
    func test_UsdGeomPrimvar_GetAttr() {
        var x: pxr.UsdAttribute
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            let p = main.DefinePrim("/foo", "Mesh")
            let primvar = pxr.UsdGeomPrimvarsAPI(p).CreatePrimvar("st", .Float2Array, .UsdGeomTokens.vertex, -1)
            do {
                x = primvar.GetAttr()
                XCTAssertTrue(Bool(x))
                XCTAssertEqual(x.description, "attribute 'primvars:st' on 'Mesh' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@")
            }
            XCTAssertTrue(Bool(x))
            XCTAssertEqual(x.description, "attribute 'primvars:st' on 'Mesh' prim </foo> on stage with rootLayer @\(Overlay.Dereference(main.GetRootLayer()).GetIdentifier())@, sessionLayer @\(Overlay.Dereference(main.GetSessionLayer()).GetIdentifier())@")
        }
        XCTAssertFalse(Bool(x))
    }
    
    func test_TfType_FindByName() {
        var x: pxr.TfType!
        do {
            x = pxr.TfType.FindByName("UsdGeomCube")
        }
        XCTAssertEqual(x.GetTypeName(), "UsdGeomCube")
    }
    
    func test_TfError_GetCommentary() {
        Overlay.withTfErrorMark { mark in
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertEqual(Array(mark.errors).count, 1)
            // `Collection.first` isn't available on a `Sequence`
            var it = mark.errors.makeIterator()
            let error = it.next()!
            let commentary: std.string = error.GetCommentary()
            XCTAssertEqual(commentary, std.string("A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'"))
            
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
        }
    }
    
    func test_SdfAssetPathParams_Noop() {
        let path = pxr.SdfAssetPath(pxr.SdfAssetPathParams())
        XCTAssertEqual(path.GetAuthoredPath(), "")
        // Call GetAuthoredPath twice because it's unclear if Swift is calling the rvalue overload,
        // which is non-const and might mutate the path?
        XCTAssertEqual(path.GetAuthoredPath(), "")
        XCTAssertEqual(path.GetEvaluatedPath(), "")
        XCTAssertEqual(path.GetEvaluatedPath(), "")
        XCTAssertEqual(path.GetResolvedPath(), "")
        XCTAssertEqual(path.GetResolvedPath(), "")
    }
    
    func test_SdfAssetPathParams_Authored() {
        let path = pxr.SdfAssetPath(pxr.SdfAssetPathParams().Authored("authored"))
        XCTAssertEqual(path.GetAuthoredPath(), "authored")
        XCTAssertEqual(path.GetAuthoredPath(), "authored")
        XCTAssertEqual(path.GetEvaluatedPath(), "")
        XCTAssertEqual(path.GetEvaluatedPath(), "")
        XCTAssertEqual(path.GetResolvedPath(), "")
        XCTAssertEqual(path.GetResolvedPath(), "")
    }
    
    func test_SdfAssetPathParams_Evaluated() {
        let path = pxr.SdfAssetPath(pxr.SdfAssetPathParams().Evaluated("evaluated"))
        XCTAssertEqual(path.GetAuthoredPath(), "")
        XCTAssertEqual(path.GetAuthoredPath(), "")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetResolvedPath(), "")
        XCTAssertEqual(path.GetResolvedPath(), "")
    }
    
    func test_SdfAssetPathParams_Resolved() {
        let path = pxr.SdfAssetPath(pxr.SdfAssetPathParams().Resolved("resolved"))
        XCTAssertEqual(path.GetAuthoredPath(), "")
        XCTAssertEqual(path.GetAuthoredPath(), "")
        XCTAssertEqual(path.GetEvaluatedPath(), "")
        XCTAssertEqual(path.GetEvaluatedPath(), "")
        XCTAssertEqual(path.GetResolvedPath(), "resolved")
        XCTAssertEqual(path.GetResolvedPath(), "resolved")
    }
    
    func test_SdfAssetPathParams_AuthoredEvaluated() {
        let path = pxr.SdfAssetPath(pxr.SdfAssetPathParams().Authored("authored").Evaluated("evaluated"))
        XCTAssertEqual(path.GetAuthoredPath(), "authored")
        XCTAssertEqual(path.GetAuthoredPath(), "authored")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetResolvedPath(), "")
        XCTAssertEqual(path.GetResolvedPath(), "")
    }
    
    func test_SdfAssetPathParams_ResolvedEvaluated() {
        let path = pxr.SdfAssetPath(pxr.SdfAssetPathParams().Resolved("resolved").Evaluated("evaluated"))
        XCTAssertEqual(path.GetAuthoredPath(), "")
        XCTAssertEqual(path.GetAuthoredPath(), "")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetResolvedPath(), "resolved")
        XCTAssertEqual(path.GetResolvedPath(), "resolved")
    }
    
    func test_SdfAssetPathParams_EvaluatedAuthoredResolved() {
        let path = pxr.SdfAssetPath(pxr.SdfAssetPathParams().Evaluated("evaluated").Authored("authored").Resolved("resolved"))
        XCTAssertEqual(path.GetAuthoredPath(), "authored")
        XCTAssertEqual(path.GetAuthoredPath(), "authored")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetEvaluatedPath(), "evaluated")
        XCTAssertEqual(path.GetResolvedPath(), "resolved")
        XCTAssertEqual(path.GetResolvedPath(), "resolved")
    }
    
    func test_UsdProperty_GetName() {
        var x: pxr.TfToken!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            let prop = stage.GetPropertyAtPath("/foo.radius")
            x = prop.GetName()
        }
        XCTAssertEqual(x, "radius")
    }
    
    func test_UsdAttribute_GetName() {
        var x: pxr.TfToken!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            let attr = stage.GetAttributeAtPath("/foo.radius")
            x = attr.GetName()
        }
        XCTAssertEqual(x, "radius")
    }
    
    func test_UsdRelationship_GetName() {
        var x: pxr.TfToken!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            let rel = p.CreateRelationship("myrel", true)
            x = rel.GetName()
        }
        XCTAssertEqual(x, "myrel")
    }
    
    func test_UsdPrim_GetName() {
        var x: pxr.TfToken!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            x = p.GetName()
        }
        XCTAssertEqual(x, "foo")
    }

    func test_SdfAttributeSpec_GetName() {
        var x: std.string!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            p.CreateAttribute("myattr", .Bool, true, .SdfVariabilityVarying)
            let attrSpec = Overlay.Dereference(stage.GetRootLayer()).GetAttributeAtPath("/foo.myattr").pointee
            x = attrSpec.GetName()
        }
        XCTAssertEqual(x, "myattr")
    }
    
    func test_SdfRelationshipSpec_GetName() {
        var x: std.string!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            p.CreateRelationship("myrel", true)
            let relSpec = Overlay.Dereference(stage.GetRootLayer()).GetRelationshipAtPath("/foo.myrel").pointee
            x = relSpec.GetName()
        }
        XCTAssertEqual(x, "myrel")
    }
    
    func test_ArResolvedPath_GetPathString() {
        var x: std.string!
        do {
            let p: pxr.ArResolvedPath = pxr.ArResolvedPath("/foo/bar")
            x = p.GetPathString()
        }
        XCTAssertEqual(x, "/foo/bar")
    }

    func test_UsdObject_GetName_1() {
        var x: pxr.TfToken!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            let o = stage.GetObjectAtPath("/foo.radius")
            x = o.GetName()
        }
        XCTAssertEqual(x, "radius")
    }
    
    func test_SdfPrimSpec_GetName() {
        var x: std.string!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            let primSpec = Overlay.Dereference(stage.GetRootLayer()).GetPrimAtPath("/foo").pointee
            x = primSpec.GetName()
        }
        XCTAssertEqual(x, "foo")
    }
    
    func test_SdfPropertySpec_GetName() {
        var x: std.string!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let p = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
            p.CreateRelationship("myrel", true)
            let propSpec = Overlay.Dereference(stage.GetRootLayer()).GetPropertyAtPath("/foo.myrel").pointee
            x = propSpec.GetName()
        }
        XCTAssertEqual(x, "myrel")
    }
    
    func test_SdfFileFormat_GetFormatId() {
        var x: pxr.TfToken!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "main.usda"), .LoadAll))
            let fileFormat = Overlay.Dereference(Overlay.Dereference(stage.GetRootLayer()).GetFileFormat())
            x = fileFormat.GetFormatId()
        }
        XCTAssertEqual(x, "usda")
    }
    
    func test_SdfLayer_GetFileFormat() {
        var x: pxr.SdfFileFormat!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "main.usda"), .LoadAll))
            x = Overlay.Dereference(Overlay.Dereference(stage.GetRootLayer()).GetFileFormat())
        }
        XCTAssertTrue(x != nil)
        XCTAssertEqual(x.GetFormatId(), "usda")
    }
    
    func test_SdfLayer_GetRealPath() {
        var x: std.string!
        let p = pathForStage(named: "main.usda")
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(p, .LoadAll))
            let layer = Overlay.Dereference(stage.GetRootLayer())
            x = layer.GetRealPath()
        }
        XCTAssertEqual(x, p)
    }
    
    func test_NdrNode_GetInputNames() {
        #warning("added: const class std::vector<class PXR_NS::TfToken> & PXR_NS::NdrNode::GetInputNames() const; replaceConstRefFunctionWithCopyingWrapper;")
        func inner(_ x: pxr.NdrNode) {
            let y: pxr.TfTokenVector = x.GetInputNames()
            withExtendedLifetime(y) {}
        }
    }

    func test_UsdShadeInput_GetAttr() {
        #warning("added: const class PXR_NS::UsdAttribute & PXR_NS::UsdShadeInput::GetAttr() const; replaceConstRefFunctionWithCopyingWrapper;")
        func inner(_ x: pxr.UsdShadeInput) {
            let y: pxr.UsdAttribute = x.GetAttr()
            withExtendedLifetime(y) {}
        }
    }
    
    func test_UsdShadeOutput_GetAttr() {
        #warning("added: const class PXR_NS::UsdAttribute & PXR_NS::UsdShadeOutput::GetAttr() const; replaceConstRefFunctionWithCopyingWrapper;")
        func inner(_ x: pxr.UsdShadeOutput) {
            let y: pxr.UsdAttribute = x.GetAttr()
            withExtendedLifetime(y) {}
        }
    }
    
    func test_UsdShadeMaterialBindingAPI_DirectBinding_GetMaterialPath() {
        #warning("added: const class PXR_NS::SdfPath & PXR_NS::UsdShadeMaterialBindingAPI::DirectBinding::GetMaterialPath() const; replaceConstRefFunctionWithCopyingWrapper;")
        func inner(_ x: pxr.UsdShadeMaterialBindingAPI.DirectBinding) {
            let y: pxr.SdfPath = x.GetMaterialPath()
            withExtendedLifetime(y) {}
        }
    }

    func test_UsdShadeMaterialBindingAPI_CollectionBinding_GetMaterialPath() {
        #warning("added: const class PXR_NS::SdfPath & PXR_NS::UsdShadeMaterialBindingAPI::CollectionBinding::GetMaterialPath() const; replaceConstRefFunctionWithCopyingWrapper;")
        func inner(_ x: pxr.UsdShadeMaterialBindingAPI.CollectionBinding) {
            let y: pxr.SdfPath = x.GetMaterialPath()
            withExtendedLifetime(y) {}
        }
    }
    
    func test_UsdShadeMaterialBindingAPI_CollectionBinding_GetCollectionPath() {
        #warning("added: const class PXR_NS::SdfPath & PXR_NS::UsdShadeMaterialBindingAPI::CollectionBinding::GetCollectionPath() const; replaceConstRefFunctionWithCopyingWrapper;")
        func inner(_ x: pxr.UsdShadeMaterialBindingAPI.CollectionBinding) {
            let y: pxr.SdfPath = x.GetCollectionPath()
            withExtendedLifetime(y) {}
        }
    }
    
    func test_SdfPath_GetString() {
        let p: pxr.SdfPath = "/foo/bar"
        let s: std.string = p.GetString()
        XCTAssertEqual(s, "/foo/bar")
    }
}
