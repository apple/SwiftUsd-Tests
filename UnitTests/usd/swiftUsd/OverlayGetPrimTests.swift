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

final class OverlayGetPrimTests: TemporaryDirectoryHelper {
    fileprivate func helper_singleApply(_ token: pxr.TfToken, _ apiSchemas: pxr.TfToken..., code: (pxr.UsdPrim) -> (pxr.UsdPrim)) {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/prim", token)
        apiSchemas.forEach { prim.ApplyAPI($0) }
        XCTAssertEqual(code(prim), prim)
        XCTAssertTrue(Bool(code(prim)))
    }
    fileprivate func helper_multipleApply(_ token: pxr.TfToken, _ apiSchema: pxr.TfToken, _ name: pxr.TfToken, code: (pxr.UsdPrim) -> (pxr.UsdPrim)) {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/prim", token)
        prim.ApplyAPI(apiSchema, name)
        XCTAssertEqual(code(prim), prim)
        XCTAssertTrue(Bool(code(prim)))
    }
    
    func test_UsdSchemaBase() {
        helper_singleApply(.UsdGeomTokens.Cube) { Overlay.GetPrim(pxr.UsdSchemaBase($0)) }
    }
    func test_UsdTyped() {
        helper_singleApply(.UsdGeomTokens.Cube) { Overlay.GetPrim(pxr.UsdTyped($0)) }
    }
    func test_UIBackdrop() {
        helper_singleApply(.UsdUITokens.Backdrop) { Overlay.GetPrim(pxr.UsdUIBackdrop($0)) }
    }
    func test_RenderVar() {
        helper_singleApply(.UsdRenderTokens.RenderVar) { Overlay.GetPrim(pxr.UsdRenderVar($0)) }
    }
    func test_UsdRenderSettingsBase() {
        helper_singleApply(.UsdRenderTokens.RenderSettingsBase) { Overlay.GetPrim(pxr.UsdRenderSettingsBase($0)) }
    }
    func test_UsdRenderSettings() {
        helper_singleApply(.UsdRenderTokens.RenderSettings) { Overlay.GetPrim(pxr.UsdRenderSettings($0)) }
    }
    func test_UsdRenderProduct() {
        helper_singleApply(.UsdRenderTokens.RenderProduct) { Overlay.GetPrim(pxr.UsdRenderProduct($0)) }
    }
    func test_UsdRenderPass() {
        helper_singleApply(.UsdRenderTokens.RenderPass) { Overlay.GetPrim(pxr.UsdRenderPass($0)) }
    }
    func test_UsdPhysicsScene() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsScene) { Overlay.GetPrim(pxr.UsdPhysicsScene($0)) }
    }
    func test_UsdPhysicsCollisionGroup() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsCollisionGroup) { Overlay.GetPrim(pxr.UsdPhysicsCollisionGroup($0)) }
    }
    func test_UsdGeomSubset() {
        helper_singleApply(.UsdGeomTokens.GeomSubset) { Overlay.GetPrim(pxr.UsdGeomSubset($0)) }
    }
    func test_UsdGeomImageable() {
        helper_singleApply(.UsdGeomTokens.Cube) { Overlay.GetPrim(pxr.UsdGeomImageable($0)) }
    }
    func test_UsdPhysicsJoint() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsJoint) { Overlay.GetPrim(pxr.UsdPhysicsJoint($0)) }
    }
    func test_UsdPhysicsSphericalJoint() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsSphericalJoint) { Overlay.GetPrim(pxr.UsdPhysicsSphericalJoint($0)) }
    }
    func test_UsdPhysicsRevoluteJoint() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsRevoluteJoint) { Overlay.GetPrim(pxr.UsdPhysicsRevoluteJoint($0)) }
    }
    func test_UsdPhysicsPrismaticJoint() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsPrismaticJoint) { Overlay.GetPrim(pxr.UsdPhysicsPrismaticJoint($0)) }
    }
    func test_UsdPhysicsFixedJoint() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsFixedJoint) { Overlay.GetPrim(pxr.UsdPhysicsFixedJoint($0)) }
    }
    func test_UsdPhysicsDistanceJoint() {
        helper_singleApply(.UsdPhysicsTokens.PhysicsDistanceJoint) { Overlay.GetPrim(pxr.UsdPhysicsDistanceJoint($0)) }
    }
    func test_UsdGeomXformable() {
        helper_singleApply(.UsdGeomTokens.Cube) { Overlay.GetPrim(pxr.UsdGeomXformable($0)) }
    }
    func test_UsdMediaSpatialAudio() {
        helper_singleApply(.UsdMediaTokens.SpatialAudio) { Overlay.GetPrim(pxr.UsdMediaSpatialAudio($0)) }
    }
    func test_UsdVolFieldBase() {
        helper_singleApply(.UsdVolTokens.FieldBase) { Overlay.GetPrim(pxr.UsdVolFieldBase($0)) }
    }
    func test_UsdVolFieldAsset() {
        helper_singleApply(.UsdVolTokens.FieldAsset) { Overlay.GetPrim(pxr.UsdVolFieldAsset($0)) }
    }
    func test_UsdVolOpenVDBAsset() {
        helper_singleApply(.UsdVolTokens.OpenVDBAsset) { Overlay.GetPrim(pxr.UsdVolOpenVDBAsset($0)) }
    }
    func test_UsdVolField3DAsset() {
        helper_singleApply(.UsdVolTokens.Field3DAsset) { Overlay.GetPrim(pxr.UsdVolField3DAsset($0)) }
    }
    func test_UsdGeomXform() {
        helper_singleApply(.UsdGeomTokens.Xform) { Overlay.GetPrim(pxr.UsdGeomXform($0)) }
    }
    func test_UsdGeomCamera() {
        helper_singleApply(.UsdGeomTokens.Camera) { Overlay.GetPrim(pxr.UsdGeomCamera($0)) }
    }
    func test_UsdGeomBoundable() {
        helper_singleApply(.UsdGeomTokens.Cube) { Overlay.GetPrim(pxr.UsdGeomBoundable($0)) }
    }
    func test_UsdProcGenerativeProcedural() {
        helper_singleApply(.UsdProcTokens.GenerativeProcedural) { Overlay.GetPrim(pxr.UsdProcGenerativeProcedural($0)) }
    }
    func test_UsdGeomPointInstancer() {
        helper_singleApply(.UsdGeomTokens.PointInstancer) { Overlay.GetPrim(pxr.UsdGeomPointInstancer($0)) }
    }
    func test_UsdGeomGprim() {
        helper_singleApply(.UsdGeomTokens.Cube) { Overlay.GetPrim(pxr.UsdGeomGprim($0)) }
    }
    func test_UsdVolVolume() {
        helper_singleApply(.UsdVolTokens.Volume) { Overlay.GetPrim(pxr.UsdVolVolume($0)) }
    }
    func test_UsdGeomSphere() {
        helper_singleApply(.UsdGeomTokens.Sphere) { Overlay.GetPrim(pxr.UsdGeomSphere($0)) }
    }
    func test_UsdGeomPointBased() {
        helper_singleApply(.UsdGeomTokens.Points) { Overlay.GetPrim(pxr.UsdGeomPointBased($0)) }
    }
    func test_UsdGeomPoints() {
        helper_singleApply(.UsdGeomTokens.Points) { Overlay.GetPrim(pxr.UsdGeomPoints($0)) }
    }
    func test_UsdGeomNurbsPatch() {
        helper_singleApply(.UsdGeomTokens.NurbsPatch) { Overlay.GetPrim(pxr.UsdGeomNurbsPatch($0)) }
    }
    func test_UsdGeomMesh() {
        helper_singleApply(.UsdGeomTokens.Mesh) { Overlay.GetPrim(pxr.UsdGeomMesh($0)) }
    }
    func test_UsdGeomCurves() {
        helper_singleApply(.UsdGeomTokens.Curves) { Overlay.GetPrim(pxr.UsdGeomCurves($0)) }
    }
    func test_UsdGeomNurbsCurves() {
        helper_singleApply(.UsdGeomTokens.NurbsCurves) { Overlay.GetPrim(pxr.UsdGeomNurbsCurves($0)) }
    }
    func test_UsdGeomHermiteCurves() {
        helper_singleApply(.UsdGeomTokens.HermiteCurves) { Overlay.GetPrim(pxr.UsdGeomHermiteCurves($0)) }
    }
    func test_UsdGeomBasisCurves() {
        helper_singleApply(.UsdGeomTokens.BasisCurves) { Overlay.GetPrim(pxr.UsdGeomBasisCurves($0)) }
    }
    func test_UsdGeomPlane() {
        helper_singleApply(.UsdGeomTokens.Plane) { Overlay.GetPrim(pxr.UsdGeomPlane($0)) }
    }
    func test_UsdGeomCylinder_1() {
        helper_singleApply(.UsdGeomTokens.Cylinder_1) { Overlay.GetPrim(pxr.UsdGeomCylinder_1($0)) }
    }
    func test_UsdGeomCylinder() {
        helper_singleApply(.UsdGeomTokens.Cylinder) { Overlay.GetPrim(pxr.UsdGeomCylinder($0)) }
    }
    func test_UsdGeomCube() {
        helper_singleApply(.UsdGeomTokens.Cube) { Overlay.GetPrim(pxr.UsdGeomCube($0)) }
    }
    func test_UsdGeomCone() {
        helper_singleApply(.UsdGeomTokens.Cone) { Overlay.GetPrim(pxr.UsdGeomCone($0)) }
    }
    func test_UsdGeomCapsule_1() {
        helper_singleApply(.UsdGeomTokens.Capsule_1) { Overlay.GetPrim(pxr.UsdGeomCapsule_1($0)) }
    }
    func test_UsdGeomCapsule() {
        helper_singleApply(.UsdGeomTokens.Capsule) { Overlay.GetPrim(pxr.UsdGeomCapsule($0)) }
    }
    func test_UsdGeomTetMesh() {
        helper_singleApply(.UsdGeomTokens.TetMesh) { Overlay.GetPrim(pxr.UsdGeomTetMesh($0)) }
    }
    func test_UsdSkelSkeleton() {
        helper_singleApply(.UsdSkelTokens.Skeleton) { Overlay.GetPrim(pxr.UsdSkelSkeleton($0)) }
    }
    func test_UsdSkelRoot() {
        helper_singleApply(.UsdSkelTokens.SkelRoot) { Overlay.GetPrim(pxr.UsdSkelRoot($0)) }
    }
    func test_UsdLuxBoundableLightBase() {
        helper_singleApply(.UsdLuxTokens.CylinderLight) { Overlay.GetPrim(pxr.UsdLuxCylinderLight($0)) }
    }
    func test_UsdLuxSphereLight() {
        helper_singleApply(.UsdLuxTokens.SphereLight) { Overlay.GetPrim(pxr.UsdLuxSphereLight($0)) }
    }
    func test_UsdLuxRectLight() {
        helper_singleApply(.UsdLuxTokens.RectLight) { Overlay.GetPrim(pxr.UsdLuxRectLight($0)) }
    }
    func test_UsdLuxPortalLight() {
        helper_singleApply(.UsdLuxTokens.PortalLight) { Overlay.GetPrim(pxr.UsdLuxPortalLight($0)) }
    }
    func test_UsdLuxDiskLight() {
        helper_singleApply(.UsdLuxTokens.DiskLight) { Overlay.GetPrim(pxr.UsdLuxDiskLight($0)) }
    }
    func test_UsdLuxCylinderLight() {
        helper_singleApply(.UsdLuxTokens.CylinderLight) { Overlay.GetPrim(pxr.UsdLuxCylinderLight($0)) }
    }
    func test_UsdLuxPluginLight() {
        helper_singleApply(.UsdLuxTokens.PluginLight) { Overlay.GetPrim(pxr.UsdLuxPluginLight($0)) }
    }
    func test_UsdLuxNonboundableLightBase() {
        helper_singleApply(.UsdLuxTokens.DomeLight) { Overlay.GetPrim(pxr.UsdLuxNonboundableLightBase($0)) }
    }
    func test_UsdLuxGeometryLight() {
        helper_singleApply(.UsdLuxTokens.GeometryLight) { Overlay.GetPrim(pxr.UsdLuxGeometryLight($0)) }
    }
    func test_UsdLuxDomeLight_1() {
        helper_singleApply(.UsdLuxTokens.DomeLight_1) { Overlay.GetPrim(pxr.UsdLuxDomeLight_1($0)) }
    }
    func test_UsdLuxDomeLight() {
        helper_singleApply(.UsdLuxTokens.DomeLight) { Overlay.GetPrim(pxr.UsdLuxDomeLight($0)) }
    }
    func test_UsdLuxDistantLight() {
        helper_singleApply(.UsdLuxTokens.DistantLight) { Overlay.GetPrim(pxr.UsdLuxDistantLight($0)) }
    }
    func test_UsdLuxLightFilter() {
        helper_singleApply(.UsdLuxTokens.LightFilter) { Overlay.GetPrim(pxr.UsdLuxLightFilter($0)) }
    }
    func test_UsdLuxPluginLightFilter() {
        helper_singleApply(.UsdLuxTokens.PluginLightFilter) { Overlay.GetPrim(pxr.UsdLuxPluginLightFilter($0)) }
    }
    func test_UsdGeomScope() {
        helper_singleApply(.UsdGeomTokens.Scope) { Overlay.GetPrim(pxr.UsdGeomScope($0)) }
    }
    func test_UsdSkelBlendShape() {
        helper_singleApply(.UsdSkelTokens.BlendShape) { Overlay.GetPrim(pxr.UsdSkelBlendShape($0)) }
    }
    func test_UsdSkelAnimation() {
        helper_singleApply(.UsdSkelTokens.SkelAnimation) { Overlay.GetPrim(pxr.UsdSkelAnimation($0)) }
    }
    func test_UsdShadeShade() {
        helper_singleApply(.UsdShadeTokens.Shader) { Overlay.GetPrim(pxr.UsdShadeShader($0)) }
    }
    func test_UsdShadeNodeGraph() {
        helper_singleApply(.UsdShadeTokens.NodeGraph) { Overlay.GetPrim(pxr.UsdShadeNodeGraph($0)) }
    }
    func test_UsdShadeMaterial() {
        helper_singleApply(.UsdShadeTokens.Material) { Overlay.GetPrim(pxr.UsdShadeMaterial($0)) }
    }
    func test_UsdUISceneGraphPrimAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdUITokens.SceneGraphPrimAPI) { Overlay.GetPrim(pxr.UsdUISceneGraphPrimAPI($0)) }
    }
    func test_UsdUINodeGraphNodeAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdUITokens.NodeGraphNodeAPI) { Overlay.GetPrim(pxr.UsdUINodeGraphNodeAPI($0)) }
    }
    func test_UsdHydraGenerativeProceduralAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdHydraTokens.HydraGenerativeProceduralAPI) { Overlay.GetPrim(pxr.UsdHydraGenerativeProceduralAPI($0)) }
    }
    func test_UsdMediaAssetPreviewsAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdMediaTokens.AssetPreviewsAPI) { Overlay.GetPrim(pxr.UsdMediaAssetPreviewsAPI($0)) }
    }
    func test_UsdPhysicsRigidBodyAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsRigidBodyAPI) { Overlay.GetPrim(pxr.UsdPhysicsRigidBodyAPI($0)) }
    }
    func test_UsdPhysicsMeshCollisionAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsMeshCollisionAPI) { Overlay.GetPrim(pxr.UsdPhysicsMeshCollisionAPI($0)) }
    }
    func test_UsdPhysicsMaterialAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsMaterialAPI) { Overlay.GetPrim(pxr.UsdPhysicsMaterialAPI($0)) }
    }
    func test_UsdPhysicsMassAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsMassAPI) { Overlay.GetPrim(pxr.UsdPhysicsMassAPI($0)) }
    }
    func test_UsdPhysicsLimitAPI() {
        helper_multipleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsLimitAPI, "test") { Overlay.GetPrim(pxr.UsdPhysicsLimitAPI($0, "test")) }
    }
    func test_UsdPhysicsFilteredPairsAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsFilteredPairsAPI) { Overlay.GetPrim(pxr.UsdPhysicsFilteredPairsAPI($0)) }
    }
    func test_UsdPhysicsDriveAPI() {
        helper_multipleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsDriveAPI, "test") { Overlay.GetPrim(pxr.UsdPhysicsDriveAPI($0, "test")) }
    }
    func test_UsdPhysicsCollisionAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsCollisionAPI) { Overlay.GetPrim(pxr.UsdPhysicsCollisionAPI($0)) }
    }
    func test_UsdPhysicsArticulationRootAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdPhysicsTokens.PhysicsArticulationRootAPI) { Overlay.GetPrim(pxr.UsdPhysicsArticulationRootAPI($0)) }
    }
    func test_UsdModelAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdTokens.ModelAPI) { Overlay.GetPrim(pxr.UsdModelAPI($0)) }
    }
    func test_UsdCollectionAPI() {
        helper_multipleApply(.UsdGeomTokens.Cube, .UsdTokens.CollectionAPI, "test") { Overlay.GetPrim(pxr.UsdCollectionAPI($0, "test")) }
    }
    func test_UsdClipsAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdTokens.ClipsAPI) { Overlay.GetPrim(pxr.UsdClipsAPI($0)) }
    }
    func test_UsdRiStatementsAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdRiTokens.StatementsAPI) { Overlay.GetPrim(pxr.UsdRiStatementsAPI($0)) }
    }
    func test_UsdRiSplineAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdRiTokens.RiSplineAPI) { Overlay.GetPrim(pxr.UsdRiSplineAPI($0)) }
    }
    func test_UsdRiMaterialAPI() {
        helper_singleApply(.UsdRiTokens.RiMaterialAPI) { Overlay.GetPrim(pxr.UsdRiMaterialAPI($0)) }
    }
    func test_UsdGeomXformCommonAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.XformCommonAPI) { Overlay.GetPrim(pxr.UsdGeomXformCommonAPI($0)) }
    }
    func test_UsdGeomVisibilityAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.VisibilityAPI) { Overlay.GetPrim(pxr.UsdGeomVisibilityAPI($0)) }
    }
    func test_UsdGeomPrimvarsAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.PrimvarsAPI) { Overlay.GetPrim(pxr.UsdGeomPrimvarsAPI($0)) }
    }
    func test_UsdGeomMotionAPI() {
        helper_singleApply(.UsdGeomTokens.MotionAPI) { Overlay.GetPrim(pxr.UsdGeomMotionAPI($0)) }
    }
    func test_UsdGeomModelAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdGeomTokens.GeomModelAPI) { Overlay.GetPrim(pxr.UsdGeomModelAPI($0)) }
    }
    func test_UsdSkelBindingAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdSkelTokens.SkelBindingAPI) { Overlay.GetPrim(pxr.UsdSkelBindingAPI($0)) }
    }
    func test_UsdLuxVolumeLightAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.VolumeLightAPI) { Overlay.GetPrim(pxr.UsdLuxVolumeLightAPI($0)) }
    }
    func test_UsdLuxShapingAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.ShapingAPI) { Overlay.GetPrim(pxr.UsdLuxShapingAPI($0)) }
    }
    func test_UsdLuxMeshLightAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.MeshLightAPI) { Overlay.GetPrim(pxr.UsdLuxMeshLightAPI($0)) }
    }
    func test_UsdLuxListAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.ListAPI) { Overlay.GetPrim(pxr.UsdLuxListAPI($0)) }
    }
    func test_UsdLuxLightListAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.LightListAPI) { Overlay.GetPrim(pxr.UsdLuxLightListAPI($0)) }
    }
    func test_UsdLuxLightAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdLuxTokens.LightAPI) { Overlay.GetPrim(pxr.UsdLuxLightAPI($0)) }
    }
    func test_UsdShadeNodeDefAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdShadeTokens.NodeDefAPI) { Overlay.GetPrim(pxr.UsdShadeNodeDefAPI($0)) }
    }
    func test_UsdShadeMaterialBindingAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdShadeTokens.MaterialBindingAPI) { Overlay.GetPrim(pxr.UsdShadeMaterialBindingAPI($0)) }
    }
    func test_UsdShadeCoordSysAPI() {
        helper_multipleApply(.UsdGeomTokens.Cube, .UsdShadeTokens.CoordSysAPI, "test") { Overlay.GetPrim(pxr.UsdShadeCoordSysAPI($0, "test")) }
    }
    func test_UsdShadeConnectableAPI() {
        helper_singleApply(.UsdGeomTokens.Cube, .UsdShadeTokens.ConnectableAPI) { Overlay.GetPrim(pxr.UsdShadeConnectableAPI($0)) }
    }
}
