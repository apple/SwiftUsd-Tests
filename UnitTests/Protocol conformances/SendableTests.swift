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

fileprivate struct SendableStruct: Sendable {}
fileprivate class NonSendableClass {}
@available(*, unavailable) extension NonSendableClass: Sendable {}

final class SendableTests: TemporaryDirectoryHelper {
    // Sendable is a marker protocol that doesn't get emitted at runtime
    // So the only way to check for Sendability is by using a compile time trick
    // like generic overloads. This only works when the dynamic and static
    // type are the same, like using literal arguments. Otherwise, things can break
    private struct SendableError: Error {
        let s: String
        init(_ s: String) {
            self.s = s
        }
    }
    
    private func assertIsSendable<T>(_ t: T.Type, file: StaticString = #filePath, line: UInt = #line, flipped: Bool = false) {
        if !flipped { XCTFail("\(t) is not Sendable, but expected it was", file: file, line: line) }
        else { /* success */ }
    }
    private func assertIsNotSendable<T>(_ t: T.Type, file: StaticString = #filePath, line: UInt = #line, flipped: Bool = false) {
        if !flipped { /* success */ }
        else { XCTFail() }
    }
    private func assertIsSendable<T: Sendable>(_ t: T.Type, file: StaticString = #filePath, line: UInt = #line, flipped: Bool = false) {
        if !flipped { /* success */ }
        else { XCTFail() }
    }
    private func assertIsNotSendable<T: Sendable>(_ t: T.Type, file: StaticString = #filePath, line: UInt = #line, flipped: Bool = false) {
        if !flipped { XCTFail("\(t) is Sendable, but expected it wasn't", file: file, line: line) }
        else { /* success */  }
    }
    
    func testAssertIsSendableWithSendable() {
        assertIsSendable(SendableStruct.self)
    }
    func testAssertIsNotSendableWithNonSendable() {
        assertIsNotSendable(NonSendableClass.self)
    }
    func testAssertIsSendableWithNonSendable() {
        assertIsSendable(NonSendableClass.self, flipped: true)
    }
    func testAssertIsNotSendableWithSendable() {
        assertIsNotSendable(SendableStruct.self, flipped: true)
    }

    // MARK: Tf
    func test_TfEnum() {
        assertIsNotSendable(pxr.TfEnum.self)
    }
    func test_TfDiagnosticBase() {
        assertIsNotSendable(pxr.TfDiagnosticBase.self)
    }
    func test_TfError() {
        assertIsNotSendable(pxr.TfError.self)
    }
    func test_TfHash() {
        assertIsSendable(pxr.TfHash.self)
    }
    func test_TfNotice() {
        assertIsSendable(pxr.TfNotice.self)
    }
    func test_TfDiagnosticMgr() {
        assertIsNotSendable(pxr.TfDiagnosticMgr.self)
    }
    func test_TfRefPtrTracker() {
        assertIsNotSendable(pxr.TfRefPtrTracker.self)
    }
    func test_SdfLayerRefPtr() {
        assertIsNotSendable(pxr.SdfLayerRefPtr.self)
    }
    func test_UsdStageRefPtr() {
        assertIsNotSendable(pxr.UsdStageRefPtr.self)
    }
    func test_SdfLayerHandle() {
        assertIsNotSendable(pxr.SdfLayerHandle.self)
    }
    func test_UsdStagePtr() {
        assertIsNotSendable(pxr.UsdStagePtr.self)
    }
    func test_TfAnyWeakPtr() {
        assertIsNotSendable(pxr.TfAnyWeakPtr.self)
    }
    func test_TfNotice_Key() {
        assertIsNotSendable(pxr.TfNotice.Key.self)
    }
    func test_TfToken() {
        assertIsSendable(pxr.TfToken.self)
    }
    func test_TfType() {
        assertIsNotSendable(pxr.TfType.self)
    }

    // MARK: Gf
    func test_GfBBox3d() {
        assertIsSendable(pxr.GfBBox3d.self)
    }
    func test_GfCamera() {
        assertIsSendable(pxr.GfCamera.self)
    }
    func test_GfFrustum() {
        assertIsSendable(pxr.GfFrustum.self)
    }
    func test_GfHalf() {
        assertIsSendable(pxr.GfHalf.self)
    }
    func test_GfMatrix2d() {
        assertIsSendable(pxr.GfMatrix2d.self)
    }
    func test_GfMatrix2f() {
        assertIsSendable(pxr.GfMatrix2f.self)
    }
    func test_GfMatrix3f() {
        assertIsSendable(pxr.GfMatrix3f.self)
    }
    func test_GfMatrix3d() {
        assertIsSendable(pxr.GfMatrix3d.self)
    }
    func test_GfMatrix4f() {
        assertIsSendable(pxr.GfMatrix4f.self)
    }
    func test_GfMatrix4d() {
        assertIsSendable(pxr.GfMatrix4d.self)
    }
    func test_GfQuatd() {
        assertIsSendable(pxr.GfQuatd.self)
    }
    func test_GfQuatf() {
        assertIsSendable(pxr.GfQuatf.self)
    }
    func test_GfQuath() {
        assertIsSendable(pxr.GfQuath.self)
    }
    func test_GfQuaternion() {
        assertIsSendable(pxr.GfQuaternion.self)
    }
    func test_GfRange1d() {
        assertIsSendable(pxr.GfRange1d.self)
    }
    func test_GfRange1f() {
        assertIsSendable(pxr.GfRange1f.self)
    }
    func test_GfRange2d() {
        assertIsSendable(pxr.GfRange2d.self)
    }
    func test_GfRange2f() {
        assertIsSendable(pxr.GfRange2f.self)
    }
    func test_GfRange3d() {
        assertIsSendable(pxr.GfRange3d.self)
    }
    func test_GfRange3f() {
        assertIsSendable(pxr.GfRange3f.self)
    }
    func test_GfRect2i() {
        assertIsSendable(pxr.GfRect2i.self)
    }
    func test_GfVec2d() {
        assertIsSendable(pxr.GfVec2d.self)
    }
    func test_GfVec2f() {
        assertIsSendable(pxr.GfVec2f.self)
    }
    func test_GfVec2h() {
        assertIsSendable(pxr.GfVec2h.self)
    }
    func test_GfVec2i() {
        assertIsSendable(pxr.GfVec2i.self)
    }
    func test_GfVec3d() {
        assertIsSendable(pxr.GfVec3d.self)
    }
    func test_GfVec3f() {
        assertIsSendable(pxr.GfVec3f.self)
    }
    func test_GfVec3h() {
        assertIsSendable(pxr.GfVec3h.self)
    }
    func test_GfVec3i() {
        assertIsSendable(pxr.GfVec3i.self)
    }
    func test_GfVec4d() {
        assertIsSendable(pxr.GfVec4d.self)
    }
    func test_GfVec4f() {
        assertIsSendable(pxr.GfVec4f.self)
    }
    func test_GfVec4h() {
        assertIsSendable(pxr.GfVec4h.self)
    }
    func test_GfVec4i() {
        assertIsSendable(pxr.GfVec4i.self)
    }
    
    // MARK: Trace
    func test_TraceCollector() {
        assertIsNotSendable(pxr.TraceCollector.self)
    }
    
    // MARK: Plug
    func test_PlugRegistry() {
        assertIsNotSendable(pxr.PlugRegistry.self)
    }
    
    // MARK: Vt
    func test_VtTokenArray() {
        assertIsSendable(pxr.VtTokenArray.self)
    }
    func test_VtIntArray() {
        assertIsSendable(pxr.VtIntArray.self)
    }
    func test_VtVec3fArray() {
        assertIsSendable(pxr.VtVec3fArray.self)
    }
    func test_VtVec4dArray() {
        assertIsSendable(pxr.VtVec4dArray.self)
    }
    func test_VtFloatArray() {
        assertIsSendable(pxr.VtFloatArray.self)
    }
    func test_VtDoubleArray() {
        assertIsSendable(pxr.VtDoubleArray.self)
    }
    func test_VtVec2dArray() {
        assertIsSendable(pxr.VtVec2dArray.self)
    }
    func test_VtVec3dArray() {
        assertIsSendable(pxr.VtVec3dArray.self)
    }
    func test_VtVec4fArray() {
        assertIsSendable(pxr.VtVec4fArray.self)
    }
    func test_VtVec2fArray() {
        assertIsSendable(pxr.VtVec2fArray.self)
    }
    func test_VtVec4iArray() {
        assertIsSendable(pxr.VtVec4iArray.self)
    }
    func test_VtVec3iArray() {
        assertIsSendable(pxr.VtVec3iArray.self)
    }
    func test_VtVec2iArray() {
        assertIsSendable(pxr.VtVec2iArray.self)
    }
    func test_VtVec4hArray() {
        assertIsSendable(pxr.VtVec4hArray.self)
    }
    func test_VtVec3hArray() {
        assertIsSendable(pxr.VtVec3hArray.self)
    }
    func test_VtVec2hArray() {
        assertIsSendable(pxr.VtVec2hArray.self)
    }
    func test_VtMatrix4fArray() {
        assertIsSendable(pxr.VtMatrix4fArray.self)
    }
    func test_VtMatrix3fArray() {
        assertIsSendable(pxr.VtMatrix3fArray.self)
    }
    func test_VtMatrix2fArray() {
        assertIsSendable(pxr.VtMatrix2fArray.self)
    }
    func test_VtMatrix4dArray() {
        assertIsSendable(pxr.VtMatrix4dArray.self)
    }
    func test_VtMatrix3dArray() {
        assertIsSendable(pxr.VtMatrix3dArray.self)
    }
    func test_VtMatrix2dArray() {
        assertIsSendable(pxr.VtMatrix2dArray.self)
    }
    func test_VtRange3fArray() {
        assertIsSendable(pxr.VtRange3fArray.self)
    }
    func test_VtRange3dArray() {
        assertIsSendable(pxr.VtRange3dArray.self)
    }
    func test_VtRange2fArray() {
        assertIsSendable(pxr.VtRange2fArray.self)
    }
    func test_VtRange2dArray() {
        assertIsSendable(pxr.VtRange2dArray.self)
    }
    func test_VtRange1fArray() {
        assertIsSendable(pxr.VtRange1fArray.self)
    }
    func test_VtRange1dArray() {
        assertIsSendable(pxr.VtRange1dArray.self)
    }
    func test_VtIntervalArray() {
        assertIsSendable(pxr.VtIntervalArray.self)
    }
    func test_VtRect2iArray() {
        assertIsSendable(pxr.VtRect2iArray.self)
    }
    func test_VtQuathArray() {
        assertIsSendable(pxr.VtQuathArray.self)
    }
    func test_VtQuatfArray() {
        assertIsSendable(pxr.VtQuatfArray.self)
    }
    func test_VtQuatdArray() {
        assertIsSendable(pxr.VtQuatdArray.self)
    }
    func test_VtQuaternionArray() {
        assertIsSendable(pxr.VtQuaternionArray.self)
    }
    func test_VtDualQuathArray() {
        assertIsSendable(pxr.VtDualQuathArray.self)
    }
    func test_VtDualQuatfArray() {
        assertIsSendable(pxr.VtDualQuatfArray.self)
    }
    func test_VtDualQuatdArray() {
        assertIsSendable(pxr.VtDualQuatdArray.self)
    }
    func test_VtCharArray() {
        assertIsSendable(pxr.VtCharArray.self)
    }
    func test_VtUCharArray() {
        assertIsSendable(pxr.VtUCharArray.self)
    }
    func test_VtShortArray() {
        assertIsSendable(pxr.VtShortArray.self)
    }
    func test_VtUShortArray() {
        assertIsSendable(pxr.VtUShortArray.self)
    }
    func test_VtUIntArray() {
        assertIsSendable(pxr.VtUIntArray.self)
    }
    func test_VtInt64Array() {
        assertIsSendable(pxr.VtInt64Array.self)
    }
    func test_VtUInt64Array() {
        assertIsSendable(pxr.VtUInt64Array.self)
    }
    func test_VtHalfArray() {
        assertIsSendable(pxr.VtHalfArray.self)
    }
    func test_VtStringArray() {
        assertIsSendable(pxr.VtStringArray.self)
    }
    func test_VtDictionary() {
        assertIsNotSendable(pxr.VtDictionary.self)
    }
    func test_VtValue() {
        assertIsNotSendable(pxr.VtValue.self)
    }

    // MARK: Kind
    func test_KindRegistry() {
        assertIsNotSendable(pxr.KindRegistry.self)
    }
    
    // MARK: Sdf
    func test_SdfAssetPath() {
        assertIsSendable(pxr.SdfAssetPath.self)
    }
    func test_SdfLayer() {
        assertIsNotSendable(pxr.SdfLayer.self)
    }
    func test_SdfLayerOffset() {
        assertIsSendable(pxr.SdfLayerOffset.self)
    }
    func test_SdfPath() {
        assertIsSendable(pxr.SdfPath.self)
    }
    func test_SdfSpec() {
        assertIsNotSendable(pxr.SdfSpec.self)
    }
    func test_SdfPrimSpec() {
        assertIsNotSendable(pxr.SdfPrimSpec.self)
    }
    func test_SdfReference() {
        assertIsNotSendable(pxr.SdfReference.self)
    }
    func test_SdfValueTypeName() {
        assertIsNotSendable(pxr.SdfValueTypeName.self)
    }
    func test_SdfRelationshipSpec() {
        assertIsNotSendable(pxr.SdfRelationshipSpec.self)
    }
    func test_SdfSpecHandle() {
        assertIsNotSendable(pxr.SdfSpecHandle.self)
    }
    func test_SdfPrimSpecHandle() {
        assertIsNotSendable(pxr.SdfPrimSpecHandle.self)
    }
    func test_SdfSpecType() {
        assertIsSendable(pxr.SdfSpecType.self)
    }
    func test_SdfPropertySpecHandle() {
        assertIsNotSendable(pxr.SdfPropertySpecHandle.self)
    }
    func test_SdfSchema() {
        assertIsNotSendable(pxr.SdfSchema.self)
    }
    
    // MARK: Sdr
    func test_SdrRegistry() {
        assertIsNotSendable(pxr.SdrRegistry.self)
    }

    // MARK: Usd
    func test_UsdAPISchemaBase() {
        assertIsNotSendable(pxr.UsdAPISchemaBase.self)
    }
    func test_UsdAttribute() {
        assertIsNotSendable(pxr.UsdAttribute.self)
    }
    func test_UsdEditTarget() {
        assertIsNotSendable(pxr.UsdEditTarget.self)
    }
    func test_UsdInherits() {
        assertIsNotSendable(pxr.UsdInherits.self)
    }
    func test_UsdNotice() {
        assertIsSendable(pxr.UsdNotice.self)
    }
    func test_UsdObject() {
        assertIsNotSendable(pxr.UsdObject.self)
    }
    func test_UsdPayloads() {
        assertIsNotSendable(pxr.UsdPayloads.self)
    }
    func test_UsdPrim() {
        assertIsNotSendable(pxr.UsdPrim.self)
    }
    func test_UsdPrimRange() {
        assertIsNotSendable(pxr.UsdPrimRange.self)
    }
    func test_UsdProperty() {
        assertIsNotSendable(pxr.UsdProperty.self)
    }
    func test_UsdReferences() {
        assertIsNotSendable(pxr.UsdReferences.self)
    }
    func test_UsdRelationship() {
        assertIsNotSendable(pxr.UsdRelationship.self)
    }
    func test_UsdSchemaBase() {
        assertIsNotSendable(pxr.UsdSchemaBase.self)
    }
    func test_UsdSpecializes() {
        assertIsNotSendable(pxr.UsdSpecializes.self)
    }
    func test_UsdStage() {
        assertIsNotSendable(pxr.UsdStage.self)
    }
    func test_UsdTimeCode() {
        assertIsSendable(pxr.UsdTimeCode.self)
    }
    func test_UsdClipsAPI() {
        assertIsNotSendable(pxr.UsdClipsAPI.self)
    }
    func test_UsdModelAPI() {
        assertIsNotSendable(pxr.UsdModelAPI.self)
    }
    func test_UsdTyped() {
        assertIsNotSendable(pxr.UsdTyped.self)
    }
    func test_UsdSchemaRegistry() {
        assertIsNotSendable(pxr.UsdSchemaRegistry.self)
    }

    // MARK: UsdGeom
    func test_UsdGeomBBoxCache() {
        assertIsNotSendable(pxr.UsdGeomBBoxCache.self)
    }
    func test_UsdGeomBasisCurves() {
        assertIsNotSendable(pxr.UsdGeomBasisCurves.self)
    }
    func test_UsdGeomBoundable() {
        assertIsNotSendable(pxr.UsdGeomBoundable.self)
    }
    func test_UsdGeomCamera() {
        assertIsNotSendable(pxr.UsdGeomCamera.self)
    }
    func test_UsdGeomXformOp() {
        assertIsNotSendable(pxr.UsdGeomXformOp.self)
    }
    func test_UsdGeomCapsule() {
        assertIsNotSendable(pxr.UsdGeomCapsule.self)
    }
    func test_UsdGeomCapsule_1() {
        assertIsNotSendable(pxr.UsdGeomCapsule_1.self)
    }
    func test_UsdGeomCone() {
        assertIsNotSendable(pxr.UsdGeomCone.self)
    }
    func test_UsdGeomCube() {
        assertIsNotSendable(pxr.UsdGeomCube.self)
    }
    func test_UsdGeomCurves() {
        assertIsNotSendable(pxr.UsdGeomCurves.self)
    }
    func test_UsdGeomCylinder() {
        assertIsNotSendable(pxr.UsdGeomCylinder.self)
    }
    func test_UsdGeomCylinder_1() {
        assertIsNotSendable(pxr.UsdGeomCylinder_1.self)
    }
    func test_UsdGeomHermiteCurves() {
        assertIsNotSendable(pxr.UsdGeomHermiteCurves.self)
    }
    func test_UsdGeomImageable() {
        assertIsNotSendable(pxr.UsdGeomImageable.self)
    }
    func test_UsdGeomGprim() {
        assertIsNotSendable(pxr.UsdGeomGprim.self)
    }
    func test_UsdGeomMesh() {
        assertIsNotSendable(pxr.UsdGeomMesh.self)
    }
    func test_UsdGeomModelAPI() {
        assertIsNotSendable(pxr.UsdGeomModelAPI.self)
    }
    func test_UsdGeomPlane() {
        assertIsNotSendable(pxr.UsdGeomPlane.self)
    }
    func test_UsdGeomPointBased() {
        assertIsNotSendable(pxr.UsdGeomPointBased.self)
    }
    func test_UsdGeomPointInstancer() {
        assertIsNotSendable(pxr.UsdGeomPointInstancer.self)
    }
    func test_UsdGeomPoints() {
        assertIsNotSendable(pxr.UsdGeomPoints.self)
    }
    func test_UsdGeomPrimvar() {
        assertIsNotSendable(pxr.UsdGeomPrimvar.self)
    }
    func test_UsdGeomScope() {
        assertIsNotSendable(pxr.UsdGeomScope.self)
    }
    func test_UsdGeomSphere() {
        assertIsNotSendable(pxr.UsdGeomSphere.self)
    }
    func test_UsdGeomSubset() {
        assertIsNotSendable(pxr.UsdGeomSubset.self)
    }
    func test_UsdGeomTetMesh() {
        assertIsNotSendable(pxr.UsdGeomTetMesh.self)
    }
    func test_UsdGeomVisibilityAPI() {
        assertIsNotSendable(pxr.UsdGeomVisibilityAPI.self)
    }
    func test_UsdGeomXform() {
        assertIsNotSendable(pxr.UsdGeomXform.self)
    }
    func test_UsdGeomXformable() {
        assertIsNotSendable(pxr.UsdGeomXformable.self)
    }
    func test_UsdGeomXformCommonAPI() {
        assertIsNotSendable(pxr.UsdGeomXformCommonAPI.self)
    }
    func test_UsdGeomPrimvarsAPI() {
        assertIsNotSendable(pxr.UsdGeomPrimvarsAPI.self)
    }

    // MARK: UsdVol
    func test_UsdVolVolume() {
        assertIsNotSendable(pxr.UsdVolVolume.self)
    }

    // MARK: UsdMedia
    func test_UsdMediaSpatialAudio() {
        assertIsNotSendable(pxr.UsdMediaSpatialAudio.self)
    }

    // MARK: UsdShade
    func test_UsdShadeConnectableAPI() {
        assertIsNotSendable(pxr.UsdShadeConnectableAPI.self)
    }
    func test_UsdShadeInput() {
        assertIsNotSendable(pxr.UsdShadeInput.self)
    }
    func test_UsdShadeOutput() {
        assertIsNotSendable(pxr.UsdShadeOutput.self)
    }
    func test_UsdShadeMaterial() {
        assertIsNotSendable(pxr.UsdShadeMaterial.self)
    }
    func test_UsdShadeMaterialBindingAPI() {
        assertIsNotSendable(pxr.UsdShadeMaterialBindingAPI.self)
    }
    func test_UsdShadeNodeDefAPI() {
        assertIsNotSendable(pxr.UsdShadeNodeDefAPI.self)
    }
    func test_UsdShadeShader() {
        assertIsNotSendable(pxr.UsdShadeShader.self)
    }
    func test_UsdShadeNodeGraph() {
        assertIsNotSendable(pxr.UsdShadeNodeGraph.self)
    }

    // MARK: UsdLux
    func test_UsdLuxBoundableLightBase() {
        assertIsNotSendable(pxr.UsdLuxBoundableLightBase.self)
    }
    func test_UsdLuxCylinderLight() {
        assertIsNotSendable(pxr.UsdLuxCylinderLight.self)
    }
    func test_UsdLuxDiskLight() {
        assertIsNotSendable(pxr.UsdLuxDiskLight.self)
    }
    func test_UsdLuxDomeLight() {
        assertIsNotSendable(pxr.UsdLuxDomeLight.self)
    }
    func test_UsdLuxGeometryLight() {
        assertIsNotSendable(pxr.UsdLuxGeometryLight.self)
    }
    func test_UsdLuxLightAPI() {
        assertIsNotSendable(pxr.UsdLuxLightAPI.self)
    }
    func test_UsdLuxLightFilter() {
        assertIsNotSendable(pxr.UsdLuxLightFilter.self)
    }
    func test_UsdLuxLightListAPI() {
        assertIsNotSendable(pxr.UsdLuxLightListAPI.self)
    }
    func test_UsdLuxListAPI() {
        assertIsNotSendable(pxr.UsdLuxListAPI.self)
    }
    func test_UsdLuxMeshLightAPI() {
        assertIsNotSendable(pxr.UsdLuxMeshLightAPI.self)
    }
    func test_UsdLuxShadowAPI() {
        assertIsNotSendable(pxr.UsdLuxShadowAPI.self)
    }

    // MARK: UsdProc
    func test_UsdProcGenerativeProcedural() {
        assertIsNotSendable(pxr.UsdProcGenerativeProcedural.self)
    }

    // MARK: UsdRender
    func test_UsdRenderSettings() {
        assertIsNotSendable(pxr.UsdRenderSettings.self)
    }

    // MARK: UsdHydra
    func test_UsdHydraGenerativeProceduralAPI() {
        assertIsNotSendable(pxr.UsdHydraGenerativeProceduralAPI.self)
    }

    // MARK: UsdRi
    func test_UsdRiMaterialAPI() {
        assertIsNotSendable(pxr.UsdRiMaterialAPI.self)
    }

    // MARK: UsdSkel
    func test_UsdSkelAnimation() {
        assertIsNotSendable(pxr.UsdSkelAnimation.self)
    }
    func test_UsdSkelBindingAPI() {
        assertIsNotSendable(pxr.UsdSkelBindingAPI.self)
    }
    func test_UsdSkelBlendShape() {
        assertIsNotSendable(pxr.UsdSkelBlendShape.self)
    }
    func test_UsdSkelRoot() {
        assertIsNotSendable(pxr.UsdSkelRoot.self)
    }
    func test_UsdSkelSkeleton() {
        assertIsNotSendable(pxr.UsdSkelSkeleton.self)
    }
    func test_UsdSkelBinding() {
        assertIsNotSendable(pxr.UsdSkelBinding.self)
    }

    // MARK: UsdUI
    func test_UsdUINodeGraphNodeAPI() {
        assertIsNotSendable(pxr.UsdUINodeGraphNodeAPI.self)
    }

    // MARK: UsdPhysics
    func test_UsdPhysicsCollisionAPI() {
        assertIsNotSendable(pxr.UsdPhysicsCollisionAPI.self)
    }
    func test_UsdPhysicsLimitAPI() {
        assertIsNotSendable(pxr.UsdPhysicsLimitAPI.self)
    }
    func test_UsdPhysicsMassAPI() {
        assertIsNotSendable(pxr.UsdPhysicsMassAPI.self)
    }
    func test_UsdPhysicsMaterialAPI() {
        assertIsNotSendable(pxr.UsdPhysicsMaterialAPI.self)
    }
    func test_UsdPhysicsMeshCollisionAPI() {
        assertIsNotSendable(pxr.UsdPhysicsMeshCollisionAPI.self)
    }
    func test_UsdPhysicsRigidBodyAPI() {
        assertIsNotSendable(pxr.UsdPhysicsRigidBodyAPI.self)
    }
    func test_UsdPhysicsScene() {
        assertIsNotSendable(pxr.UsdPhysicsScene.self)
    }
    func test_UsdPhysicsSphericalJoint() {
        assertIsNotSendable(pxr.UsdPhysicsSphericalJoint.self)
    }


    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    // MARK: Hio
    func test_HioImage() {
        assertIsNotSendable(Overlay.HioImageWrapper.self)
    }
    func test_HioImage_StorageSpec() {
        assertIsNotSendable(Overlay.HioImageWrapper.StorageSpec.self)
    }
    func test_HioImage_ImageOriginLocation() {
        assertIsSendable(Overlay.HioImageWrapper.ImageOriginLocation.self)
    }
    func test_HioImage_SourceColorSpace() {
        assertIsSendable(Overlay.HioImageWrapper.SourceColorSpace.self)
    }
    func test_HioImageRegistry() {
        assertIsNotSendable(pxr.HioImageRegistry.self)
    }
    
    // MARK: CameraUtil
    func test_CameraUtilConformWindowPolicy() {
        assertIsSendable(pxr.CameraUtilConformWindowPolicy.self)
    }

    // MARK: Glf
    func test_GlfSimpleLight() {
        assertIsSendable(pxr.GlfSimpleLight.self)
    }
    func test_GlfContextCaps() {
        assertIsNotSendable(pxr.GlfContextCaps.self)
    }

    // MARK: Hd
    func test_HdSceneIndexPrimView_const_iterator() {
        assertIsNotSendable(pxr.HdSceneIndexPrimView.const_iterator.self)
    }
    func test_HdPerfLog() {
        assertIsNotSendable(pxr.HdPerfLog.self)
    }
    func test_HdRendererPluginRegistry() {
        assertIsNotSendable(pxr.HdRendererPluginRegistry.self)
    }
    func test_HdSceneIndexPluginRegistry() {
        assertIsNotSendable(pxr.HdSceneIndexPluginRegistry.self)
    }
    
    // MARK: HdGp
    func test_HdGpGenerativeProceduralPluginRegistry() {
        assertIsNotSendable(pxr.HdGpGenerativeProceduralPluginRegistry.self)
    }

    // MARK: Hdsi
    func test_HdsiLegacyDisplayStyleOverrideSceneIndex_OptionalInt() {
        assertIsSendable(pxr.HdsiLegacyDisplayStyleOverrideSceneIndex.OptionalInt.self)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)

    #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
    // MARK: UsdImagingGL
    func test_UsdImagingGLRenderParams() {
        assertIsSendable(pxr.UsdImagingGLRenderParams.self)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_USDIMAGING_SUPPORT)
}
