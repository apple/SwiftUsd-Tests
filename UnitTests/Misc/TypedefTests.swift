//
//  TypedefTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 6/2/25.
//

import XCTest
import OpenUSD

final class TypedefTests: TemporaryDirectoryHelper {
    func test_typedefs() {
        // Make sure types exist
        #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
        let _: Overlay.HgiBlitCmds_SharedPtr? = nil
        #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
        let _: Overlay.UsdStagePtr_UsdEditTarget_Pair? = nil
        let _: Overlay.VtDictionary_Iterator_Bool_Pair? = nil
        let _: Overlay.String_Vector? = nil
        let _: Overlay.Double_Vector? = nil
        let _: Overlay.String_String_Pair_Vector? = nil
        let _: Overlay.GfVec4f_Vector? = nil
        let _: Overlay.UsdGeomXformOp_Vector? = nil
        let _: Overlay.UsdProperty_Vector? = nil
        let _: Overlay.UsdAttribute_Vector? = nil
        let _: Overlay.UsdRelationship_Vector? = nil
        let _: Overlay.TfDiagnosticBase_Shared_Ptr_Vector? = nil
        let _: Overlay.TfDiagnosticBase_Unique_Ptr_Vector? = nil
        let _: Overlay.UsdShadeInput_Vector? = nil
        let _: Overlay.SdfLayer_RefPtr_Vector? = nil
        let _: Overlay.String_Set? = nil
        let _: Overlay.SdfLayerHandle_Set? = nil
        let _: Overlay.TfDiagnosticBase_Shared_Ptr? = nil
        let _: Overlay.SdfAssetPath_VtArray? = nil
    }
}
