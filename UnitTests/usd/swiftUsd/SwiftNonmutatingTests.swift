//
//  SwiftNonmutatingTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 10/31/24.
//

import XCTest
import OpenUSD

// For these tests, it's enough to test that the code compiles, without actually running it,
// because we're testing the arguments and the presence of non-mutating methods

final class SwiftNonmutatingTests: TemporaryDirectoryHelper {
    // MARK: UsdReferences
    func test_AddReference_twoArgs() {
        func __(references: pxr.UsdReferences, ref: pxr.SdfReference) {
            let _: Bool = references.AddReference(ref, .UsdListPositionBackOfPrependList)
        }
    }
    
    func test_AddReference_fourArgs() {
        func __(references: pxr.UsdReferences) {
            let _: Bool = references.AddReference("" as std.string, "" as pxr.SdfPath, pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        }
    }
    
    func test_AddReference_threeArgs() {
        func __(references: pxr.UsdReferences) {
            let _: Bool = references.AddReference("" as std.string, pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        }
    }
    
    func test_AddInternalReference() {
        func __(references: pxr.UsdReferences) {
            let _: Bool = references.AddInternalReference("" as pxr.SdfPath, pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        }
    }
    
    func test_RemoveReference() {
        func __(references: pxr.UsdReferences, ref: pxr.SdfReference) {
            let _: Bool = references.RemoveReference(ref)
        }
    }
    
    func test_ClearReferences() {
        func __(references: pxr.UsdReferences) {
            let _: Bool = references.ClearReferences()
        }
    }
    
    func test_SetReferences() {
        func __(references: pxr.UsdReferences) {
            let _: Bool = references.SetReferences(pxr.SdfReferenceVector())
        }
    }
    
    // MARK: UsdPayloads
    
    func test_AddPayload_twoArgs() {
        func __(payloads: pxr.UsdPayloads, p: pxr.SdfPayload) {
            let _: Bool = payloads.AddPayload(p, .UsdListPositionBackOfPrependList)
        }
    }

    func test_AddPayload_fourArgs() {
        func __(payloads: pxr.UsdPayloads) {
            let _: Bool = payloads.AddPayload("" as std.string, "" as pxr.SdfPath, pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        }
    }

    func test_AddPayload_threeArgs() {
        func __(payloads: pxr.UsdPayloads) {
            let _: Bool = payloads.AddPayload("" as std.string, pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        }
    }

    func test_AddInternalPayload() {
        func __(payloads: pxr.UsdPayloads) {
            let _: Bool = payloads.AddInternalPayload("" as pxr.SdfPath, pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
        }
    }

    func test_RemovePayload() {
        func __(payloads: pxr.UsdPayloads, p: pxr.SdfPayload) {
            let _: Bool = payloads.RemovePayload(p)
        }
    }

    func test_ClearPayloads() {
        func __(payloads: pxr.UsdPayloads) {
            let _: Bool = payloads.ClearPayloads()
        }
    }

    func test_SetPayloads() {
        func __(payloads: pxr.UsdPayloads) {
            let _: Bool = payloads.SetPayloads(pxr.SdfPayloadVector())
        }
    }
}
