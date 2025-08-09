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

// This file is a translation of https://openusd.org/release/tut_simple_shading.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/SimpleShadingInUsd` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/simpleShading.
// `SwiftUsdTests/UnitTests/Resources/Tutorials/SimpleShadingInUsd/1.txt` is a renamed copy of
// https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.05.01/extras/usd/tutorials/simpleShading/USDLogoLrg.png.

final class SimpleShadingInUsd: TutorialsHelper {
    override class var name: String { "SimpleShadingInUsd" }
    
    func testTutorial() throws {
        _ = try copyResourceToWorkingDirectory(subPath: "Tutorials/SimpleShadingInUsd/1.txt", destName: "USDLogoLrg.png")
        
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "simpleShading.usda"), .LoadAll))
        
        pxr.UsdGeomSetStageUpAxis(Overlay.TfWeakPtr(stage), .UsdGeomTokens.y)
        let modelRoot = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/TexModel")
        pxr.UsdModelAPI(Overlay.GetPrim(modelRoot)).SetKind(.KindTokens.component)
        
        let billboard = pxr.UsdGeomMesh.Define(Overlay.TfWeakPtr(stage), "/TexModel/card")
        let pointsValue: pxr.VtVec3fArray = [
            pxr.GfVec3f(-430, -145, 0),
            pxr.GfVec3f(430, -145, 0),
            pxr.GfVec3f(430, 145, 0),
            pxr.GfVec3f(-430, 145, 0)
        ]
        billboard.CreatePointsAttr(pxr.VtValue(pointsValue), false)
        let faceVertexCountsValue: pxr.VtIntArray = [4]
        billboard.CreateFaceVertexCountsAttr(pxr.VtValue(faceVertexCountsValue), false)
        let faceVertexIndicesValue: pxr.VtIntArray = [0, 1, 2, 3]
        billboard.CreateFaceVertexIndicesAttr(pxr.VtValue(faceVertexIndicesValue), false)
        let extentValue: pxr.VtVec3fArray = [pxr.GfVec3f(-430, -145, 0), pxr.GfVec3f(430, 145, 0)]
        Overlay.CreateExtentAttr(billboard, pxr.VtValue(extentValue), false)
        let primvarsAPI = pxr.UsdGeomPrimvarsAPI(Overlay.GetPrim(billboard))
        let texCoords = primvarsAPI.CreatePrimvar("st", .TexCoord2fArray,
                                                  .UsdGeomTokens.varying, -1)
        let texCoordsValue: pxr.VtVec2fArray = [
            pxr.GfVec2f(0, 0),
            pxr.GfVec2f(1, 0),
            pxr.GfVec2f(1, 1),
            pxr.GfVec2f(0, 1)
        ]
        texCoords.Set(texCoordsValue, pxr.UsdTimeCode.Default())
        stage.Save()
        XCTAssertEqual(try contentsOfStage(named: "simpleShading.usda"), try expected(2))
        
        let material = pxr.UsdShadeMaterial.Define(Overlay.TfWeakPtr(stage), "/TexModel/boardMat")
        
        var pbrShader = pxr.UsdShadeShader.Define(Overlay.TfWeakPtr(stage), "/TexModel/boardMat/PBRShader")
        pbrShader.CreateIdAttr(pxr.VtValue(pxr.TfToken("UsdPreviewSurface")), false)
        pbrShader.CreateInput("roughness", .Float).Set(0.4 as Float, pxr.UsdTimeCode.Default())
        pbrShader.CreateInput("metallic", .Float).Set(0.0 as Float, pxr.UsdTimeCode.Default())
        material.CreateSurfaceOutput(.UsdShadeTokens.universalRenderContext)
            .ConnectToSource(pbrShader.ConnectableAPI(), .UsdShadeTokens.surface,
                             pxr.UsdShadeAttributeType.Output, pxr.SdfValueTypeName())
        
        var stReader = pxr.UsdShadeShader.Define(Overlay.TfWeakPtr(stage), "/TexModel/boardMat/stReader")
        stReader.CreateIdAttr(pxr.VtValue(pxr.TfToken("UsdPrimvarReader_float2")), false)
        var diffuseTextureSampler = pxr.UsdShadeShader.Define(Overlay.TfWeakPtr(stage), "/TexModel/boardMat/diffuseTexture")
        diffuseTextureSampler.CreateIdAttr(pxr.VtValue(pxr.TfToken("UsdUVTexture")), false)
        diffuseTextureSampler.CreateInput("file", .Asset)
            .Set(pxr.SdfAssetPath("USDLogoLrg.png"), pxr.UsdTimeCode.Default())
        diffuseTextureSampler.CreateInput("st", .Float2)
            .ConnectToSource(stReader.ConnectableAPI(), "result",
                             pxr.UsdShadeAttributeType.Output, pxr.SdfValueTypeName())
        diffuseTextureSampler.CreateOutput("rgb", .Float3)
        pbrShader.CreateInput("diffuseColor", .Color3f)
            .ConnectToSource(diffuseTextureSampler.ConnectableAPI(), "rgb",
                             pxr.UsdShadeAttributeType.Output, pxr.SdfValueTypeName())
        
        let stInput = material.CreateInput("frame:stPrimvarName", .Token)
        stInput.Set(pxr.TfToken("st"), pxr.UsdTimeCode.Default())
        stReader.CreateInput("varname", .Token).ConnectToSource(stInput)
        
        _ = Overlay.GetPrim(billboard).ApplyAPI(SchemaType: pxr.UsdShadeMaterialBindingAPI.self)
        pxr.UsdShadeMaterialBindingAPI(Overlay.GetPrim(billboard)).Bind(material, .UsdShadeTokens.fallbackStrength, .UsdShadeTokens.allPurpose)
        stage.Save()
        XCTAssertEqual(try contentsOfStage(named: "simpleShading.usda"), try expected(3))
    }
}
