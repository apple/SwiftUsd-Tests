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

final class BoolInitTests: TemporaryDirectoryHelper {
    fileprivate func helper_singleApply(_ token: pxr.TfToken, _ apiSchemas: pxr.TfToken..., code: (pxr.UsdPrim) -> (Bool)) {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/prim", token)
        apiSchemas.forEach { prim.ApplyAPI($0) }
        XCTAssertTrue(code(prim))
    }

    fileprivate func helper_multipleApply(_ token: pxr.TfToken, _ apiSchema: pxr.TfToken, _ name: pxr.TfToken, code: (pxr.UsdPrim) -> (Bool)) {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/prim", token)
        prim.ApplyAPI(apiSchema, name)
        XCTAssertTrue(code(prim))
    }
    
    // MARK: Pointers
    
    func test_UsdStageRefPtr() {
        XCTAssertFalse(Bool(pxr.UsdStageRefPtr()))
        var stage: pxr.UsdStageRefPtr!
        do {
            stage = pxr.UsdStage.CreateInMemory(.LoadAll)
            XCTAssertTrue(Bool(stage))
        }
        XCTAssertTrue(Bool(stage))
        stage.Reset()
        XCTAssertFalse(Bool(stage))
    }
    
    func test_SdfLayerHandle() {
        XCTAssertFalse(Bool(pxr.SdfLayerHandle()))
        var layer: pxr.SdfLayerHandle!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            layer = stage.GetRootLayer()
            XCTAssertTrue(Bool(layer))
        }
        XCTAssertFalse(Bool(layer))
    }
    
    func test_UsdStagePtr() {
        XCTAssertFalse(Bool(pxr.UsdStagePtr()))
        var stage: pxr.UsdStagePtr!
        do {
            let strongStage = pxr.UsdStage.CreateInMemory(.LoadAll)
            stage = Overlay.TfWeakPtr(strongStage)
            XCTAssertTrue(Bool(stage))
        }
        XCTAssertFalse(Bool(stage))
    }
    
    func test_SdfLayerRefPtr() {
        XCTAssertFalse(Bool(pxr.SdfLayerRefPtr()))
        var layer: pxr.SdfLayerRefPtr!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            layer = Overlay.TfRefPtr(stage.GetRootLayer())
            XCTAssertTrue(Bool(layer))
        }
        XCTAssertTrue(Bool(layer))
        layer.Reset()
        XCTAssertFalse(Bool(layer))
    }
    
    // MARK: Specs
    
    func test_SdfPrimSpecHandle() {
        XCTAssertFalse(Bool(pxr.SdfPrimSpecHandle()))
        var primSpec: pxr.SdfPrimSpecHandle!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            stage.DefinePrim("/foo", "Cube")
            let layer = Overlay.Dereference(stage.GetRootLayer())
            primSpec = layer.GetPrimAtPath("/foo")
            XCTAssertTrue(Bool(primSpec))
        }
        XCTAssertFalse(Bool(primSpec))
    }
    
    // MARK: Objects
    
    func test_UsdObject() {
        XCTAssertFalse(Bool(pxr.UsdObject()))
        var object: pxr.UsdObject!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/foo")
            object = stage.GetObjectAtPath("/foo")
            XCTAssertTrue(Bool(object))
        }
        XCTAssertFalse(Bool(object))
    }
    
    func test_UsdPrim() {
        XCTAssertFalse(Bool(pxr.UsdPrim()))
        var prim: pxr.UsdPrim!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/foo")
            prim = stage.GetPrimAtPath("/foo")
            XCTAssertTrue(Bool(prim))
        }
        XCTAssertFalse(Bool(prim))
    }
    
    func test_UsdProperty() {
        XCTAssertFalse(Bool(pxr.UsdAttribute()))
        var property: pxr.UsdProperty!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/foo")
            property = stage.GetPropertyAtPath("/foo.primvars:displayColor")
            XCTAssertTrue(Bool(property))
        }
        XCTAssertFalse(Bool(property))
    }
    
    func test_UsdAttribute() {
        XCTAssertFalse(Bool(pxr.UsdAttribute()))
        var attribute: pxr.UsdAttribute!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let cube = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/foo")
            attribute = cube.GetDisplayColorAttr()
            XCTAssertTrue(Bool(attribute))
        }
        XCTAssertFalse(Bool(attribute))
    }
    
    func test_UsdRelationship() {
        XCTAssertFalse(Bool(pxr.UsdRelationship()))
        var relationship: pxr.UsdRelationship!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let cube = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/foo")
            relationship = Overlay.GetPrim(cube).CreateRelationship("myRel", true)
            XCTAssertTrue(Bool(relationship))
        }
        XCTAssertFalse(Bool(relationship))
    }
    
    func test_UsdShadeInput() {
        XCTAssertFalse(Bool(pxr.UsdShadeInput()))
        var input: pxr.UsdShadeInput!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            var shader = pxr.UsdShadeShader.Define(Overlay.TfWeakPtr(stage), "/shader")
            input = shader.CreateInput("roughness", .Float)
            XCTAssertTrue(Bool(input))
        }
        XCTAssertFalse(Bool(input))
    }
    
    func test_UsdShadeOutput() {
        XCTAssertFalse(Bool(pxr.UsdShadeOutput()))
        var output: pxr.UsdShadeOutput!
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            var shader = pxr.UsdShadeShader.Define(Overlay.TfWeakPtr(stage), "/shader")
            output = shader.CreateOutput("rgb", .Float3)
            XCTAssertTrue(Bool(output))
        }
        XCTAssertFalse(Bool(output))
    }
    
    func test_UsdGeomXformOp() {
        XCTAssertFalse(Bool(pxr.UsdGeomXformOp()))
        var op: pxr.UsdGeomXformOp!
        do {
            let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
            main.DefinePrim("/foo", "Sphere")
            let p = pxr.UsdGeomXformable.Get(Overlay.TfWeakPtr(main), "/foo")
            op = p.AddTranslateOp(.PrecisionDouble, "op1", false)
            XCTAssertTrue(Bool(op))
        }
        XCTAssertFalse(Bool(op))
    }
    
    func test_ArResolvedPath() {
        XCTAssertFalse(Bool(pxr.ArResolvedPath()))
        XCTAssertTrue(Bool(pxr.ArResolvedPath(pathForStage(named: "Main.usda"))))
    }
    
    func test_UsdZipFile() {
        XCTAssertFalse(Bool(pxr.UsdZipFile()))
        XCTAssertTrue(Bool(pxr.UsdZipFile.Open(std.string(urlForResource(subPath: "Wrapping/usdzipfileiteratorwrapper.usdz").relativePath))))
        XCTAssertFalse(Bool(pxr.UsdZipFile.Open("/this/path/doesnt/exist.usdz")))
    }
    
    // MARK: Schemas
    
    // Usd schemas
            
    func test_UsdClipsAPI() {
        var x = pxr.UsdClipsAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_multipleApply(.UsdGeomTokens.Cube, .UsdTokens.ClipsAPI, "test") { x = pxr.UsdClipsAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }

    func test_UsdCollectionAPI() {
        var x = pxr.UsdCollectionAPI(pxr.UsdPrim(), "test")
        XCTAssertFalse(Bool(x))
        helper_multipleApply(.UsdGeomTokens.Cube, .UsdTokens.CollectionAPI, "test") { x = pxr.UsdCollectionAPI($0, "test"); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdModelAPI() {
        var x = pxr.UsdModelAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdTokens.ModelAPI) { x = pxr.UsdModelAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdSchemaBase() {
        var x = pxr.UsdSchemaBase(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube) { x = pxr.UsdSchemaBase($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdTyped() {
        var x = pxr.UsdTyped(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube) { x = pxr.UsdTyped($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdGeom schemas
    
    func test_UsdGeomBasisCurves() {
        var x = pxr.UsdGeomBasisCurves(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.BasisCurves) { x = pxr.UsdGeomBasisCurves($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomBoundable() {
        var x = pxr.UsdGeomBoundable(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube) { x = pxr.UsdGeomBoundable($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCamera() {
        var x = pxr.UsdGeomCamera(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Camera) { x = pxr.UsdGeomCamera($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCapsule() {
        var x = pxr.UsdGeomCapsule(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Capsule) { x = pxr.UsdGeomCapsule($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCapsule_1() {
        var x = pxr.UsdGeomCapsule_1(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Capsule_1) { x = pxr.UsdGeomCapsule_1($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCone() {
        var x = pxr.UsdGeomCone(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cone) { x = pxr.UsdGeomCone($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCube() {
        var x = pxr.UsdGeomCube(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube) { x = pxr.UsdGeomCube($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCurves() {
        var x = pxr.UsdGeomCurves(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.BasisCurves) { x = pxr.UsdGeomCurves($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCylinder() {
        var x = pxr.UsdGeomCylinder(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cylinder) { x = pxr.UsdGeomCylinder($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomCylinder_1() {
        var x = pxr.UsdGeomCylinder_1(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cylinder_1) { x = pxr.UsdGeomCylinder_1($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomGprim() {
        var x = pxr.UsdGeomGprim(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube) { x = pxr.UsdGeomGprim($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomHermiteCurves() {
        var x = pxr.UsdGeomHermiteCurves(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.HermiteCurves) { x = pxr.UsdGeomHermiteCurves($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomImageable() {
        var x = pxr.UsdGeomImageable(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube) { x = pxr.UsdGeomImageable($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomMesh() {
        var x = pxr.UsdGeomMesh(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Mesh) { x = pxr.UsdGeomMesh($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomModelAPI() {
        var x = pxr.UsdGeomModelAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.GeomModelAPI) { x = pxr.UsdGeomModelAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomMotionAPI() {
        var x = pxr.UsdGeomMotionAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.MotionAPI) { x = pxr.UsdGeomMotionAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomNurbsCurves() {
        var x = pxr.UsdGeomNurbsCurves(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.NurbsCurves) { x = pxr.UsdGeomNurbsCurves($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomNurbsPatch() {
        var x = pxr.UsdGeomNurbsPatch(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.NurbsPatch) { x = pxr.UsdGeomNurbsPatch($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomPlane() {
        var x = pxr.UsdGeomPlane(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Plane) { x = pxr.UsdGeomPlane($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomPointBased() {
        var x = pxr.UsdGeomPointBased(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Mesh) { x = pxr.UsdGeomPointBased($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomPointInstancer() {
        var x = pxr.UsdGeomPointInstancer(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.PointInstancer) { x = pxr.UsdGeomPointInstancer($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomPoints() {
        var x = pxr.UsdGeomPoints(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Points) { x = pxr.UsdGeomPoints($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomPrimvarsAPI() {
        var x = pxr.UsdGeomPrimvarsAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.PrimvarsAPI) { x = pxr.UsdGeomPrimvarsAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomScope() {
        var x = pxr.UsdGeomScope(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Scope) { x = pxr.UsdGeomScope($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomSphere() {
        var x = pxr.UsdGeomSphere(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Sphere) { x = pxr.UsdGeomSphere($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomSubset() {
        var x = pxr.UsdGeomSubset(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.GeomSubset) { x = pxr.UsdGeomSubset($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomTetMesh() {
        var x = pxr.UsdGeomTetMesh(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.TetMesh) { x = pxr.UsdGeomTetMesh($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomVisibilityAPI() {
        var x = pxr.UsdGeomVisibilityAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.VisibilityAPI) { x = pxr.UsdGeomVisibilityAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomXform() {
        var x = pxr.UsdGeomXform(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Xform) { x = pxr.UsdGeomXform($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomXformable() {
        var x = pxr.UsdGeomXformable(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube) { x = pxr.UsdGeomXformable($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdGeomXformCommonAPI() {
        var x = pxr.UsdGeomXformCommonAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.XformCommonAPI) { x = pxr.UsdGeomXformCommonAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdHydra schemas
    
    func test_UsdHydraGenerativeProceduralAPI() {
        var x = pxr.UsdHydraGenerativeProceduralAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdHydraTokens.HydraGenerativeProceduralAPI) { x = pxr.UsdHydraGenerativeProceduralAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdLux schemas
    
    func test_UsdLuxBoundableLightBase() {
        var x = pxr.UsdLuxBoundableLightBase(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.SphereLight) { x = pxr.UsdLuxBoundableLightBase($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxCylinderLight() {
        var x = pxr.UsdLuxCylinderLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.CylinderLight) { x = pxr.UsdLuxCylinderLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxDiskLight() {
        var x = pxr.UsdLuxDiskLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.DiskLight) { x = pxr.UsdLuxDiskLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxDistantLight() {
        var x = pxr.UsdLuxDistantLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.DistantLight) { x = pxr.UsdLuxDistantLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxDomeLight() {
        var x = pxr.UsdLuxDomeLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.DomeLight) { x = pxr.UsdLuxDomeLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxDomeLight_1() {
        var x = pxr.UsdLuxDomeLight_1(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.DomeLight_1) { x = pxr.UsdLuxDomeLight_1($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxGeometryLight() {
        var x = pxr.UsdLuxGeometryLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.GeometryLight) { x = pxr.UsdLuxGeometryLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxLightAPI() {
        var x = pxr.UsdLuxLightAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.LightAPI) { x = pxr.UsdLuxLightAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxLightListAPI() {
        var x = pxr.UsdLuxLightListAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.LightListAPI) { x = pxr.UsdLuxLightListAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxLightFilter() {
        var x = pxr.UsdLuxLightFilter(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.LightFilter) { x = pxr.UsdLuxLightFilter($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxListAPI() {
        var x = pxr.UsdLuxListAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.ListAPI) { x = pxr.UsdLuxListAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxMeshLightAPI() {
        var x = pxr.UsdLuxMeshLightAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.MeshLightAPI) { x = pxr.UsdLuxMeshLightAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxNonboundableLightBase() {
        var x = pxr.UsdLuxNonboundableLightBase(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.DomeLight, .UsdLuxTokens.NonboundableLightBase) { x = pxr.UsdLuxNonboundableLightBase($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxPluginLight() {
        var x = pxr.UsdLuxPluginLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.PluginLight) { x = pxr.UsdLuxPluginLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxPluginLightFilter() {
        var x = pxr.UsdLuxPluginLightFilter(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.PluginLightFilter) { x = pxr.UsdLuxPluginLightFilter($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxPortalLight() {
        var x = pxr.UsdLuxPortalLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.PortalLight) { x = pxr.UsdLuxPortalLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxRectLight() {
        var x = pxr.UsdLuxRectLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.RectLight) { x = pxr.UsdLuxRectLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxShadowAPI() {
        var x = pxr.UsdLuxShadowAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.ShadowAPI) { x = pxr.UsdLuxShadowAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxShapingAPI() {
        var x = pxr.UsdLuxShapingAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.ShapingAPI) { x = pxr.UsdLuxShapingAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxSphereLight() {
        var x = pxr.UsdLuxSphereLight(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdLuxTokens.SphereLight) { x = pxr.UsdLuxSphereLight($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdLuxVolumeLightAPI() {
        var x = pxr.UsdLuxVolumeLightAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.VolumeLightAPI) { x = pxr.UsdLuxVolumeLightAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdMedia schemas
    
    func test_UsdMediaAssetPreviewsAPI() {
        var x = pxr.UsdMediaAssetPreviewsAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdMediaTokens.AssetPreviewsAPI) { x = pxr.UsdMediaAssetPreviewsAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdMediaSpatialAudio() {
        var x = pxr.UsdMediaSpatialAudio(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdMediaTokens.SpatialAudio) { x = pxr.UsdMediaSpatialAudio($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdPhysics schemas
    
    func test_UsdPhysicsArticulationRootAPI() {
        var x = pxr.UsdPhysicsArticulationRootAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsArticulationRootAPI) { x = pxr.UsdPhysicsArticulationRootAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsCollisionAPI() {
        var x = pxr.UsdPhysicsCollisionAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsCollisionAPI) { x = pxr.UsdPhysicsCollisionAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsCollisionGroup() {
        var x = pxr.UsdPhysicsCollisionGroup(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsCollisionGroup) { x = pxr.UsdPhysicsCollisionGroup($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsDistanceJoint() {
        var x = pxr.UsdPhysicsDistanceJoint(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsDistanceJoint) { x = pxr.UsdPhysicsDistanceJoint($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsDriveAPI() {
        var x = pxr.UsdPhysicsDriveAPI(pxr.UsdPrim(), "test")
        XCTAssertFalse(Bool(x))
        helper_multipleApply(.UsdPhysicsTokens.PhysicsRevoluteJoint, .UsdPhysicsTokens.PhysicsDriveAPI, "test") { x = pxr.UsdPhysicsDriveAPI($0, "test"); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsFilteredPairsAPI() {
        var x = pxr.UsdPhysicsFilteredPairsAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsFilteredPairsAPI) { x = pxr.UsdPhysicsFilteredPairsAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsFixedJoint() {
        var x = pxr.UsdPhysicsFixedJoint(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsFixedJoint) { x = pxr.UsdPhysicsFixedJoint($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsJoint() {
        var x = pxr.UsdPhysicsJoint(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsFixedJoint) { x = pxr.UsdPhysicsJoint($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsLimitAPI() {
        var x = pxr.UsdPhysicsLimitAPI(pxr.UsdPrim(), "test")
        XCTAssertFalse(Bool(x))
        helper_multipleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsLimitAPI, "test") { x = pxr.UsdPhysicsLimitAPI($0, "test"); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsMassAPI() {
        var x = pxr.UsdPhysicsMassAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsMassAPI) { x = pxr.UsdPhysicsMassAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsMaterialAPI() {
        var x = pxr.UsdPhysicsMaterialAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsMaterialAPI) { x = pxr.UsdPhysicsMaterialAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsMeshCollisionAPI() {
        var x = pxr.UsdPhysicsMeshCollisionAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Mesh, .UsdPhysicsTokens.PhysicsMeshCollisionAPI) { x = pxr.UsdPhysicsMeshCollisionAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsPrismaticJoint() {
        var x = pxr.UsdPhysicsPrismaticJoint(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsPrismaticJoint) { x = pxr.UsdPhysicsPrismaticJoint($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsRevoluteJoint() {
        var x = pxr.UsdPhysicsRevoluteJoint(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsRevoluteJoint) { x = pxr.UsdPhysicsRevoluteJoint($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsRigidBodyAPI() {
        var x = pxr.UsdPhysicsRigidBodyAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsRigidBodyAPI) { x = pxr.UsdPhysicsRigidBodyAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsScene() {
        var x = pxr.UsdPhysicsScene(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsScene) { x = pxr.UsdPhysicsScene($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdPhysicsSphericalJoint() {
        var x = pxr.UsdPhysicsSphericalJoint(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdPhysicsTokens.PhysicsSphericalJoint) { x = pxr.UsdPhysicsSphericalJoint($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdProc schemas
    
    func test_UsdProcGenerativeProcedural() {
        var x = pxr.UsdProcGenerativeProcedural(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdProcTokens.GenerativeProcedural) { x = pxr.UsdProcGenerativeProcedural($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdRender schemas
        
    func test_UsdRenderPass() {
        var x = pxr.UsdRenderPass(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdRenderTokens.RenderPass) { x = pxr.UsdRenderPass($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdRenderProduct() {
        var x = pxr.UsdRenderProduct(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdRenderTokens.RenderProduct) { x = pxr.UsdRenderProduct($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdRenderSettings() {
        var x = pxr.UsdRenderSettings(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdRenderTokens.RenderSettings) { x = pxr.UsdRenderSettings($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdRenderSettingsBase() {
        var x = pxr.UsdRenderSettingsBase(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdRenderTokens.RenderSettings) { x = pxr.UsdRenderSettingsBase($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdRenderVar() {
        var x = pxr.UsdRenderVar(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdRenderTokens.RenderVar) { x = pxr.UsdRenderVar($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdRi schemas
    
    func test_UsdRiMaterialAPI() {
        var x = pxr.UsdRiMaterialAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdRiTokens.RiMaterialAPI) { x = pxr.UsdRiMaterialAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdRiSplineAPI() {
        var x = pxr.UsdRiSplineAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdRiTokens.RiSplineAPI) { x = pxr.UsdRiSplineAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdRiStatementsAPI() {
        var x = pxr.UsdRiStatementsAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdRiTokens.StatementsAPI) { x = pxr.UsdRiStatementsAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdShade schemas
    
    func test_UsdShadeConnectableAPI() {
        var x = pxr.UsdShadeConnectableAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdShadeTokens.Shader) { x = pxr.UsdShadeConnectableAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdShadeCoordSysAPI() {
        var x = pxr.UsdShadeCoordSysAPI(pxr.UsdPrim(), "test")
        XCTAssertFalse(Bool(x))
        helper_multipleApply(.UsdShadeTokens.Shader, .UsdShadeTokens.CoordSysAPI, "test") { x = pxr.UsdShadeCoordSysAPI($0, "test"); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdShadeMaterial() {
        var x = pxr.UsdShadeMaterial(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdShadeTokens.Material) { x = pxr.UsdShadeMaterial($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdShadeMaterialBindingAPI() {
        var x = pxr.UsdShadeMaterialBindingAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdShadeTokens.Shader, .UsdShadeTokens.MaterialBindingAPI) { x = pxr.UsdShadeMaterialBindingAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdShadeNodeDefAPI() {
        var x = pxr.UsdShadeNodeDefAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdShadeTokens.Shader, .UsdShadeTokens.NodeDefAPI) { x = pxr.UsdShadeNodeDefAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdShadeNodeGraph() {
        var x = pxr.UsdShadeNodeGraph(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdShadeTokens.NodeGraph) { x = pxr.UsdShadeNodeGraph($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdShadeShader() {
        var x = pxr.UsdShadeShader(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdShadeTokens.Shader) { x = pxr.UsdShadeShader($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdSkel schemas
    
    func test_UsdSkelAnimation() {
        var x = pxr.UsdSkelAnimation(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdSkelTokens.SkelAnimation) { x = pxr.UsdSkelAnimation($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdSkelBindingAPI() {
        var x = pxr.UsdSkelBindingAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Mesh, .UsdSkelTokens.SkelBindingAPI) { x = pxr.UsdSkelBindingAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdSkelBlendShape() {
        var x = pxr.UsdSkelBlendShape(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdSkelTokens.BlendShape) { x = pxr.UsdSkelBlendShape($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdSkelRoot() {
        var x = pxr.UsdSkelRoot(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdSkelTokens.SkelRoot) { x = pxr.UsdSkelRoot($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdSkelSkeleton() {
        var x = pxr.UsdSkelSkeleton(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdSkelTokens.Skeleton) { x = pxr.UsdSkelSkeleton($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdUI schemas
    
    func test_UsdUIBackdrop() {
        var x = pxr.UsdUIBackdrop(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdUITokens.Backdrop) { x = pxr.UsdUIBackdrop($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdUINodeGraphNodeAPI() {
        var x = pxr.UsdUINodeGraphNodeAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Cube, .UsdUITokens.NodeGraphNodeAPI) { x = pxr.UsdUINodeGraphNodeAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdUISceneGraphPrimAPI() {
        var x = pxr.UsdUISceneGraphPrimAPI(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdGeomTokens.Sphere, .UsdUITokens.SceneGraphPrimAPI) { x = pxr.UsdUISceneGraphPrimAPI($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    // UsdVol
    
    func test_UsdVolFieldAsset() {
        var x = pxr.UsdVolFieldAsset(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdVolTokens.OpenVDBAsset) { x = pxr.UsdVolFieldAsset($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdVolFieldBase() {
        var x = pxr.UsdVolFieldBase(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdVolTokens.OpenVDBAsset) { x = pxr.UsdVolFieldBase($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdVolField3DAsset() {
        var x = pxr.UsdVolField3DAsset(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdVolTokens.Field3DAsset) { x = pxr.UsdVolField3DAsset($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdVolOpenVDBAsset() {
        var x = pxr.UsdVolOpenVDBAsset(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdVolTokens.OpenVDBAsset) { x = pxr.UsdVolOpenVDBAsset($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }
    
    func test_UsdVolVolume() {
        var x = pxr.UsdVolVolume(pxr.UsdPrim())
        XCTAssertFalse(Bool(x))
        helper_singleApply(.UsdVolTokens.Volume) { x = pxr.UsdVolVolume($0); return Bool(x) }
        XCTAssertFalse(Bool(x))
    }

//    func test_Usd<#_FOO_#>() {
//        var x = pxr.Usd<#_FOO_#>(pxr.UsdPrim())
//        XCTAssertFalse(Bool(x))
//        helper_singleApply(.Usd<#FOO#>Tokens.<#Foo#>) { x = pxr.Usd<#Foo#>($0); return Bool(x) }
//        XCTAssertFalse(Bool(x))
//    }
    
//    func test_Usd<#_FOO_#>API() {
//        var x = pxr.Usd<#_FOO_#>API(pxr.UsdPrim())
//        XCTAssertFalse(Bool(x))
//        helper_singleApply(.UsdGeomTokens.Cube, .Usd<#BAR#>Tokens.<#FOO#>API) { x = pxr.Usd<#Foo#>API($0); return Bool(x) }
//        XCTAssertFalse(Bool(x))
//    }
}
