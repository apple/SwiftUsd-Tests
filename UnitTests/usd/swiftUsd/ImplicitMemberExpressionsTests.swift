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

final class ImplicitMemberExpressionsTests: TemporaryDirectoryHelper {
    // MARK: Tokens
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    func test_HdAovTokens() {
        let a: pxr.TfToken = .HdAovTokens.color
        let b: pxr.TfToken = "color"
        XCTAssertEqual(a, b)
    }
    
    func test_HdxColorCorrectionTokens() {
        let a: pxr.TfToken = .HdxColorCorrectionTokens.disabled
        let b: pxr.TfToken = "disabled"
        XCTAssertEqual(a, b)
    }
    
    func test_HgiTokens() {
        let a: pxr.TfToken = .HgiTokens.renderDriver
        let b: pxr.TfToken = "renderDriver"
        XCTAssertEqual(a, b)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    
    func test_KindTokens() {
        let a: pxr.TfToken = .KindTokens.model
        let b: pxr.TfToken = "model"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdGeomTokens() {
        let a: pxr.TfToken = .UsdGeomTokens.Cube
        let b: pxr.TfToken = "Cube"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdHydraTokens() {
        let a: pxr.TfToken = .UsdHydraTokens.clamp
        let b: pxr.TfToken = "clamp"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdLuxTokens() {
        let a: pxr.TfToken = .UsdLuxTokens.treatAsLine
        let b: pxr.TfToken = "treatAsLine"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdMediaTokens() {
        let a: pxr.TfToken = .UsdMediaTokens.mediaOffset
        let b: pxr.TfToken = "mediaOffset"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdPhysicsTokens() {
        let a: pxr.TfToken = .UsdPhysicsTokens.physicsMaxDistance
        let b: pxr.TfToken = "physics:maxDistance"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdProcTokens() {
        let a: pxr.TfToken = .UsdProcTokens.proceduralSystem
        let b: pxr.TfToken = "proceduralSystem"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdRenderTokens() {
        let a: pxr.TfToken = .UsdRenderTokens.materialBindingPurposes
        let b: pxr.TfToken = "materialBindingPurposes"
        XCTAssertEqual(a, b)
    }

    func test_UsdRiTokens() {
        let a: pxr.TfToken = .UsdRiTokens.interpolation
        let b: pxr.TfToken = "interpolation"
        XCTAssertEqual(a, b)
    }

    func test_UsdShadeTokens() {
        let a: pxr.TfToken = .UsdShadeTokens.full
        let b: pxr.TfToken = "full"
        XCTAssertEqual(a, b)
    }

    func test_UsdSkelTokens() {
        let a: pxr.TfToken = .UsdSkelTokens.classicLinear
        let b: pxr.TfToken = "classicLinear"
        XCTAssertEqual(a, b)
    }

    func test_UsdTokens() {
        let a: pxr.TfToken = .UsdTokens.exclude
        let b: pxr.TfToken = "exclude"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdUITokens() {
        let a: pxr.TfToken = .UsdUITokens.closed
        let b: pxr.TfToken = "closed"
        XCTAssertEqual(a, b)
    }

    func test_UsdVolTokens() {
        let a: pxr.TfToken = .UsdVolTokens.fieldClass
        let b: pxr.TfToken = "fieldClass"
        XCTAssertEqual(a, b)
    }
    
    func test_GfColorSpaceNames() {
        let a: pxr.TfToken = .GfColorSpaceNames.CIEXYZ
        let b: pxr.TfToken = "lin_ciexyzd65_scene"
        XCTAssertEqual(a, b)
    }
    
    func test_SdfDataTokens() {
        let a: pxr.TfToken = .SdfDataTokens.TimeSamples
        let b: pxr.TfToken = "timeSamples"
        XCTAssertEqual(a, b)
    }
    
    func test_SdfTokens() {
        let a: pxr.TfToken = .SdfTokens.AnyTypeToken
        let b: pxr.TfToken = "__AnyType__"
        XCTAssertEqual(a, b)
    }
    
    func test_SdfPathTokens() {
        let a: pxr.TfToken = .SdfPathTokens.expressionIndicator
        let b: pxr.TfToken = "expression"
        XCTAssertEqual(a, b)
    }
    
    func test_SdfFileFormatTokens() {
        let a: pxr.TfToken = .SdfFileFormatTokens.TargetArg
        let b: pxr.TfToken = "target"
        XCTAssertEqual(a, b)
    }
    
    func test_SdfTextFileFormatTokens() {
        let a: pxr.TfToken = .SdfTextFileFormatTokens.Id
        let b: pxr.TfToken = "sdf"
        XCTAssertEqual(a, b)
    }
    
    func test_UsdTimeCodeTokens() {
        let a: pxr.TfToken = .UsdTimeCodeTokens.DEFAULT
        let b: pxr.TfToken = "DEFAULT"
        XCTAssertEqual(a, b)
    }
    
    #if canImport(SwiftUsd_PXR_ENABLE_MATERIALX_SUPPORT)
    func test_UsdMtlxTokensType() {
        let a: pxr.TfToken = .UsdMtlxTokens.configMtlxVersion
        let b: pxr.TfToken = "config:mtlx:version"
        XCTAssertEqual(a, b)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_MATERIALX_SUPPORT)
    
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    func test_GlfTextureTokens() {
        let a: pxr.TfToken = .GlfTextureTokens.texels
        let b: pxr.TfToken = "texels"
        XCTAssertEqual(a, b)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    
    #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
    func test_UsdImagingTokens() {
        let a: pxr.TfToken = .UsdImagingTokens.primvarsNormals
        let b: pxr.TfToken = "primvars:normals"
        XCTAssertEqual(a, b)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)

    // MARK: SdfValueTypeNames
    
    func test_Asset() {
        let typeName: pxr.SdfValueTypeName = .Asset
        XCTAssertEqual(typeName.GetAsToken(), "asset")
    }
    
    func test_AssetArray() {
        let typeName: pxr.SdfValueTypeName = .AssetArray
        XCTAssertEqual(typeName.GetAsToken(), "asset[]")
    }
    
    func test_Bool() {
        let typeName: pxr.SdfValueTypeName = .Bool
        XCTAssertEqual(typeName.GetAsToken(), "bool")
    }
    
    func test_BoolArray() {
        let typeName: pxr.SdfValueTypeName = .BoolArray
        XCTAssertEqual(typeName.GetAsToken(), "bool[]")
    }
    
    func test_Color3d() {
        let typeName: pxr.SdfValueTypeName = .Color3d
        XCTAssertEqual(typeName.GetAsToken(), "color3d")
    }
    
    func test_Color3dArray() {
        let typeName: pxr.SdfValueTypeName = .Color3dArray
        XCTAssertEqual(typeName.GetAsToken(), "color3d[]")
    }

    func test_Color3f() {
        let typeName: pxr.SdfValueTypeName = .Color3f
        XCTAssertEqual(typeName.GetAsToken(), "color3f")
    }

    func test_Color3fArray() {
        let typeName: pxr.SdfValueTypeName = .Color3fArray
        XCTAssertEqual(typeName.GetAsToken(), "color3f[]")
    }
    
    func test_Color3h() {
        let typeName: pxr.SdfValueTypeName = .Color3h
        XCTAssertEqual(typeName.GetAsToken(), "color3h")
    }
    
    func test_Color3hArray() {
        let typeName: pxr.SdfValueTypeName = .Color3hArray
        XCTAssertEqual(typeName.GetAsToken(), "color3h[]")
    }

    func test_Color4d() {
        let typeName: pxr.SdfValueTypeName = .Color4d
        XCTAssertEqual(typeName.GetAsToken(), "color4d")
    }
    
    func test_Color4dArray() {
        let typeName: pxr.SdfValueTypeName = .Color4dArray
        XCTAssertEqual(typeName.GetAsToken(), "color4d[]")
    }
    
    func test_Color4f() {
        let typeName: pxr.SdfValueTypeName = .Color4f
        XCTAssertEqual(typeName.GetAsToken(), "color4f")
    }
    
    func test_Color4fArray() {
        let typeName: pxr.SdfValueTypeName = .Color4fArray
        XCTAssertEqual(typeName.GetAsToken(), "color4f[]")
    }
    
    func test_Color4h() {
        let typeName: pxr.SdfValueTypeName = .Color4h
        XCTAssertEqual(typeName.GetAsToken(), "color4h")
    }
    
    func test_Color4hArray() {
        let typeName: pxr.SdfValueTypeName = .Color4hArray
        XCTAssertEqual(typeName.GetAsToken(), "color4h[]")
    }
    
    func test_Double() {
        let typeName: pxr.SdfValueTypeName = .Double
        XCTAssertEqual(typeName.GetAsToken(), "double")
    }
    
    func test_Double2() {
        let typeName: pxr.SdfValueTypeName = .Double2
        XCTAssertEqual(typeName.GetAsToken(), "double2")
    }
    
    func test_Double2Array() {
        let typeName: pxr.SdfValueTypeName = .Double2Array
        XCTAssertEqual(typeName.GetAsToken(), "double2[]")
    }
    
    func test_Double3() {
        let typeName: pxr.SdfValueTypeName = .Double3
        XCTAssertEqual(typeName.GetAsToken(), "double3")
    }
    
    func test_Double3Array() {
        let typeName: pxr.SdfValueTypeName = .Double3Array
        XCTAssertEqual(typeName.GetAsToken(), "double3[]")
    }
    
    func test_Double4() {
        let typeName: pxr.SdfValueTypeName = .Double4
        XCTAssertEqual(typeName.GetAsToken(), "double4")
    }
    
    func test_Double4Array() {
        let typeName: pxr.SdfValueTypeName = .Double4Array
        XCTAssertEqual(typeName.GetAsToken(), "double4[]")
    }
    
    func test_DoubleArray() {
        let typeName: pxr.SdfValueTypeName = .DoubleArray
        XCTAssertEqual(typeName.GetAsToken(), "double[]")
    }
    
    func test_Float() {
        let typeName: pxr.SdfValueTypeName = .Float
        XCTAssertEqual(typeName.GetAsToken(), "float")
    }
    
    func test_Float2() {
        let typeName: pxr.SdfValueTypeName = .Float2
        XCTAssertEqual(typeName.GetAsToken(), "float2")
    }
    
    func test_Float2Array() {
        let typeName: pxr.SdfValueTypeName = .Float2Array
        XCTAssertEqual(typeName.GetAsToken(), "float2[]")
    }
    
    func test_Float3() {
        let typeName: pxr.SdfValueTypeName = .Float3
        XCTAssertEqual(typeName.GetAsToken(), "float3")
    }
    
    func test_Float3Array() {
        let typeName: pxr.SdfValueTypeName = .Float3Array
        XCTAssertEqual(typeName.GetAsToken(), "float3[]")
    }
    
    func test_Float4() {
        let typeName: pxr.SdfValueTypeName = .Float4
        XCTAssertEqual(typeName.GetAsToken(), "float4")
    }
    
    func test_Float4Array() {
        let typeName: pxr.SdfValueTypeName = .Float4Array
        XCTAssertEqual(typeName.GetAsToken(), "float4[]")
    }
    
    func test_FloatArray() {
        let typeName: pxr.SdfValueTypeName = .FloatArray
        XCTAssertEqual(typeName.GetAsToken(), "float[]")
    }
    
    func test_Frame4d() {
        let typeName: pxr.SdfValueTypeName = .Frame4d
        XCTAssertEqual(typeName.GetAsToken(), "frame4d")
    }
    
    func test_Frame4dArray() {
        let typeName: pxr.SdfValueTypeName = .Frame4dArray
        XCTAssertEqual(typeName.GetAsToken(), "frame4d[]")
    }
    
    func test_Group() {
        let typeName: pxr.SdfValueTypeName = .Group
        XCTAssertEqual(typeName.GetAsToken(), "group")
    }
    
    func test_Half() {
        let typeName: pxr.SdfValueTypeName = .Half
        XCTAssertEqual(typeName.GetAsToken(), "half")
    }
    
    func test_Half2() {
        let typeName: pxr.SdfValueTypeName = .Half2
        XCTAssertEqual(typeName.GetAsToken(), "half2")
    }
    
    func test_Half2Array() {
        let typeName: pxr.SdfValueTypeName = .Half2Array
        XCTAssertEqual(typeName.GetAsToken(), "half2[]")
    }
    
    func test_Half3() {
        let typeName: pxr.SdfValueTypeName = .Half3
        XCTAssertEqual(typeName.GetAsToken(), "half3")
    }
    
    func test_Half3Array() {
        let typeName: pxr.SdfValueTypeName = .Half3Array
        XCTAssertEqual(typeName.GetAsToken(), "half3[]")
    }
    
    func test_Half4() {
        let typeName: pxr.SdfValueTypeName = .Half4
        XCTAssertEqual(typeName.GetAsToken(), "half4")
    }
    
    func test_Half4Array() {
        let typeName: pxr.SdfValueTypeName = .Half4Array
        XCTAssertEqual(typeName.GetAsToken(), "half4[]")
    }
    
    func test_Int() {
        let typeName: pxr.SdfValueTypeName = .Int
        XCTAssertEqual(typeName.GetAsToken(), "int")
    }
    
    func test_Int2() {
        let typeName: pxr.SdfValueTypeName = .Int2
        XCTAssertEqual(typeName.GetAsToken(), "int2")
    }
    
    func test_Int2Array() {
        let typeName: pxr.SdfValueTypeName = .Int2Array
        XCTAssertEqual(typeName.GetAsToken(), "int2[]")
    }
    
    func test_Int3() {
        let typeName: pxr.SdfValueTypeName = .Int3
        XCTAssertEqual(typeName.GetAsToken(), "int3")
    }
    
    func test_Int3Array() {
        let typeName: pxr.SdfValueTypeName = .Int3Array
        XCTAssertEqual(typeName.GetAsToken(), "int3[]")
    }
    
    func test_Int4() {
        let typeName: pxr.SdfValueTypeName = .Int4
        XCTAssertEqual(typeName.GetAsToken(), "int4")
    }
    
    func test_Int4Array() {
        let typeName: pxr.SdfValueTypeName = .Int4Array
        XCTAssertEqual(typeName.GetAsToken(), "int4[]")
    }
    
    func test_Int64() {
        let typeName: pxr.SdfValueTypeName = .Int64
        XCTAssertEqual(typeName.GetAsToken(), "int64")
    }
    
    func test_Int64Array() {
        let typeName: pxr.SdfValueTypeName = .Int64Array
        XCTAssertEqual(typeName.GetAsToken(), "int64[]")
    }
    
    func test_IntArray() {
        let typeName: pxr.SdfValueTypeName = .IntArray
        XCTAssertEqual(typeName.GetAsToken(), "int[]")
    }
    
    func test_Matrix2d() {
        let typeName: pxr.SdfValueTypeName = .Matrix2d
        XCTAssertEqual(typeName.GetAsToken(), "matrix2d")
    }
    
    func test_Matrix2dArray() {
        let typeName: pxr.SdfValueTypeName = .Matrix2dArray
        XCTAssertEqual(typeName.GetAsToken(), "matrix2d[]")
    }
    
    func test_Matrix3d() {
        let typeName: pxr.SdfValueTypeName = .Matrix3d
        XCTAssertEqual(typeName.GetAsToken(), "matrix3d")
    }
    
    func test_Matrix3dArray() {
        let typeName: pxr.SdfValueTypeName = .Matrix3dArray
        XCTAssertEqual(typeName.GetAsToken(), "matrix3d[]")
    }
    
    func test_Matrix4d() {
        let typeName: pxr.SdfValueTypeName = .Matrix4d
        XCTAssertEqual(typeName.GetAsToken(), "matrix4d")
    }
    
    func test_Matrix4dArray() {
        let typeName: pxr.SdfValueTypeName = .Matrix4dArray
        XCTAssertEqual(typeName.GetAsToken(), "matrix4d[]")
    }
    
    func test_Normal3d() {
        let typeName: pxr.SdfValueTypeName = .Normal3d
        XCTAssertEqual(typeName.GetAsToken(), "normal3d")
    }
    
    func test_Normal3dArray() {
        let typeName: pxr.SdfValueTypeName = .Normal3dArray
        XCTAssertEqual(typeName.GetAsToken(), "normal3d[]")
    }
    
    func test_Normal3f() {
        let typeName: pxr.SdfValueTypeName = .Normal3f
        XCTAssertEqual(typeName.GetAsToken(), "normal3f")
    }
    
    func test_Normal3fArray() {
        let typeName: pxr.SdfValueTypeName = .Normal3fArray
        XCTAssertEqual(typeName.GetAsToken(), "normal3f[]")
    }
    
    func test_Normal3h() {
        let typeName: pxr.SdfValueTypeName = .Normal3h
        XCTAssertEqual(typeName.GetAsToken(), "normal3h")
    }
    
    func test_Normal3hArray() {
        let typeName: pxr.SdfValueTypeName = .Normal3hArray
        XCTAssertEqual(typeName.GetAsToken(), "normal3h[]")
    }
    
    func test_Opaque() {
        let typeName: pxr.SdfValueTypeName = .Opaque
        XCTAssertEqual(typeName.GetAsToken(), "opaque")
    }
    
    func test_Point3d() {
        let typeName: pxr.SdfValueTypeName = .Point3d
        XCTAssertEqual(typeName.GetAsToken(), "point3d")
    }
    
    func test_Point3dArray() {
        let typeName: pxr.SdfValueTypeName = .Point3dArray
        XCTAssertEqual(typeName.GetAsToken(), "point3d[]")
    }
    
    func test_Point3f() {
        let typeName: pxr.SdfValueTypeName = .Point3f
        XCTAssertEqual(typeName.GetAsToken(), "point3f")
    }
    
    func test_Point3fArray() {
        let typeName: pxr.SdfValueTypeName = .Point3fArray
        XCTAssertEqual(typeName.GetAsToken(), "point3f[]")
    }
    
    func test_Point3h() {
        let typeName: pxr.SdfValueTypeName = .Point3h
        XCTAssertEqual(typeName.GetAsToken(), "point3h")
    }
    
    func test_Point3hArray() {
        let typeName: pxr.SdfValueTypeName = .Point3hArray
        XCTAssertEqual(typeName.GetAsToken(), "point3h[]")
    }
    
    func test_Quatd() {
        let typeName: pxr.SdfValueTypeName = .Quatd
        XCTAssertEqual(typeName.GetAsToken(), "quatd")
    }
    
    func test_QuatdArray() {
        let typeName: pxr.SdfValueTypeName = .QuatdArray
        XCTAssertEqual(typeName.GetAsToken(), "quatd[]")
    }
    
    func test_Quatf() {
        let typeName: pxr.SdfValueTypeName = .Quatf
        XCTAssertEqual(typeName.GetAsToken(), "quatf")
    }
    
    func test_QuatfArray() {
        let typeName: pxr.SdfValueTypeName = .QuatfArray
        XCTAssertEqual(typeName.GetAsToken(), "quatf[]")
    }
    
    func test_Quath() {
        let typeName: pxr.SdfValueTypeName = .Quath
        XCTAssertEqual(typeName.GetAsToken(), "quath")
    }
    
    func test_QuathArray() {
        let typeName: pxr.SdfValueTypeName = .QuathArray
        XCTAssertEqual(typeName.GetAsToken(), "quath[]")
    }
    
    func test_String() {
        let typeName: pxr.SdfValueTypeName = .String
        XCTAssertEqual(typeName.GetAsToken(), "string")
    }
    
    func test_StringArray() {
        let typeName: pxr.SdfValueTypeName = .StringArray
        XCTAssertEqual(typeName.GetAsToken(), "string[]")
    }
    
    func test_TexCoord2d() {
        let typeName: pxr.SdfValueTypeName = .TexCoord2d
        XCTAssertEqual(typeName.GetAsToken(), "texCoord2d")
    }
    
    func test_TexCoord2dArray() {
        let typeName: pxr.SdfValueTypeName = .TexCoord2dArray
        XCTAssertEqual(typeName.GetAsToken(), "texCoord2d[]")
    }
    
    func test_TexCoord2f() {
        let typeName: pxr.SdfValueTypeName = .TexCoord2f
        XCTAssertEqual(typeName.GetAsToken(), "texCoord2f")
    }
    
    func test_TexCoord2fArray() {
        let typeName: pxr.SdfValueTypeName = .TexCoord2fArray
        XCTAssertEqual(typeName.GetAsToken(), "texCoord2f[]")
    }
    
    func test_TexCoord2h() {
        let typeName: pxr.SdfValueTypeName = .TexCoord2h
        XCTAssertEqual(typeName.GetAsToken(), "texCoord2h")
    }
    
    func test_TexCoord2hArray() {
        let typeName: pxr.SdfValueTypeName = .TexCoord2hArray
        XCTAssertEqual(typeName.GetAsToken(), "texCoord2h[]")
    }
    
    func test_TexCoord3d() {
        let typeName: pxr.SdfValueTypeName = .TexCoord3d
        XCTAssertEqual(typeName.GetAsToken(), "texCoord3d")
    }
    
    func test_TexCoord3dArray() {
        let typeName: pxr.SdfValueTypeName = .TexCoord3dArray
        XCTAssertEqual(typeName.GetAsToken(), "texCoord3d[]")
    }
    
    func test_TexCoord3f() {
        let typeName: pxr.SdfValueTypeName = .TexCoord3f
        XCTAssertEqual(typeName.GetAsToken(), "texCoord3f")
    }
    
    func test_TexCoord3fArray() {
        let typeName: pxr.SdfValueTypeName = .TexCoord3fArray
        XCTAssertEqual(typeName.GetAsToken(), "texCoord3f[]")
    }
    
    func test_TexCoord3h() {
        let typeName: pxr.SdfValueTypeName = .TexCoord3h
        XCTAssertEqual(typeName.GetAsToken(), "texCoord3h")
    }
    
    func test_TexCoord3hArray() {
        let typeName: pxr.SdfValueTypeName = .TexCoord3hArray
        XCTAssertEqual(typeName.GetAsToken(), "texCoord3h[]")
    }
    
    func test_TimeCode() {
        let typeName: pxr.SdfValueTypeName = .TimeCode
        XCTAssertEqual(typeName.GetAsToken(), "timecode")
    }
    
    func test_TimeCodeArray() {
        let typeName: pxr.SdfValueTypeName = .TimeCodeArray
        XCTAssertEqual(typeName.GetAsToken(), "timecode[]")
    }
    
    func test_Token() {
        let typeName: pxr.SdfValueTypeName = .Token
        XCTAssertEqual(typeName.GetAsToken(), "token")
    }
    
    func test_TokenArray() {
        let typeName: pxr.SdfValueTypeName = .TokenArray
        XCTAssertEqual(typeName.GetAsToken(), "token[]")
    }
    
    func test_UChar() {
        let typeName: pxr.SdfValueTypeName = .UChar
        XCTAssertEqual(typeName.GetAsToken(), "uchar")
    }
    
    func test_UCharArray() {
        let typeName: pxr.SdfValueTypeName = .UCharArray
        XCTAssertEqual(typeName.GetAsToken(), "uchar[]")
    }
    
    func test_UInt() {
        let typeName: pxr.SdfValueTypeName = .UInt
        XCTAssertEqual(typeName.GetAsToken(), "uint")
    }
    
    func test_UInt64() {
        let typeName: pxr.SdfValueTypeName = .UInt64
        XCTAssertEqual(typeName.GetAsToken(), "uint64")
    }
    
    func test_UInt64Array() {
        let typeName: pxr.SdfValueTypeName = .UInt64Array
        XCTAssertEqual(typeName.GetAsToken(), "uint64[]")
    }
    
    func test_UIntArray() {
        let typeName: pxr.SdfValueTypeName = .UIntArray
        XCTAssertEqual(typeName.GetAsToken(), "uint[]")
    }
    
    func test_Vector3d() {
        let typeName: pxr.SdfValueTypeName = .Vector3d
        XCTAssertEqual(typeName.GetAsToken(), "vector3d")
    }
    
    func test_Vector3dArray() {
        let typeName: pxr.SdfValueTypeName = .Vector3dArray
        XCTAssertEqual(typeName.GetAsToken(), "vector3d[]")
    }
    
    func test_Vector3f() {
        let typeName: pxr.SdfValueTypeName = .Vector3f
        XCTAssertEqual(typeName.GetAsToken(), "vector3f")
    }
    
    func test_Vector3fArray() {
        let typeName: pxr.SdfValueTypeName = .Vector3fArray
        XCTAssertEqual(typeName.GetAsToken(), "vector3f[]")
    }
    
    func test_Vector3h() {
        let typeName: pxr.SdfValueTypeName = .Vector3h
        XCTAssertEqual(typeName.GetAsToken(), "vector3h")
    }
    
    func test_Vector3hArray() {
        let typeName: pxr.SdfValueTypeName = .Vector3hArray
        XCTAssertEqual(typeName.GetAsToken(), "vector3h[]")
    }

}
