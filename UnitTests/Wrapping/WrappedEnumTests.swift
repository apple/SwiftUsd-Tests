//
//  WrappedEnumTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/15/23.
//

import XCTest
import OpenUSD

#if DEBUG
// https://github.com/swiftlang/swift/pull/79791 (Runtime crash using `==` on two instances of C++ enum `pxr.HdCamera.Projection`)
#warning("Disabling wrapped enum tests in debug")
#else
final class WrappedEnumTests: TemporaryDirectoryHelper {
    // MARK: Arch
    
    // MARK: ArchMemAdvice
    func test_ArchMemAdviceNormal() {
        let x: pxr.ArchMemAdvice = Overlay.ArchMemAdviceNormal
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.ArchMemAdvice = .ArchMemAdviceNormal
        XCTAssertEqual(x, y)
    }
    func test_ArchMemAdviceWillNeed() {
        let x: pxr.ArchMemAdvice = Overlay.ArchMemAdviceWillNeed
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.ArchMemAdvice = .ArchMemAdviceWillNeed
        XCTAssertEqual(x, y)
    }
    func test_ArchMemAdviceDontNeed() {
        let x: pxr.ArchMemAdvice = Overlay.ArchMemAdviceDontNeed
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.ArchMemAdvice = .ArchMemAdviceDontNeed
        XCTAssertEqual(x, y)
    }
    func test_ArchMemAdviceRandomAccess() {
        let x: pxr.ArchMemAdvice = Overlay.ArchMemAdviceRandomAccess
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.ArchMemAdvice = .ArchMemAdviceRandomAccess
        XCTAssertEqual(x, y)
    }
    // MARK: ArchFileAdvice
    func test_ArchFileAdviceNormal() {
        let x: pxr.ArchFileAdvice = Overlay.ArchFileAdviceNormal
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.ArchFileAdvice = .ArchFileAdviceNormal
        XCTAssertEqual(x, y)
    }
    func test_ArchFileAdviceWillNeed() {
        let x: pxr.ArchFileAdvice = Overlay.ArchFileAdviceWillNeed
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.ArchFileAdvice = .ArchFileAdviceWillNeed
        XCTAssertEqual(x, y)
    }
    func test_ArchFileAdviceDontNeed() {
        let x: pxr.ArchFileAdvice = Overlay.ArchFileAdviceDontNeed
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.ArchFileAdvice = .ArchFileAdviceDontNeed
        XCTAssertEqual(x, y)
    }
    func test_ArchFileAdviceRandomAccess() {
        let x: pxr.ArchFileAdvice = Overlay.ArchFileAdviceRandomAccess
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.ArchFileAdvice = .ArchFileAdviceRandomAccess
        XCTAssertEqual(x, y)
    }
    // MARK: ArchMemoryProtection
    func test_ArchMemoryProtectNoAccess() {
        let x: pxr.ArchMemoryProtection = Overlay.ArchProtectNoAccess
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.ArchMemoryProtection = .ArchProtectNoAccess
        XCTAssertEqual(x, y)
    }
    func test_ArchMemoryProtectReadOnly() {
        let x: pxr.ArchMemoryProtection = Overlay.ArchProtectReadOnly
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.ArchMemoryProtection = .ArchProtectReadOnly
        XCTAssertEqual(x, y)
    }
    func test_ArchMemoryProtectReadWrite() {
        let x: pxr.ArchMemoryProtection = Overlay.ArchProtectReadWrite
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.ArchMemoryProtection = .ArchProtectReadWrite
        XCTAssertEqual(x, y)
    }
    func test_ArchMemoryProtectReadWriteCopy() {
        let x: pxr.ArchMemoryProtection = Overlay.ArchProtectReadWriteCopy
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.ArchMemoryProtection = .ArchProtectReadWriteCopy
        XCTAssertEqual(x, y)
    }
    
    // MARK: Tf
    
    // MARK: TfMallocTag.CallTree.PrintSetting
    func test_TfMallocTag_CallTree_TREE() {
        let x: pxr.TfMallocTag.CallTree.PrintSetting = Overlay.TfMallocTag.CallTree.TREE
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.TfMallocTag.CallTree.PrintSetting = .TREE
        XCTAssertEqual(x, y)
    }
    func test_TfMallocTag_CallTree_CALLSITES() {
        let x: pxr.TfMallocTag.CallTree.PrintSetting = Overlay.TfMallocTag.CallTree.CALLSITES
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.TfMallocTag.CallTree.PrintSetting = .CALLSITES
        XCTAssertEqual(x, y)
    }
    func test_TfMallocTag_CallTree_BOTH() {
        let x: pxr.TfMallocTag.CallTree.PrintSetting = Overlay.TfMallocTag.CallTree.BOTH
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.TfMallocTag.CallTree.PrintSetting = .BOTH
        XCTAssertEqual(x, y)
    }
    
    // MARK: TfType.LegacyFlags
    func test_TfType_ABSTRACT() {
        let x: pxr.TfType.LegacyFlags = Overlay.TfType.ABSTRACT
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.TfType.LegacyFlags = .ABSTRACT
        XCTAssertEqual(x, y)
    }
    func test_TfType_CONCRETE() {
        let x: pxr.TfType.LegacyFlags = Overlay.TfType.CONCRETE
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.TfType.LegacyFlags = .CONCRETE
        XCTAssertEqual(x, y)
    }
    func test_TfType_MANUFACTURABLE() {
        let x: pxr.TfType.LegacyFlags = Overlay.TfType.MANUFACTURABLE
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.TfType.LegacyFlags = .MANUFACTURABLE
        XCTAssertEqual(x, y)
    }
    // MARK: TfDiagonisticType
    func test_TF_DIAGNOSTIC_INVALID_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_INVALID_TYPE
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_INVALID_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_DIAGNOSTIC_CODING_ERROR_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_CODING_ERROR_TYPE
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_CODING_ERROR_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_DIAGNOSTIC_FATAL_CODING_ERROR_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_FATAL_CODING_ERROR_TYPE
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_FATAL_CODING_ERROR_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_DIAGNOSTIC_RUNTIME_ERROR_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_RUNTIME_ERROR_TYPE
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_RUNTIME_ERROR_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_DIAGNOSTIC_FATAL_ERROR_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_FATAL_ERROR_TYPE
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_FATAL_ERROR_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_DIAGNOSTIC_NONFATAL_ERROR_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_NONFATAL_ERROR_TYPE
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_NONFATAL_ERROR_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_DIAGNOSTIC_WARNING_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_WARNING_TYPE
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_WARNING_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_DIAGNOSTIC_STATUS_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_DIAGNOSTIC_STATUS_TYPE
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.TfDiagnosticType = .TF_DIAGNOSTIC_STATUS_TYPE
        XCTAssertEqual(x, y)
    }
    func test_TF_APPLICATION_EXIT_TYPE() {
        let x: pxr.TfDiagnosticType = Overlay.TF_APPLICATION_EXIT_TYPE
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.TfDiagnosticType = .TF_APPLICATION_EXIT_TYPE
        XCTAssertEqual(x, y)
    }
    
    // MARK: Gf
    
    // MARK: GfCamera.Projection
    func test_GfCamera_Perspective() {
        let x: pxr.GfCamera.Projection = Overlay.GfCamera.Perspective
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.GfCamera.Projection = .Perspective
        XCTAssertEqual(x, y)
    }
    func test_GfCamera_Orthographic() {
        let x: pxr.GfCamera.Projection = Overlay.GfCamera.Orthographic
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.GfCamera.Projection = .Orthographic
        XCTAssertEqual(x, y)
    }
    // MARK: GfCamera.FOVDirection
    func test_GfCamera_FOVHorizontal() {
        let x: pxr.GfCamera.FOVDirection = Overlay.GfCamera.FOVHorizontal
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.GfCamera.FOVDirection = .FOVHorizontal
        XCTAssertEqual(x, y)
    }
    func test_GfCamera_FOVVertical() {
        let x: pxr.GfCamera.FOVDirection = Overlay.GfCamera.FOVVertical
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.GfCamera.FOVDirection = .FOVVertical
        XCTAssertEqual(x, y)
    }
    // MARK: GfFrustum.ProjectionType
    func test_GfFrustum_Orthographic() {
        let x: pxr.GfFrustum.ProjectionType = Overlay.GfFrustum.Orthographic
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.GfFrustum.ProjectionType = .Orthographic
        XCTAssertEqual(x, y)
    }
    func test_GfFrustum_Perspective() {
        let x: pxr.GfFrustum.ProjectionType = Overlay.GfFrustum.Perspective
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.GfFrustum.ProjectionType = .Perspective
        XCTAssertEqual(x, y)
    }
    
    // MARK: Js
    
    // MARK: JsValue.Type
    func test_JsValue_ObjectType() {
        let x: pxr.JsValue.`Type` = Overlay.JsValue.ObjectType
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.JsValue.`Type` = .ObjectType
        XCTAssertEqual(x, y)
    }
    func test_JsValue_ArrayType() {
        let x: pxr.JsValue.`Type` = Overlay.JsValue.ArrayType
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.JsValue.`Type` = .ArrayType
        XCTAssertEqual(x, y)
    }
    func test_JsValue_StringType() {
        let x: pxr.JsValue.`Type` = Overlay.JsValue.StringType
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.JsValue.`Type` = .StringType
        XCTAssertEqual(x, y)
    }
    func test_JsValue_BoolType() {
        let x: pxr.JsValue.`Type` = Overlay.JsValue.BoolType
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.JsValue.`Type` = .BoolType
        XCTAssertEqual(x, y)
    }
    func test_JsValue_IntType() {
        let x: pxr.JsValue.`Type` = Overlay.JsValue.IntType
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.JsValue.`Type` = .IntType
        XCTAssertEqual(x, y)
    }
    func test_JsValue_RealType() {
        let x: pxr.JsValue.`Type` = Overlay.JsValue.RealType
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.JsValue.`Type` = .RealType
        XCTAssertEqual(x, y)
    }
    func test_JsValue_NullType() {
        let x: pxr.JsValue.`Type` = Overlay.JsValue.NullType
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.JsValue.`Type` = .NullType
        XCTAssertEqual(x, y)
    }
    
    // MARK: Sdf
    
    // MARK: SdfChangeList.SubLayerChangeType
    func test_SubLayerChangeType_SubLayerAdded() {
        let x: pxr.SdfChangeList.SubLayerChangeType = Overlay.SdfChangeList.SubLayerAdded
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfChangeList.SubLayerChangeType = .SubLayerAdded
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    func test_SubLayerChangeType_SubLayerRemoved() {
        let x: pxr.SdfChangeList.SubLayerChangeType = Overlay.SdfChangeList.SubLayerRemoved
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfChangeList.SubLayerChangeType = .SubLayerRemoved
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    func test_SubLayerChangeType_SubLayerOffset() {
        let x: pxr.SdfChangeList.SubLayerChangeType = Overlay.SdfChangeList.SubLayerOffset
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfChangeList.SubLayerChangeType = .SubLayerOffset
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    // MARK: SdfListOpType
    func test_SdfListOpType_SdfListOpTypeExplicit() {
        let x: pxr.SdfListOpType = Overlay.SdfListOpTypeExplicit
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfListOpType = .SdfListOpTypeExplicit
        XCTAssertEqual(x, y)
    }
    func test_SdfListOpType_SdfListOpTypeAdded() {
        let x: pxr.SdfListOpType = Overlay.SdfListOpTypeAdded
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfListOpType = .SdfListOpTypeAdded
        XCTAssertEqual(x, y)
    }
    func test_SdfListOpType_SdfListOpTypeDeleted() {
        let x: pxr.SdfListOpType = Overlay.SdfListOpTypeDeleted
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfListOpType = .SdfListOpTypeDeleted
        XCTAssertEqual(x, y)
    }
    func test_SdfListOpType_SdfListOpTypeOrdered() {
        let x: pxr.SdfListOpType = Overlay.SdfListOpTypeOrdered
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.SdfListOpType = .SdfListOpTypeOrdered
        XCTAssertEqual(x, y)
    }
    func test_SdfListOpType_SdfListOpTypePrepended() {
        let x: pxr.SdfListOpType = Overlay.SdfListOpTypePrepended
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.SdfListOpType = .SdfListOpTypePrepended
        XCTAssertEqual(x, y)
    }
    func test_SdfListOpType_SdfListOpTypeAppended() {
        let x: pxr.SdfListOpType = Overlay.SdfListOpTypeAppended
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.SdfListOpType = .SdfListOpTypeAppended
        XCTAssertEqual(x, y)
    }
    // MARK: SdfNamespaceEditDetail.Result
    func test_SdfNamespaceEditDetail_Error() {
        let x: pxr.SdfNamespaceEditDetail.Result = Overlay.SdfNamespaceEditDetail.Error
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfNamespaceEditDetail.Result = .Error
        XCTAssertEqual(x, y)
    }
    func test_SdfNamespaceEditDetail_Unbatched() {
        let x: pxr.SdfNamespaceEditDetail.Result = Overlay.SdfNamespaceEditDetail.Unbatched
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfNamespaceEditDetail.Result = .Unbatched
        XCTAssertEqual(x, y)
    }
    func test_SdfNamespaceEditDetail_Okay() {
        let x: pxr.SdfNamespaceEditDetail.Result = Overlay.SdfNamespaceEditDetail.Okay
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfNamespaceEditDetail.Result = .Okay
        XCTAssertEqual(x, y)
    }
    // MARK: SdfPathExpression.Op
    func test_SdfPathExpression_Complement() {
        let x: pxr.SdfPathExpression.Op = Overlay.SdfPathExpression.Complement
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfPathExpression.Op = .Complement
        XCTAssertEqual(x, y)
    }
    func test_SdfPathExpression_ImpliedUnion() {
        let x: pxr.SdfPathExpression.Op = Overlay.SdfPathExpression.ImpliedUnion
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfPathExpression.Op = .ImpliedUnion
        XCTAssertEqual(x, y)
    }
    func test_SdfPathExpression_Union() {
        let x: pxr.SdfPathExpression.Op = Overlay.SdfPathExpression.Union
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfPathExpression.Op = .Union
        XCTAssertEqual(x, y)
    }
    func test_SdfPathExpression_Intersection() {
        let x: pxr.SdfPathExpression.Op = Overlay.SdfPathExpression.Intersection
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.SdfPathExpression.Op = .Intersection
        XCTAssertEqual(x, y)
    }
    func test_SdfPathExpression_Difference() {
        let x: pxr.SdfPathExpression.Op = Overlay.SdfPathExpression.Difference
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.SdfPathExpression.Op = .Difference
        XCTAssertEqual(x, y)
    }
    func test_SdfPathExpression_ExpressionRef() {
        let x: pxr.SdfPathExpression.Op = Overlay.SdfPathExpression.ExpressionRef
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.SdfPathExpression.Op = .ExpressionRef
        XCTAssertEqual(x, y)
    }
    func test_SdfPathExpression_Pattern() {
        let x: pxr.SdfPathExpression.Op = Overlay.SdfPathExpression.Pattern
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.SdfPathExpression.Op = .Pattern
        XCTAssertEqual(x, y)
    }
    // MARK: SdfPredicateExpression.FnCall.Kind
    func test_SdfPredicateExpression_FnCall_BareCall() {
        let x: pxr.SdfPredicateExpression.FnCall.Kind = Overlay.SdfPredicateExpression.FnCall.BareCall
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfPredicateExpression.FnCall.Kind = .BareCall
        XCTAssertEqual(x, y)
    }
    func test_SdfPredicateExpression_FnCall_ColonCall() {
        let x: pxr.SdfPredicateExpression.FnCall.Kind = Overlay.SdfPredicateExpression.FnCall.ColonCall
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfPredicateExpression.FnCall.Kind = .ColonCall
        XCTAssertEqual(x, y)
    }
    func test_SdfPredicateExpression_FnCall_ParenCall() {
        let x: pxr.SdfPredicateExpression.FnCall.Kind = Overlay.SdfPredicateExpression.FnCall.ParenCall
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfPredicateExpression.FnCall.Kind = .ParenCall
        XCTAssertEqual(x, y)
    }
    // MARK: SdfPredicateExpression.Op
    func test_SdfPredicateExpression_Call() {
        let x: pxr.SdfPredicateExpression.Op = Overlay.SdfPredicateExpression.Call
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfPredicateExpression.Op = .Call
        XCTAssertEqual(x, y)
    }
    func test_SdfPredicateExpression_Not() {
        let x: pxr.SdfPredicateExpression.Op = Overlay.SdfPredicateExpression.Not
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfPredicateExpression.Op = .Not
        XCTAssertEqual(x, y)
    }
    func test_SdfPredicateExpression_ImpliedAnd() {
        let x: pxr.SdfPredicateExpression.Op = Overlay.SdfPredicateExpression.ImpliedAnd
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfPredicateExpression.Op = .ImpliedAnd
        XCTAssertEqual(x, y)
    }
    func test_SdfPredicateExpression_And() {
        let x: pxr.SdfPredicateExpression.Op = Overlay.SdfPredicateExpression.And
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.SdfPredicateExpression.Op = .And
        XCTAssertEqual(x, y)
    }
    func test_SdfPredicateExpression_Or() {
        let x: pxr.SdfPredicateExpression.Op = Overlay.SdfPredicateExpression.Or
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.SdfPredicateExpression.Op = .Or
        XCTAssertEqual(x, y)
    }
    // MARK: SdfPredicateFunctionResult.Constancy
    func test_SdfPredicateFunctionResult_ConstantOverDescendants() {
        let x: pxr.SdfPredicateFunctionResult.Constancy = Overlay.SdfPredicateFunctionResult.ConstantOverDescendants
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfPredicateFunctionResult.Constancy = .ConstantOverDescendants
        XCTAssertEqual(x, y)
    }
    func test_SdfPredicateFunctionResult_MayVaryOverDescendants() {
        let x: pxr.SdfPredicateFunctionResult.Constancy = Overlay.SdfPredicateFunctionResult.MayVaryOverDescendants
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfPredicateFunctionResult.Constancy = .MayVaryOverDescendants
        XCTAssertEqual(x, y)
    }
    // MARK: SdfSpecType
    func test_SdfSpecTypeUnknown() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeUnknown
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfSpecType = .SdfSpecTypeUnknown
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeAttribute() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeAttribute
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfSpecType = .SdfSpecTypeAttribute
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeConnection() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeConnection
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfSpecType = .SdfSpecTypeConnection
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeExpression() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeExpression
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.SdfSpecType = .SdfSpecTypeExpression
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeMapper() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeMapper
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.SdfSpecType = .SdfSpecTypeMapper
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeMapperArg() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeMapperArg
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.SdfSpecType = .SdfSpecTypeMapperArg
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypePrim() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypePrim
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.SdfSpecType = .SdfSpecTypePrim
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypePseudoRoot() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypePseudoRoot
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.SdfSpecType = .SdfSpecTypePseudoRoot
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeRelationship() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeRelationship
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.SdfSpecType = .SdfSpecTypeRelationship
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeRelationshipTarget() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeRelationshipTarget
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.SdfSpecType = .SdfSpecTypeRelationshipTarget
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeVariant() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeVariant
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.SdfSpecType = .SdfSpecTypeVariant
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecTypeVariantSet() {
        let x: pxr.SdfSpecType = Overlay.SdfSpecTypeVariantSet
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.SdfSpecType = .SdfSpecTypeVariantSet
        XCTAssertEqual(x, y)
    }
    func test_SdfNumSpecTypes() {
        let x: pxr.SdfSpecType = Overlay.SdfNumSpecTypes
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.SdfSpecType = .SdfNumSpecTypes
        XCTAssertEqual(x, y)
    }
    // MARK: SdfSpecifier
    func test_SdfSpecifierDef() {
        let x: pxr.SdfSpecifier = Overlay.SdfSpecifierDef
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfSpecifier = .SdfSpecifierDef
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecifierOver() {
        let x: pxr.SdfSpecifier = Overlay.SdfSpecifierOver
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfSpecifier = .SdfSpecifierOver
        XCTAssertEqual(x, y)
    }
    func test_SdfSpecifierClass() {
        let x: pxr.SdfSpecifier = Overlay.SdfSpecifierClass
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfSpecifier = .SdfSpecifierClass
        XCTAssertEqual(x, y)
    }
    func test_SdfNumSpecifiers() {
        let x: pxr.SdfSpecifier = Overlay.SdfNumSpecifiers
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.SdfSpecifier = .SdfNumSpecifiers
        XCTAssertEqual(x, y)
    }
    // MARK: SdfPermission
    func test_SdfPermissionPublic() {
        let x: pxr.SdfPermission = Overlay.SdfPermissionPublic
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfPermission = .SdfPermissionPublic
        XCTAssertEqual(x, y)
    }
    func test_SdfPermissionPrivate() {
        let x: pxr.SdfPermission = Overlay.SdfPermissionPrivate
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfPermission = .SdfPermissionPrivate
        XCTAssertEqual(x, y)
    }
    func test_SdfNumPermissions() {
        let x: pxr.SdfPermission = Overlay.SdfNumPermissions
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfPermission = .SdfNumPermissions
        XCTAssertEqual(x, y)
    }
    // MARK: SdfVariability
    func test_SdfVariabilityVarying() {
        let x: pxr.SdfVariability = Overlay.SdfVariabilityVarying
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfVariability = .SdfVariabilityVarying
        XCTAssertEqual(x, y)
    }
    func test_SdfVariabilityUniform() {
        let x: pxr.SdfVariability = Overlay.SdfVariabilityUniform
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfVariability = .SdfVariabilityUniform
        XCTAssertEqual(x, y)
    }
    func test_SdfNumVariabilities() {
        let x: pxr.SdfVariability = Overlay.SdfNumVariabilities
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.SdfVariability = .SdfNumVariabilities
        XCTAssertEqual(x, y)
    }
    // MARK: SdfAuthoringError
    func test_SdfAuthoringErrorUnrecognizedFields() {
        let x: pxr.SdfAuthoringError = Overlay.SdfAuthoringErrorUnrecognizedFields
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.SdfAuthoringError = .SdfAuthoringErrorUnrecognizedFields
        XCTAssertEqual(x, y)
    }
    func test_SdfAuthoringErrorUnrecognizedSpecType() {
        let x: pxr.SdfAuthoringError = Overlay.SdfAuthoringErrorUnrecognizedSpecType
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.SdfAuthoringError = .SdfAuthoringErrorUnrecognizedSpecType
        XCTAssertEqual(x, y)
    }
    
    // MARK: Pcp
    
    // MARK: PcpCacheChanges.TargetType
    func test_PcpCacheChanges_TargetTypeConnection() {
        let x: pxr.PcpCacheChanges.TargetType = Overlay.PcpCacheChanges.TargetTypeConnection
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.PcpCacheChanges.TargetType = .TargetTypeConnection
        XCTAssertEqual(x, y)
    }
    func test_PcpCacheChanges_TargetTypeRelationshipTarget() {
        let x: pxr.PcpCacheChanges.TargetType = Overlay.PcpCacheChanges.TargetTypeRelationshipTarget
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.PcpCacheChanges.TargetType = .TargetTypeRelationshipTarget
        XCTAssertEqual(x, y)
    }
    // MARK: PcpDependencyType
    func test_PcpDependencyTypeNone() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeNone
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypeRoot() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeRoot
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeRoot
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypePurelyDirect() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypePurelyDirect
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.PcpDependencyType = .PcpDependencyTypePurelyDirect
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypePartlyDirect() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypePartlyDirect
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.PcpDependencyType = .PcpDependencyTypePartlyDirect
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypeAncestral() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeAncestral
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeAncestral
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypeVirtual() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeVirtual
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeVirtual
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypeNonVirtual() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeNonVirtual
        XCTAssertEqual(x.rawValue, 32)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeNonVirtual
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypeDirect() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeDirect
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeDirect
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypeAnyNonVirtual() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeAnyNonVirtual
        XCTAssertEqual(x.rawValue, 47)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeAnyNonVirtual
        XCTAssertEqual(x, y)
    }
    func test_PcpDependencyTypeAnyIncludingVirtual() {
        let x: pxr.PcpDependencyType = Overlay.PcpDependencyTypeAnyIncludingVirtual
        XCTAssertEqual(x.rawValue, 63)
        let y: pxr.PcpDependencyType = .PcpDependencyTypeAnyIncludingVirtual
        XCTAssertEqual(x, y)
    }
    // MARK: PcpErrorType
    func test_PcpErrorType_ArcCycle() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_ArcCycle
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.PcpErrorType = .PcpErrorType_ArcCycle
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_ArcPermissionDenied() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_ArcPermissionDenied
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.PcpErrorType = .PcpErrorType_ArcPermissionDenied
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_ArcToProhibitedChild() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_ArcToProhibitedChild
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.PcpErrorType = .PcpErrorType_ArcToProhibitedChild
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_IndexCapacityExceeded() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_IndexCapacityExceeded
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.PcpErrorType = .PcpErrorType_IndexCapacityExceeded
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_ArcCapacityExceeded() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_ArcCapacityExceeded
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.PcpErrorType = .PcpErrorType_ArcCapacityExceeded
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_ArcNamespaceDepthCapacityExceeded() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_ArcNamespaceDepthCapacityExceeded
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.PcpErrorType = .PcpErrorType_ArcNamespaceDepthCapacityExceeded
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InconsistentPropertyType() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InconsistentPropertyType
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.PcpErrorType = .PcpErrorType_InconsistentPropertyType
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InconsistentAttributeType() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InconsistentAttributeType
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.PcpErrorType = .PcpErrorType_InconsistentAttributeType
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InconsistentAttributeVariability() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InconsistentAttributeVariability
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.PcpErrorType = .PcpErrorType_InconsistentAttributeVariability
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InternalAssetPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InternalAssetPath
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.PcpErrorType = .PcpErrorType_InternalAssetPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidPrimPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidPrimPath
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidPrimPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidAssetPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidAssetPath
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidAssetPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidInstanceTargetPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidInstanceTargetPath
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidInstanceTargetPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidExternalTargetPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidExternalTargetPath
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidExternalTargetPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidTargetPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidTargetPath
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidTargetPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidReferenceOffset() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidReferenceOffset
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidReferenceOffset
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidSublayerOffset() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidSublayerOffset
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidSublayerOffset
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidSublayerOwnership() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidSublayerOwnership
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidSublayerOwnership
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidSublayerPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidSublayerPath
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidSublayerPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidVariantSelection() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidVariantSelection
        XCTAssertEqual(x.rawValue, 19)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidVariantSelection
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_MutedAssetPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_MutedAssetPath
        XCTAssertEqual(x.rawValue, 20)
        let y: pxr.PcpErrorType = .PcpErrorType_MutedAssetPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidAuthoredRelocation() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidAuthoredRelocation
        XCTAssertEqual(x.rawValue, 21)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidAuthoredRelocation
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidConflictingRelocation() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidConflictingRelocation
        XCTAssertEqual(x.rawValue, 22)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidConflictingRelocation
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_InvalidSameTargetRelocations() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_InvalidSameTargetRelocations
        XCTAssertEqual(x.rawValue, 23)
        let y: pxr.PcpErrorType = .PcpErrorType_InvalidSameTargetRelocations
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_OpinionAtRelocationSource() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_OpinionAtRelocationSource
        XCTAssertEqual(x.rawValue, 24)
        let y: pxr.PcpErrorType = .PcpErrorType_OpinionAtRelocationSource
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_PrimPermissionDenied() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_PrimPermissionDenied
        XCTAssertEqual(x.rawValue, 25)
        let y: pxr.PcpErrorType = .PcpErrorType_PrimPermissionDenied
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_PropertyPermissionDenied() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_PropertyPermissionDenied
        XCTAssertEqual(x.rawValue, 26)
        let y: pxr.PcpErrorType = .PcpErrorType_PropertyPermissionDenied
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_SublayerCycle() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_SublayerCycle
        XCTAssertEqual(x.rawValue, 27)
        let y: pxr.PcpErrorType = .PcpErrorType_SublayerCycle
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_TargetPermissionDenied() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_TargetPermissionDenied
        XCTAssertEqual(x.rawValue, 28)
        let y: pxr.PcpErrorType = .PcpErrorType_TargetPermissionDenied
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_UnresolvedPrimPath() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_UnresolvedPrimPath
        XCTAssertEqual(x.rawValue, 29)
        let y: pxr.PcpErrorType = .PcpErrorType_UnresolvedPrimPath
        XCTAssertEqual(x, y)
    }
    func test_PcpErrorType_VariableExpressionError() {
        let x: pxr.PcpErrorType = Overlay.PcpErrorType_VariableExpressionError
        XCTAssertEqual(x.rawValue, 30)
        let y: pxr.PcpErrorType = .PcpErrorType_VariableExpressionError
        XCTAssertEqual(x, y)
    }
    // MARK: PcpNamespaceEdits.EditType
    func test_PcpNamespaceEdits_EditPath() {
        let x: pxr.PcpNamespaceEdits.EditType = Overlay.PcpNamespaceEdits.EditPath
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.PcpNamespaceEdits.EditType = .EditPath
        XCTAssertEqual(x, y)
    }
    func test_PcpNamespaceEdits_EditInherit() {
        let x: pxr.PcpNamespaceEdits.EditType = Overlay.PcpNamespaceEdits.EditInherit
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.PcpNamespaceEdits.EditType = .EditInherit
        XCTAssertEqual(x, y)
    }
    func test_PcpNamespaceEdits_EditSpecializes() {
        let x: pxr.PcpNamespaceEdits.EditType = Overlay.PcpNamespaceEdits.EditSpecializes
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.PcpNamespaceEdits.EditType = .EditSpecializes
        XCTAssertEqual(x, y)
    }
    func test_PcpNamespaceEdits_EditReference() {
        let x: pxr.PcpNamespaceEdits.EditType = Overlay.PcpNamespaceEdits.EditReference
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.PcpNamespaceEdits.EditType = .EditReference
        XCTAssertEqual(x, y)
    }
    func test_PcpNamespaceEdits_EditPayload() {
        let x: pxr.PcpNamespaceEdits.EditType = Overlay.PcpNamespaceEdits.EditPayload
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.PcpNamespaceEdits.EditType = .EditPayload
        XCTAssertEqual(x, y)
    }
    func test_PcpNamespaceEdits_EditRelocate() {
        let x: pxr.PcpNamespaceEdits.EditType = Overlay.PcpNamespaceEdits.EditRelocate
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.PcpNamespaceEdits.EditType = .EditRelocate
        XCTAssertEqual(x, y)
    }
    // MARK: PcpArcType
    func test_PcpArcTypeRoot() {
        let x: pxr.PcpArcType = Overlay.PcpArcTypeRoot
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.PcpArcType = .PcpArcTypeRoot
        XCTAssertEqual(x, y)
    }
    func test_PcpArcTypeInherit() {
        let x: pxr.PcpArcType = Overlay.PcpArcTypeInherit
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.PcpArcType = .PcpArcTypeInherit
        XCTAssertEqual(x, y)
    }
    func test_PcpArcTypeVariant() {
        let x: pxr.PcpArcType = Overlay.PcpArcTypeVariant
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.PcpArcType = .PcpArcTypeVariant
        XCTAssertEqual(x, y)
    }
    func test_PcpArcTypeRelocate() {
        let x: pxr.PcpArcType = Overlay.PcpArcTypeRelocate
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.PcpArcType = .PcpArcTypeRelocate
        XCTAssertEqual(x, y)
    }
    func test_PcpArcTypeReference() {
        let x: pxr.PcpArcType = Overlay.PcpArcTypeReference
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.PcpArcType = .PcpArcTypeReference
        XCTAssertEqual(x, y)
    }
    func test_PcpArcTypePayload() {
        let x: pxr.PcpArcType = Overlay.PcpArcTypePayload
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.PcpArcType = .PcpArcTypePayload
        XCTAssertEqual(x, y)
    }
    func test_PcpArcTypeSpecialize() {
        let x: pxr.PcpArcType = Overlay.PcpArcTypeSpecialize
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.PcpArcType = .PcpArcTypeSpecialize
        XCTAssertEqual(x, y)
    }
    func test_PcpNumArcTypes() {
        let x: pxr.PcpArcType = Overlay.PcpNumArcTypes
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.PcpArcType = .PcpNumArcTypes
        XCTAssertEqual(x, y)
    }
    // MARK: PcpRangeType
    func test_PcpRangeTypeRoot() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeRoot
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.PcpRangeType = .PcpRangeTypeRoot
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypeInherit() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeInherit
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.PcpRangeType = .PcpRangeTypeInherit
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypeVariant() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeVariant
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.PcpRangeType = .PcpRangeTypeVariant
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypeReference() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeReference
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.PcpRangeType = .PcpRangeTypeReference
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypePayload() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypePayload
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.PcpRangeType = .PcpRangeTypePayload
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypeSpecialize() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeSpecialize
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.PcpRangeType = .PcpRangeTypeSpecialize
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypAll() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeAll
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.PcpRangeType = .PcpRangeTypeAll
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypeWeakerThanRoot() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeWeakerThanRoot
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.PcpRangeType = .PcpRangeTypeWeakerThanRoot
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypeStrongerThanPaylod() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeStrongerThanPayload
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.PcpRangeType = .PcpRangeTypeStrongerThanPayload
        XCTAssertEqual(x, y)
    }
    func test_PcpRangeTypeInvalid() {
        let x: pxr.PcpRangeType = Overlay.PcpRangeTypeInvalid
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.PcpRangeType = .PcpRangeTypeInvalid
        XCTAssertEqual(x, y)
    }
    
    // MARK: Usd
    
    // MARK: UsdListPosition
    func test_UsdListPositionFrontOfPrependList() {
        let x: pxr.UsdListPosition = Overlay.UsdListPositionFrontOfPrependList
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdListPosition = .UsdListPositionFrontOfPrependList
        XCTAssertEqual(x, y)
    }
    func test_UsdListPositionBackOfPrependList() {
        let x: pxr.UsdListPosition = Overlay.UsdListPositionBackOfPrependList
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdListPosition = .UsdListPositionBackOfPrependList
        XCTAssertEqual(x, y)
    }
    func test_UsdListPositionFrontOfAppendList() {
        let x: pxr.UsdListPosition = Overlay.UsdListPositionFrontOfAppendList
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdListPosition = .UsdListPositionFrontOfAppendList
        XCTAssertEqual(x, y)
    }
    func test_UsdListPositionBackOfAppendList() {
        let x: pxr.UsdListPosition = Overlay.UsdListPositionBackOfAppendList
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdListPosition = .UsdListPositionBackOfAppendList
        XCTAssertEqual(x, y)
    }
    // MARK: UsdLoadPolicy
    func test_UsdLoadWithDescendants() {
        let x: pxr.UsdLoadPolicy = Overlay.UsdLoadWithDescendants
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdLoadPolicy = .UsdLoadWithDescendants
        XCTAssertEqual(x, y)
    }
    func test_UsdLoadWithoutDescendants() {
        let x: pxr.UsdLoadPolicy = Overlay.UsdLoadWithoutDescendants
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdLoadPolicy = .UsdLoadWithoutDescendants
        XCTAssertEqual(x, y)
    }
    // MARK: UsdSchemaKind
    func test_UsdSchemaKind_Invalid() {
        let x: pxr.UsdSchemaKind = Overlay.UsdSchemaKind.Invalid
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdSchemaKind = .Invalid
        XCTAssertEqual(x, y)
    }
    func test_UsdSchemaKind_AbstractBase() {
        let x: pxr.UsdSchemaKind = Overlay.UsdSchemaKind.AbstractBase
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdSchemaKind = .AbstractBase
        XCTAssertEqual(x, y)
    }
    func test_UsdSchemaKind_AbstractTyped() {
        let x: pxr.UsdSchemaKind = Overlay.UsdSchemaKind.AbstractTyped
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdSchemaKind = .AbstractTyped
        XCTAssertEqual(x, y)
    }
    func test_UsdSchemaKind_ConcreteTyped() {
        let x: pxr.UsdSchemaKind = Overlay.UsdSchemaKind.ConcreteTyped
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdSchemaKind = .ConcreteTyped
        XCTAssertEqual(x, y)
    }
    func test_UsdSchemaKind_NonAppliedAPI() {
        let x: pxr.UsdSchemaKind = Overlay.UsdSchemaKind.NonAppliedAPI
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdSchemaKind = .NonAppliedAPI
        XCTAssertEqual(x, y)
    }
    func test_UsdSchemaKind_SingleApplyAPI() {
        let x: pxr.UsdSchemaKind = Overlay.UsdSchemaKind.SingleApplyAPI
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.UsdSchemaKind = .SingleApplyAPI
        XCTAssertEqual(x, y)
    }
    func test_UsdSchemaKind_MultipleApplyAPI() {
        let x: pxr.UsdSchemaKind = Overlay.UsdSchemaKind.MultipleApplyAPI
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.UsdSchemaKind = .MultipleApplyAPI
        XCTAssertEqual(x, y)
    }
    // MARK: UsdInterpolationType
    func test_UsdInterpolationTypeHeld() {
        let x: pxr.UsdInterpolationType = Overlay.UsdInterpolationTypeHeld
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdInterpolationType = .UsdInterpolationTypeHeld
        XCTAssertEqual(x, y)
    }
    func test_UsdInterpolationTypeLinear() {
        let x: pxr.UsdInterpolationType = Overlay.UsdInterpolationTypeLinear
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdInterpolationType = .UsdInterpolationTypeLinear
        XCTAssertEqual(x, y)
    }
    // MARK: UsdModelAPI.KindValidation
    func test_UsdModelAPI_KindValidationNone() {
        let x: pxr.UsdModelAPI.KindValidation = Overlay.UsdModelAPI.KindValidationNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdModelAPI.KindValidation = .KindValidationNone
        XCTAssertEqual(x, y)
    }
    func test_UsdModelAPI_KindValidationModelHierarchy() {
        let x: pxr.UsdModelAPI.KindValidation = Overlay.UsdModelAPI.KindValidationModelHierarchy
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdModelAPI.KindValidation = .KindValidationModelHierarchy
        XCTAssertEqual(x, y)
    }
    // MARK: UsdObjType
    func test_UsdTypeObject() {
        let x: pxr.UsdObjType = Overlay.UsdTypeObject
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdObjType = .UsdTypeObject
        XCTAssertEqual(x, y)
    }
    func test_UsdTypePrim() {
        let x: pxr.UsdObjType = Overlay.UsdTypePrim
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdObjType = .UsdTypePrim
        XCTAssertEqual(x, y)
    }
    func test_UsdTypeProperty() {
        let x: pxr.UsdObjType = Overlay.UsdTypeProperty
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdObjType = .UsdTypeProperty
        XCTAssertEqual(x, y)
    }
    func test_UsdTypeAttribute() {
        let x: pxr.UsdObjType = Overlay.UsdTypeAttribute
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdObjType = .UsdTypeAttribute
        XCTAssertEqual(x, y)
    }
    func test_UsdTypeRelationship() {
        let x: pxr.UsdObjType = Overlay.UsdTypeRelationship
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdObjType = .UsdTypeRelationship
        XCTAssertEqual(x, y)
    }
    func test_Usd_NumObjTypes() {
        let x: pxr.UsdObjType = Overlay.Usd_NumObjTypes
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.UsdObjType = .Usd_NumObjTypes
        XCTAssertEqual(x, y)
    }
    // MARK: UsdPrimCompositionQuery.ArcTypeFilter
    func test_UsdPrimCompositionQuery_ArcTypeFilter_All() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.All
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .All
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_Reference() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.Reference
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .Reference
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_Payload() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.Payload
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .Payload
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_Inherit() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.Inherit
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .Inherit
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_Specialize() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.Specialize
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .Specialize
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_Variant() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.Variant
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .Variant
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_ReferenceOrPayload() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.ReferenceOrPayload
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .ReferenceOrPayload
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_InheritOrSpecialize() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.InheritOrSpecialize
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .InheritOrSpecialize
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_NotReferenceOrPayload() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.NotReferenceOrPayload
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .NotReferenceOrPayload
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_NotInheritOrSpecialize() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.NotInheritOrSpecialize
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .NotInheritOrSpecialize
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcTypeFilter_NotVariant() {
        let x: pxr.UsdPrimCompositionQuery.ArcTypeFilter = Overlay.UsdPrimCompositionQuery.ArcTypeFilter.NotVariant
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.UsdPrimCompositionQuery.ArcTypeFilter = .NotVariant
        XCTAssertEqual(x, y)
    }
    // MARK: UsdPrimCompositionQuery.DependencyTypeFilter
    func test_UsdPrimCompositionQuery_DependencyTypeFilter_All() {
        let x: pxr.UsdPrimCompositionQuery.DependencyTypeFilter = Overlay.UsdPrimCompositionQuery.DependencyTypeFilter.All
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdPrimCompositionQuery.DependencyTypeFilter = .All
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_DependencyTypeFilter_Direct() {
        let x: pxr.UsdPrimCompositionQuery.DependencyTypeFilter = Overlay.UsdPrimCompositionQuery.DependencyTypeFilter.Direct
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdPrimCompositionQuery.DependencyTypeFilter = .Direct
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_DependencyTypeFilter_Ancestral() {
        let x: pxr.UsdPrimCompositionQuery.DependencyTypeFilter = Overlay.UsdPrimCompositionQuery.DependencyTypeFilter.Ancestral
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdPrimCompositionQuery.DependencyTypeFilter = .Ancestral
        XCTAssertEqual(x, y)
    }
    // MARK: UsdPrimCompositionQuery.ArcIntroducedFilter
    func test_UsdPrimCompositionQuery_ArcIntroducedFilter_All() {
        let x: pxr.UsdPrimCompositionQuery.ArcIntroducedFilter = Overlay.UsdPrimCompositionQuery.ArcIntroducedFilter.All
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdPrimCompositionQuery.ArcIntroducedFilter = .All
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcIntroducedFilter_IntroducedRootLayerStack() {
        let x: pxr.UsdPrimCompositionQuery.ArcIntroducedFilter = Overlay.UsdPrimCompositionQuery.ArcIntroducedFilter.IntroducedInRootLayerStack
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdPrimCompositionQuery.ArcIntroducedFilter = .IntroducedInRootLayerStack
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_ArcIntroducedFilter_IntroducedInRootLayerPrimSpec() {
        let x: pxr.UsdPrimCompositionQuery.ArcIntroducedFilter = Overlay.UsdPrimCompositionQuery.ArcIntroducedFilter.IntroducedInRootLayerPrimSpec
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdPrimCompositionQuery.ArcIntroducedFilter = .IntroducedInRootLayerPrimSpec
        XCTAssertEqual(x, y)
    }
    // MARK: UsdPrimCompositionQuery.HasSpecsFilter
    func test_UsdPrimCompositionQuery_HasSpecsFilter_All() {
        let x: pxr.UsdPrimCompositionQuery.HasSpecsFilter = Overlay.UsdPrimCompositionQuery.HasSpecsFilter.All
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdPrimCompositionQuery.HasSpecsFilter = .All
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_HasSpecsFilter_HasSpecs() {
        let x: pxr.UsdPrimCompositionQuery.HasSpecsFilter = Overlay.UsdPrimCompositionQuery.HasSpecsFilter.HasSpecs
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdPrimCompositionQuery.HasSpecsFilter = .HasSpecs
        XCTAssertEqual(x, y)
    }
    func test_UsdPrimCompositionQuery_HasSpecsFilter_HasNoSpecs() {
        let x: pxr.UsdPrimCompositionQuery.HasSpecsFilter = Overlay.UsdPrimCompositionQuery.HasSpecsFilter.HasNoSpecs
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdPrimCompositionQuery.HasSpecsFilter = .HasNoSpecs
        XCTAssertEqual(x, y)
    }
    // MARK: Usd_PrimFlags
    func test_Usd_PrimActiveFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimActiveFlag
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.Usd_PrimFlags = .Usd_PrimActiveFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimLoadedFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimLoadedFlag
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.Usd_PrimFlags = .Usd_PrimLoadedFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimModelFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimModelFlag
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.Usd_PrimFlags = .Usd_PrimModelFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimGroupFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimGroupFlag
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.Usd_PrimFlags = .Usd_PrimGroupFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimComponentFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimComponentFlag
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.Usd_PrimFlags = .Usd_PrimComponentFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimAbstractFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimAbstractFlag
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.Usd_PrimFlags = .Usd_PrimAbstractFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimDefinedFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimDefinedFlag
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.Usd_PrimFlags = .Usd_PrimDefinedFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimHasDefiningSpecifierFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimHasDefiningSpecifierFlag
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.Usd_PrimFlags = .Usd_PrimHasDefiningSpecifierFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimInstanceFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimInstanceFlag
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.Usd_PrimFlags = .Usd_PrimInstanceFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimHasPayloadFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimHasPayloadFlag
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.Usd_PrimFlags = .Usd_PrimHasPayloadFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimClipsFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimClipsFlag
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.Usd_PrimFlags = .Usd_PrimClipsFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimDeadFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimDeadFlag
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.Usd_PrimFlags = .Usd_PrimDeadFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimPrototypeFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimPrototypeFlag
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.Usd_PrimFlags = .Usd_PrimPrototypeFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimInstanceProxyFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimInstanceProxyFlag
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.Usd_PrimFlags = .Usd_PrimInstanceProxyFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimPseudoRootFlag() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimPseudoRootFlag
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.Usd_PrimFlags = .Usd_PrimPseudoRootFlag
        XCTAssertEqual(x, y)
    }
    func test_Usd_PrimNumFlags() {
        let x: pxr.Usd_PrimFlags = Overlay.Usd_PrimNumFlags
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.Usd_PrimFlags = .Usd_PrimNumFlags
        XCTAssertEqual(x, y)
    }
    // MARK: UsdResolveInfoSource
    func test_UsdResolveInfoSourceNone() {
        let x: pxr.UsdResolveInfoSource = Overlay.UsdResolveInfoSourceNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdResolveInfoSource = .UsdResolveInfoSourceNone
        XCTAssertEqual(x, y)
    }
    func test_UsdResolveInfoSourceFallback() {
        let x: pxr.UsdResolveInfoSource = Overlay.UsdResolveInfoSourceFallback
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdResolveInfoSource = .UsdResolveInfoSourceFallback
        XCTAssertEqual(x, y)
    }
    func test_UsdResolveInfoSourceDefault() {
        let x: pxr.UsdResolveInfoSource = Overlay.UsdResolveInfoSourceDefault
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdResolveInfoSource = .UsdResolveInfoSourceDefault
        XCTAssertEqual(x, y)
    }
    func test_UsdResolveInfoSourceTimeSamples() {
        let x: pxr.UsdResolveInfoSource = Overlay.UsdResolveInfoSourceTimeSamples
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdResolveInfoSource = .UsdResolveInfoSourceTimeSamples
        XCTAssertEqual(x, y)
    }
    func test_UsdResolveInfoSourceValueClips() {
        let x: pxr.UsdResolveInfoSource = Overlay.UsdResolveInfoSourceValueClips
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdResolveInfoSource = .UsdResolveInfoSourceValueClips
        XCTAssertEqual(x, y)
    }
    // MARK: UsdStage.InitialLoadSet
    func test_UsdStage_LoadAll() {
        let x: pxr.UsdStage.InitialLoadSet = Overlay.UsdStage.LoadAll
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdStage.InitialLoadSet = .LoadAll
        XCTAssertEqual(x, y)
    }
    func test_UsdStage_LoadNone() {
        let x: pxr.UsdStage.InitialLoadSet = Overlay.UsdStage.LoadNone
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdStage.InitialLoadSet = .LoadNone
        XCTAssertEqual(x, y)
    }
    // MARK: UsdStageCacheContext
    func test_UsdBlockStageCaches() {
        let x: pxr.UsdStageCacheContextBlockType = Overlay.UsdBlockStageCaches
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdStageCacheContextBlockType = .UsdBlockStageCaches
        XCTAssertEqual(x, y)
    }
    func test_UsdBlockStageCachePopulation() {
        let x: pxr.UsdStageCacheContextBlockType = Overlay.UsdBlockStageCachePopulation
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdStageCacheContextBlockType = .UsdBlockStageCachePopulation
        XCTAssertEqual(x, y)
    }
    func test_Usd_NoBlock() {
        let x: pxr.UsdStageCacheContextBlockType = Overlay.Usd_NoBlock
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdStageCacheContextBlockType = .Usd_NoBlock
        XCTAssertEqual(x, y)
    }
    // MARK: UsdStageLoadRules.Rule
    func test_UsdStageLoadRules_AllRule() {
        let x: pxr.UsdStageLoadRules.Rule = Overlay.UsdStageLoadRules.AllRule
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdStageLoadRules.Rule = .AllRule
        XCTAssertEqual(x, y)
    }
    func test_UsdStageLoadRules_OnlyRule() {
        let x: pxr.UsdStageLoadRules.Rule = Overlay.UsdStageLoadRules.OnlyRule
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdStageLoadRules.Rule = .OnlyRule
        XCTAssertEqual(x, y)
    }
    func test_UsdStageLoadRules_NoneRule() {
        let x: pxr.UsdStageLoadRules.Rule = Overlay.UsdStageLoadRules.NoneRule
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdStageLoadRules.Rule = .NoneRule
        XCTAssertEqual(x, y)
    }
    
    // MARK: UsdGeom
    
    // MARK: UsdGeomPointInstancer.ProtoXformInclusion
    func test_UsdGeomPointInstancer_IncludeProtoXform() {
        let x: pxr.UsdGeomPointInstancer.ProtoXformInclusion = Overlay.UsdGeomPointInstancer.IncludeProtoXform
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdGeomPointInstancer.ProtoXformInclusion = .IncludeProtoXform
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomPointInstancer_ExcludeProtoXform() {
        let x: pxr.UsdGeomPointInstancer.ProtoXformInclusion = Overlay.UsdGeomPointInstancer.ExcludeProtoXform
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdGeomPointInstancer.ProtoXformInclusion = .ExcludeProtoXform
        XCTAssertEqual(x, y)
    }
    // MARK: UsdGeomPointInstancer.MaskApplication
    func test_UsdGeomPointInstancer_ApplyMask() {
        let x: pxr.UsdGeomPointInstancer.MaskApplication = Overlay.UsdGeomPointInstancer.ApplyMask
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdGeomPointInstancer.MaskApplication = .ApplyMask
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomPointInstancer_IgnoreMask() {
        let x: pxr.UsdGeomPointInstancer.MaskApplication = Overlay.UsdGeomPointInstancer.IgnoreMask
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdGeomPointInstancer.MaskApplication = .IgnoreMask
        XCTAssertEqual(x, y)
    }
    // MARK: UsdGeomXformOp.Type
    func test_UsdGeomXformOp_TypeInvalid() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeInvalid
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeInvalid
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeTranslateX() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeTranslateX
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeTranslateX
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeTranslateY() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeTranslateY
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeTranslateY
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeTranslateZ() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeTranslateZ
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeTranslateZ
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeTranslate() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeTranslate
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeTranslate
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeScaleX() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeScaleX
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeScaleX
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeScaleY() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeScaleY
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeScaleY
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeScaleZ() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeScaleZ
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeScaleZ
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeScale() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeScale
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeScale
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateX() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateX
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateX
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateY() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateY
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateY
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateZ() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateZ
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateZ
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateXYZ() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateXYZ
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateXYZ
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateXZY() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateXZY
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateXZY
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateYXZ() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateYXZ
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateYXZ
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateYZX() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateYZX
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateYZX
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateZXY() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateZXY
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateZXY
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeRotateZYX() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeRotateZYX
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeRotateZYX
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeOrient() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeOrient
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeOrient
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_TypeTransform() {
        let x: pxr.UsdGeomXformOp.`Type` = Overlay.UsdGeomXformOp.TypeTransform
        XCTAssertEqual(x.rawValue, 19)
        let y: pxr.UsdGeomXformOp.`Type` = .TypeTransform
        XCTAssertEqual(x, y)
    }
    // MARK: UsdGeomXformOp.Precision
    func test_UsdGeomXformOp_PrecisionDouble() {
        let x: pxr.UsdGeomXformOp.Precision = Overlay.UsdGeomXformOp.PrecisionDouble
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdGeomXformOp.Precision = .PrecisionDouble
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_PrecisionFloat() {
        let x: pxr.UsdGeomXformOp.Precision = Overlay.UsdGeomXformOp.PrecisionFloat
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdGeomXformOp.Precision = .PrecisionFloat
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformOp_PrecisionHalf() {
        let x: pxr.UsdGeomXformOp.Precision = Overlay.UsdGeomXformOp.PrecisionHalf
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdGeomXformOp.Precision = .PrecisionHalf
        XCTAssertEqual(x, y)
    }
    // MARK: UsdGeomXformCommonAPI.RotationOrder
    func test_UsdGeomXformCommonAPI_RotationOrderXYZ() {
        let x: pxr.UsdGeomXformCommonAPI.RotationOrder = Overlay.UsdGeomXformCommonAPI.RotationOrderXYZ
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdGeomXformCommonAPI.RotationOrder = .RotationOrderXYZ
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_RotationOrderXZY() {
        let x: pxr.UsdGeomXformCommonAPI.RotationOrder = Overlay.UsdGeomXformCommonAPI.RotationOrderXZY
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdGeomXformCommonAPI.RotationOrder = .RotationOrderXZY
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_RotationOrderYXZ() {
        let x: pxr.UsdGeomXformCommonAPI.RotationOrder = Overlay.UsdGeomXformCommonAPI.RotationOrderYXZ
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdGeomXformCommonAPI.RotationOrder = .RotationOrderYXZ
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_RotationOrderYZX() {
        let x: pxr.UsdGeomXformCommonAPI.RotationOrder = Overlay.UsdGeomXformCommonAPI.RotationOrderYZX
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdGeomXformCommonAPI.RotationOrder = .RotationOrderYZX
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_RotationOrderZXY() {
        let x: pxr.UsdGeomXformCommonAPI.RotationOrder = Overlay.UsdGeomXformCommonAPI.RotationOrderZXY
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdGeomXformCommonAPI.RotationOrder = .RotationOrderZXY
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_RotationOrderZYX() {
        let x: pxr.UsdGeomXformCommonAPI.RotationOrder = Overlay.UsdGeomXformCommonAPI.RotationOrderZYX
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.UsdGeomXformCommonAPI.RotationOrder = .RotationOrderZYX
        XCTAssertEqual(x, y)
    }
    // MARK: UsdGeomXformCommonAPI.OpFlags
    func test_UsdGeomXformCommonAPI_OpNone() {
        let x: pxr.UsdGeomXformCommonAPI.OpFlags = Overlay.UsdGeomXformCommonAPI.OpNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdGeomXformCommonAPI.OpFlags = .OpNone
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_OpTranslate() {
        let x: pxr.UsdGeomXformCommonAPI.OpFlags = Overlay.UsdGeomXformCommonAPI.OpTranslate
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdGeomXformCommonAPI.OpFlags = .OpTranslate
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_OpPivot() {
        let x: pxr.UsdGeomXformCommonAPI.OpFlags = Overlay.UsdGeomXformCommonAPI.OpPivot
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdGeomXformCommonAPI.OpFlags = .OpPivot
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_OpRotate() {
        let x: pxr.UsdGeomXformCommonAPI.OpFlags = Overlay.UsdGeomXformCommonAPI.OpRotate
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdGeomXformCommonAPI.OpFlags = .OpRotate
        XCTAssertEqual(x, y)
    }
    func test_UsdGeomXformCommonAPI_OpScale() {
        let x: pxr.UsdGeomXformCommonAPI.OpFlags = Overlay.UsdGeomXformCommonAPI.OpScale
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.UsdGeomXformCommonAPI.OpFlags = .OpScale
        XCTAssertEqual(x, y)
    }
    
    // MARK: UsdShade
    
    // MARK: UsdShadeConnectableAPIBehavior.ConnectableNodeTypes
    func test_UsdShadeConnectableAPIBehavior_BasicNodes() {
        let x: pxr.UsdShadeConnectableAPIBehavior.ConnectableNodeTypes = Overlay.UsdShadeConnectableAPIBehavior.BasicNodes
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdShadeConnectableAPIBehavior.ConnectableNodeTypes = .BasicNodes
        XCTAssertEqual(x, y)
    }
    func test_UsdShadeConnectableAPIBehavior_DerivedContainerNodes() {
        let x: pxr.UsdShadeConnectableAPIBehavior.ConnectableNodeTypes = Overlay.UsdShadeConnectableAPIBehavior.DerivedContainerNodes
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdShadeConnectableAPIBehavior.ConnectableNodeTypes = .DerivedContainerNodes
        XCTAssertEqual(x, y)
    }
    // MARK: UsdShadeAttributeType
    func test_UsdShadeAttributeType_Invalid() {
        let x: pxr.UsdShadeAttributeType = Overlay.UsdShadeAttributeType.Invalid
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdShadeAttributeType = .Invalid
        XCTAssertEqual(x, y)
    }
    func test_UsdShadeAttributeType_Input() {
        let x: pxr.UsdShadeAttributeType = Overlay.UsdShadeAttributeType.Input
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdShadeAttributeType = .Input
        XCTAssertEqual(x, y)
    }
    func test_UsdShadeAttributeType_Output() {
        let x: pxr.UsdShadeAttributeType = Overlay.UsdShadeAttributeType.Output
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdShadeAttributeType = .Output
        XCTAssertEqual(x, y)
    }
    // MARK: UsdShadeConnectionModification
    func test_UsdShadeConnectionModification_Replace() {
        let x: pxr.UsdShadeConnectionModification = Overlay.UsdShadeConnectionModification.Replace
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdShadeConnectionModification = .Replace
        XCTAssertEqual(x, y)
    }
    func test_UsdShadeConnectionModification_Prepend() {
        let x: pxr.UsdShadeConnectionModification = Overlay.UsdShadeConnectionModification.Prepend
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdShadeConnectionModification = .Prepend
        XCTAssertEqual(x, y)
    }
    func test_UsdShadeConnectionModification_Append() {
        let x: pxr.UsdShadeConnectionModification = Overlay.UsdShadeConnectionModification.Append
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdShadeConnectionModification = .Append
        XCTAssertEqual(x, y)
    }

    // MARK: UsdLux
    
    // MARK: UsdLuxLightListAPI.ComputeMode
    func test_UsdLuxLightListAPI_ComputeModeConsultModelHierarchyCache() {
        let x: pxr.UsdLuxLightListAPI.ComputeMode = Overlay.UsdLuxLightListAPI.ComputeModeConsultModelHierarchyCache
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdLuxLightListAPI.ComputeMode = .ComputeModeConsultModelHierarchyCache
        XCTAssertEqual(x, y)
    }
    func test_UsdLuxLightListAPI_ComputeModeIgnoreCache() {
        let x: pxr.UsdLuxLightListAPI.ComputeMode = Overlay.UsdLuxLightListAPI.ComputeModeIgnoreCache
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdLuxLightListAPI.ComputeMode = .ComputeModeIgnoreCache
        XCTAssertEqual(x, y)
    }
    // MARK: UsdLuxListAPI.ComputeMode
    func test_UsdLuxListAPI_ComputeModeConsultModelHierarchyCache() {
        let x: pxr.UsdLuxListAPI.ComputeMode = Overlay.UsdLuxListAPI.ComputeModeConsultModelHierarchyCache
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdLuxListAPI.ComputeMode = .ComputeModeConsultModelHierarchyCache
        XCTAssertEqual(x, y)
    }
    func test_UsdLuxListAPI_ComputeModeIgnoreCache() {
        let x: pxr.UsdLuxListAPI.ComputeMode = Overlay.UsdLuxListAPI.ComputeModeIgnoreCache
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdLuxListAPI.ComputeMode = .ComputeModeIgnoreCache
        XCTAssertEqual(x, y)
    }
    
    // MARK: UsdSkel
    
    // MARK: UsdSkelBakeSkinningParms.DeformationFlags
    func test_UsdSkelBakeSkinningParms_DeformPointsWithSkinning() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformPointsWithSkinning
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformPointsWithSkinning
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_DeformNormalsWithSkinning() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformNormalsWithSkinning
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformNormalsWithSkinning
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_DeformXformWithSkinning() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformXformWithSkinning
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformXformWithSkinning
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_DeformPointsWithBlendShapes() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformPointsWithBlendShapes
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformPointsWithBlendShapes
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_DeformNormalsWithBlendShapes() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformNormalsWithBlendShapes
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformNormalsWithBlendShapes
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_DeformWithSkinning() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformWithSkinning
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformWithSkinning
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_DeformWithBlendShapes() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformWithBlendShapes
        XCTAssertEqual(x.rawValue, 24)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformWithBlendShapes
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_DeformAll() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.DeformAll
        XCTAssertEqual(x.rawValue, 31)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .DeformAll
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_ModifiesPoints() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.ModifiesPoints
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .ModifiesPoints
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_ModifiesNormals() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.ModifiesNormals
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .ModifiesNormals
        XCTAssertEqual(x, y)
    }
    func test_UsdSkelBakeSkinningParms_ModifiesXform() {
        let x: pxr.UsdSkelBakeSkinningParms.DeformationFlags = Overlay.UsdSkelBakeSkinningParms.ModifiesXform
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdSkelBakeSkinningParms.DeformationFlags = .ModifiesXform
        XCTAssertEqual(x, y)
    }
    
    // MARK: UsdUtils
    
    // MARK: UsdUtilsRegisteredVariantSet.SelectionExportPolicy
    func test_UsdUtilsRegisteredVariantSet_Never() {
        let x: pxr.UsdUtilsRegisteredVariantSet.SelectionExportPolicy = Overlay.UsdUtilsRegisteredVariantSet.SelectionExportPolicy.Never
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdUtilsRegisteredVariantSet.SelectionExportPolicy = .Never
        XCTAssertEqual(x, y)
    }
    func test_UsdUtilsRegisteredVariantSet_IfAuthored() {
        let x: pxr.UsdUtilsRegisteredVariantSet.SelectionExportPolicy = Overlay.UsdUtilsRegisteredVariantSet.SelectionExportPolicy.IfAuthored
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdUtilsRegisteredVariantSet.SelectionExportPolicy = .IfAuthored
        XCTAssertEqual(x, y)
    }
    func test_UsdUtilsRegisteredVariantSet_Always() {
        let x: pxr.UsdUtilsRegisteredVariantSet.SelectionExportPolicy = Overlay.UsdUtilsRegisteredVariantSet.SelectionExportPolicy.Always
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdUtilsRegisteredVariantSet.SelectionExportPolicy = .Always
        XCTAssertEqual(x, y)
    }
    // MARK: UsdUtilsStitchValueStatus
    func test_UsdUtilsStitchValueStatus_NoStitchedValue() {
        let x: pxr.UsdUtilsStitchValueStatus = Overlay.UsdUtilsStitchValueStatus.NoStitchedValue
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdUtilsStitchValueStatus = .NoStitchedValue
        XCTAssertEqual(x, y)
    }
    func test_UsdUtilsStitchValueStatus_UseDefaultValue() {
        let x: pxr.UsdUtilsStitchValueStatus = Overlay.UsdUtilsStitchValueStatus.UseDefaultValue
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdUtilsStitchValueStatus = .UseDefaultValue
        XCTAssertEqual(x, y)
    }
    func test_UsdUtilsStitchValueStatus_UseSuppliedValue() {
        let x: pxr.UsdUtilsStitchValueStatus = Overlay.UsdUtilsStitchValueStatus.UseSuppliedValue
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdUtilsStitchValueStatus = .UseSuppliedValue
        XCTAssertEqual(x, y)
    }
    
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    // MARK: Garch
    
    // MARK: GarchGLDebugWindow.Buttons
    func test_GarchGLDebugWindow_MyButton1() {
        let x: pxr.GarchGLDebugWindow.Buttons = Overlay.GarchGLDebugWindow.MyButton1
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.GarchGLDebugWindow.Buttons = .MyButton1
        XCTAssertEqual(x, y)
    }
    func test_GarchGLDebugWindow_MyButton2() {
        let x: pxr.GarchGLDebugWindow.Buttons = Overlay.GarchGLDebugWindow.MyButton2
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.GarchGLDebugWindow.Buttons = .MyButton2
        XCTAssertEqual(x, y)
    }
    func test_GarchGLDebugWindow_MyButton3() {
        let x: pxr.GarchGLDebugWindow.Buttons = Overlay.GarchGLDebugWindow.MyButton3
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.GarchGLDebugWindow.Buttons = .MyButton3
        XCTAssertEqual(x, y)
    }
    // MARK: GarchGLDebugWindow.ModifierKeys
    func test_GarchGLDebugWindow_NoModifiers() {
        let x: pxr.GarchGLDebugWindow.ModifierKeys = Overlay.GarchGLDebugWindow.NoModifiers
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.GarchGLDebugWindow.ModifierKeys = .NoModifiers
        XCTAssertEqual(x, y)
    }
    func test_GarchGLDebugWindow_Shift() {
        let x: pxr.GarchGLDebugWindow.ModifierKeys = Overlay.GarchGLDebugWindow.Shift
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.GarchGLDebugWindow.ModifierKeys = .Shift
        XCTAssertEqual(x, y)
    }
    func test_GarchGLDebugWindow_Alt() {
        let x: pxr.GarchGLDebugWindow.ModifierKeys = Overlay.GarchGLDebugWindow.Alt
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.GarchGLDebugWindow.ModifierKeys = .Alt
        XCTAssertEqual(x, y)
    }
    func test_GarchGLDebugWindow_Ctrl() {
        let x: pxr.GarchGLDebugWindow.ModifierKeys = Overlay.GarchGLDebugWindow.Ctrl
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.GarchGLDebugWindow.ModifierKeys = .Ctrl
        XCTAssertEqual(x, y)
    }
    
    // MARK: Hio
    
    // MARK: HioGlslfxConfig
    func test_HioGlslfxConfig_RoleNone() {
        let x: pxr.HioGlslfxConfig.Role = Overlay.HioGlslfxConfig.RoleNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioGlslfxConfig.Role = .RoleNone
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxConfig_RoleColor() {
        let x: pxr.HioGlslfxConfig.Role = Overlay.HioGlslfxConfig.RoleColor
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioGlslfxConfig.Role = .RoleColor
        XCTAssertEqual(x, y)
    }
    // MARK: HioGlslfxResourceLayout.InOut
    func test_HioGlslfxResourceLayout_InOut_NONE() {
        let x: pxr.HioGlslfxResourceLayout.InOut = Overlay.HioGlslfxResourceLayout.InOut.NONE
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioGlslfxResourceLayout.InOut = .NONE
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_InOut_STAGE_IN() {
        let x: pxr.HioGlslfxResourceLayout.InOut = Overlay.HioGlslfxResourceLayout.InOut.STAGE_IN
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioGlslfxResourceLayout.InOut = .STAGE_IN
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_InOut_STAGE_OUT() {
        let x: pxr.HioGlslfxResourceLayout.InOut = Overlay.HioGlslfxResourceLayout.InOut.STAGE_OUT
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HioGlslfxResourceLayout.InOut = .STAGE_OUT
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_NONE() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.NONE
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioGlslfxResourceLayout.Kind = .NONE
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_VALUE() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.VALUE
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioGlslfxResourceLayout.Kind = .VALUE
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_BLOCK() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.BLOCK
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HioGlslfxResourceLayout.Kind = .BLOCK
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_QUALIFIER() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.QUALIFIER
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HioGlslfxResourceLayout.Kind = .QUALIFIER
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_UNIFORM_VALUE() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.UNIFORM_VALUE
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HioGlslfxResourceLayout.Kind = .UNIFORM_VALUE
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_UNIFORM_BLOCK() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.UNIFORM_BLOCK
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HioGlslfxResourceLayout.Kind = .UNIFORM_BLOCK
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_UNIFORM_BLOCK_CONSTANT_PARAMS() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.UNIFORM_BLOCK_CONSTANT_PARAMS
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HioGlslfxResourceLayout.Kind = .UNIFORM_BLOCK_CONSTANT_PARAMS
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_BUFFER_READ_ONLY() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.BUFFER_READ_ONLY
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HioGlslfxResourceLayout.Kind = .BUFFER_READ_ONLY
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_Kind_BUFFER_READ_WRITE() {
        let x: pxr.HioGlslfxResourceLayout.Kind = Overlay.HioGlslfxResourceLayout.Kind.BUFFER_READ_WRITE
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HioGlslfxResourceLayout.Kind = .BUFFER_READ_WRITE
        XCTAssertEqual(x, y)
    }
    // MARK: HioGlslfxResourceLayout.TextureType
    func test_HioGlslfxResourceLayout_TextureType_TEXTURE() {
        let x: pxr.HioGlslfxResourceLayout.TextureType = Overlay.HioGlslfxResourceLayout.TextureType.TEXTURE
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioGlslfxResourceLayout.TextureType = .TEXTURE
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_TextureType_SHADOW_TEXTURE() {
        let x: pxr.HioGlslfxResourceLayout.TextureType = Overlay.HioGlslfxResourceLayout.TextureType.SHADOW_TEXTURE
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioGlslfxResourceLayout.TextureType = .SHADOW_TEXTURE
        XCTAssertEqual(x, y)
    }
    func test_HioGlslfxResourceLayout_TextureType_ARRAY_TEXTURE() {
        let x: pxr.HioGlslfxResourceLayout.TextureType = Overlay.HioGlslfxResourceLayout.TextureType.ARRAY_TEXTURE
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HioGlslfxResourceLayout.TextureType = .ARRAY_TEXTURE
        XCTAssertEqual(x, y)
    }
    // MARK: HioFormat
    func test_HioFormatInvalid() {
        let x: pxr.HioFormat = Overlay.HioFormatInvalid
        XCTAssertEqual(x.rawValue, -1)
        let y: pxr.HioFormat = .HioFormatInvalid
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioFormat = .HioFormatUNorm8
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8Vec2
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioFormat = .HioFormatUNorm8Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8Vec3
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HioFormat = .HioFormatUNorm8Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8Vec4
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HioFormat = .HioFormatUNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatSNorm8() {
        let x: pxr.HioFormat = Overlay.HioFormatSNorm8
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HioFormat = .HioFormatSNorm8
        XCTAssertEqual(x, y)
    }
    func test_HioFormatSNorm8Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatSNorm8Vec2
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HioFormat = .HioFormatSNorm8Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatSNorm8Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatSNorm8Vec3
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HioFormat = .HioFormatSNorm8Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatSNorm8Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatSNorm8Vec4
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HioFormat = .HioFormatSNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat16() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat16
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HioFormat = .HioFormatFloat16
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat16Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat16Vec2
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.HioFormat = .HioFormatFloat16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat16Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat16Vec3
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.HioFormat = .HioFormatFloat16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat16Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat16Vec4
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.HioFormat = .HioFormatFloat16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat32() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat32
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.HioFormat = .HioFormatFloat32
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat32Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat32Vec2
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.HioFormat = .HioFormatFloat32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat32Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat32Vec3
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.HioFormat = .HioFormatFloat32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatFloat32Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatFloat32Vec4
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.HioFormat = .HioFormatFloat32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatDouble64() {
        let x: pxr.HioFormat = Overlay.HioFormatDouble64
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HioFormat = .HioFormatDouble64
        XCTAssertEqual(x, y)
    }
    func test_HioFormatDouble64Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatDouble64Vec2
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.HioFormat = .HioFormatDouble64Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatDouble64Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatDouble64Vec3
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.HioFormat = .HioFormatDouble64Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatDouble64Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatDouble64Vec4
        XCTAssertEqual(x.rawValue, 19)
        let y: pxr.HioFormat = .HioFormatDouble64Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt16() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt16
        XCTAssertEqual(x.rawValue, 20)
        let y: pxr.HioFormat = .HioFormatUInt16
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt16Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt16Vec2
        XCTAssertEqual(x.rawValue, 21)
        let y: pxr.HioFormat = .HioFormatUInt16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt16Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt16Vec3
        XCTAssertEqual(x.rawValue, 22)
        let y: pxr.HioFormat = .HioFormatUInt16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt16Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt16Vec4
        XCTAssertEqual(x.rawValue, 23)
        let y: pxr.HioFormat = .HioFormatUInt16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt16() {
        let x: pxr.HioFormat = Overlay.HioFormatInt16
        XCTAssertEqual(x.rawValue, 24)
        let y: pxr.HioFormat = .HioFormatInt16
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt16Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatInt16Vec2
        XCTAssertEqual(x.rawValue, 25)
        let y: pxr.HioFormat = .HioFormatInt16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt16Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatInt16Vec3
        XCTAssertEqual(x.rawValue, 26)
        let y: pxr.HioFormat = .HioFormatInt16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt16Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatInt16Vec4
        XCTAssertEqual(x.rawValue, 27)
        let y: pxr.HioFormat = .HioFormatInt16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt32() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt32
        XCTAssertEqual(x.rawValue, 28)
        let y: pxr.HioFormat = .HioFormatUInt32
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt32Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt32Vec2
        XCTAssertEqual(x.rawValue, 29)
        let y: pxr.HioFormat = .HioFormatUInt32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt32Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt32Vec3
        XCTAssertEqual(x.rawValue, 30)
        let y: pxr.HioFormat = .HioFormatUInt32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUInt32Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatUInt32Vec4
        XCTAssertEqual(x.rawValue, 31)
        let y: pxr.HioFormat = .HioFormatUInt32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt32() {
        let x: pxr.HioFormat = Overlay.HioFormatInt32
        XCTAssertEqual(x.rawValue, 32)
        let y: pxr.HioFormat = .HioFormatInt32
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt32Vec2() {
        let x: pxr.HioFormat = Overlay.HioFormatInt32Vec2
        XCTAssertEqual(x.rawValue, 33)
        let y: pxr.HioFormat = .HioFormatInt32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt32Vec3() {
        let x: pxr.HioFormat = Overlay.HioFormatInt32Vec3
        XCTAssertEqual(x.rawValue, 34)
        let y: pxr.HioFormat = .HioFormatInt32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatInt32Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatInt32Vec4
        XCTAssertEqual(x.rawValue, 35)
        let y: pxr.HioFormat = .HioFormatInt32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8srgb() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8srgb
        XCTAssertEqual(x.rawValue, 36)
        let y: pxr.HioFormat = .HioFormatUNorm8srgb
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8Vec2srgb() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8Vec2srgb
        XCTAssertEqual(x.rawValue, 37)
        let y: pxr.HioFormat = .HioFormatUNorm8Vec2srgb
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8Vec3srgb() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8Vec3srgb
        XCTAssertEqual(x.rawValue, 38)
        let y: pxr.HioFormat = .HioFormatUNorm8Vec3srgb
        XCTAssertEqual(x, y)
    }
    func test_HioFormatUNorm8Vec4srgb() {
        let x: pxr.HioFormat = Overlay.HioFormatUNorm8Vec4srgb
        XCTAssertEqual(x.rawValue, 39)
        let y: pxr.HioFormat = .HioFormatUNorm8Vec4srgb
        XCTAssertEqual(x, y)
    }
    func test_HioFormatBC6FloatVec3() {
        let x: pxr.HioFormat = Overlay.HioFormatBC6FloatVec3
        XCTAssertEqual(x.rawValue, 40)
        let y: pxr.HioFormat = .HioFormatBC6FloatVec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatBC6UFloatVec3() {
        let x: pxr.HioFormat = Overlay.HioFormatBC6UFloatVec3
        XCTAssertEqual(x.rawValue, 41)
        let y: pxr.HioFormat = .HioFormatBC6UFloatVec3
        XCTAssertEqual(x, y)
    }
    func test_HioFormatBC7UNorm8Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatBC7UNorm8Vec4
        XCTAssertEqual(x.rawValue, 42)
        let y: pxr.HioFormat = .HioFormatBC7UNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatBC7UNorm8Vec4srgb() {
        let x: pxr.HioFormat = Overlay.HioFormatBC7UNorm8Vec4srgb
        XCTAssertEqual(x.rawValue, 43)
        let y: pxr.HioFormat = .HioFormatBC7UNorm8Vec4srgb
        XCTAssertEqual(x, y)
    }
    func test_HioFormatBC1UNorm8Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatBC1UNorm8Vec4
        XCTAssertEqual(x.rawValue, 44)
        let y: pxr.HioFormat = .HioFormatBC1UNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatBC3UNorm8Vec4() {
        let x: pxr.HioFormat = Overlay.HioFormatBC3UNorm8Vec4
        XCTAssertEqual(x.rawValue, 45)
        let y: pxr.HioFormat = .HioFormatBC3UNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HioFormatCount() {
        let x: pxr.HioFormat = Overlay.HioFormatCount
        XCTAssertEqual(x.rawValue, 46)
        let y: pxr.HioFormat = .HioFormatCount
        XCTAssertEqual(x, y)
    }
    // MARK: HioAddressDimension
    func test_HioAddressDimensionU() {
        let x: pxr.HioAddressDimension = Overlay.HioAddressDimensionU
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioAddressDimension = .HioAddressDimensionU
        XCTAssertEqual(x, y)
    }
    func test_HioAddressDimensionV() {
        let x: pxr.HioAddressDimension = Overlay.HioAddressDimensionV
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioAddressDimension = .HioAddressDimensionV
        XCTAssertEqual(x, y)
    }
    func test_HioAddressDimensionW() {
        let x: pxr.HioAddressDimension = Overlay.HioAddressDimensionW
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HioAddressDimension = .HioAddressDimensionW
        XCTAssertEqual(x, y)
    }
    // MARK: HioAddressMode
    func test_HioAddressModeClampToEdge() {
        let x: pxr.HioAddressMode = Overlay.HioAddressModeClampToEdge
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioAddressMode = .HioAddressModeClampToEdge
        XCTAssertEqual(x, y)
    }
    func test_HioAddressModeMirrorClampToEdge() {
        let x: pxr.HioAddressMode = Overlay.HioAddressModeMirrorClampToEdge
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioAddressMode = .HioAddressModeMirrorClampToEdge
        XCTAssertEqual(x, y)
    }
    func test_HioAddressModeRepeat() {
        let x: pxr.HioAddressMode = Overlay.HioAddressModeRepeat
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HioAddressMode = .HioAddressModeRepeat
        XCTAssertEqual(x, y)
    }
    func test_HioAddressModeMirrorRepeat() {
        let x: pxr.HioAddressMode = Overlay.HioAddressModeMirrorRepeat
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HioAddressMode = .HioAddressModeMirrorRepeat
        XCTAssertEqual(x, y)
    }
    func test_HioAddressModeClampToBorderColor() {
        let x: pxr.HioAddressMode = Overlay.HioAddressModeClampToBorderColor
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HioAddressMode = .HioAddressModeClampToBorderColor
        XCTAssertEqual(x, y)
    }
    // MARK: HioType
    func test_HioTypeUnsignedByte() {
        let x: pxr.HioType = Overlay.HioTypeUnsignedByte
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HioType = .HioTypeUnsignedByte
        XCTAssertEqual(x, y)
    }
    func test_HioTypeUnsignedByteSRGB() {
        let x: pxr.HioType = Overlay.HioTypeUnsignedByteSRGB
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HioType = .HioTypeUnsignedByteSRGB
        XCTAssertEqual(x, y)
    }
    func test_HioTypeSignedByte() {
        let x: pxr.HioType = Overlay.HioTypeSignedByte
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HioType = .HioTypeSignedByte
        XCTAssertEqual(x, y)
    }
    func test_HioTypeUnsignedShort() {
        let x: pxr.HioType = Overlay.HioTypeUnsignedShort
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HioType = .HioTypeUnsignedShort
        XCTAssertEqual(x, y)
    }
    func test_HioTypeSignedShort() {
        let x: pxr.HioType = Overlay.HioTypeSignedShort
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HioType = .HioTypeSignedShort
        XCTAssertEqual(x, y)
    }
    func test_HioTypeUnsignedInt() {
        let x: pxr.HioType = Overlay.HioTypeUnsignedInt
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HioType = .HioTypeUnsignedInt
        XCTAssertEqual(x, y)
    }
    func test_HioTypeInt() {
        let x: pxr.HioType = Overlay.HioTypeInt
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HioType = .HioTypeInt
        XCTAssertEqual(x, y)
    }
    func test_HioTypeHalfFloat() {
        let x: pxr.HioType = Overlay.HioTypeHalfFloat
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HioType = .HioTypeHalfFloat
        XCTAssertEqual(x, y)
    }
    func test_HioTypeFloat() {
        let x: pxr.HioType = Overlay.HioTypeFloat
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HioType = .HioTypeFloat
        XCTAssertEqual(x, y)
    }
    func test_HioTypeDouble() {
        let x: pxr.HioType = Overlay.HioTypeDouble
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.HioType = .HioTypeDouble
        XCTAssertEqual(x, y)
    }
    func test_HioTypeCount() {
        let x: pxr.HioType = Overlay.HioTypeCount
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.HioType = .HioTypeCount
        XCTAssertEqual(x, y)
    }
    
    // MARK: CameraUtil
    
    // MARK: CameraUtilConformWindowPolicy
    func test_CameraUtilMatchVertically() {
        let x: pxr.CameraUtilConformWindowPolicy = Overlay.CameraUtilMatchVertically
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.CameraUtilConformWindowPolicy = .CameraUtilMatchVertically
        XCTAssertEqual(x, y)
    }
    func test_CameraUtilMatchHorizontally() {
        let x: pxr.CameraUtilConformWindowPolicy = Overlay.CameraUtilMatchHorizontally
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.CameraUtilConformWindowPolicy = .CameraUtilMatchHorizontally
        XCTAssertEqual(x, y)
    }
    func test_CameraUtilFit() {
        let x: pxr.CameraUtilConformWindowPolicy = Overlay.CameraUtilFit
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.CameraUtilConformWindowPolicy = .CameraUtilFit
        XCTAssertEqual(x, y)
    }
    func test_CameraUtilCrop() {
        let x: pxr.CameraUtilConformWindowPolicy = Overlay.CameraUtilCrop
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.CameraUtilConformWindowPolicy = .CameraUtilCrop
        XCTAssertEqual(x, y)
    }
    func test_CameraUtilDontConform() {
        let x: pxr.CameraUtilConformWindowPolicy = Overlay.CameraUtilDontConform
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.CameraUtilConformWindowPolicy = .CameraUtilDontConform
        XCTAssertEqual(x, y)
    }
    
    // MARK: PxOsd
    
    // MARK: PxOsdMeshTopologyValidation.Code
    func test_PxOsdMeshTopologyValidation_Code_InvalidScheme() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidScheme
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidScheme
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidOrientation() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidOrientation
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidOrientation
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidTriangleSubdivision() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidTriangleSubdivision
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidTriangleSubdivision
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidVertexInterpolationRule() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidVertexInterpolationRule
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidVertexInterpolationRule
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidFaceVaryingInterpolationRule() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidFaceVaryingInterpolationRule
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidFaceVaryingInterpolationRule
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidCreaseMethod() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidCreaseMethod
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidCreaseMethod
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidCreaseLengthElement() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidCreaseLengthElement
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidCreaseLengthElement
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidCreaseIndicesSize() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidCreaseIndicesSize
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidCreaseIndicesSize
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidCreaseIndicesElement() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidCreaseIndicesElement
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidCreaseIndicesElement
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidCreaseWeightsSize() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidCreaseWeightsSize
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidCreaseWeightsSize
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_NegativeCreaseWeights() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.NegativeCreaseWeights
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .NegativeCreaseWeights
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidCornerIndicesElement() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidCornerIndicesElement
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidCornerIndicesElement
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_NegativeCornerWeights() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.NegativeCornerWeights
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .NegativeCornerWeights
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidCornerWeightsSize() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidCornerWeightsSize
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidCornerWeightsSize
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidHoleIndicesElement() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidHoleIndicesElement
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidHoleIndicesElement
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidFaceVertexCountsElement() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidFaceVertexCountsElement
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidFaceVertexCountsElement
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidFaceVertexIndicesElement() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidFaceVertexIndicesElement
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidFaceVertexIndicesElement
        XCTAssertEqual(x, y)
    }
    func test_PxOsdMeshTopologyValidation_Code_InvalidFaceVertexIndicesSize() {
        let x: pxr.PxOsdMeshTopologyValidation.Code = Overlay.PxOsdMeshTopologyValidation.Code.InvalidFaceVertexIndicesSize
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.PxOsdMeshTopologyValidation.Code = .InvalidFaceVertexIndicesSize
        XCTAssertEqual(x, y)
    }
    
    // MARK: Hgi
    
    // MARK: HgiTessellationState.PatchType
    func test_HgiTessellationState_Triangle() {
        let x: pxr.HgiTessellationState.PatchType = Overlay.HgiTessellationState.Triangle
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiTessellationState.PatchType = .Triangle
        XCTAssertEqual(x, y)
    }
    func test_HgiTessellationState_Quad() {
        let x: pxr.HgiTessellationState.PatchType = Overlay.HgiTessellationState.Quad
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiTessellationState.PatchType = .Quad
        XCTAssertEqual(x, y)
    }
    func test_HgiTessellationState_Isoline() {
        let x: pxr.HgiTessellationState.PatchType = Overlay.HgiTessellationState.Isoline
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiTessellationState.PatchType = .Isoline
        XCTAssertEqual(x, y)
    }
    // MARK: HgiTessellationState.TessFactorMode
    func test_HgiTessellationState_Constant() {
        let x: pxr.HgiTessellationState.TessFactorMode = Overlay.HgiTessellationState.Constant
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiTessellationState.TessFactorMode = .Constant
        XCTAssertEqual(x, y)
    }
    func test_HgiTessellationState_TessControl() {
        let x: pxr.HgiTessellationState.TessFactorMode = Overlay.HgiTessellationState.TessControl
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiTessellationState.TessFactorMode = .TessControl
        XCTAssertEqual(x, y)
    }
    func test_HgiTessellationState_TessVertex() {
        let x: pxr.HgiTessellationState.TessFactorMode = Overlay.HgiTessellationState.TessVertex
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiTessellationState.TessFactorMode = .TessVertex
        XCTAssertEqual(x, y)
    }
    // MARK: HgiShaderFunctionTessellationDesc.PatchType
    func test_HgiShaderFunctionTessellationDesc_PatchType_Triangles() {
        let x: pxr.HgiShaderFunctionTessellationDesc.PatchType = Overlay.HgiShaderFunctionTessellationDesc.PatchType.Triangles
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiShaderFunctionTessellationDesc.PatchType = .Triangles
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionTessellationDesc_PatchType_Quads() {
        let x: pxr.HgiShaderFunctionTessellationDesc.PatchType = Overlay.HgiShaderFunctionTessellationDesc.PatchType.Quads
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiShaderFunctionTessellationDesc.PatchType = .Quads
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionTessellationDesc_PatchType_Isolines() {
        let x: pxr.HgiShaderFunctionTessellationDesc.PatchType = Overlay.HgiShaderFunctionTessellationDesc.PatchType.Isolines
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiShaderFunctionTessellationDesc.PatchType = .Isolines
        XCTAssertEqual(x, y)
    }
    // MARK: HgiShaderFunctionTessellationDesc.Spacing
    func test_HgiShaderFunctionTessellationDesc_Spacing_Equal() {
        let x: pxr.HgiShaderFunctionTessellationDesc.Spacing = Overlay.HgiShaderFunctionTessellationDesc.Spacing.Equal
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiShaderFunctionTessellationDesc.Spacing = .Equal
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionTessellationDesc_Spacing_FractionalEven() {
        let x: pxr.HgiShaderFunctionTessellationDesc.Spacing = Overlay.HgiShaderFunctionTessellationDesc.Spacing.FractionalEven
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiShaderFunctionTessellationDesc.Spacing = .FractionalEven
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionTessellationDesc_Spacing_FractionalOdd() {
        let x: pxr.HgiShaderFunctionTessellationDesc.Spacing = Overlay.HgiShaderFunctionTessellationDesc.Spacing.FractionalOdd
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiShaderFunctionTessellationDesc.Spacing = .FractionalOdd
        XCTAssertEqual(x, y)
    }
    // MARK: HgiShaderFunctionTessellationDesc.Ordering
    func test_HgiShaderFunctionTessellationDesc_Ordering_CW() {
        let x: pxr.HgiShaderFunctionTessellationDesc.Ordering = Overlay.HgiShaderFunctionTessellationDesc.Ordering.CW
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiShaderFunctionTessellationDesc.Ordering = .CW
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionTessellationDesc_Ordering_CCW() {
        let x: pxr.HgiShaderFunctionTessellationDesc.Ordering = Overlay.HgiShaderFunctionTessellationDesc.Ordering.CCW
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiShaderFunctionTessellationDesc.Ordering = .CCW
        XCTAssertEqual(x, y)
    }
    // MARK: HgiShaderFunctionGeometryDesc.InPrimitiveType
    func test_HgiShaderFunctionGeometryDesc_InPrimitiveType_Points() {
        let x: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.InPrimitiveType.Points
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = .Points
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionGeometryDesc_InPrimitiveType_Lines() {
        let x: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.InPrimitiveType.Lines
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = .Lines
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionGeometryDesc_InPrimitiveType_LinesAdjacency() {
        let x: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.InPrimitiveType.LinesAdjacency
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = .LinesAdjacency
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionGeometryDesc_InPrimitiveType_Triangles() {
        let x: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.InPrimitiveType.Triangles
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = .Triangles
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionGeometryDesc_InPrimitiveType_TrianglesAdjacency() {
        let x: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.InPrimitiveType.TrianglesAdjacency
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiShaderFunctionGeometryDesc.InPrimitiveType = .TrianglesAdjacency
        XCTAssertEqual(x, y)
    }
    // MARK: HgiShaderFunctionGeometryDesc.OutPrimitiveType
    func test_HgiShaderFunctionGeometryDesc_OutPrimitiveType_Points() {
        let x: pxr.HgiShaderFunctionGeometryDesc.OutPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.OutPrimitiveType.Points
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiShaderFunctionGeometryDesc.OutPrimitiveType = .Points
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionGeometryDesc_OutPrimitiveType_LineStrip() {
        let x: pxr.HgiShaderFunctionGeometryDesc.OutPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.OutPrimitiveType.LineStrip
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiShaderFunctionGeometryDesc.OutPrimitiveType = .LineStrip
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderFunctionGeometryDesc_OutPrimitiveType_TriangleStrip() {
        let x: pxr.HgiShaderFunctionGeometryDesc.OutPrimitiveType = Overlay.HgiShaderFunctionGeometryDesc.OutPrimitiveType.TriangleStrip
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiShaderFunctionGeometryDesc.OutPrimitiveType = .TriangleStrip
        XCTAssertEqual(x, y)
    }
    // MARK: HgiFormat
    func test_HgiFormatInvalid() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInvalid
        XCTAssertEqual(x.rawValue, -1)
        let y: pxr.HgiFormat = .HgiFormatInvalid
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUNorm8() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUNorm8
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiFormat = .HgiFormatUNorm8
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUNorm8Vec2() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUNorm8Vec2
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiFormat = .HgiFormatUNorm8Vec2
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUNorm8Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUNorm8Vec4
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiFormat = .HgiFormatUNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatSNorm8() {
        let x: pxr.HgiFormat = Overlay.HgiFormatSNorm8
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiFormat = .HgiFormatSNorm8
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatSNorm8Vec2() {
        let x: pxr.HgiFormat = Overlay.HgiFormatSNorm8Vec2
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiFormat = .HgiFormatSNorm8Vec2
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatSNorm8Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatSNorm8Vec4
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiFormat = .HgiFormatSNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat16() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat16
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiFormat = .HgiFormatFloat16
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat16Vec2() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat16Vec2
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HgiFormat = .HgiFormatFloat16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat16Vec3() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat16Vec3
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiFormat = .HgiFormatFloat16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat16Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat16Vec4
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.HgiFormat = .HgiFormatFloat16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat32() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat32
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.HgiFormat = .HgiFormatFloat32
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat32Vec2() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat32Vec2
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.HgiFormat = .HgiFormatFloat32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat32Vec3() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat32Vec3
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.HgiFormat = .HgiFormatFloat32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat32Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat32Vec4
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.HgiFormat = .HgiFormatFloat32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt16() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt16
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.HgiFormat = .HgiFormatInt16
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt16Vec2() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt16Vec2
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.HgiFormat = .HgiFormatInt16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt16Vec3() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt16Vec3
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HgiFormat = .HgiFormatInt16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt16Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt16Vec4
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.HgiFormat = .HgiFormatInt16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUInt16() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUInt16
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.HgiFormat = .HgiFormatUInt16
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUInt16Vec2() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUInt16Vec2
        XCTAssertEqual(x.rawValue, 19)
        let y: pxr.HgiFormat = .HgiFormatUInt16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUInt16Vec3() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUInt16Vec3
        XCTAssertEqual(x.rawValue, 20)
        let y: pxr.HgiFormat = .HgiFormatUInt16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUInt16Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUInt16Vec4
        XCTAssertEqual(x.rawValue, 21)
        let y: pxr.HgiFormat = .HgiFormatUInt16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt32() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt32
        XCTAssertEqual(x.rawValue, 22)
        let y: pxr.HgiFormat = .HgiFormatInt32
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt32Vec2() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt32Vec2
        XCTAssertEqual(x.rawValue, 23)
        let y: pxr.HgiFormat = .HgiFormatInt32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt32Vec3() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt32Vec3
        XCTAssertEqual(x.rawValue, 24)
        let y: pxr.HgiFormat = .HgiFormatInt32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatInt32Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatInt32Vec4
        XCTAssertEqual(x.rawValue, 25)
        let y: pxr.HgiFormat = .HgiFormatInt32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatUNorm8Vec4srgb() {
        let x: pxr.HgiFormat = Overlay.HgiFormatUNorm8Vec4srgb
        XCTAssertEqual(x.rawValue, 26)
        let y: pxr.HgiFormat = .HgiFormatUNorm8Vec4srgb
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatBC6FloatVec3() {
        let x: pxr.HgiFormat = Overlay.HgiFormatBC6FloatVec3
        XCTAssertEqual(x.rawValue, 27)
        let y: pxr.HgiFormat = .HgiFormatBC6FloatVec3
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatBC6UFloatVec3() {
        let x: pxr.HgiFormat = Overlay.HgiFormatBC6UFloatVec3
        XCTAssertEqual(x.rawValue, 28)
        let y: pxr.HgiFormat = .HgiFormatBC6UFloatVec3
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatBC7UNorm8Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatBC7UNorm8Vec4
        XCTAssertEqual(x.rawValue, 29)
        let y: pxr.HgiFormat = .HgiFormatBC7UNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatBC7UNorm8Vec4srgb() {
        let x: pxr.HgiFormat = Overlay.HgiFormatBC7UNorm8Vec4srgb
        XCTAssertEqual(x.rawValue, 30)
        let y: pxr.HgiFormat = .HgiFormatBC7UNorm8Vec4srgb
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatBC1UNorm8Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatBC1UNorm8Vec4
        XCTAssertEqual(x.rawValue, 31)
        let y: pxr.HgiFormat = .HgiFormatBC1UNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatBC3UNorm8Vec4() {
        let x: pxr.HgiFormat = Overlay.HgiFormatBC3UNorm8Vec4
        XCTAssertEqual(x.rawValue, 32)
        let y: pxr.HgiFormat = .HgiFormatBC3UNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatFloat32UInt8() {
        let x: pxr.HgiFormat = Overlay.HgiFormatFloat32UInt8
        XCTAssertEqual(x.rawValue, 33)
        let y: pxr.HgiFormat = .HgiFormatFloat32UInt8
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatPackedInt1010102() {
        let x: pxr.HgiFormat = Overlay.HgiFormatPackedInt1010102
        XCTAssertEqual(x.rawValue, 34)
        let y: pxr.HgiFormat = .HgiFormatPackedInt1010102
        XCTAssertEqual(x, y)
    }
    func test_HgiFormatCount() {
        let x: pxr.HgiFormat = Overlay.HgiFormatCount
        XCTAssertEqual(x.rawValue, 35)
        let y: pxr.HgiFormat = .HgiFormatCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiDeviceCapabilitiesBits
    func test_HgiDeviceCapabilitiesBitsPresentation() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsPresentation
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsPresentation
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitBindlessBuffers() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsBindlessBuffers
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsBindlessBuffers
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsConcurrentDispatch() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsConcurrentDispatch
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsConcurrentDispatch
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsUnifiedMemory() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsUnifiedMemory
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsUnifiedMemory
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsBuiltinBarycentrics() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsBuiltinBarycentrics
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsBuiltinBarycentrics
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsShaderDrawParameters() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsShaderDrawParameters
        XCTAssertEqual(x.rawValue, 32)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsShaderDrawParameters
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsMultiDrawIndirect() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsMultiDrawIndirect
        XCTAssertEqual(x.rawValue, 64)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsMultiDrawIndirect
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsBindlessTextures() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsBindlessTextures
        XCTAssertEqual(x.rawValue, 128)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsBindlessTextures
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsShaderDoublePrecision() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsShaderDoublePrecision
        XCTAssertEqual(x.rawValue, 256)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsShaderDoublePrecision
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsDepthRangeMinusOnetoOne() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsDepthRangeMinusOnetoOne
        XCTAssertEqual(x.rawValue, 512)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsDepthRangeMinusOnetoOne
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsCppShaderPadding() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsCppShaderPadding
        XCTAssertEqual(x.rawValue, 1024)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsCppShaderPadding
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsConservativeRaster() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsConservativeRaster
        XCTAssertEqual(x.rawValue, 2048)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsConservativeRaster
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsBuiltinStencilReadback() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsStencilReadback
        XCTAssertEqual(x.rawValue, 4096)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsStencilReadback
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsCustomDepthRange() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsCustomDepthRange
        XCTAssertEqual(x.rawValue, 8192)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsCustomDepthRange
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsMetalTessellation() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsMetalTessellation
        XCTAssertEqual(x.rawValue, 16384)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsMetalTessellation
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsBasePrimitiveOffset() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsBasePrimitiveOffset
        XCTAssertEqual(x.rawValue, 32768)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsBasePrimitiveOffset
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsPrimitiveIdEmulation() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsPrimitiveIdEmulation
        XCTAssertEqual(x.rawValue, 65536)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsPrimitiveIdEmulation
        XCTAssertEqual(x, y)
    }
    func test_HgiDeviceCapabilitiesBitsIndirectCommandBuffers() {
        let x: pxr.HgiDeviceCapabilitiesBits = Overlay.HgiDeviceCapabilitiesBitsIndirectCommandBuffers
        XCTAssertEqual(x.rawValue, 131072)
        let y: pxr.HgiDeviceCapabilitiesBits = .HgiDeviceCapabilitiesBitsIndirectCommandBuffers
        XCTAssertEqual(x, y)
    }
    // MARK: HgiTextureType
    func test_HgiTextureType1D() {
        let x: pxr.HgiTextureType = Overlay.HgiTextureType1D
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiTextureType = .HgiTextureType1D
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureType2D() {
        let x: pxr.HgiTextureType = Overlay.HgiTextureType2D
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiTextureType = .HgiTextureType2D
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureType3D() {
        let x: pxr.HgiTextureType = Overlay.HgiTextureType3D
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiTextureType = .HgiTextureType3D
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureType1DArray() {
        let x: pxr.HgiTextureType = Overlay.HgiTextureType1DArray
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiTextureType = .HgiTextureType1DArray
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureType2DArray() {
        let x: pxr.HgiTextureType = Overlay.HgiTextureType2DArray
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiTextureType = .HgiTextureType2DArray
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureTypeCount() {
        let x: pxr.HgiTextureType = Overlay.HgiTextureTypeCount
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiTextureType = .HgiTextureTypeCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiTextureUsageBits
    func test_HgiTextureUsageBitsColorTarget() {
        let x: pxr.HgiTextureUsageBits = Overlay.HgiTextureUsageBitsColorTarget
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiTextureUsageBits = .HgiTextureUsageBitsColorTarget
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureUsageBitsDepthTarget() {
        let x: pxr.HgiTextureUsageBits = Overlay.HgiTextureUsageBitsDepthTarget
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiTextureUsageBits = .HgiTextureUsageBitsDepthTarget
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureUsageBitsStencilTarget() {
        let x: pxr.HgiTextureUsageBits = Overlay.HgiTextureUsageBitsStencilTarget
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiTextureUsageBits = .HgiTextureUsageBitsStencilTarget
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureUsageBitsShaderRead() {
        let x: pxr.HgiTextureUsageBits = Overlay.HgiTextureUsageBitsShaderRead
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiTextureUsageBits = .HgiTextureUsageBitsShaderRead
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureUsageBitsShaderWrite() {
        let x: pxr.HgiTextureUsageBits = Overlay.HgiTextureUsageBitsShaderWrite
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HgiTextureUsageBits = .HgiTextureUsageBitsShaderWrite
        XCTAssertEqual(x, y)
    }
    func test_HgiTextureUsageBitsCustomBitsBegin() {
        let x: pxr.HgiTextureUsageBits = Overlay.HgiTextureUsageCustomBitsBegin
        XCTAssertEqual(x.rawValue, 32)
        let y: pxr.HgiTextureUsageBits = .HgiTextureUsageCustomBitsBegin
        XCTAssertEqual(x, y)
    }
    // MARK: HgiSamplerAddressMode
    func test_HgiSamplerAddressModeClampToEdge() {
        let x: pxr.HgiSamplerAddressMode = Overlay.HgiSamplerAddressModeClampToEdge
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiSamplerAddressMode = .HgiSamplerAddressModeClampToEdge
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplerAddressModeMirrorClampToEdge() {
        let x: pxr.HgiSamplerAddressMode = Overlay.HgiSamplerAddressModeMirrorClampToEdge
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiSamplerAddressMode = .HgiSamplerAddressModeMirrorClampToEdge
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplerAddressModeRepeat() {
        let x: pxr.HgiSamplerAddressMode = Overlay.HgiSamplerAddressModeRepeat
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiSamplerAddressMode = .HgiSamplerAddressModeRepeat
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplerAddressModeMirrorRepeat() {
        let x: pxr.HgiSamplerAddressMode = Overlay.HgiSamplerAddressModeMirrorRepeat
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiSamplerAddressMode = .HgiSamplerAddressModeMirrorRepeat
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplerAddressModeClampToBorderColor() {
        let x: pxr.HgiSamplerAddressMode = Overlay.HgiSamplerAddressModeClampToBorderColor
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiSamplerAddressMode = .HgiSamplerAddressModeClampToBorderColor
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplerAddressModeCount() {
        let x: pxr.HgiSamplerAddressMode = Overlay.HgiSamplerAddressModeCount
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiSamplerAddressMode = .HgiSamplerAddressModeCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiSamplerFilter
    func test_HgiSamplerFilterNearest() {
        let x: pxr.HgiSamplerFilter = Overlay.HgiSamplerFilterNearest
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiSamplerFilter = .HgiSamplerFilterNearest
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplerFilterLinear() {
        let x: pxr.HgiSamplerFilter = Overlay.HgiSamplerFilterLinear
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiSamplerFilter = .HgiSamplerFilterLinear
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplerFilterCount() {
        let x: pxr.HgiSamplerFilter = Overlay.HgiSamplerFilterCount
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiSamplerFilter = .HgiSamplerFilterCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiMipFilter
    func test_HgiMipFilterNotMipmapped() {
        let x: pxr.HgiMipFilter = Overlay.HgiMipFilterNotMipmapped
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiMipFilter = .HgiMipFilterNotMipmapped
        XCTAssertEqual(x, y)
    }
    func test_HgiMipFilterNearest() {
        let x: pxr.HgiMipFilter = Overlay.HgiMipFilterNearest
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiMipFilter = .HgiMipFilterNearest
        XCTAssertEqual(x, y)
    }
    func test_HgiMipFilterLinear() {
        let x: pxr.HgiMipFilter = Overlay.HgiMipFilterLinear
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiMipFilter = .HgiMipFilterLinear
        XCTAssertEqual(x, y)
    }
    func test_HgiMipFilterCount() {
        let x: pxr.HgiMipFilter = Overlay.HgiMipFilterCount
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiMipFilter = .HgiMipFilterCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiBorderColor
    func test_HgiBorderColorTransparentBlack() {
        let x: pxr.HgiBorderColor = Overlay.HgiBorderColorTransparentBlack
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiBorderColor = .HgiBorderColorTransparentBlack
        XCTAssertEqual(x, y)
    }
    func test_HgiBorderColorOpaqueBlack() {
        let x: pxr.HgiBorderColor = Overlay.HgiBorderColorOpaqueBlack
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiBorderColor = .HgiBorderColorOpaqueBlack
        XCTAssertEqual(x, y)
    }
    func test_HgiBorderColorOpaqueWhite() {
        let x: pxr.HgiBorderColor = Overlay.HgiBorderColorOpaqueWhite
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiBorderColor = .HgiBorderColorOpaqueWhite
        XCTAssertEqual(x, y)
    }
    func test_HgiBorderColorCount() {
        let x: pxr.HgiBorderColor = Overlay.HgiBorderColorCount
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiBorderColor = .HgiBorderColorCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiSampleCount
    func test_HgiSampleCount1() {
        let x: pxr.HgiSampleCount = Overlay.HgiSampleCount1
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiSampleCount = .HgiSampleCount1
        XCTAssertEqual(x, y)
    }
    func test_HgiSampleCount2() {
        let x: pxr.HgiSampleCount = Overlay.HgiSampleCount2
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiSampleCount = .HgiSampleCount2
        XCTAssertEqual(x, y)
    }
    func test_HgiSampleCount4() {
        let x: pxr.HgiSampleCount = Overlay.HgiSampleCount4
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiSampleCount = .HgiSampleCount4
        XCTAssertEqual(x, y)
    }
    func test_HgiSampleCount8() {
        let x: pxr.HgiSampleCount = Overlay.HgiSampleCount8
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiSampleCount = .HgiSampleCount8
        XCTAssertEqual(x, y)
    }
    func test_HgiSampleCount16() {
        let x: pxr.HgiSampleCount = Overlay.HgiSampleCount16
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HgiSampleCount = .HgiSampleCount16
        XCTAssertEqual(x, y)
    }
    func test_HgiSampleCountEnd() {
        let x: pxr.HgiSampleCount = Overlay.HgiSampleCountEnd
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.HgiSampleCount = .HgiSampleCountEnd
        XCTAssertEqual(x, y)
    }
    // MARK: HgiAttachmentLoadOp
    func test_HgiAttachmentLoadOpDontCare() {
        let x: pxr.HgiAttachmentLoadOp = Overlay.HgiAttachmentLoadOpDontCare
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiAttachmentLoadOp = .HgiAttachmentLoadOpDontCare
        XCTAssertEqual(x, y)
    }
    func test_HgiAttachmentLoadOpClear() {
        let x: pxr.HgiAttachmentLoadOp = Overlay.HgiAttachmentLoadOpClear
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiAttachmentLoadOp = .HgiAttachmentLoadOpClear
        XCTAssertEqual(x, y)
    }
    func test_HgiAttachmentLoadOpLoad() {
        let x: pxr.HgiAttachmentLoadOp = Overlay.HgiAttachmentLoadOpLoad
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiAttachmentLoadOp = .HgiAttachmentLoadOpLoad
        XCTAssertEqual(x, y)
    }
    func test_HgiAttachmentLoadOpCount() {
        let x: pxr.HgiAttachmentLoadOp = Overlay.HgiAttachmentLoadOpCount
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiAttachmentLoadOp = .HgiAttachmentLoadOpCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiAttachmentStoreOp
    func test_HgiAttachmentStoreOpDontCare() {
        let x: pxr.HgiAttachmentStoreOp = Overlay.HgiAttachmentStoreOpDontCare
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiAttachmentStoreOp = .HgiAttachmentStoreOpDontCare
        XCTAssertEqual(x, y)
    }
    func test_HgiAttachmentStoreOpStore() {
        let x: pxr.HgiAttachmentStoreOp = Overlay.HgiAttachmentStoreOpStore
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiAttachmentStoreOp = .HgiAttachmentStoreOpStore
        XCTAssertEqual(x, y)
    }
    func test_HgiAttachmentStoreOpCount() {
        let x: pxr.HgiAttachmentStoreOp = Overlay.HgiAttachmentStoreOpCount
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiAttachmentStoreOp = .HgiAttachmentStoreOpCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiBufferUsageBits
    func test_HgiBufferUsageUniform() {
        let x: pxr.HgiBufferUsageBits = Overlay.HgiBufferUsageUniform
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiBufferUsageBits = .HgiBufferUsageUniform
        XCTAssertEqual(x, y)
    }
    func test_HgiBufferUsageIndex32() {
        let x: pxr.HgiBufferUsageBits = Overlay.HgiBufferUsageIndex32
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiBufferUsageBits = .HgiBufferUsageIndex32
        XCTAssertEqual(x, y)
    }
    func test_HgiBufferUsageVertex() {
        let x: pxr.HgiBufferUsageBits = Overlay.HgiBufferUsageVertex
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiBufferUsageBits = .HgiBufferUsageVertex
        XCTAssertEqual(x, y)
    }
    func test_HgiBufferUsageStorage() {
        let x: pxr.HgiBufferUsageBits = Overlay.HgiBufferUsageStorage
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiBufferUsageBits = .HgiBufferUsageStorage
        XCTAssertEqual(x, y)
    }
    func test_HgiBufferUsageIndirect() {
        let x: pxr.HgiBufferUsageBits = Overlay.HgiBufferUsageIndirect
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HgiBufferUsageBits = .HgiBufferUsageIndirect
        XCTAssertEqual(x, y)
    }
    func test_HgiBufferUsageCustomBitsBegin() {
        let x: pxr.HgiBufferUsageBits = Overlay.HgiBufferUsageCustomBitsBegin
        XCTAssertEqual(x.rawValue, 32)
        let y: pxr.HgiBufferUsageBits = .HgiBufferUsageCustomBitsBegin
        XCTAssertEqual(x, y)
    }
    // MARK: HgiShaderStageBits
    func test_HgiShaderStageVertex() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStageVertex
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiShaderStageBits = .HgiShaderStageVertex
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStageFragment() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStageFragment
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiShaderStageBits = .HgiShaderStageFragment
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStageCompute() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStageCompute
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiShaderStageBits = .HgiShaderStageCompute
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStageTessellationControl() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStageTessellationControl
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiShaderStageBits = .HgiShaderStageTessellationControl
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStageTessellationEval() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStageTessellationEval
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HgiShaderStageBits = .HgiShaderStageTessellationEval
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStageGeometry() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStageGeometry
        XCTAssertEqual(x.rawValue, 32)
        let y: pxr.HgiShaderStageBits = .HgiShaderStageGeometry
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStagePostTessellationControl() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStagePostTessellationControl
        XCTAssertEqual(x.rawValue, 64)
        let y: pxr.HgiShaderStageBits = .HgiShaderStagePostTessellationControl
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStagePostTessellationVertex() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStagePostTessellationVertex
        XCTAssertEqual(x.rawValue, 128)
        let y: pxr.HgiShaderStageBits = .HgiShaderStagePostTessellationVertex
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderStageCustomBitsBegin() {
        let x: pxr.HgiShaderStageBits = Overlay.HgiShaderStageCustomBitsBegin
        XCTAssertEqual(x.rawValue, 256)
        let y: pxr.HgiShaderStageBits = .HgiShaderStageCustomBitsBegin
        XCTAssertEqual(x, y)
    }
    // MARK: HgiBindResourceType
    func test_HgiBindResourceTypeSampler() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeSampler
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeSampler
        XCTAssertEqual(x, y)
    }
    func test_HgiBindResourceTypeSampledImage() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeSampledImage
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeSampledImage
        XCTAssertEqual(x, y)
    }
    func test_HgiBindResourceTypeCombinedSamplerImage() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeCombinedSamplerImage
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeCombinedSamplerImage
        XCTAssertEqual(x, y)
    }
    func test_HgiBindResourceTypeStorageImage() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeStorageImage
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeStorageImage
        XCTAssertEqual(x, y)
    }
    func test_HgiBindResourceTypeUniformBuffer() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeUniformBuffer
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeUniformBuffer
        XCTAssertEqual(x, y)
    }
    func test_HgiBindResourceTypeStorageBuffer() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeStorageBuffer
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeStorageBuffer
        XCTAssertEqual(x, y)
    }
    func test_HgiBindResourceTypeTessFactors() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeTessFactors
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeTessFactors
        XCTAssertEqual(x, y)
    }
    func test_HgiBindResourceTypeCount() {
        let x: pxr.HgiBindResourceType = Overlay.HgiBindResourceTypeCount
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HgiBindResourceType = .HgiBindResourceTypeCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiPolygonMode
    func test_HgiPolygonModeFill() {
        let x: pxr.HgiPolygonMode = Overlay.HgiPolygonModeFill
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiPolygonMode = .HgiPolygonModeFill
        XCTAssertEqual(x, y)
    }
    func test_HgiPolygonModeLine() {
        let x: pxr.HgiPolygonMode = Overlay.HgiPolygonModeLine
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiPolygonMode = .HgiPolygonModeLine
        XCTAssertEqual(x, y)
    }
    func test_HgiPolygonModePoint() {
        let x: pxr.HgiPolygonMode = Overlay.HgiPolygonModePoint
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiPolygonMode = .HgiPolygonModePoint
        XCTAssertEqual(x, y)
    }
    func test_HgiPolygonModeCount() {
        let x: pxr.HgiPolygonMode = Overlay.HgiPolygonModeCount
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiPolygonMode = .HgiPolygonModeCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiCullMode
    func test_HgiCullModeNone() {
        let x: pxr.HgiCullMode = Overlay.HgiCullModeNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiCullMode = .HgiCullModeNone
        XCTAssertEqual(x, y)
    }
    func test_HgiCullModeFront() {
        let x: pxr.HgiCullMode = Overlay.HgiCullModeFront
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiCullMode = .HgiCullModeFront
        XCTAssertEqual(x, y)
    }
    func test_HgiCullModeBack() {
        let x: pxr.HgiCullMode = Overlay.HgiCullModeBack
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiCullMode = .HgiCullModeBack
        XCTAssertEqual(x, y)
    }
    func test_HgiCullModeFrontAndBack() {
        let x: pxr.HgiCullMode = Overlay.HgiCullModeFrontAndBack
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiCullMode = .HgiCullModeFrontAndBack
        XCTAssertEqual(x, y)
    }
    func test_HgiCullModeCount() {
        let x: pxr.HgiCullMode = Overlay.HgiCullModeCount
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiCullMode = .HgiCullModeCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiWinding
    func test_HgiWindingClockwise() {
        let x: pxr.HgiWinding = Overlay.HgiWindingClockwise
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiWinding = .HgiWindingClockwise
        XCTAssertEqual(x, y)
    }
    func test_HgiWindingCounterClockwise() {
        let x: pxr.HgiWinding = Overlay.HgiWindingCounterClockwise
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiWinding = .HgiWindingCounterClockwise
        XCTAssertEqual(x, y)
    }
    func test_HgiWindingCount() {
        let x: pxr.HgiWinding = Overlay.HgiWindingCount
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiWinding = .HgiWindingCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiBlendOp
    func test_HgiBlendOpAdd() {
        let x: pxr.HgiBlendOp = Overlay.HgiBlendOpAdd
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiBlendOp = .HgiBlendOpAdd
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendOpSubtract() {
        let x: pxr.HgiBlendOp = Overlay.HgiBlendOpSubtract
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiBlendOp = .HgiBlendOpSubtract
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendOpReverseSubtract() {
        let x: pxr.HgiBlendOp = Overlay.HgiBlendOpReverseSubtract
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiBlendOp = .HgiBlendOpReverseSubtract
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendOpMin() {
        let x: pxr.HgiBlendOp = Overlay.HgiBlendOpMin
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiBlendOp = .HgiBlendOpMin
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendOpMax() {
        let x: pxr.HgiBlendOp = Overlay.HgiBlendOpMax
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiBlendOp = .HgiBlendOpMax
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendOpCount() {
        let x: pxr.HgiBlendOp = Overlay.HgiBlendOpCount
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiBlendOp = .HgiBlendOpCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiBlendFactor
    func test_HgiBlendFactorZero() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorZero
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorZero
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOne() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOne
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOne
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorSrcColor() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorSrcColor
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorSrcColor
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusSrcColor() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusSrcColor
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusSrcColor
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorDstColor() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorDstColor
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorDstColor
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusDstColor() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusDstColor
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusDstColor
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorSrcAlpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorSrcAlpha
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorSrcAlpha
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusSrcAlpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusSrcAlpha
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusSrcAlpha
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorDstAlpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorDstAlpha
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorDstAlpha
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusDstAlpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusDstAlpha
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusDstAlpha
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorConstantColor() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorConstantColor
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorConstantColor
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusConstantColor() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusConstantColor
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusConstantColor
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorConstantAlpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorConstantAlpha
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorConstantAlpha
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusConstantAlpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusConstantAlpha
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusConstantAlpha
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorSrcAlphaSaturate() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorSrcAlphaSaturate
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorSrcAlphaSaturate
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorSrc1Color() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorSrc1Color
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorSrc1Color
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusSrc1Color() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusSrc1Color
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusSrc1Color
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorSrc1Alpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorSrc1Alpha
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorSrc1Alpha
        XCTAssertEqual(x, y)
    }
    func test_HgiBlendFactorOneMinusSrc1Alpha() {
        let x: pxr.HgiBlendFactor = Overlay.HgiBlendFactorOneMinusSrc1Alpha
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.HgiBlendFactor = .HgiBlendFactorOneMinusSrc1Alpha
        XCTAssertEqual(x, y)
    }
    // MARK: HgiColorMaskBits
    func test_HgiColorMaskRed() {
        let x: pxr.HgiColorMaskBits = Overlay.HgiColorMaskRed
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiColorMaskBits = .HgiColorMaskRed
        XCTAssertEqual(x, y)
    }
    func test_HgiColorMaskGreen() {
        let x: pxr.HgiColorMaskBits = Overlay.HgiColorMaskGreen
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiColorMaskBits = .HgiColorMaskGreen
        XCTAssertEqual(x, y)
    }
    func test_HgiColorMaskBlue() {
        let x: pxr.HgiColorMaskBits = Overlay.HgiColorMaskBlue
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiColorMaskBits = .HgiColorMaskBlue
        XCTAssertEqual(x, y)
    }
    func test_HgiColorMaskAlpha() {
        let x: pxr.HgiColorMaskBits = Overlay.HgiColorMaskAlpha
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiColorMaskBits = .HgiColorMaskAlpha
        XCTAssertEqual(x, y)
    }
    // MARK: HgiCompareFunction
    func test_HgiCompareFunctionNever() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionNever
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionNever
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionLess() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionLess
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionLess
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionEqual() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionEqual
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionEqual
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionLEqual() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionLEqual
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionLEqual
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionGreater() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionGreater
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionGreater
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionNotEqual() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionNotEqual
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionNotEqual
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionGEqual() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionGEqual
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionGEqual
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionAlways() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionAlways
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionAlways
        XCTAssertEqual(x, y)
    }
    func test_HgiCompareFunctionCount() {
        let x: pxr.HgiCompareFunction = Overlay.HgiCompareFunctionCount
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HgiCompareFunction = .HgiCompareFunctionCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiStencilOp
    func test_HgiStencilOpKeep() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpKeep
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiStencilOp = .HgiStencilOpKeep
        XCTAssertEqual(x, y)
    }
    func test_HgiStencilOpZero() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpZero
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiStencilOp = .HgiStencilOpZero
        XCTAssertEqual(x, y)
    }
    func test_HgiStencilOpReplace() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpReplace
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiStencilOp = .HgiStencilOpReplace
        XCTAssertEqual(x, y)
    }
    func test_HgiStencilOpIncrementClamp() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpIncrementClamp
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiStencilOp = .HgiStencilOpIncrementClamp
        XCTAssertEqual(x, y)
    }
    func test_HgiStencilOpDecrementClamp() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpDecrementClamp
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiStencilOp = .HgiStencilOpDecrementClamp
        XCTAssertEqual(x, y)
    }
    func test_HgiStencilOpInvert() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpInvert
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiStencilOp = .HgiStencilOpInvert
        XCTAssertEqual(x, y)
    }
    func test_HgiStencilOpIncrementWrap() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpIncrementWrap
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiStencilOp = .HgiStencilOpIncrementWrap
        XCTAssertEqual(x, y)
    }
    func test_HgiStencilOpDecrementWrap() {
        let x: pxr.HgiStencilOp = Overlay.HgiStencilOpDecrementWrap
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HgiStencilOp = .HgiStencilOpDecrementWrap
        XCTAssertEqual(x, y)
    }
    // MARK: HgiComponentSwizzle
    func test_HgiComponentSwizzleZero() {
        let x: pxr.HgiComponentSwizzle = Overlay.HgiComponentSwizzleZero
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiComponentSwizzle = .HgiComponentSwizzleZero
        XCTAssertEqual(x, y)
    }
    func test_HgiComponentSwizzleOne() {
        let x: pxr.HgiComponentSwizzle = Overlay.HgiComponentSwizzleOne
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiComponentSwizzle = .HgiComponentSwizzleOne
        XCTAssertEqual(x, y)
    }
    func test_HgiComponentSwizzleR() {
        let x: pxr.HgiComponentSwizzle = Overlay.HgiComponentSwizzleR
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiComponentSwizzle = .HgiComponentSwizzleR
        XCTAssertEqual(x, y)
    }
    func test_HgiComponentSwizzleG() {
        let x: pxr.HgiComponentSwizzle = Overlay.HgiComponentSwizzleG
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiComponentSwizzle = .HgiComponentSwizzleG
        XCTAssertEqual(x, y)
    }
    func test_HgiComponentSwizzleB() {
        let x: pxr.HgiComponentSwizzle = Overlay.HgiComponentSwizzleB
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiComponentSwizzle = .HgiComponentSwizzleB
        XCTAssertEqual(x, y)
    }
    func test_HgiComponentSwizzleA() {
        let x: pxr.HgiComponentSwizzle = Overlay.HgiComponentSwizzleA
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiComponentSwizzle = .HgiComponentSwizzleA
        XCTAssertEqual(x, y)
    }
    func test_HgiComponentSwizzleCount() {
        let x: pxr.HgiComponentSwizzle = Overlay.HgiComponentSwizzleCount
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiComponentSwizzle = .HgiComponentSwizzleCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiPrimitiveType
    func test_HgiPrimitiveTypePointList() {
        let x: pxr.HgiPrimitiveType = Overlay.HgiPrimitiveTypePointList
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiPrimitiveType = .HgiPrimitiveTypePointList
        XCTAssertEqual(x, y)
    }
    func test_HgiPrimitiveTypeLineList() {
        let x: pxr.HgiPrimitiveType = Overlay.HgiPrimitiveTypeLineList
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiPrimitiveType = .HgiPrimitiveTypeLineList
        XCTAssertEqual(x, y)
    }
    func test_HgiPrimitiveTypeLineStrip() {
        let x: pxr.HgiPrimitiveType = Overlay.HgiPrimitiveTypeLineStrip
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiPrimitiveType = .HgiPrimitiveTypeLineStrip
        XCTAssertEqual(x, y)
    }
    func test_HgiPrimitiveTypeTriangleList() {
        let x: pxr.HgiPrimitiveType = Overlay.HgiPrimitiveTypeTriangleList
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiPrimitiveType = .HgiPrimitiveTypeTriangleList
        XCTAssertEqual(x, y)
    }
    func test_HgiPrimitiveTypePatchList() {
        let x: pxr.HgiPrimitiveType = Overlay.HgiPrimitiveTypePatchList
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiPrimitiveType = .HgiPrimitiveTypePatchList
        XCTAssertEqual(x, y)
    }
    func test_HgiPrimitiveTypeLineListWithAdjacency() {
        let x: pxr.HgiPrimitiveType = Overlay.HgiPrimitiveTypeLineListWithAdjacency
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiPrimitiveType = .HgiPrimitiveTypeLineListWithAdjacency
        XCTAssertEqual(x, y)
    }
    func test_HgiPrimitiveTypeCount() {
        let x: pxr.HgiPrimitiveType = Overlay.HgiPrimitiveTypeCount
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiPrimitiveType = .HgiPrimitiveTypeCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiVertexBufferStepFunction
    func test_HgiVertexBufferStepFunctionConstant() {
        let x: pxr.HgiVertexBufferStepFunction = Overlay.HgiVertexBufferStepFunctionConstant
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiVertexBufferStepFunction = .HgiVertexBufferStepFunctionConstant
        XCTAssertEqual(x, y)
    }
    func test_HgiVertexBufferStepFunctionPerVertex() {
        let x: pxr.HgiVertexBufferStepFunction = Overlay.HgiVertexBufferStepFunctionPerVertex
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiVertexBufferStepFunction = .HgiVertexBufferStepFunctionPerVertex
        XCTAssertEqual(x, y)
    }
    func test_HgiVertexBufferStepFunctionPerInstance() {
        let x: pxr.HgiVertexBufferStepFunction = Overlay.HgiVertexBufferStepFunctionPerInstance
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiVertexBufferStepFunction = .HgiVertexBufferStepFunctionPerInstance
        XCTAssertEqual(x, y)
    }
    func test_HgiVertexBufferStepFunctionPerPatch() {
        let x: pxr.HgiVertexBufferStepFunction = Overlay.HgiVertexBufferStepFunctionPerPatch
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiVertexBufferStepFunction = .HgiVertexBufferStepFunctionPerPatch
        XCTAssertEqual(x, y)
    }
    func test_HgiVertexBufferStepFunctionPerPatchControlPoint() {
        let x: pxr.HgiVertexBufferStepFunction = Overlay.HgiVertexBufferStepFunctionPerPatchControlPoint
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiVertexBufferStepFunction = .HgiVertexBufferStepFunctionPerPatchControlPoint
        XCTAssertEqual(x, y)
    }
    func test_HgiVertexBufferStepFunctionPerDrawCommand() {
        let x: pxr.HgiVertexBufferStepFunction = Overlay.HgiVertexBufferStepFunctionPerDrawCommand
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HgiVertexBufferStepFunction = .HgiVertexBufferStepFunctionPerDrawCommand
        XCTAssertEqual(x, y)
    }
    func test_HgiVertexBufferStepFunctionCount() {
        let x: pxr.HgiVertexBufferStepFunction = Overlay.HgiVertexBufferStepFunctionCount
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HgiVertexBufferStepFunction = .HgiVertexBufferStepFunctionCount
        XCTAssertEqual(x, y)
    }
    // MARK: HgiSubmitWaitType
    func test_HgiSubmitWaitTypeWaitNoWait() {
        let x: pxr.HgiSubmitWaitType = Overlay.HgiSubmitWaitTypeNoWait
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiSubmitWaitType = .HgiSubmitWaitTypeNoWait
        XCTAssertEqual(x, y)
    }
    func test_HgiSubmitWaitTypeWaitUntilCompleted() {
        let x: pxr.HgiSubmitWaitType = Overlay.HgiSubmitWaitTypeWaitUntilCompleted
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiSubmitWaitType = .HgiSubmitWaitTypeWaitUntilCompleted
        XCTAssertEqual(x, y)
    }
    // MARK: HgiMemoryBarrierBits
    func test_HgiMemoryBarrierNone() {
        let x: pxr.HgiMemoryBarrierBits = Overlay.HgiMemoryBarrierNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiMemoryBarrierBits = .HgiMemoryBarrierNone
        XCTAssertEqual(x, y)
    }
    func test_HgiMemoryBarrierAll() {
        let x: pxr.HgiMemoryBarrierBits = Overlay.HgiMemoryBarrierAll
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiMemoryBarrierBits = .HgiMemoryBarrierAll
        XCTAssertEqual(x, y)
    }
    // MARK: HgiBindingType
    func test_HgiBindingTypeValue() {
        let x: pxr.HgiBindingType = Overlay.HgiBindingTypeValue
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiBindingType = .HgiBindingTypeValue
        XCTAssertEqual(x, y)
    }
    func test_HgiBindingTypeUniformValue() {
        let x: pxr.HgiBindingType = Overlay.HgiBindingTypeUniformValue
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiBindingType = .HgiBindingTypeUniformValue
        XCTAssertEqual(x, y)
    }
    func test_HgiBindingTypeArray() {
        let x: pxr.HgiBindingType = Overlay.HgiBindingTypeArray
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiBindingType = .HgiBindingTypeArray
        XCTAssertEqual(x, y)
    }
    func test_HgiBindingTypeUniformArray() {
        let x: pxr.HgiBindingType = Overlay.HgiBindingTypeUniformArray
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HgiBindingType = .HgiBindingTypeUniformArray
        XCTAssertEqual(x, y)
    }
    func test_HgiBindingTypePointer() {
        let x: pxr.HgiBindingType = Overlay.HgiBindingTypePointer
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HgiBindingType = .HgiBindingTypePointer
        XCTAssertEqual(x, y)
    }
    // MARK: HgiInterpolationType
    func test_HgiInterpolationDefault() {
        let x: pxr.HgiInterpolationType = Overlay.HgiInterpolationDefault
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiInterpolationType = .HgiInterpolationDefault
        XCTAssertEqual(x, y)
    }
    func test_HgiInterpolationFlat() {
        let x: pxr.HgiInterpolationType = Overlay.HgiInterpolationFlat
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiInterpolationType = .HgiInterpolationFlat
        XCTAssertEqual(x, y)
    }
    func test_HgiInterpolationNoPerspective() {
        let x: pxr.HgiInterpolationType = Overlay.HgiInterpolationNoPerspective
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiInterpolationType = .HgiInterpolationNoPerspective
        XCTAssertEqual(x, y)
    }
    // MARK: HgiSamplingType
    func test_HgiSamplingDefault() {
        let x: pxr.HgiSamplingType = Overlay.HgiSamplingDefault
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiSamplingType = .HgiSamplingDefault
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplingCentroid() {
        let x: pxr.HgiSamplingType = Overlay.HgiSamplingCentroid
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiSamplingType = .HgiSamplingCentroid
        XCTAssertEqual(x, y)
    }
    func test_HgiSamplingSample() {
        let x: pxr.HgiSamplingType = Overlay.HgiSamplingSample
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiSamplingType = .HgiSamplingSample
        XCTAssertEqual(x, y)
    }
    // MARK: HgiStorageType
    func test_HgiStorageDefault() {
        let x: pxr.HgiStorageType = Overlay.HgiStorageDefault
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiStorageType = .HgiStorageDefault
        XCTAssertEqual(x, y)
    }
    func test_HgiStoragePatch() {
        let x: pxr.HgiStorageType = Overlay.HgiStoragePatch
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiStorageType = .HgiStoragePatch
        XCTAssertEqual(x, y)
    }
    // MARK: HgiShaderTextureType
    func test_HgiShaderTextureTypeTexture() {
        let x: pxr.HgiShaderTextureType = Overlay.HgiShaderTextureTypeTexture
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiShaderTextureType = .HgiShaderTextureTypeTexture
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderTextureTypeShadowTexture() {
        let x: pxr.HgiShaderTextureType = Overlay.HgiShaderTextureTypeShadowTexture
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiShaderTextureType = .HgiShaderTextureTypeShadowTexture
        XCTAssertEqual(x, y)
    }
    func test_HgiShaderTextureTypeArrayTexture() {
        let x: pxr.HgiShaderTextureType = Overlay.HgiShaderTextureTypeArrayTexture
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HgiShaderTextureType = .HgiShaderTextureTypeArrayTexture
        XCTAssertEqual(x, y)
    }
    // MARK: HgiComputeDispatch
    func test_HgiComputeDispatchSerial() {
        let x: pxr.HgiComputeDispatch = Overlay.HgiComputeDispatchSerial
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiComputeDispatch = .HgiComputeDispatchSerial
        XCTAssertEqual(x, y)
    }
    func test_HgiComputeDispatchConcurrent() {
        let x: pxr.HgiComputeDispatch = Overlay.HgiComputeDispatchConcurrent
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HgiComputeDispatch = .HgiComputeDispatchConcurrent
        XCTAssertEqual(x, y)
    }
    
    #if canImport(Metal)
    // MARK: HgiMetal
    
    // MARK: HgiMetalArgumentIndex
    func test_HgiMetalArgumentIndexICB() {
        let x: pxr.HgiMetalArgumentIndex = Overlay.HgiMetalArgumentIndexICB
        XCTAssertEqual(x.rawValue, 26)
        let y: pxr.HgiMetalArgumentIndex = .HgiMetalArgumentIndexICB
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentIndexConstants() {
        let x: pxr.HgiMetalArgumentIndex = Overlay.HgiMetalArgumentIndexConstants
        XCTAssertEqual(x.rawValue, 27)
        let y: pxr.HgiMetalArgumentIndex = .HgiMetalArgumentIndexConstants
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentIndexSamplers() {
        let x: pxr.HgiMetalArgumentIndex = Overlay.HgiMetalArgumentIndexSamplers
        XCTAssertEqual(x.rawValue, 28)
        let y: pxr.HgiMetalArgumentIndex = .HgiMetalArgumentIndexSamplers
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentIndexTextures() {
        let x: pxr.HgiMetalArgumentIndex = Overlay.HgiMetalArgumentIndexTextures
        XCTAssertEqual(x.rawValue, 29)
        let y: pxr.HgiMetalArgumentIndex = .HgiMetalArgumentIndexTextures
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentIndexBuffers() {
        let x: pxr.HgiMetalArgumentIndex = Overlay.HgiMetalArgumentIndexBuffers
        XCTAssertEqual(x.rawValue, 30)
        let y: pxr.HgiMetalArgumentIndex = .HgiMetalArgumentIndexBuffers
        XCTAssertEqual(x, y)
    }
    // MARK: HgiMetalArgumentOffset
    func test_HgiMetalArgumentOffsetBufferVS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetBufferVS
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetBufferVS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetBufferFS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetBufferFS
        XCTAssertEqual(x.rawValue, 512)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetBufferFS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetSamplerVS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetSamplerVS
        XCTAssertEqual(x.rawValue, 1024)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetSamplerVS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetSamplerFS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetSamplerFS
        XCTAssertEqual(x.rawValue, 1536)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetSamplerFS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetTextureVS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetTextureVS
        XCTAssertEqual(x.rawValue, 2048)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetTextureVS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetTextureFS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetTextureFS
        XCTAssertEqual(x.rawValue, 2560)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetTextureFS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetBufferCS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetBufferCS
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetBufferCS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetSamplerCS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetSamplerCS
        XCTAssertEqual(x.rawValue, 1024)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetSamplerCS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetTextureCS() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetTextureCS
        XCTAssertEqual(x.rawValue, 2048)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetTextureCS
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetConstants() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetConstants
        XCTAssertEqual(x.rawValue, 3072)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetConstants
        XCTAssertEqual(x, y)
    }
    func test_HgiMetalArgumentOffsetSize() {
        let x: pxr.HgiMetalArgumentOffset = Overlay.HgiMetalArgumentOffsetSize
        XCTAssertEqual(x.rawValue, 4096)
        let y: pxr.HgiMetalArgumentOffset = .HgiMetalArgumentOffsetSize
        XCTAssertEqual(x, y)
    }
    #endif // #if canImport(Metal)
    
    // MARK: Hd
    
    // MARK: HdCamera.DirtyBits
    func test_HdCamera_Clean() {
        let x: pxr.HdCamera.DirtyBits = Overlay.HdCamera.Clean
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdCamera.DirtyBits = .Clean
        XCTAssertEqual(x, y)
    }
    func test_HdCamera_DirtyTransform() {
        let x: pxr.HdCamera.DirtyBits = Overlay.HdCamera.DirtyTransform
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdCamera.DirtyBits = .DirtyTransform
        XCTAssertEqual(x, y)
    }
    func test_HdCamera_DirtyParams() {
        let x: pxr.HdCamera.DirtyBits = Overlay.HdCamera.DirtyParams
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdCamera.DirtyBits = .DirtyParams
        XCTAssertEqual(x, y)
    }
    func test_HdCamera_DirtyClipPlanes() {
        let x: pxr.HdCamera.DirtyBits = Overlay.HdCamera.DirtyClipPlanes
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdCamera.DirtyBits = .DirtyClipPlanes
        XCTAssertEqual(x, y)
    }
    func test_HdCamera_DirtyWindowPolicy() {
        let x: pxr.HdCamera.DirtyBits = Overlay.HdCamera.DirtyWindowPolicy
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HdCamera.DirtyBits = .DirtyWindowPolicy
        XCTAssertEqual(x, y)
    }
    func test_HdCamera_AllDirty() {
        let x: pxr.HdCamera.DirtyBits = Overlay.HdCamera.AllDirty
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.HdCamera.DirtyBits = .AllDirty
        XCTAssertEqual(x, y)
    }
    // MARK: HdCamera.Projection
    func test_HdCamera_Perspective() {
        let x: pxr.HdCamera.Projection = Overlay.HdCamera.Perspective
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdCamera.Projection = .Perspective
        XCTAssertEqual(x, y)
    }
    func test_HdCamera_Orthographic() {
        let x: pxr.HdCamera.Projection = Overlay.HdCamera.Orthographic
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdCamera.Projection = .Orthographic
        XCTAssertEqual(x, y)
    }
    // MARK: HdCoordSys.DirtyBits
    func test_HdCoordSys_Clean() {
        let x: pxr.HdCoordSys.DirtyBits = Overlay.HdCoordSys.Clean
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdCoordSys.DirtyBits = .Clean
        XCTAssertEqual(x, y)
    }
    func test_HdCoordSys_DirtyName() {
        let x: pxr.HdCoordSys.DirtyBits = Overlay.HdCoordSys.DirtyName
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdCoordSys.DirtyBits = .DirtyName
        XCTAssertEqual(x, y)
    }
    func test_HdCoordSys_DirtyTransform() {
        let x: pxr.HdCoordSys.DirtyBits = Overlay.HdCoordSys.DirtyTransform
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdCoordSys.DirtyBits = .DirtyTransform
        XCTAssertEqual(x, y)
    }
    func test_HdCoordSys_AllDirty() {
        let x: pxr.HdCoordSys.DirtyBits = Overlay.HdCoordSys.AllDirty
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdCoordSys.DirtyBits = .AllDirty
        XCTAssertEqual(x, y)
    }
    // MARK: HdCompareFunction
    func test_HdCmpFuncNever() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncNever
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdCompareFunction = .HdCmpFuncNever
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncLess() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncLess
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdCompareFunction = .HdCmpFuncLess
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncEqual() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncEqual
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdCompareFunction = .HdCmpFuncEqual
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncLEqual() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncLEqual
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdCompareFunction = .HdCmpFuncLEqual
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncGreater() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncGreater
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdCompareFunction = .HdCmpFuncGreater
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncNotEqual() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncNotEqual
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdCompareFunction = .HdCmpFuncNotEqual
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncGEqual() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncGEqual
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HdCompareFunction = .HdCmpFuncGEqual
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncAlways() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncAlways
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HdCompareFunction = .HdCmpFuncAlways
        XCTAssertEqual(x, y)
    }
    func test_HdCmpFuncLast() {
        let x: pxr.HdCompareFunction = Overlay.HdCmpFuncLast
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HdCompareFunction = .HdCmpFuncLast
        XCTAssertEqual(x, y)
    }
    // MARK: HdStencilOp
    func test_HdStencilOpKeep() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpKeep
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdStencilOp = .HdStencilOpKeep
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpZero() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpZero
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdStencilOp = .HdStencilOpZero
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpReplace() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpReplace
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdStencilOp = .HdStencilOpReplace
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpIncrement() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpIncrement
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdStencilOp = .HdStencilOpIncrement
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpIncrementWrap() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpIncrementWrap
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdStencilOp = .HdStencilOpIncrementWrap
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpDecrement() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpDecrement
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdStencilOp = .HdStencilOpDecrement
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpDecrementWrap() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpDecrementWrap
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HdStencilOp = .HdStencilOpDecrementWrap
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpInvert() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpInvert
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HdStencilOp = .HdStencilOpInvert
        XCTAssertEqual(x, y)
    }
    func test_HdStencilOpLast() {
        let x: pxr.HdStencilOp = Overlay.HdStencilOpLast
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HdStencilOp = .HdStencilOpLast
        XCTAssertEqual(x, y)
    }
    // MARK: HdBlendOp
    func test_HdBlendOpAdd() {
        let x: pxr.HdBlendOp = Overlay.HdBlendOpAdd
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdBlendOp = .HdBlendOpAdd
        XCTAssertEqual(x, y)
    }
    func test_HdBlendOpSubtract() {
        let x: pxr.HdBlendOp = Overlay.HdBlendOpSubtract
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdBlendOp = .HdBlendOpSubtract
        XCTAssertEqual(x, y)
    }
    func test_HdBlendOpReverseSubtract() {
        let x: pxr.HdBlendOp = Overlay.HdBlendOpReverseSubtract
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdBlendOp = .HdBlendOpReverseSubtract
        XCTAssertEqual(x, y)
    }
    func test_HdBlendOpMin() {
        let x: pxr.HdBlendOp = Overlay.HdBlendOpMin
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdBlendOp = .HdBlendOpMin
        XCTAssertEqual(x, y)
    }
    func test_HdBlendOpMax() {
        let x: pxr.HdBlendOp = Overlay.HdBlendOpMax
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdBlendOp = .HdBlendOpMax
        XCTAssertEqual(x, y)
    }
    func test_HdBlendOpLast() {
        let x: pxr.HdBlendOp = Overlay.HdBlendOpLast
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdBlendOp = .HdBlendOpLast
        XCTAssertEqual(x, y)
    }
    // MARK: HdBlendFactor
    func test_HdBlendFactorZero() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorZero
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdBlendFactor = .HdBlendFactorZero
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOne() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOne
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdBlendFactor = .HdBlendFactorOne
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorSrcColor() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorSrcColor
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdBlendFactor = .HdBlendFactorSrcColor
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusSrcColor() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusSrcColor
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusSrcColor
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorDstColor() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorDstColor
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdBlendFactor = .HdBlendFactorDstColor
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusDstColor() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusDstColor
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusDstColor
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorSrcAlpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorSrcAlpha
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HdBlendFactor = .HdBlendFactorSrcAlpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusSrcAlpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusSrcAlpha
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusSrcAlpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorDstAlpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorDstAlpha
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HdBlendFactor = .HdBlendFactorDstAlpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusDstAlpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusDstAlpha
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusDstAlpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorConstantColor() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorConstantColor
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.HdBlendFactor = .HdBlendFactorConstantColor
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusConstantColor() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusConstantColor
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusConstantColor
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorConstantAlpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorConstantAlpha
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.HdBlendFactor = .HdBlendFactorConstantAlpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusConstantAlpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusConstantAlpha
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusConstantAlpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorSrcAlphaSaturate() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorSrcAlphaSaturate
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.HdBlendFactor = .HdBlendFactorSrcAlphaSaturate
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorSrc1Color() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorSrc1Color
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.HdBlendFactor = .HdBlendFactorSrc1Color
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusSrc1Color() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusSrc1Color
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusSrc1Color
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorSrc1Alpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorSrc1Alpha
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.HdBlendFactor = .HdBlendFactorSrc1Alpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorOneMinusSrc1Alpha() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorOneMinusSrc1Alpha
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.HdBlendFactor = .HdBlendFactorOneMinusSrc1Alpha
        XCTAssertEqual(x, y)
    }
    func test_HdBlendFactorLast() {
        let x: pxr.HdBlendFactor = Overlay.HdBlendFactorLast
        XCTAssertEqual(x.rawValue, 19)
        let y: pxr.HdBlendFactor = .HdBlendFactorLast
        XCTAssertEqual(x, y)
    }
    // MARK: HdCullStyle
    func test_HdCullStyleDontCare() {
        let x: pxr.HdCullStyle = Overlay.HdCullStyleDontCare
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdCullStyle = .HdCullStyleDontCare
        XCTAssertEqual(x, y)
    }
    func test_HdCullStyleNothing() {
        let x: pxr.HdCullStyle = Overlay.HdCullStyleNothing
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdCullStyle = .HdCullStyleNothing
        XCTAssertEqual(x, y)
    }
    func test_HdCullStyleBack() {
        let x: pxr.HdCullStyle = Overlay.HdCullStyleBack
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdCullStyle = .HdCullStyleBack
        XCTAssertEqual(x, y)
    }
    func test_HdCullStyleFront() {
        let x: pxr.HdCullStyle = Overlay.HdCullStyleFront
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdCullStyle = .HdCullStyleFront
        XCTAssertEqual(x, y)
    }
    func test_HdCullStyleBackUnlessDoubleSided() {
        let x: pxr.HdCullStyle = Overlay.HdCullStyleBackUnlessDoubleSided
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdCullStyle = .HdCullStyleBackUnlessDoubleSided
        XCTAssertEqual(x, y)
    }
    func test_HdCullStyleFrontUnlessDoubleSided() {
        let x: pxr.HdCullStyle = Overlay.HdCullStyleFrontUnlessDoubleSided
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdCullStyle = .HdCullStyleFrontUnlessDoubleSided
        XCTAssertEqual(x, y)
    }
    // MARK: HdPolygonMode
    func test_HdPolygonModeFill() {
        let x: pxr.HdPolygonMode = Overlay.HdPolygonModeFill
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdPolygonMode = .HdPolygonModeFill
        XCTAssertEqual(x, y)
    }
    func test_HdPolygonModeLine() {
        let x: pxr.HdPolygonMode = Overlay.HdPolygonModeLine
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdPolygonMode = .HdPolygonModeLine
        XCTAssertEqual(x, y)
    }
    // MARK: HdMeshGeomStyle
    func test_HdMeshGeomStyleInvalid() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStyleInvalid
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStyleInvalid
        XCTAssertEqual(x, y)
    }
    func test_HdMeshGeomStyleSurf() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStyleSurf
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStyleSurf
        XCTAssertEqual(x, y)
    }
    func test_HdMeshGeomStyleEdgeOnly() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStyleEdgeOnly
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStyleEdgeOnly
        XCTAssertEqual(x, y)
    }
    func test_HdMeshGeomStyleEdgeOnSurf() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStyleEdgeOnSurf
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStyleEdgeOnSurf
        XCTAssertEqual(x, y)
    }
    func test_HdMeshGeomStyleHull() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStyleHull
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStyleHull
        XCTAssertEqual(x, y)
    }
    func test_HdMeshGeomStyleHullEdgeOnly() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStyleHullEdgeOnly
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStyleHullEdgeOnly
        XCTAssertEqual(x, y)
    }
    func test_HdMeshGeomStyleHullEdgeOnSurf() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStyleHullEdgeOnSurf
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStyleHullEdgeOnSurf
        XCTAssertEqual(x, y)
    }
    func test_HdMeshGeomStylePoints() {
        let x: pxr.HdMeshGeomStyle = Overlay.HdMeshGeomStylePoints
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HdMeshGeomStyle = .HdMeshGeomStylePoints
        XCTAssertEqual(x, y)
    }
    // MARK: HdBasisCurvesGeomStyle
    func test_HdBasisCurvesGeomStyleInvalid() {
        let x: pxr.HdBasisCurvesGeomStyle = Overlay.HdBasisCurvesGeomStyleInvalid
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdBasisCurvesGeomStyle = .HdBasisCurvesGeomStyleInvalid
        XCTAssertEqual(x, y)
    }
    func test_HdBasisCurvesGeomStyleWire() {
        let x: pxr.HdBasisCurvesGeomStyle = Overlay.HdBasisCurvesGeomStyleWire
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdBasisCurvesGeomStyle = .HdBasisCurvesGeomStyleWire
        XCTAssertEqual(x, y)
    }
    func test_HdBasisCurvesGeomStylePatch() {
        let x: pxr.HdBasisCurvesGeomStyle = Overlay.HdBasisCurvesGeomStylePatch
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdBasisCurvesGeomStyle = .HdBasisCurvesGeomStylePatch
        XCTAssertEqual(x, y)
    }
    func test_HdBasisCurvesGeomStylePoints() {
        let x: pxr.HdBasisCurvesGeomStyle = Overlay.HdBasisCurvesGeomStylePoints
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdBasisCurvesGeomStyle = .HdBasisCurvesGeomStylePoints
        XCTAssertEqual(x, y)
    }
    // MARK: HdPointsGeomStyle
    func test_HdPointsGeomStyleInvalid() {
        let x: pxr.HdPointsGeomStyle = Overlay.HdPointsGeomStyleInvalid
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdPointsGeomStyle = .HdPointsGeomStyleInvalid
        XCTAssertEqual(x, y)
    }
    func test_HdPointsGeomStylePoints() {
        let x: pxr.HdPointsGeomStyle = Overlay.HdPointsGeomStylePoints
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdPointsGeomStyle = .HdPointsGeomStylePoints
        XCTAssertEqual(x, y)
    }
    // MARK: HdInterpolation
    func test_HdInterpolationConstant() {
        let x: pxr.HdInterpolation = Overlay.HdInterpolationConstant
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdInterpolation = .HdInterpolationConstant
        XCTAssertEqual(x, y)
    }
    func test_HdInterpolationUniform() {
        let x: pxr.HdInterpolation = Overlay.HdInterpolationUniform
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdInterpolation = .HdInterpolationUniform
        XCTAssertEqual(x, y)
    }
    func test_HdInterpolationVarying() {
        let x: pxr.HdInterpolation = Overlay.HdInterpolationVarying
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdInterpolation = .HdInterpolationVarying
        XCTAssertEqual(x, y)
    }
    func test_HdInterpolationVertex() {
        let x: pxr.HdInterpolation = Overlay.HdInterpolationVertex
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdInterpolation = .HdInterpolationVertex
        XCTAssertEqual(x, y)
    }
    func test_HdInterpolationFaceVarying() {
        let x: pxr.HdInterpolation = Overlay.HdInterpolationFaceVarying
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdInterpolation = .HdInterpolationFaceVarying
        XCTAssertEqual(x, y)
    }
    func test_HdInterpolationInstance() {
        let x: pxr.HdInterpolation = Overlay.HdInterpolationInstance
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdInterpolation = .HdInterpolationInstance
        XCTAssertEqual(x, y)
    }
    func test_HdInterpolationCount() {
        let x: pxr.HdInterpolation = Overlay.HdInterpolationCount
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HdInterpolation = .HdInterpolationCount
        XCTAssertEqual(x, y)
    }
    // MARK: HdDepthPriority
    func test_HdDepthPriorityNearest() {
        let x: pxr.HdDepthPriority = Overlay.HdDepthPriorityNearest
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdDepthPriority = .HdDepthPriorityNearest
        XCTAssertEqual(x, y)
    }
    func test_HdDepthPriorityFarthest() {
        let x: pxr.HdDepthPriority = Overlay.HdDepthPriorityFarthest
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdDepthPriority = .HdDepthPriorityFarthest
        XCTAssertEqual(x, y)
    }
    func test_HdDepthPriorityCount() {
        let x: pxr.HdDepthPriority = Overlay.HdDepthPriorityCount
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdDepthPriority = .HdDepthPriorityCount
        XCTAssertEqual(x, y)
    }
    // MARK: HdField.DirtyBits
    func test_HdField_Clean() {
        let x: pxr.HdField.DirtyBits = Overlay.HdField.Clean
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdField.DirtyBits = .Clean
        XCTAssertEqual(x, y)
    }
    func test_HdField_DirtyTransform() {
        let x: pxr.HdField.DirtyBits = Overlay.HdField.DirtyTransform
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdField.DirtyBits = .DirtyTransform
        XCTAssertEqual(x, y)
    }
    func test_HdField_DirtyParams() {
        let x: pxr.HdField.DirtyBits = Overlay.HdField.DirtyParams
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdField.DirtyBits = .DirtyParams
        XCTAssertEqual(x, y)
    }
    func test_HdField_AllDirty() {
        let x: pxr.HdField.DirtyBits = Overlay.HdField.AllDirty
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdField.DirtyBits = .AllDirty
        XCTAssertEqual(x, y)
    }
    // MARK: HdGeomSubset.Type
    func test_HdGeomSubset_TypeFaceSet() {
        let x: pxr.HdGeomSubset.`Type` = Overlay.HdGeomSubset.TypeFaceSet
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdGeomSubset.`Type` = .TypeFaceSet
        XCTAssertEqual(x, y)
    }
    // MARK: HdLight.DirtyBits
    func test_HdLight_Clean() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.Clean
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdLight.DirtyBits = .Clean
        XCTAssertEqual(x, y)
    }
    func test_HdLight_DirtyTransform() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.DirtyTransform
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdLight.DirtyBits = .DirtyTransform
        XCTAssertEqual(x, y)
    }
    func test_HdLight_DirtyParams() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.DirtyParams
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdLight.DirtyBits = .DirtyParams
        XCTAssertEqual(x, y)
    }
    func test_HdLight_DirtyShadowParams() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.DirtyShadowParams
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdLight.DirtyBits = .DirtyShadowParams
        XCTAssertEqual(x, y)
    }
    func test_HdLight_DirtyCollection() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.DirtyCollection
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HdLight.DirtyBits = .DirtyCollection
        XCTAssertEqual(x, y)
    }
    func test_HdLight_DirtyResource() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.DirtyResource
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HdLight.DirtyBits = .DirtyResource
        XCTAssertEqual(x, y)
    }
    func test_HdLight_DirtyInstancer() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.DirtyInstancer
        XCTAssertEqual(x.rawValue, 65536)
        let y: pxr.HdLight.DirtyBits = .DirtyInstancer
        XCTAssertEqual(x, y)
    }
    func test_HdLight_AllDirty() {
        let x: pxr.HdLight.DirtyBits = Overlay.HdLight.AllDirty
        XCTAssertEqual(x.rawValue, 65567)
        let y: pxr.HdLight.DirtyBits = .AllDirty
        XCTAssertEqual(x, y)
    }
    // MARK: HdRenderBuffer.DirtyBits
    func test_HdRenderBuffer_Clean() {
        let x: pxr.HdRenderBuffer.DirtyBits = Overlay.HdRenderBuffer.Clean
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdRenderBuffer.DirtyBits = .Clean
        XCTAssertEqual(x, y)
    }
    func test_HdRenderBuffer_DirtyDescription() {
        let x: pxr.HdRenderBuffer.DirtyBits = Overlay.HdRenderBuffer.DirtyDescription
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdRenderBuffer.DirtyBits = .DirtyDescription
        XCTAssertEqual(x, y)
    }
    func test_HdRenderBuffer_AllDirty() {
        let x: pxr.HdRenderBuffer.DirtyBits = Overlay.HdRenderBuffer.AllDirty
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdRenderBuffer.DirtyBits = .AllDirty
        XCTAssertEqual(x, y)
    }
    // MARK: HdRenderPassState.ColorMask
    func test_HdRenderPassState_ColorMaskNone() {
        let x: pxr.HdRenderPassState.ColorMask = Overlay.HdRenderPassState.ColorMaskNone
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdRenderPassState.ColorMask = .ColorMaskNone
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    func test_HdRenderPassState_ColorMaskRGB() {
        let x: pxr.HdRenderPassState.ColorMask = Overlay.HdRenderPassState.ColorMaskRGB
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdRenderPassState.ColorMask = .ColorMaskRGB
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    func test_HdRenderPassState_ColorMaskRGBA() {
        let x: pxr.HdRenderPassState.ColorMask = Overlay.HdRenderPassState.ColorMaskRGBA
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdRenderPassState.ColorMask = .ColorMaskRGBA
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    // MARK: HdSelection.HighlightMode
    func test_HdSelection_HighlightModeSelect() {
        let x: pxr.HdSelection.HighlightMode = Overlay.HdSelection.HighlightModeSelect
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdSelection.HighlightMode = .HighlightModeSelect
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    func test_HdSelection_HighlightModeLocate() {
        let x: pxr.HdSelection.HighlightMode = Overlay.HdSelection.HighlightModeLocate
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdSelection.HighlightMode = .HighlightModeLocate
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    func test_HdSelection_HighlightModeCount() {
        let x: pxr.HdSelection.HighlightMode = Overlay.HdSelection.HighlightModeCount
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdSelection.HighlightMode = .HighlightModeCount
        // https://github.com/swiftlang/swift/issues/83115 (Conforming C++ enum to Swift protocol causes linker errors (missing destructors for STL types))
        XCTAssertEqual(x.rawValue, y.rawValue)
    }
    // MARK: HdWrap
    func test_HdWrapClamp() {
        let x: pxr.HdWrap = Overlay.HdWrapClamp
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdWrap = .HdWrapClamp
        XCTAssertEqual(x, y)
    }
    func test_HdWrapRepeat() {
        let x: pxr.HdWrap = Overlay.HdWrapRepeat
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdWrap = .HdWrapRepeat
        XCTAssertEqual(x, y)
    }
    func test_HdWrapBlack() {
        let x: pxr.HdWrap = Overlay.HdWrapBlack
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdWrap = .HdWrapBlack
        XCTAssertEqual(x, y)
    }
    func test_HdWrapMirror() {
        let x: pxr.HdWrap = Overlay.HdWrapMirror
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdWrap = .HdWrapMirror
        XCTAssertEqual(x, y)
    }
    func test_HdWrapNoOpinion() {
        let x: pxr.HdWrap = Overlay.HdWrapNoOpinion
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdWrap = .HdWrapNoOpinion
        XCTAssertEqual(x, y)
    }
    func test_HdWrapLegacyNoOpinionFallbackRepeat() {
        let x: pxr.HdWrap = Overlay.HdWrapLegacyNoOpinionFallbackRepeat
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdWrap = .HdWrapLegacyNoOpinionFallbackRepeat
        XCTAssertEqual(x, y)
    }
    func test_HdWrapUseMetadata() {
        let x: pxr.HdWrap = Overlay.HdWrapUseMetadata
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdWrap = .HdWrapUseMetadata
        XCTAssertEqual(x, y)
    }
    func test_HdWrapLegacy() {
        let x: pxr.HdWrap = Overlay.HdWrapLegacy
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdWrap = .HdWrapLegacy
        XCTAssertEqual(x, y)
    }
    // MARK: HdMinFilter
    func test_HdMinFilterNearest() {
        let x: pxr.HdMinFilter = Overlay.HdMinFilterNearest
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdMinFilter = .HdMinFilterNearest
        XCTAssertEqual(x, y)
    }
    func test_HdMinFilterLinear() {
        let x: pxr.HdMinFilter = Overlay.HdMinFilterLinear
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdMinFilter = .HdMinFilterLinear
        XCTAssertEqual(x, y)
    }
    func test_HdMinFilterNearestMipmapNearest() {
        let x: pxr.HdMinFilter = Overlay.HdMinFilterNearestMipmapNearest
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdMinFilter = .HdMinFilterNearestMipmapNearest
        XCTAssertEqual(x, y)
    }
    func test_HdMinFilterLinearMipmapNearest() {
        let x: pxr.HdMinFilter = Overlay.HdMinFilterLinearMipmapNearest
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdMinFilter = .HdMinFilterLinearMipmapNearest
        XCTAssertEqual(x, y)
    }
    func test_HdMinFilterNearestMipmapLinear() {
        let x: pxr.HdMinFilter = Overlay.HdMinFilterNearestMipmapLinear
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdMinFilter = .HdMinFilterNearestMipmapLinear
        XCTAssertEqual(x, y)
    }
    func test_HdMinFilterLinearMipmapLinear() {
        let x: pxr.HdMinFilter = Overlay.HdMinFilterLinearMipmapLinear
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdMinFilter = .HdMinFilterLinearMipmapLinear
        XCTAssertEqual(x, y)
    }
    // MARK: HdMagFilter
    func test_HdMagFilterNearest() {
        let x: pxr.HdMagFilter = Overlay.HdMagFilterNearest
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdMagFilter = .HdMagFilterNearest
        XCTAssertEqual(x, y)
    }
    func test_HdMagFilterLinear() {
        let x: pxr.HdMagFilter = Overlay.HdMagFilterLinear
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdMagFilter = .HdMagFilterLinear
        XCTAssertEqual(x, y)
    }
    // MARK: HdBorderColor
    func test_HdBorderColorTransparentBlack() {
        let x: pxr.HdBorderColor = Overlay.HdBorderColorTransparentBlack
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdBorderColor = .HdBorderColorTransparentBlack
        XCTAssertEqual(x, y)
    }
    func test_HdBorderColorOpaqueBlack() {
        let x: pxr.HdBorderColor = Overlay.HdBorderColorOpaqueBlack
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdBorderColor = .HdBorderColorOpaqueBlack
        XCTAssertEqual(x, y)
    }
    func test_HdBorderColorOpaqueWhite() {
        let x: pxr.HdBorderColor = Overlay.HdBorderColorOpaqueWhite
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdBorderColor = .HdBorderColorOpaqueWhite
        XCTAssertEqual(x, y)
    }
    // MARK: HdType
    func test_HdTypeInvalid() {
        let x: pxr.HdType = Overlay.HdTypeInvalid
        XCTAssertEqual(x.rawValue, -1)
        let y: pxr.HdType = .HdTypeInvalid
        XCTAssertEqual(x, y)
    }
    func test_HdTypeBool() {
        let x: pxr.HdType = Overlay.HdTypeBool
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdType = .HdTypeBool
        XCTAssertEqual(x, y)
    }
    func test_HdTypeUInt8() {
        let x: pxr.HdType = Overlay.HdTypeUInt8
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdType = .HdTypeUInt8
        XCTAssertEqual(x, y)
    }
    func test_HdTypeUInt16() {
        let x: pxr.HdType = Overlay.HdTypeUInt16
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdType = .HdTypeUInt16
        XCTAssertEqual(x, y)
    }
    func test_HdTypeInt8() {
        let x: pxr.HdType = Overlay.HdTypeInt8
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdType = .HdTypeInt8
        XCTAssertEqual(x, y)
    }
    func test_HdTypeInt16() {
        let x: pxr.HdType = Overlay.HdTypeInt16
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdType = .HdTypeInt16
        XCTAssertEqual(x, y)
    }
    func test_HdTypeInt32() {
        let x: pxr.HdType = Overlay.HdTypeInt32
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdType = .HdTypeInt32
        XCTAssertEqual(x, y)
    }
    func test_HdTypeInt32Vec2() {
        let x: pxr.HdType = Overlay.HdTypeInt32Vec2
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HdType = .HdTypeInt32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdTypeInt32Vec3() {
        let x: pxr.HdType = Overlay.HdTypeInt32Vec3
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HdType = .HdTypeInt32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdTypeInt32Vec4() {
        let x: pxr.HdType = Overlay.HdTypeInt32Vec4
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HdType = .HdTypeInt32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdTypeUInt32() {
        let x: pxr.HdType = Overlay.HdTypeUInt32
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.HdType = .HdTypeUInt32
        XCTAssertEqual(x, y)
    }
    func test_HdTypeUInt32Vec2() {
        let x: pxr.HdType = Overlay.HdTypeUInt32Vec2
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.HdType = .HdTypeUInt32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdTypeUInt32Vec3() {
        let x: pxr.HdType = Overlay.HdTypeUInt32Vec3
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.HdType = .HdTypeUInt32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdTypeUInt32Vec4() {
        let x: pxr.HdType = Overlay.HdTypeUInt32Vec4
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.HdType = .HdTypeUInt32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdTypeFloat() {
        let x: pxr.HdType = Overlay.HdTypeFloat
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.HdType = .HdTypeFloat
        XCTAssertEqual(x, y)
    }
    func test_HdTypeFloatVec2() {
        let x: pxr.HdType = Overlay.HdTypeFloatVec2
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.HdType = .HdTypeFloatVec2
        XCTAssertEqual(x, y)
    }
    func test_HdTypeFloatVec3() {
        let x: pxr.HdType = Overlay.HdTypeFloatVec3
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.HdType = .HdTypeFloatVec3
        XCTAssertEqual(x, y)
    }
    func test_HdTypeFloatVec4() {
        let x: pxr.HdType = Overlay.HdTypeFloatVec4
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HdType = .HdTypeFloatVec4
        XCTAssertEqual(x, y)
    }
    func test_HdTypeFloatMat3() {
        let x: pxr.HdType = Overlay.HdTypeFloatMat3
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.HdType = .HdTypeFloatMat3
        XCTAssertEqual(x, y)
    }
    func test_HdTypeFloatMat4() {
        let x: pxr.HdType = Overlay.HdTypeFloatMat4
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.HdType = .HdTypeFloatMat4
        XCTAssertEqual(x, y)
    }
    func test_HdTypeDouble() {
        let x: pxr.HdType = Overlay.HdTypeDouble
        XCTAssertEqual(x.rawValue, 19)
        let y: pxr.HdType = .HdTypeDouble
        XCTAssertEqual(x, y)
    }
    func test_HdTypeDoubleVec2() {
        let x: pxr.HdType = Overlay.HdTypeDoubleVec2
        XCTAssertEqual(x.rawValue, 20)
        let y: pxr.HdType = .HdTypeDoubleVec2
        XCTAssertEqual(x, y)
    }
    func test_HdTypeDoubleVec3() {
        let x: pxr.HdType = Overlay.HdTypeDoubleVec3
        XCTAssertEqual(x.rawValue, 21)
        let y: pxr.HdType = .HdTypeDoubleVec3
        XCTAssertEqual(x, y)
    }
    func test_HdTypeDoubleVec4() {
        let x: pxr.HdType = Overlay.HdTypeDoubleVec4
        XCTAssertEqual(x.rawValue, 22)
        let y: pxr.HdType = .HdTypeDoubleVec4
        XCTAssertEqual(x, y)
    }
    func test_HdTypeDoubleMat3() {
        let x: pxr.HdType = Overlay.HdTypeDoubleMat3
        XCTAssertEqual(x.rawValue, 23)
        let y: pxr.HdType = .HdTypeDoubleMat3
        XCTAssertEqual(x, y)
    }
    func test_HdTypeDoubleMat4() {
        let x: pxr.HdType = Overlay.HdTypeDoubleMat4
        XCTAssertEqual(x.rawValue, 24)
        let y: pxr.HdType = .HdTypeDoubleMat4
        XCTAssertEqual(x, y)
    }
    func test_HdTypeHalfFloat() {
        let x: pxr.HdType = Overlay.HdTypeHalfFloat
        XCTAssertEqual(x.rawValue, 25)
        let y: pxr.HdType = .HdTypeHalfFloat
        XCTAssertEqual(x, y)
    }
    func test_HdTypeHalfFloatVec2() {
        let x: pxr.HdType = Overlay.HdTypeHalfFloatVec2
        XCTAssertEqual(x.rawValue, 26)
        let y: pxr.HdType = .HdTypeHalfFloatVec2
        XCTAssertEqual(x, y)
    }
    func test_HdTypeHalfFloatVec3() {
        let x: pxr.HdType = Overlay.HdTypeHalfFloatVec3
        XCTAssertEqual(x.rawValue, 27)
        let y: pxr.HdType = .HdTypeHalfFloatVec3
        XCTAssertEqual(x, y)
    }
    func test_HdTypeHalfFloatVec4() {
        let x: pxr.HdType = Overlay.HdTypeHalfFloatVec4
        XCTAssertEqual(x.rawValue, 28)
        let y: pxr.HdType = .HdTypeHalfFloatVec4
        XCTAssertEqual(x, y)
    }
    func test_HdTypeInt32_2_10_10_10_REV() {
        let x: pxr.HdType = Overlay.HdTypeInt32_2_10_10_10_REV
        XCTAssertEqual(x.rawValue, 29)
        let y: pxr.HdType = .HdTypeInt32_2_10_10_10_REV
        XCTAssertEqual(x, y)
    }
    func test_HdTypeCount() {
        let x: pxr.HdType = Overlay.HdTypeCount
        XCTAssertEqual(x.rawValue, 30)
        let y: pxr.HdType = .HdTypeCount
        XCTAssertEqual(x, y)
    }
    // MARK: HdFormat
    func test_HdFormatInvalid() {
        let x: pxr.HdFormat = Overlay.HdFormatInvalid
        XCTAssertEqual(x.rawValue, -1)
        let y: pxr.HdFormat = .HdFormatInvalid
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUNorm8() {
        let x: pxr.HdFormat = Overlay.HdFormatUNorm8
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdFormat = .HdFormatUNorm8
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUNorm8Vec2() {
        let x: pxr.HdFormat = Overlay.HdFormatUNorm8Vec2
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdFormat = .HdFormatUNorm8Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUNorm8Vec3() {
        let x: pxr.HdFormat = Overlay.HdFormatUNorm8Vec3
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdFormat = .HdFormatUNorm8Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUNorm8Vec4() {
        let x: pxr.HdFormat = Overlay.HdFormatUNorm8Vec4
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdFormat = .HdFormatUNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdFormatSNorm8() {
        let x: pxr.HdFormat = Overlay.HdFormatSNorm8
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.HdFormat = .HdFormatSNorm8
        XCTAssertEqual(x, y)
    }
    func test_HdFormatSNorm8Vec2() {
        let x: pxr.HdFormat = Overlay.HdFormatSNorm8Vec2
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.HdFormat = .HdFormatSNorm8Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdFormatSNorm8Vec3() {
        let x: pxr.HdFormat = Overlay.HdFormatSNorm8Vec3
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.HdFormat = .HdFormatSNorm8Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdFormatSNorm8Vec4() {
        let x: pxr.HdFormat = Overlay.HdFormatSNorm8Vec4
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.HdFormat = .HdFormatSNorm8Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat16() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat16
        XCTAssertEqual(x.rawValue, 8)
        let y: pxr.HdFormat = .HdFormatFloat16
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat16Vec2() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat16Vec2
        XCTAssertEqual(x.rawValue, 9)
        let y: pxr.HdFormat = .HdFormatFloat16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat16Vec3() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat16Vec3
        XCTAssertEqual(x.rawValue, 10)
        let y: pxr.HdFormat = .HdFormatFloat16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat16Vec4() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat16Vec4
        XCTAssertEqual(x.rawValue, 11)
        let y: pxr.HdFormat = .HdFormatFloat16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat32() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat32
        XCTAssertEqual(x.rawValue, 12)
        let y: pxr.HdFormat = .HdFormatFloat32
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat32Vec2() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat32Vec2
        XCTAssertEqual(x.rawValue, 13)
        let y: pxr.HdFormat = .HdFormatFloat32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat32Vec3() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat32Vec3
        XCTAssertEqual(x.rawValue, 14)
        let y: pxr.HdFormat = .HdFormatFloat32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat32Vec4() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat32Vec4
        XCTAssertEqual(x.rawValue, 15)
        let y: pxr.HdFormat = .HdFormatFloat32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt16() {
        let x: pxr.HdFormat = Overlay.HdFormatInt16
        XCTAssertEqual(x.rawValue, 16)
        let y: pxr.HdFormat = .HdFormatInt16
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt16Vec2() {
        let x: pxr.HdFormat = Overlay.HdFormatInt16Vec2
        XCTAssertEqual(x.rawValue, 17)
        let y: pxr.HdFormat = .HdFormatInt16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt16Vec3() {
        let x: pxr.HdFormat = Overlay.HdFormatInt16Vec3
        XCTAssertEqual(x.rawValue, 18)
        let y: pxr.HdFormat = .HdFormatInt16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt16Vec4() {
        let x: pxr.HdFormat = Overlay.HdFormatInt16Vec4
        XCTAssertEqual(x.rawValue, 19)
        let y: pxr.HdFormat = .HdFormatInt16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUInt16() {
        let x: pxr.HdFormat = Overlay.HdFormatUInt16
        XCTAssertEqual(x.rawValue, 20)
        let y: pxr.HdFormat = .HdFormatUInt16
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUInt16Vec2() {
        let x: pxr.HdFormat = Overlay.HdFormatUInt16Vec2
        XCTAssertEqual(x.rawValue, 21)
        let y: pxr.HdFormat = .HdFormatUInt16Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUInt16Vec3() {
        let x: pxr.HdFormat = Overlay.HdFormatUInt16Vec3
        XCTAssertEqual(x.rawValue, 22)
        let y: pxr.HdFormat = .HdFormatUInt16Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdFormatUInt16Vec4() {
        let x: pxr.HdFormat = Overlay.HdFormatUInt16Vec4
        XCTAssertEqual(x.rawValue, 23)
        let y: pxr.HdFormat = .HdFormatUInt16Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt32() {
        let x: pxr.HdFormat = Overlay.HdFormatInt32
        XCTAssertEqual(x.rawValue, 24)
        let y: pxr.HdFormat = .HdFormatInt32
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt32Vec2() {
        let x: pxr.HdFormat = Overlay.HdFormatInt32Vec2
        XCTAssertEqual(x.rawValue, 25)
        let y: pxr.HdFormat = .HdFormatInt32Vec2
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt32Vec3() {
        let x: pxr.HdFormat = Overlay.HdFormatInt32Vec3
        XCTAssertEqual(x.rawValue, 26)
        let y: pxr.HdFormat = .HdFormatInt32Vec3
        XCTAssertEqual(x, y)
    }
    func test_HdFormatInt32Vec4() {
        let x: pxr.HdFormat = Overlay.HdFormatInt32Vec4
        XCTAssertEqual(x.rawValue, 27)
        let y: pxr.HdFormat = .HdFormatInt32Vec4
        XCTAssertEqual(x, y)
    }
    func test_HdFormatFloat32UInt8() {
        let x: pxr.HdFormat = Overlay.HdFormatFloat32UInt8
        XCTAssertEqual(x.rawValue, 28)
        let y: pxr.HdFormat = .HdFormatFloat32UInt8
        XCTAssertEqual(x, y)
    }
    func test_HdFormatCount() {
        let x: pxr.HdFormat = Overlay.HdFormatCount
        XCTAssertEqual(x.rawValue, 29)
        let y: pxr.HdFormat = .HdFormatCount
        XCTAssertEqual(x, y)
    }
    
    // MARK: HdGp
    
    // MARK: HdGpGenerativeProcedural.AsyncState
    func test_HdGpGenerativeProcedural_Continuing() {
        let x: pxr.HdGpGenerativeProcedural.AsyncState = Overlay.HdGpGenerativeProcedural.Continuing
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.HdGpGenerativeProcedural.AsyncState = .Continuing
        XCTAssertEqual(x, y)
    }
    func test_HdGpGenerativeProcedural_Finished() {
        let x: pxr.HdGpGenerativeProcedural.AsyncState = Overlay.HdGpGenerativeProcedural.Finished
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.HdGpGenerativeProcedural.AsyncState = .Finished
        XCTAssertEqual(x, y)
    }
    func test_HdGpGenerativeProcedural_ContinuingWithNewChanges() {
        let x: pxr.HdGpGenerativeProcedural.AsyncState = Overlay.HdGpGenerativeProcedural.ContinuingWithNewChanges
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.HdGpGenerativeProcedural.AsyncState = .ContinuingWithNewChanges
        XCTAssertEqual(x, y)
    }
    func test_HdGpGenerativeProcedural_FinishedWithNewChanges() {
        let x: pxr.HdGpGenerativeProcedural.AsyncState = Overlay.HdGpGenerativeProcedural.FinishedWithNewChanges
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.HdGpGenerativeProcedural.AsyncState = .FinishedWithNewChanges
        XCTAssertEqual(x, y)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    
    #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
    
    // MARK: UsdImaging
    
    // MARK: UsdImagingPrimAdapter.PopulationMode
    func test_UsdImagingPrimAdapter_RepresentsSelf() {
        let x: pxr.UsdImagingPrimAdapter.PopulationMode = Overlay.UsdImagingPrimAdapter.RepresentsSelf
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdImagingPrimAdapter.PopulationMode = .RepresentsSelf
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingPrimAdapter_RepresentsSelfAndDescendents() {
        let x: pxr.UsdImagingPrimAdapter.PopulationMode = Overlay.UsdImagingPrimAdapter.RepresentsSelfAndDescendents
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdImagingPrimAdapter.PopulationMode = .RepresentsSelfAndDescendents
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingPrimAdapter_RepresentedByAncestor() {
        let x: pxr.UsdImagingPrimAdapter.PopulationMode = Overlay.UsdImagingPrimAdapter.RepresentedByAncestor
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdImagingPrimAdapter.PopulationMode = .RepresentedByAncestor
        XCTAssertEqual(x, y)
    }
    // MARK: UsdImagingPropertyInvalidationType
    func test_UsdImagingPropertyInvalidationType_Update() {
        let x: pxr.UsdImagingPropertyInvalidationType = Overlay.UsdImagingPropertyInvalidationType.Update
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdImagingPropertyInvalidationType = .Update
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingPropertyInvalidationType_Resync() {
        let x: pxr.UsdImagingPropertyInvalidationType = Overlay.UsdImagingPropertyInvalidationType.Resync
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdImagingPropertyInvalidationType = .Resync
        XCTAssertEqual(x, y)
    }
    // MARK: UsdImagingGLDrawMode
    func test_UsdImagingGLDrawMode_DRAW_POINTS() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_POINTS
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_POINTS
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLDrawMode_DRAW_WIREFRAME() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_WIREFRAME
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_WIREFRAME
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLDrawMode_DRAW_WIREFRAME_ON_SURFACE() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_WIREFRAME_ON_SURFACE
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_WIREFRAME_ON_SURFACE
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLDrawMode_DRAW_SHADED_FLAT() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_SHADED_FLAT
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_SHADED_FLAT
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLDrawMode_DRAW_SHADED_SMOOTH() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_SHADED_SMOOTH
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_SHADED_SMOOTH
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLDrawMode_DRAW_GEOM_ONLY() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_GEOM_ONLY
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_GEOM_ONLY
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLDrawMode_DRAW_GEOM_FLAT() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_GEOM_FLAT
        XCTAssertEqual(x.rawValue, 6)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_GEOM_FLAT
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLDrawMode_DRAW_GEOM_SMOOTH() {
        let x: pxr.UsdImagingGLDrawMode = Overlay.UsdImagingGLDrawMode.DRAW_GEOM_SMOOTH
        XCTAssertEqual(x.rawValue, 7)
        let y: pxr.UsdImagingGLDrawMode = .DRAW_GEOM_SMOOTH
        XCTAssertEqual(x, y)
    }
    // MARK: UsdImagingGLCullStyle
    func test_UsdImagingGLCullStyle_CULL_STYLE_NO_OPINION() {
        let x: pxr.UsdImagingGLCullStyle = Overlay.UsdImagingGLCullStyle.CULL_STYLE_NO_OPINION
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdImagingGLCullStyle = .CULL_STYLE_NO_OPINION
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLCullStyle_CULL_STYLE_NOTHING() {
        let x: pxr.UsdImagingGLCullStyle = Overlay.UsdImagingGLCullStyle.CULL_STYLE_NOTHING
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdImagingGLCullStyle = .CULL_STYLE_NOTHING
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLCullStyle_CULL_STYLE_BACK() {
        let x: pxr.UsdImagingGLCullStyle = Overlay.UsdImagingGLCullStyle.CULL_STYLE_BACK
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdImagingGLCullStyle = .CULL_STYLE_BACK
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLCullStyle_CULL_STYLE_FRONT() {
        let x: pxr.UsdImagingGLCullStyle = Overlay.UsdImagingGLCullStyle.CULL_STYLE_FRONT
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdImagingGLCullStyle = .CULL_STYLE_FRONT
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLCullStyle_CULL_STYLE_BACK_UNLESS_DOUBLE_SIDED() {
        let x: pxr.UsdImagingGLCullStyle = Overlay.UsdImagingGLCullStyle.CULL_STYLE_BACK_UNLESS_DOUBLE_SIDED
        XCTAssertEqual(x.rawValue, 4)
        let y: pxr.UsdImagingGLCullStyle = .CULL_STYLE_BACK_UNLESS_DOUBLE_SIDED
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLCullStyle_CULL_STYLE_COUNT() {
        let x: pxr.UsdImagingGLCullStyle = Overlay.UsdImagingGLCullStyle.CULL_STYLE_COUNT
        XCTAssertEqual(x.rawValue, 5)
        let y: pxr.UsdImagingGLCullStyle = .CULL_STYLE_COUNT
        XCTAssertEqual(x, y)
    }
    // MARK: UsdImagingGLRendererSetting.Type
    func test_UsdImagingGLRendererSetting_TYPE_FLAG() {
        let x: pxr.UsdImagingGLRendererSetting.`Type` = Overlay.UsdImagingGLRendererSetting.TYPE_FLAG
        XCTAssertEqual(x.rawValue, 0)
        let y: pxr.UsdImagingGLRendererSetting.`Type` = .TYPE_FLAG
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLRendererSetting_TYPE_INT() {
        let x: pxr.UsdImagingGLRendererSetting.`Type` = Overlay.UsdImagingGLRendererSetting.TYPE_INT
        XCTAssertEqual(x.rawValue, 1)
        let y: pxr.UsdImagingGLRendererSetting.`Type` = .TYPE_INT
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLRendererSetting_TYPE_FLOAT() {
        let x: pxr.UsdImagingGLRendererSetting.`Type` = Overlay.UsdImagingGLRendererSetting.TYPE_FLOAT
        XCTAssertEqual(x.rawValue, 2)
        let y: pxr.UsdImagingGLRendererSetting.`Type` = .TYPE_FLOAT
        XCTAssertEqual(x, y)
    }
    func test_UsdImagingGLRendererSetting_TYPE_STRING() {
        let x: pxr.UsdImagingGLRendererSetting.`Type` = Overlay.UsdImagingGLRendererSetting.TYPE_STRING
        XCTAssertEqual(x.rawValue, 3)
        let y: pxr.UsdImagingGLRendererSetting.`Type` = .TYPE_STRING
        XCTAssertEqual(x, y)
    }
    
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
    
    
    
    
    
    func test_DefaultPropertyPredicateFunc() {
        let x = Overlay.DefaultPropertyPredicateFunc
        // Can't test it any more than this,
        // because it throws std::bad_function_call
        withExtendedLifetime(x) {}
    }

    


    
    
    
    
    func test_UsdPrimDefaultPredicate() {
        let _: pxr.Usd_PrimFlagsPredicate = Overlay.UsdPrimDefaultPredicate
        // Can't test more than this
    }
}
#endif
