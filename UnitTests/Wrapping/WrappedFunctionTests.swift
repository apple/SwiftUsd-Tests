//===----------------------------------------------------------------------===//
// This source file is part of github.com/apple/SwiftUsd-Tests
//
// Copyright © 2025 Apple Inc. and the SwiftUsd-Tests project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0
//===----------------------------------------------------------------------===//

import XCTest
import OpenUSD

final class WrappedFunctionTests: TemporaryDirectoryHelper {
    func test_CopyTextureGpuToCpu() {
        // omitted due to CopyTextureGpuToCpu being removed in the future
    }
    
    func test_CreateExtentAttr() {
        // omitted due to Tutorials coverage and Create vs Get discussion
    }
    
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    func test_GetDescriptor() {
        let f: (pxr.HgiTextureHandle) -> pxr.HgiTextureDesc = Overlay.GetDescriptor
        withExtendedLifetime(f) {}
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    
    func test_GetStage() {
        var stage2: pxr.UsdStage!
        
        do {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let attr = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage1), "/myprim").GetDisplayColorAttr()
            stage2 = Overlay.Dereference(Overlay.GetStage(attr))
        }
        assertOpen("HelloWorld.usda")
        stage2.SetStartTimeCode(5)
    }
    
    func test_GetXformAsAttr() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let cube = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myprim")
        let xformOp = cube.AddTranslateOp(Overlay.UsdGeomXformOp.PrecisionDouble, pxr.TfToken("test"), false)
        let attr1 = Overlay.GetAttr(xformOp)
        let attr2 = stage.GetAttributeAtPath("/myprim.xformOp:translate:test")
        XCTAssertEqual(attr1, attr2)
    }
    
    func test_GfMatrix4dMultiply() {
        // Rotate around the Y axis by +90 degrees
        let l = pxr.GfMatrix4d(0, 0, -1, 0,
                               0, 1, 0, 0,
                               1, 0, 0, 0,
                               0, 0, 0, 1)
        
        // Translate (4, 5, 6)
        let r = pxr.GfMatrix4d(1, 0, 0, 4,
                               0, 1, 0, 5,
                               0, 0, 1, 6,
                               0, 0, 0, 1)
        
        // Translate, then rotate globally
        let lr = pxr.GfMatrix4d(0, 0, -1, -6,
                                0, 1, 0, 5,
                                1, 0, 0, 4,
                                0, 0, 0, 1)
        
        // Rotate, then translate globally
        let rl = pxr.GfMatrix4d(0, 0, -1, 4,
                                0, 1, 0, 5,
                                1, 0, 0, 6,
                                0, 0, 0, 1)
        
        XCTAssertTrue(l * r == lr)
        XCTAssertTrue(r * l == rl)
    }
    
    func test_GfRotationMultiply() {
        // Y+90
        let l = pxr.GfRotation(pxr.GfVec3d(0, 1, 0), 90)
        // X+90
        let r = pxr.GfRotation(pxr.GfVec3d(1, 0, 0), 90)
        
        
        assertEqual(l.TransformDir(pxr.GfVec3d(1, 0, 0)), pxr.GfVec3d(0, 0, -1), accuracy: pxr.GfVec3d(0.001))
        assertEqual(l.TransformDir(pxr.GfVec3d(0, 1, 0)), pxr.GfVec3d(0, 1, 0), accuracy: pxr.GfVec3d(0.001))
        assertEqual(l.TransformDir(pxr.GfVec3d(0, 0, 1)), pxr.GfVec3d(1, 0, 0), accuracy: pxr.GfVec3d(0.001))

        
        // Rotate Y, then rotate X locally
        let lr = l * r
        assertEqual(lr.TransformDir(pxr.GfVec3d(1, 0, 0)), pxr.GfVec3d(0, 1, 0), accuracy: pxr.GfVec3d(0.001))
        assertEqual(lr.TransformDir(pxr.GfVec3d(0, 1, 0)), pxr.GfVec3d(0, 0, 1), accuracy: pxr.GfVec3d(0.001))
        assertEqual(lr.TransformDir(pxr.GfVec3d(0, 0, 1)), pxr.GfVec3d(1, 0, 0), accuracy: pxr.GfVec3d(0.001))
        
        // Rotate X, then rotate Y locally
        let rl = r * l
        assertEqual(rl.TransformDir(pxr.GfVec3d(1, 0, 0)), pxr.GfVec3d(0, 0, -1), accuracy: pxr.GfVec3d(0.001))
        assertEqual(rl.TransformDir(pxr.GfVec3d(0, 1, 0)), pxr.GfVec3d(1, 0, 0), accuracy: pxr.GfVec3d(0.001))
        assertEqual(rl.TransformDir(pxr.GfVec3d(0, 0, 1)), pxr.GfVec3d(0, -1, 0), accuracy: pxr.GfVec3d(0.001))
    }
    
    func assertEqual(_ l: pxr.GfVec3d, _ r: pxr.GfVec3d, accuracy: pxr.GfVec3d) {
        if (l - r).GetLengthSq() <= accuracy.GetLengthSq() {
            // pass
        } else {
            XCTFail("XCTAssertEqual failed: (\(l) is not equal to \(r) with accuracy \(accuracy))")
        }
    }
    
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT) && canImport(Metal)
    func test_HgiTextureHandleGetTextureId() {
        let f: (pxr.HgiTextureHandle) -> MTLTexture? = Overlay.HgiTextureHandleGetTextureId
        withExtendedLifetime(f) {}
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT) && canImport(Metal)
    
    func test_halfToFloat() {
        XCTAssertEqual(Float(pxr.GfHalf(0.25) + pxr.GfHalf(0.0625)), 0.3125)
    }
    
    func test_allowedTokensForAttribute() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let cube = pxr.UsdGeomCube.Define(Overlay.TfWeakPtr(stage), "/myprim")
        
        let visAttr = cube.GetVisibilityAttr()
        var tokens = pxr.VtTokenArray()
        XCTAssertTrue(Overlay.allowedTokensForAttribute(visAttr, &tokens))
        XCTAssertEqual(tokens, ["inherited", "invisible"])
        
        let extentAttr = cube.GetExtentAttr()
        tokens = []
        XCTAssertFalse(Overlay.allowedTokensForAttribute(extentAttr, &tokens))
    }

    func test_setBoolForAttr_succeeds() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let plane = pxr.UsdGeomPlane.Define(Overlay.TfWeakPtr(stage), "/plane")
        let attr = plane.GetDoubleSidedAttr()
        #if compiler(<6)
        attr.Set(false as ObjCBool, 4)
        #else
        attr.Set(false, 4)
        #endif
        var success = false
        var result = false
        success = attr.Get(&result, 4)
        XCTAssertTrue(success)
        XCTAssertFalse(result)
    }
    
    func test_setBoolForAttr_fails() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let plane = pxr.UsdGeomPlane.Define(Overlay.TfWeakPtr(stage), "/plane")
        let attr = plane.GetDisplayColorAttr()
        #if compiler(<6)
        attr.Set(false as ObjCBool, 4)
        #else
        attr.Set(false, 4)
        #endif
        var success = false
        var result = false
        success = attr.Get(&result, 4)
        XCTAssertFalse(success)
    }
    
    func test_UsdAttribute_Get_VtValue() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let sphere = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(stage), "/sphere")
        let attr = sphere.GetRadiusAttr()
        var value: pxr.VtValue = pxr.VtValue()
        attr.Set(5.0, .Default())
        XCTAssertTrue(Overlay.Get(attr, &value, .Default()))
        XCTAssertEqual(value, pxr.VtValue(5.0))
    }
    
    func test_UsdAttribute_Set_VtValue() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let sphere = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(stage), "/sphere")
        let attr = sphere.GetRadiusAttr()
        let value: pxr.VtValue = pxr.VtValue(5.0)
        XCTAssertTrue(Overlay.Set(attr, value, .Default()))
        var radius = 0.0
        XCTAssertTrue(attr.Get(&radius, .Default()))
        XCTAssertEqual(radius, 5.0)
    }
    
    func test_GfMatrix4d_MakeTranslate() {
        XCTAssertEqual(pxr.GfMatrix4d.MakeTranslate(pxr.GfVec3d(3, 1, 4)),
                       pxr.GfMatrix4d(1, 0, 0, 0,
                                      0, 1, 0, 0,
                                      0, 0, 1, 0,
                                      3, 1, 4, 1))
    }
    
    func test_GfMatrix4d_MakeRotate() {
        assertEqualMatrix4d(pxr.GfMatrix4d.MakeRotate(pxr.GfRotation(pxr.GfVec3d(0, 0, 1), 90)),
                            pxr.GfMatrix4d(0, 1, 0, 0,
                                           -1, 0, 0, 0,
                                           0, 0, 1, 0,
                                           0, 0, 0, 1),
                            accuracy: 0.0001
        )
    }
    
    func assertEqualMatrix4d(_ l: pxr.GfMatrix4d, _ r: pxr.GfMatrix4d, accuracy: Double) {
        for i in 0..<3 {
            for j in 0..<3 {
                if Swift.abs(l[i][j] - r[i][j]) >= accuracy {
                    XCTFail("XCTAssertEqual failed: (\(l) is not equal to \(r) with accuracy \(accuracy))")
                    return
                }
            }
        }
    }
    
    func test_SdfLayer_ExportToString() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "Cube")
        let s: String? = Overlay.Dereference(stage.GetRootLayer()).ExportToString()
        XCTAssertEqual(s!, try contentsOfResource(subPath: "Wrapping/Function/SdfLayer_ExportToString.txt"))
    }
    
    func test_UsdStage_ExportToString_true() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "Cube")
        let s: String? = stage.ExportToString(addSourceFileComment: true)
        XCTAssertEqual(s!, try contentsOfResource(subPath: "Wrapping/Function/UsdStage_ExportToString_true.txt"))
    }
    
    func test_UsdStage_ExportToString_false() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "Cube")
        let s: String? = stage.ExportToString(addSourceFileComment: false)
        XCTAssertEqual(s!, try contentsOfResource(subPath: "Wrapping/Function/UsdStage_ExportToString_false.txt"))
    }

    func test_UsdStage_ExportToString_default() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "Cube")
        let s: String? = stage.ExportToString()
        XCTAssertEqual(s!, try contentsOfResource(subPath: "Wrapping/Function/UsdStage_ExportToString_default.txt"))
    }

    func test_UsdGeomXformOp_GetOpType() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let xformable = pxr.UsdGeomXformable(stage.DefinePrim("/foo", "Cube"))
        
        #if os(Linux)
        #warning("GetOpType on an invalid xform op is disabled on Linux")
        // https://github.com/PixarAnimationStudios/OpenUSD/issues/3559
        #else
        let invalid = xformable.GetTranslateOp("", false).GetOpType()
        XCTAssertEqual(invalid, .TypeInvalid)
        #endif // #if os(Linux)
        
        let translateOp = xformable.AddTranslateOp(.PrecisionDouble, "", false)
        let scaleOp = xformable.AddScaleOp(.PrecisionFloat, "", false)
        let rotateXOp = xformable.AddRotateXOp(.PrecisionFloat, "", false)
        let rotateYOp = xformable.AddRotateYOp(.PrecisionFloat, "", false)
        let rotateZOp = xformable.AddRotateZOp(.PrecisionFloat, "", false)
        let rotateXYZOp = xformable.AddRotateXYZOp(.PrecisionFloat, "", false)
        let rotateXZYOp = xformable.AddRotateXZYOp(.PrecisionFloat, "", false)
        let rotateYXZOp = xformable.AddRotateYXZOp(.PrecisionFloat, "", false)
        let rotateYZXOp = xformable.AddRotateYZXOp(.PrecisionFloat, "", false)
        let rotateZXYOp = xformable.AddRotateZXYOp(.PrecisionFloat, "", false)
        let rotateZYXOp = xformable.AddRotateZYXOp(.PrecisionFloat, "", false)
        let orientOp = xformable.AddOrientOp(.PrecisionFloat, "", false)
        let transformOp = xformable.AddTransformOp(.PrecisionDouble, "", false)

        XCTAssertEqual(translateOp.GetOpType(), .TypeTranslate)
        XCTAssertEqual(scaleOp.GetOpType(), .TypeScale)
        XCTAssertEqual(rotateXOp.GetOpType(), .TypeRotateX)
        XCTAssertEqual(rotateYOp.GetOpType(), .TypeRotateY)
        XCTAssertEqual(rotateZOp.GetOpType(), .TypeRotateZ)
        XCTAssertEqual(rotateXYZOp.GetOpType(), .TypeRotateXYZ)
        XCTAssertEqual(rotateXZYOp.GetOpType(), .TypeRotateXZY)
        XCTAssertEqual(rotateYXZOp.GetOpType(), .TypeRotateYXZ)
        XCTAssertEqual(rotateYZXOp.GetOpType(), .TypeRotateYZX)
        XCTAssertEqual(rotateZXYOp.GetOpType(), .TypeRotateZXY)
        XCTAssertEqual(rotateZYXOp.GetOpType(), .TypeRotateZYX)
        XCTAssertEqual(orientOp.GetOpType(), .TypeOrient)
        XCTAssertEqual(transformOp.GetOpType(), .TypeTransform)
        
    }
    
    func test_UsdStage_equalsEqualsEquals() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage3 = stage1
        let stage4: pxr.UsdStage? = nil
        let stage5: pxr.UsdStage? = nil

        XCTAssertTrue(stage1 === stage1)
        XCTAssertFalse(stage1 === stage2)
        XCTAssertTrue(stage1 === stage3)
        XCTAssertFalse(stage1 === stage4)
        XCTAssertFalse(stage1 === stage5)
        
        XCTAssertFalse(stage2 === stage1)
        XCTAssertTrue(stage2 === stage2)
        XCTAssertFalse(stage2 === stage3)
        XCTAssertFalse(stage2 === stage4)
        XCTAssertFalse(stage2 === stage5)
        
        XCTAssertTrue(stage3 === stage1)
        XCTAssertFalse(stage3 === stage2)
        XCTAssertTrue(stage3 === stage3)
        XCTAssertFalse(stage3 === stage4)
        XCTAssertFalse(stage3 === stage5)
        
        XCTAssertFalse(stage4 === stage1)
        XCTAssertFalse(stage4 === stage2)
        XCTAssertFalse(stage4 === stage3)
        XCTAssertTrue(stage4 === stage4)
        XCTAssertTrue(stage4 === stage5)
        
        XCTAssertFalse(stage5 === stage1)
        XCTAssertFalse(stage5 === stage2)
        XCTAssertFalse(stage5 === stage3)
        XCTAssertTrue(stage5 === stage4)
        XCTAssertTrue(stage5 === stage5)
    }
    
    func test_UsdStage_notEqualsEquals() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage3 = stage1
        let stage4: pxr.UsdStage? = nil
        let stage5: pxr.UsdStage? = nil

        XCTAssertFalse(stage1 !== stage1)
        XCTAssertTrue(stage1 !== stage2)
        XCTAssertFalse(stage1 !== stage3)
        XCTAssertTrue(stage1 !== stage4)
        XCTAssertTrue(stage1 !== stage5)
        
        XCTAssertTrue(stage2 !== stage1)
        XCTAssertFalse(stage2 !== stage2)
        XCTAssertTrue(stage2 !== stage3)
        XCTAssertTrue(stage2 !== stage4)
        XCTAssertTrue(stage2 !== stage5)
        
        XCTAssertFalse(stage3 !== stage1)
        XCTAssertTrue(stage3 !== stage2)
        XCTAssertFalse(stage3 !== stage3)
        XCTAssertTrue(stage3 !== stage4)
        XCTAssertTrue(stage3 !== stage5)
        
        XCTAssertTrue(stage4 !== stage1)
        XCTAssertTrue(stage4 !== stage2)
        XCTAssertTrue(stage4 !== stage3)
        XCTAssertFalse(stage4 !== stage4)
        XCTAssertFalse(stage4 !== stage5)
        
        XCTAssertTrue(stage5 !== stage1)
        XCTAssertTrue(stage5 !== stage2)
        XCTAssertTrue(stage5 !== stage3)
        XCTAssertFalse(stage5 !== stage4)
        XCTAssertFalse(stage5 !== stage5)
    }
    
    func test_SdfLayer_equalsEqualsEquals() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))

        let layer1 = Overlay.Dereference(stage1.GetRootLayer())
        let layer2 = Overlay.Dereference(stage2.GetRootLayer())
        let layer3 = layer1
        let layer4: pxr.SdfLayer? = nil
        let layer5: pxr.SdfLayer? = nil
        
        XCTAssertTrue(layer1 === layer1)
        XCTAssertFalse(layer1 === layer2)
        XCTAssertTrue(layer1 === layer3)
        XCTAssertFalse(layer1 === layer4)
        XCTAssertFalse(layer1 === layer5)
        
        XCTAssertFalse(layer2 === layer1)
        XCTAssertTrue(layer2 === layer2)
        XCTAssertFalse(layer2 === layer3)
        XCTAssertFalse(layer2 === layer4)
        XCTAssertFalse(layer2 === layer5)
        
        XCTAssertTrue(layer3 === layer1)
        XCTAssertFalse(layer3 === layer2)
        XCTAssertTrue(layer3 === layer3)
        XCTAssertFalse(layer3 === layer4)
        XCTAssertFalse(layer3 === layer5)
        
        XCTAssertFalse(layer4 === layer1)
        XCTAssertFalse(layer4 === layer2)
        XCTAssertFalse(layer4 === layer3)
        XCTAssertTrue(layer4 === layer4)
        XCTAssertTrue(layer4 === layer5)
        
        XCTAssertFalse(layer5 === layer1)
        XCTAssertFalse(layer5 === layer2)
        XCTAssertFalse(layer5 === layer3)
        XCTAssertTrue(layer5 === layer4)
        XCTAssertTrue(layer5 === layer5)
    }
    
    func test_SdfLayer_notEqualsEquals() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))

        let layer1 = Overlay.Dereference(stage1.GetRootLayer())
        let layer2 = Overlay.Dereference(stage2.GetRootLayer())
        let layer3 = layer1
        let layer4: pxr.SdfLayer? = nil
        let layer5: pxr.SdfLayer? = nil
        
        XCTAssertFalse(layer1 !== layer1)
        XCTAssertTrue(layer1 !== layer2)
        XCTAssertFalse(layer1 !== layer3)
        XCTAssertTrue(layer1 !== layer4)
        XCTAssertTrue(layer1 !== layer5)
        
        XCTAssertTrue(layer2 !== layer1)
        XCTAssertFalse(layer2 !== layer2)
        XCTAssertTrue(layer2 !== layer3)
        XCTAssertTrue(layer2 !== layer4)
        XCTAssertTrue(layer2 !== layer5)
        
        XCTAssertFalse(layer3 !== layer1)
        XCTAssertTrue(layer3 !== layer2)
        XCTAssertFalse(layer3 !== layer3)
        XCTAssertTrue(layer3 !== layer4)
        XCTAssertTrue(layer3 !== layer5)
        
        XCTAssertTrue(layer4 !== layer1)
        XCTAssertTrue(layer4 !== layer2)
        XCTAssertTrue(layer4 !== layer3)
        XCTAssertFalse(layer4 !== layer4)
        XCTAssertFalse(layer4 !== layer5)
        
        XCTAssertTrue(layer5 !== layer1)
        XCTAssertTrue(layer5 !== layer2)
        XCTAssertTrue(layer5 !== layer3)
        XCTAssertFalse(layer5 !== layer4)
        XCTAssertFalse(layer5 !== layer5)
    }

    func test_SdfPath_EmptyPath() {
        let p: pxr.SdfPath = pxr.SdfPath.EmptyPath()
        let q: pxr.SdfPath = .EmptyPath()
        let w: pxr.SdfPath = ""
        XCTAssertEqual(p, q)
        XCTAssertEqual(p, w)
        XCTAssertEqual(q, w)
    }
    
    func test_SdfPath_AbsoluteRootPath() {
        let p: pxr.SdfPath = pxr.SdfPath.AbsoluteRootPath()
        let q: pxr.SdfPath = .AbsoluteRootPath()
        let w: pxr.SdfPath = "/"
        XCTAssertEqual(p, q)
        XCTAssertEqual(p, w)
        XCTAssertEqual(q, w)
    }

    func test_SdfPath_ReflexiveRelativePath() {
        let p: pxr.SdfPath = pxr.SdfPath.ReflexiveRelativePath()
        let q: pxr.SdfPath = .ReflexiveRelativePath()
        let w: pxr.SdfPath = "."
        XCTAssertEqual(p, q)
        XCTAssertEqual(p, w)
        XCTAssertEqual(q, w)

    }
    
    func test_TfEnum_FormEnum() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        
        let defPrim = stage.DefinePrim("/foo", .UsdGeomTokens.Cube)
        let overPrim = stage.OverridePrim("/bar")
        
        
        var tfEnum1 = pxr.TfEnum()
        Overlay.formTfEnum(defPrim.GetSpecifier() as pxr.SdfSpecifier, &tfEnum1)
        let spec1 = pxr.TfEnum.GetDisplayName(tfEnum1)
        XCTAssertEqual(spec1, "Def")
        
        var tfEnum2 = pxr.TfEnum()
        Overlay.formTfEnum(overPrim.GetSpecifier() as pxr.SdfSpecifier, &tfEnum2)
        let spec2 = pxr.TfEnum.GetDisplayName(tfEnum2)
        XCTAssertEqual(spec2, "Over")
    }
}

