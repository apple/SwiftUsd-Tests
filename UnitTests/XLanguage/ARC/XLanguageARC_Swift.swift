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
#if canImport(XLangTestingUtil)
import XLangTestingUtil
#endif // #if canImport(XLangTestingUtil)

// The purpose of XLanguageARC is to test how Swift and C++ handle reference counting
// when crossing the language boundary.
//
// Crossing language boundaries can happen in the following ways:
// 1. Passing an argument to a function with ownership
// 2. Passing an argument to a function without ownership
// 3. Returning a value from a function with ownership
//
// When Swift does reference counting, it always does so via raw pointer.
// When passed a borrowing SWIFT_SHARED_REFERENCE from C++, Swift balances all retains and releases.
// When passed a consuming SWIFT_SHARED_REFERENCE from C++, Swift _currently_ performs a retain before running the function body,
// but this behavior might change in a future release. Thus, it's worth maintaining separate tests for both borrowing and consuming,
// even if they're redundant at the moment.
//
// When C++ does reference counting, it can either take ownership via TfRefPtr,
// or not take ownership via TfWeakPtr. C++ can also be passed raw pointers
// when calling a Swift function that returns a SWIFT_SHARED_REFERENCE. Raw pointers
// should not be used in C++, but the conversion from raw pointer to shared pointer still needs
// to be tested.
//
// We want to test combinations of passing and returning, in either language,
// with UsdStage, SdfLayer, and SdfLayer-owned-by-UsdStage,
// with smart and raw pointers

#if os(Linux)
// rdar://146138311 (Swift closure wrapped in ObjC block wrapped in std::function crashes at runtime on Linux)
#warning("XLARC tests disabled on Linux because they rely on ObjC blocks")
#else

public class _xLanguageARC_functions_swift {
    static public func smartStage_passStrong(_ p: pxr.UsdStageRefPtr) {
        Overlay.Dereference(p).SetStartTimeCode(5)
    }
    static public func smartStage_passWeak(_ p: pxr.UsdStageWeakPtr) {
        Overlay.Dereference(p).SetStartTimeCode(5)
    }
    static public func smartStage_return(_ path: std.string) -> pxr.UsdStageRefPtr {
        pxr.UsdStage.CreateNew(path, .LoadAll)
    }

    
    static public func smartLayer_passStrong(_ p: pxr.SdfLayerRefPtr) {
        Overlay.Dereference(p).SetStartTimeCode(5)
    }
    static public func smartLayer_passWeak(_ p: pxr.SdfLayerHandle) {
        Overlay.Dereference(p).SetStartTimeCode(5)
    }
    static public func smartLayer_return(_ path: std.string) -> pxr.SdfLayerRefPtr {
        pxr.SdfLayer.CreateNew(path, pxr.SdfLayer.FileFormatArguments())
    }

    
    static public func smartLayerFromStage_passStrong(_ p: pxr.SdfLayerRefPtr) {
        Overlay.Dereference(p).SetStartTimeCode(5)
    }
    static public func smartLayerFromStage_passWeak(_ p: pxr.SdfLayerHandle) {
        Overlay.Dereference(p).SetStartTimeCode(5)
    }
    static public func smartLayerFromStage_return(_ path: std.string) -> pxr.SdfLayerRefPtr {
        let s = Overlay.Dereference(pxr.UsdStage.CreateNew(path, .LoadAll))
        let l = Overlay.Dereference(s.GetRootLayer())
        return Overlay.TfRefPtr(l)
    }
    
    
    static public func rawStage_passBorrowing(_ p: borrowing pxr.UsdStage) {
        p.SetStartTimeCode(5)
    }
    static public func rawStage_passConsuming(_ p: consuming pxr.UsdStage) {
        p.SetStartTimeCode(5)
    }
    static public func rawStage_return(_ path: std.string) -> pxr.UsdStage {
        Overlay.Dereference(pxr.UsdStage.CreateNew(path, .LoadAll))
    }
    
    static public func rawLayer_passBorrowing(_ p: borrowing pxr.SdfLayer) {
        p.SetStartTimeCode(5)
    }
    static public func rawLayer_passConsuming(_ p: consuming pxr.SdfLayer) {
        p.SetStartTimeCode(5)
    }
    static public func rawLayer_return(_ path: std.string) -> pxr.SdfLayer {
        Overlay.Dereference(pxr.SdfLayer.CreateNew(path, pxr.SdfLayer.FileFormatArguments()))
    }
    
    static public func rawLayerFromStage_passBorrowing(_ p: borrowing pxr.SdfLayer) {
        p.SetStartTimeCode(5)
    }
    static public func rawLayerFromStage_passConsuming(_ p: consuming pxr.SdfLayer) {
        p.SetStartTimeCode(5)
    }
    static public func rawLayerFromStage_return(_ path: std.string) -> pxr.SdfLayer {
        let s = Overlay.Dereference(pxr.UsdStage.CreateNew(path, .LoadAll))
        let l = Overlay.Dereference(s.GetRootLayer())
        return l
    }
}

// Working with smart pointers:
// 3 types of object: smartStage, smartLayer, smartLayerFromStage
// 2 languages for functions that create an object: swiftReturn, cppReturn
// 2 ways of holding on to the object: holdTemporary, noTemporary
// 2 languages of functions to pass an object to: swiftPass, cppPass
// 2 smart pointer types to pass an object: strong, weak
// 2 languages to do everything from: swiftEntry, cppEntry

// Working with raw pointers:
// 3 types of objects: rawStage, rawLayer, rawLayerFromStage
// 2 languages for functions that create an object: swiftReturn, cppReturn
// 2 ways of holding on to the object: holdTemporary, noTemporary
// 3 kinds of ways to pass an object to a function: swiftPassBorrowing, swiftPassConsuming, cppPass
// 2 languages to do everything from: swiftEntry, cppEntry




final class UsdStage_XLanguageARCTests: TemporaryDirectoryHelper {
    fileprivate typealias xlarcf_swift = _xLanguageARC_functions_swift
    fileprivate typealias xlarcf_cpp = _xLanguageARC_functions_cpp
    fileprivate typealias xltest = _xLanguageARC_tests

   // See comment in XLangagueARC_Cpp.hpp for an explanation of MULTI_TARGET_INTEROP.
   // and `#if canImport(XLangTestingUtil)`. 
   // Tl;dr, Swift Package Manager doesn't support bidirectional interop, so we have
   // to build it ourselves by setting up a function pointer table. 
    #if canImport(XLangTestingUtil)
    private static nonisolated(unsafe) var didClassSetUp = false
    override class func setUp() {
        super.setUp()
        if didClassSetUp { return }
        setUpFunctionPointers()
        didClassSetUp = true
    }
    #endif // #if canImport(XLangTestingUtil)
    
    // MARK: SmartStage
        
    func test_smartStage_swiftReturn_holdTemporary_swiftPass_strong_swiftEntry() {
        do {
            let p = xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_holdTemporary_swiftPass_weak_swiftEntry() {
        do {
            let p = xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_holdTemporary_cppPass_strong_swiftEntry() {
        do {
            let p = xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_holdTemporary_cppPass_weak_swiftEntry() {
        do {
            let p = xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_smartStage_swiftReturn_noTemporary_swiftPass_strong_swiftEntry() {
        do {
            xlarcf_swift.smartStage_passStrong(xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_noTemporary_swiftPass_weak_swiftEntry() {
//        // This reasonably crashes
//        do {
//            xlarcf_swift.smartStage_passWeak(Overlay.TfWeakPtr(xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_noTemporary_cppPass_strong_swiftEntry() {
        do {
            xlarcf_cpp.smartStage_passStrong(xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_noTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_noTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_noTemporary_cppPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_cpp.smartStage_passWeak(Overlay.TfWeakPtr(xlarcf_swift.smartStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_swiftReturn_noTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartStage_swiftReturn_noTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    
    
    func test_smartStage_cppReturn_holdTemporary_swiftPass_strong_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_holdTemporary_swiftPass_weak_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_holdTemporary_cppPass_strong_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_holdTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartStage_cppReturn_holdTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_holdTemporary_cppPass_weak_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_holdTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartStage_cppReturn_holdTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_smartStage_cppReturn_noTemporary_swiftPass_strong_swiftEntry() {
        do {
            xlarcf_swift.smartStage_passStrong(xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_noTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartStage_cppReturn_noTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_noTemporary_swiftPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_swift.smartStage_passWeak(Overlay.TfWeakPtr(xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_noTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartStage_cppReturn_noTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_noTemporary_cppPass_strong_swiftEntry() {
        do {
            xlarcf_cpp.smartStage_passStrong(xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_noTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartStage_cppReturn_noTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_noTemporary_cppPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_cpp.smartStage_passWeak(Overlay.TfWeakPtr(xlarcf_cpp.smartStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartStage_cppReturn_noTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartStage_cppReturn_noTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    
    
    
    // MARK: RawStage
    func test_rawStage_swiftReturn_holdTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            let p = xlarcf_swift.rawStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawStage_passBorrowing(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_holdTemporary_swiftPassConsuming_swiftEntry() {
        do {
            let p = xlarcf_swift.rawStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawStage_passConsuming(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_holdTemporary_cppPass_swiftEntry() {
        do {
            let p = xlarcf_swift.rawStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.rawStage_cppPass(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_holdTemporary_cppPass_cppEntry() {
        do {
            xltest.rawStage_swiftReturn_holdTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_noTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            xlarcf_swift.rawStage_passBorrowing(xlarcf_swift.rawStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_noTemporary_swiftPassConsuming_swiftEntry() {
        do {
            xlarcf_swift.rawStage_passConsuming(xlarcf_swift.rawStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_noTemporary_cppPass_swiftEntry() {
        do {
            xlarcf_cpp.rawStage_cppPass(xlarcf_swift.rawStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_swiftReturn_noTemporary_cppPass_cppEntry() {
        do {
            xltest.rawStage_swiftReturn_noTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_holdTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawStage_passBorrowing(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_holdTemporary_swiftPassConsuming_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawStage_passConsuming(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_holdTemporary_cppPass_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.rawStage_cppPass(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_holdTemporary_cppPass_cppEntry() {
        do {
            xltest.rawStage_cppReturn_holdTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_noTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            xlarcf_swift.rawStage_passBorrowing(xlarcf_cpp.rawStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_noTemporary_swiftPassConsuming_swiftEntry() {
        do {
            xlarcf_swift.rawStage_passConsuming(xlarcf_cpp.rawStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_noTemporary_cppPass_swiftEntry() {
        do {
            xlarcf_cpp.rawStage_cppPass(xlarcf_cpp.rawStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawStage_cppReturn_noTemporary_cppPass_cppEntry() {
        do {
            xltest.rawStage_cppReturn_noTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }

    // MARK: SmartLayer
    func test_smartLayer_swiftReturn_holdTemporary_swiftPass_strong_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            assertOpen("HelloWorld.usda")
            xlarcf_swift.smartLayer_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_holdTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_holdTemporary_swiftPass_weak_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartLayer_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_holdTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_holdTemporary_cppPass_strong_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayer_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_holdTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_holdTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_holdTemporary_cppPass_weak_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayer_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_holdTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_holdTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_swiftPass_strong_swiftEntry() {
        do {
            xlarcf_swift.smartLayer_passStrong(xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_noTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_swiftPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_swift.smartLayer_passWeak(Overlay.TfWeakPtr(xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_noTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_cppPass_strong_swiftEntry() {
        do {
            xlarcf_cpp.smartLayer_passStrong(xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_noTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_cppPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_cpp.smartLayer_passWeak(Overlay.TfWeakPtr(xlarcf_swift.smartLayer_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_swiftReturn_noTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayer_swiftReturn_noTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_holdTemporary_swiftPass_strong_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartLayer_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_holdTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_holdTemporary_swiftPass_strong_swiftEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_holdTemporary_swiftPass_weak_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartLayer_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_holdTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_holdTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_holdTemporary_cppPass_strong_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayer_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_smartLayer_cppReturn_holdTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_holdTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_holdTemporary_cppPass_weak_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayer_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_holdTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_holdTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_swiftPass_strong_swiftEntry() {
        do {
            xlarcf_swift.smartLayer_passStrong(xlarcf_cpp.smartLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_noTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_swiftPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_swift.smartLayer_passWeak(Overlay.TfWeakPtr(xlarcf_cpp.smartLayer_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_noTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_cppPass_strong_swiftEntry() {
        do {
            xlarcf_cpp.smartLayer_passStrong(xlarcf_cpp.smartLayer_return("HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_noTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_cppPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_cpp.smartLayer_passWeak(Overlay.TfWeakPtr(xlarcf_cpp.smartLayer_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayer_cppReturn_noTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayer_cppReturn_noTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    
    
    
    
    // MARK: RawLayer
    func test_rawLayer_swiftReturn_holdTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            let p = xlarcf_swift.rawLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayer_passBorrowing(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayer_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_holdTemporary_swiftPassConsuming_swiftEntry() {
        do {
            let p = xlarcf_swift.rawLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayer_passConsuming(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayer_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_holdTemporary_cppPass_swiftEntry() {
        do {
            let p = xlarcf_swift.rawLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.rawLayer_cppPass(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_holdTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayer_swiftReturn_holdTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_noTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            xlarcf_swift.rawLayer_passBorrowing(xlarcf_swift.rawLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayer_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_noTemporary_swiftPassConsuming_swiftEntry() {
        do {
            xlarcf_swift.rawLayer_passConsuming(xlarcf_swift.rawLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_noTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayer_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_noTemporary_cppPass_swiftEntry() {
        do {
            xlarcf_cpp.rawLayer_cppPass(xlarcf_swift.rawLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_swiftReturn_noTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayer_swiftReturn_noTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_holdTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayer_passBorrowing(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayer_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_holdTemporary_swiftPassConsuming_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayer_passConsuming(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_holdTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayer_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_holdTemporary_cppPass_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawLayer_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.rawLayer_cppPass(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_holdTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayer_cppReturn_holdTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_noTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            xlarcf_swift.rawLayer_passBorrowing(xlarcf_cpp.rawLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_noTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayer_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_noTemporary_swiftPassConsuming_swiftEntry() {
        do {
            xlarcf_swift.rawLayer_passConsuming(xlarcf_cpp.rawLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_noTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayer_cppReturn_noTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_noTemporary_cppPass_swiftEntry() {
        do {
            xlarcf_cpp.rawLayer_cppPass(xlarcf_cpp.rawLayer_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayer_cppReturn_noTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayer_cppReturn_noTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }

    
    // MARK: SmartLayerFromStage
    func test_smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_strong_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            assertOpen("HelloWorld.usda")
            xlarcf_swift.smartLayerFromStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_weak_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_holdTemporary_cppPass_strong_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayerFromStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_holdTemporary_cppPass_weak_swiftEntry() {
        do {
            let p = xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_swiftPass_strong_swiftEntry() {
        do {
            xlarcf_swift.smartLayerFromStage_passStrong(xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_swiftPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_swift.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_cppPass_strong_swiftEntry() {
        do {
            xlarcf_cpp.smartLayerFromStage_passStrong(xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_noTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_cppPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_cpp.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(xlarcf_swift.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_swiftReturn_noTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_swiftReturn_noTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_holdTemporary_swiftPass_strong_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartLayerFromStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_holdTemporary_swiftPass_weak_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_smartLayerFromStage_cppReturn_holdTemporary_cppPass_strong_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayerFromStage_passStrong(p)
        }
        assertClosed("HelloWorld.usda")
    }
    
    func test_smartLayerFromStage_cppReturn_holdTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_holdTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_holdTemporary_cppPass_weak_swiftEntry() {
        do {
            let p = xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(p))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_holdTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_holdTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_swiftPass_strong_swiftEntry() {
        do {
            xlarcf_swift.smartLayerFromStage_passStrong(xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_swiftPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_noTemporary_swiftPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_swiftPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_swift.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_swiftPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_noTemporary_swiftPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_cppPass_strong_swiftEntry() {
        do {
            xlarcf_cpp.smartLayerFromStage_passStrong(xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_cppPass_strong_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_noTemporary_cppPass_strong_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_cppPass_weak_swiftEntry() {
        // This reasonably crashes
//        do {
//            xlarcf_cpp.smartLayerFromStage_passWeak(Overlay.TfWeakPtr(xlarcf_cpp.smartLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))))
//        }
//        assertClosed("HelloWorld.usda")
    }
    func test_smartLayerFromStage_cppReturn_noTemporary_cppPass_weak_cppEntry() {
        do {
            xltest.smartLayerFromStage_cppReturn_noTemporary_cppPass_weak_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    
    
    
    // MARK: RawLayerFromStage
    func test_rawLayerFromStage_swiftReturn_holdTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            let p = xlarcf_swift.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayerFromStage_passBorrowing(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayerFromStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_holdTemporary_swiftPassConsuming_swiftEntry() {
        do {
            let p = xlarcf_swift.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayerFromStage_passConsuming(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayerFromStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_holdTemporary_cppPass_swiftEntry() {
        do {
            let p = xlarcf_swift.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.rawLayerFromStage_cppPass(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_holdTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayerFromStage_swiftReturn_holdTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_noTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            xlarcf_swift.rawLayerFromStage_passBorrowing(xlarcf_swift.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayerFromStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_noTemporary_swiftPassConsuming_swiftEntry() {
        do {
            xlarcf_swift.rawLayerFromStage_passConsuming(xlarcf_swift.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayerFromStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_noTemporary_cppPass_swiftEntry() {
        do {
            xlarcf_cpp.rawLayerFromStage_cppPass(xlarcf_swift.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_swiftReturn_noTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayerFromStage_swiftReturn_noTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_holdTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayerFromStage_passBorrowing(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayerFromStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_holdTemporary_swiftPassConsuming_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_swift.rawLayerFromStage_passConsuming(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayerFromStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_holdTemporary_cppPass_swiftEntry() {
        do {
            let p = xlarcf_cpp.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda"))
            xlarcf_cpp.rawLayerFromStage_cppPass(p)
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_holdTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayerFromStage_cppReturn_holdTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_noTemporary_swiftPassBorrowing_swiftEntry() {
        do {
            xlarcf_swift.rawLayerFromStage_passBorrowing(xlarcf_cpp.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry() {
        do {
            xltest.rawLayerFromStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_noTemporary_swiftPassConsuming_swiftEntry() {
        do {
            xlarcf_swift.rawLayerFromStage_passConsuming(xlarcf_cpp.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry() {
        do {
            xltest.rawLayerFromStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_noTemporary_cppPass_swiftEntry() {
        do {
            xlarcf_cpp.rawLayerFromStage_cppPass(xlarcf_cpp.rawLayerFromStage_return(pathForStage(named: "HelloWorld.usda")))
        }
        assertClosed("HelloWorld.usda")
    }
    func test_rawLayerFromStage_cppReturn_noTemporary_cppPass_cppEntry() {
        do {
            xltest.rawLayerFromStage_cppReturn_noTemporary_cppPass_cppEntry(pathForStage(named: "HelloWorld.usda"))
        }
        assertClosed("HelloWorld.usda")
    }

}



#if canImport(XLangTestingUtil)
fileprivate func setUpFunctionPointers() {
    // Set up the function pointer table in C++, so
    // C++ can call functions on `_xLanguageARC_functions_swift`
    typealias table = _xLanguageARC_functionPointers_swift;
    typealias impl = _xLanguageARC_functions_swift
    
    table.set_smartStage_passStrong {
        impl.smartStage_passStrong($0.pointee)
    }
    table.set_smartStage_passWeak {
        impl.smartStage_passWeak($0.pointee)
    }
    table.set_smartStage_return {
        $1.pointee = impl.smartStage_return($0.pointee)
    }
    table.set_smartLayer_passStrong {
        impl.smartLayer_passStrong($0.pointee)
    }
    table.set_smartLayer_passWeak {
        impl.smartLayer_passWeak($0.pointee)
    }
    table.set_smartLayer_return {
        $1.pointee = impl.smartLayer_return($0.pointee)
    }
    table.set_smartLayerFromStage_passStrong {
        impl.smartLayerFromStage_passStrong($0.pointee)
    }
    table.set_smartLayerFromStage_passWeak {
        impl.smartLayerFromStage_passWeak($0.pointee)
    }
    table.set_smartLayerFromStage_return {
        $1.pointee = impl.smartLayerFromStage_return($0.pointee)
    }
    
    table.set_rawStage_passBorrowing {
        impl.rawStage_passBorrowing($0)
    }
    table.set_rawStage_passConsuming {
        impl.rawStage_passConsuming($0)
    }
    table.set_rawStage_return {
        $1.pointee = impl.rawStage_return($0.pointee)
    }
    table.set_rawLayer_passBorrowing {
        impl.rawLayer_passBorrowing($0)
    }
    table.set_rawLayer_passConsuming {
        impl.rawLayer_passConsuming($0)
    }
    table.set_rawLayer_return {
        $1.pointee = impl.rawLayer_return($0.pointee)
    }
    table.set_rawLayerFromStage_passBorrowing {
        impl.rawLayerFromStage_passBorrowing($0)
    }
    table.set_rawLayerFromStage_passConsuming {
        impl.rawLayerFromStage_passConsuming($0)
    }
    table.set_rawLayerFromStage_return {
        $1.pointee = impl.rawLayerFromStage_return($0.pointee)
    }
}
#endif // #if canImport(XLangTestingUtil)

#endif // #if os(Linux)
