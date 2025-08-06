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

fileprivate func _assertEquatableHashableComparable<T>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(T.self is any Equatable.Type, file: file, line: line)
    XCTAssertTrue(T.self is any Hashable.Type, file: file, line: line)
    XCTAssertTrue(T.self is any Comparable.Type, file: file, line: line)
}

fileprivate func _assertConforms_SwiftUsdReferenceTypeProtocol<T>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(T.self is any Overlay._SwiftUsdReferenceTypeProtocol.Type, file: file, line: line)
}
fileprivate func _assertConforms_TfRefBaseProtocol<T>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(T.self is any Overlay._TfRefBaseProtocol.Type, file: file, line: line)
}
fileprivate func _assertConforms_TfWeakBaseProtocol<T>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(T.self is any Overlay._TfWeakBaseProtocol.Type, file: file, line: line)
}
fileprivate func _assertConforms_SwiftUsdImmortalReferenceTypeProtocol<T>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(T.self is any Overlay._SwiftUsdImmortalReferenceTypeProtocol.Type, file: file, line: line)
}

final class FRTProtocolsTests: TemporaryDirectoryHelper {
    func assertSwiftUsdReferenceTypeProtocol<T: Overlay._SwiftUsdReferenceTypeProtocol>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
        _assertEquatableHashableComparable(t, file: file, line: line)
        _assertConforms_SwiftUsdReferenceTypeProtocol(T.self, file: file, line: line)
        XCTAssertTrue(T._SelfType.self == T.self, file: file, line: line)
        let _: (T) -> UnsafeMutableRawPointer = { $0._address }
    }
    
    func assertNotSwiftUsdReferenceTypeProtocol<T>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(T.self is any Overlay._SwiftUsdReferenceTypeProtocol.Type, file: file, line: line)
    }
    
    func assertTfRefBaseProtocol<T: Overlay._TfRefBaseProtocol>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
        // TfRefBase
        assertSwiftUsdReferenceTypeProtocol(t, file: file, line: line)
        _assertConforms_TfRefBaseProtocol(T.self, file: file, line: line)
        XCTAssertTrue(T._TfRefPtrType._TfRefBaseType.self == T.self, file: file, line: line)
        let _: (T) -> T._TfRefPtrType = { $0._asRefPtrType() }
        let _: (T._TfRefPtrType) -> T._SelfType? = T._fromRefPtrType
        let _: (T._TfConstRefPtrType) -> T._SelfType? = T._fromConstRefPtrType
        
        // TfRefPtr
        XCTAssertTrue(T._TfRefPtrType._TfRefBaseType._TfRefPtrType.self == T._TfRefPtrType.self, file: file, line: line)
        let _: () -> T._TfRefPtrType = T._TfRefPtrType._nullPtr
        let _: (T._TfRefPtrType) -> Bool = { $0._isNonnull() }
        
        // TfConstRefPtr
        XCTAssertTrue(T._TfConstRefPtrType._TfRefBaseType.self == T.self, file: file, line: line)
        let _: (T._TfConstRefPtrType) -> Bool = { $0._isNonnull() }
    }
    
    func assertTfWeakBaseProtocol<T: Overlay._TfWeakBaseProtocol>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
        // TfWeakBase
        assertSwiftUsdReferenceTypeProtocol(t, file: file, line: line)
        _assertConforms_TfWeakBaseProtocol(T.self, file: file, line: line)
        XCTAssertTrue(T._TfWeakPtrType._TfWeakBaseType.self == T.self, file: file, line: line)
        let _: (T) -> T._TfWeakPtrType = { $0._asWeakPtrType() }
        let _: (T._TfWeakPtrType) -> T._SelfType? = T._fromWeakPtrType
        let _: (T._TfConstWeakPtrType) -> T._SelfType? = T._fromConstWeakPtrType
        
        // TfWeakPtr
        XCTAssertTrue(T._TfWeakPtrType._TfWeakBaseType._TfWeakPtrType.self == T._TfWeakPtrType.self, file: file, line: line)
        let _: (T._TfWeakPtrType) -> pxr.TfAnyWeakPtr = { $0._asAnyWeakPtr() }
        let _: (pxr.TfAnyWeakPtr) -> T._TfWeakPtrType = T._TfWeakPtrType._fromAnyWeakPtr
        let _: () -> T._TfWeakPtrType = T._TfWeakPtrType._nullPtr
        let _: (T._TfWeakPtrType) -> Bool = { $0._isNonnull() }
        
        // TfConstWeakPtr
        XCTAssertTrue(T._TfConstWeakPtrType._TfWeakBaseType.self == T.self, file: file, line: line)
        let _: (T._TfConstWeakPtrType) -> Bool = { $0._isNonnull() }
    }
    
    func assertNotTfWeakBaseProtocol<T>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(T.self is any Overlay._TfWeakBaseProtocol.Type, file: file, line: line)
    }
    
    func assertImmortalReferenceTypeProtocol<T: Overlay._SwiftUsdImmortalReferenceTypeProtocol>(_ t: T.Type, file: StaticString = #file, line: UInt = #line) {
        assertSwiftUsdReferenceTypeProtocol(t, file: file, line: line)
        _assertConforms_SwiftUsdImmortalReferenceTypeProtocol(t, file: file, line: line)
    }
    
    // MARK: WeakReferenceHolder
    
    func test_WeakReferenceHolder_interface() {
        func inner<T: Overlay._TfWeakBaseProtocol>(_ t: T.Type) where T._SelfType == T {
            _assertEquatableHashableComparable(Overlay.WeakReferenceHolder<T>.self)
            let _: (T?) -> Overlay.WeakReferenceHolder<T> = Overlay.WeakReferenceHolder<T>.init
            let _: (Overlay.WeakReferenceHolder<T>) -> T? = { $0.value }
            let _: (inout Overlay.WeakReferenceHolder<T>) -> () = { $0.value = nil }
        }
        
        inner(pxr.UsdStage.self)
        inner(pxr.SdfLayer.self)
        #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
        inner(pxr.GlfDrawTarget.self)
        #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
        inner(pxr.SdfLayerTree.self)
        inner(pxr.SdfAbstractData.self)
        inner(pxr.PcpLayerStack.self)
    }
    
    func test_WeakReferenceHolder_UsdStage() {
        var weak1 = Overlay.WeakReferenceHolder<pxr.UsdStage>(value: nil)
        var weak2 = weak1
        XCTAssertNil(weak1.value)
        XCTAssertEqual(weak1, weak1)
        XCTAssertEqual(weak1, weak2)
        XCTAssertFalse(weak1 < weak2 || weak2 < weak1)
        XCTAssertEqual(weak1.hashValue, weak2.hashValue)
        do {
            var x: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let y: pxr.UsdStage? = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "2.usda"), .LoadAll))
            
            weak1.value = x
            weak2.value = y
            
            XCTAssertTrue(weak1.value != nil)
            XCTAssertTrue(weak2.value != nil)
            XCTAssertNotEqual(weak1, weak2)
            XCTAssertTrue(weak1 < weak2 || weak2 < weak1)
            XCTAssertNotEqual(weak1.hashValue, weak2.hashValue)
            
            weak2.value = weak1.value
            XCTAssertEqual(weak1, weak2)
            XCTAssertEqual(weak1.value, weak2.value)
            XCTAssertTrue(weak1.value != nil)
            XCTAssertTrue(weak2.value != nil)
            
            weak2 = Overlay.WeakReferenceHolder<pxr.UsdStage>(value: y)
            
            XCTAssertTrue(weak1.value != nil)
            XCTAssertEqual(weak1.value, x)
            assertOpen("HelloWorld.usda")
            x = nil
            assertClosed("HelloWorld.usda")
            XCTAssertNil(weak1.value)
            
            XCTAssertTrue(weak2.value != nil)
            XCTAssertEqual(weak2.value, y)
            assertOpen("2.usda")
        }
        assertClosed("2.usda")
        XCTAssertNil(weak2.value)
    }
    
    // MARK: Pointer conversion functions
    func test_Dereference_interface() {
        func inner1<T: Overlay._TfRefPtrProtocol>(_ t: T.Type) {
            let _: (T) -> T._TfRefBaseType = { Overlay.Dereference($0) }
        }
        func inner2<T: Overlay._TfWeakPtrProtocol>(_ t: T.Type) {
            let _: (T) -> T._TfWeakBaseType = { Overlay.Dereference($0) }
        }
        inner1(pxr.UsdStageRefPtr.self)
        inner2(pxr.UsdStageWeakPtr.self)
    }
    
    func test_Dereference_UsdStage() {
        let x: pxr.UsdStageRefPtr = pxr.UsdStage.CreateInMemory(.LoadAll)
        let y: pxr.UsdStage = Overlay.Dereference(x)
        let z: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(x)
        let w: pxr.UsdStage = Overlay.Dereference(z)
        XCTAssertEqual(y, w)
    }
    
    func test_DereferenceOrNil_interface() {
        func inner1<T: Overlay._TfRefPtrProtocol>(_ t: T.Type) {
            let _: (T) -> T._TfRefBaseType? = { Overlay.DereferenceOrNil($0) }
        }
        func inner2<T: Overlay._TfWeakPtrProtocol>(_ t: T.Type) {
            let _: (T) -> T._TfWeakBaseType? = { Overlay.DereferenceOrNil($0) }
        }
        inner1(pxr.UsdStageRefPtr.self)
        inner2(pxr.UsdStageWeakPtr.self)
    }
    
    func test_DereferenceOrNil_UsdStage() {
        let x: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
        let y: pxr.UsdStage? = Overlay.DereferenceOrNil(x)
        XCTAssertTrue(y != nil)
        let z: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(x)
        let w: pxr.UsdStage? = Overlay.DereferenceOrNil(z)
        XCTAssertTrue(w != nil)
        XCTAssertEqual(y, w)
        let a: pxr.UsdStageRefPtr = pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll)
        let b: pxr.UsdStage? = Overlay.DereferenceOrNil(a)
        XCTAssertNil(b)
    }
    
    func test_TfRefPtr_interface() {
        func inner1<T: Overlay._TfRefBaseProtocol>(_ t: T.Type) {
            let _: (T?) -> T._TfRefPtrType = { Overlay.TfRefPtr($0) }
        }
        func inner2<T: Overlay._TfWeakBaseProtocol & Overlay._TfRefBaseProtocol>(_ t: T.Type) {
            let _: (T._TfWeakPtrType) -> T._TfRefPtrType = { Overlay.TfRefPtr($0) }
        }
        inner1(pxr.UsdStage.self)
        inner2(pxr.UsdStage.self)
    }
    
    func test_TfRefPtr_UsdStage() {
        let x: pxr.UsdStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let y: pxr.UsdStageRefPtr = Overlay.TfRefPtr(x)
        let z: pxr.UsdStageRefPtr = Overlay.TfRefPtr(Overlay.Dereference(y))
        XCTAssertEqual(y, z)
        let w: pxr.UsdStageRefPtr = Overlay.TfRefPtr(nil)
        let _ = Overlay.TfRefPtr(nil as pxr.UsdStage?)
        XCTAssertNil(Overlay.DereferenceOrNil(w))
        XCTAssertNotEqual(w, y)
        XCTAssertNotEqual(w, z)
        
        let a: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(x)
        let b: pxr.UsdStageRefPtr = Overlay.TfRefPtr(a)
        XCTAssertEqual(b, y)
        XCTAssertEqual(Overlay.Dereference(b), x)
        let c: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(nil)
        let d: pxr.UsdStageRefPtr = Overlay.TfRefPtr(c)
        XCTAssertEqual(d, w)
    }
    
     func test_TfWeakPtr_interface() {
         func inner1<T: Overlay._TfWeakBaseProtocol>(_ t: T.Type) {
             let _: (T?) -> T._TfWeakPtrType = { Overlay.TfWeakPtr($0) }
         }
         func inner2<T: Overlay._TfWeakBaseProtocol & Overlay._TfRefBaseProtocol>(_ t: T.Type) {
             let _: (T._TfRefPtrType) -> T._TfWeakPtrType = { Overlay.TfWeakPtr($0) }
         }
         inner1(pxr.UsdStage.self)
         inner2(pxr.UsdStage.self)
     }
     
     func test_TfWeakPtr_UsdStage() {
         let x: pxr.UsdStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
         let y: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(x)
         let z: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(Overlay.Dereference(y))
         XCTAssertEqual(y, z)
         let w: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(nil)
         let _ = Overlay.TfWeakPtr(nil as pxr.UsdStage?)
         XCTAssertNil(Overlay.DereferenceOrNil(w))
         XCTAssertNotEqual(w, y)
         XCTAssertNotEqual(w, z)
     
         let a: pxr.UsdStageRefPtr = Overlay.TfRefPtr(x)
         let b: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(a)
         XCTAssertEqual(b, y)
         XCTAssertEqual(Overlay.Dereference(b), x)
         let c: pxr.UsdStageRefPtr = Overlay.TfRefPtr(nil)
         let d: pxr.UsdStageWeakPtr = Overlay.TfWeakPtr(c)
         XCTAssertEqual(d, w)
     }
    
    func test_equalsEqualsEquals() {
        func inner<T: Overlay._SwiftUsdReferenceTypeProtocol>(_ a: T?, _ b: T?) {
            XCTAssertTrue(a === b)
        }
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        inner(stage, stage)
        XCTAssertTrue(stage === stage)
    }
    
    func test_notEqualsEquals() {
        func inner<T: Overlay._SwiftUsdReferenceTypeProtocol>(_ a: T?, _ b: T?) {
            XCTAssertFalse(a !== b)
        }
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        inner(stage, stage)
        XCTAssertFalse(stage !== stage)
    }
    
    func test_Bool_init() {
        func innerRefTrue<T: Overlay._TfRefPtrProtocol>(_ a: T) {
            XCTAssertTrue(Bool(a))
        }
        func innerRefFalse<T: Overlay._TfRefPtrProtocol>(_ a: T) {
            XCTAssertFalse(Bool(a))
        }
        func innerWeakTrue<T: Overlay._TfWeakPtrProtocol>(_ a: T) {
            XCTAssertTrue(Bool(a))
        }
        func innerWeakFalse<T: Overlay._TfWeakPtrProtocol>(_ a: T) {
            XCTAssertFalse(Bool(a))
        }
        let stagePtr = pxr.UsdStage.CreateInMemory(.LoadAll)
        innerRefTrue(stagePtr)
        XCTAssertTrue(Bool(stagePtr))
        innerRefFalse(Overlay.TfRefPtr(nil as pxr.UsdStage?))
        XCTAssertFalse(Bool(Overlay.TfRefPtr(nil as pxr.UsdStage?)))
        innerWeakTrue(Overlay.Dereference(stagePtr).GetRootLayer())
        XCTAssertTrue(Bool(Overlay.Dereference(stagePtr).GetRootLayer()))
        innerWeakFalse(Overlay.TfWeakPtr(nil as pxr.UsdStage?))
        XCTAssertFalse(Bool(Overlay.TfWeakPtr(nil as pxr.UsdStage?)))
    }
    
    // MARK: Casting
    
    func test_simpleCasting() {
        let x = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let y: pxr.TfRefBase? = x.as(pxr.TfRefBase.self)
        XCTAssertTrue(y != nil)
        XCTAssertTrue(y!._address == x._address)
        let z: pxr.UsdStage? = y!.as(pxr.UsdStage.self)
        XCTAssertTrue(z != nil)
        XCTAssertEqual(x, z)
        
        let a: pxr.SdfLayer? = x.as(pxr.SdfLayer.self)
        let b: pxr.SdfLayer? = y!.as(pxr.SdfLayer.self)
        XCTAssertTrue(a == nil)
        XCTAssertTrue(b == nil)
        
        let c: pxr.SdfLayer = Overlay.Dereference(x.GetRootLayer())
        let d: pxr.SdfLayer? = c.as(pxr.SdfLayer.self)
        XCTAssertEqual(c, d)
        XCTAssertTrue(c.as(pxr.UsdStage.self) == nil)
        XCTAssertTrue(c.as(pxr.TfRefBase.self) != nil)
        XCTAssertTrue(c.as(pxr.TfRefBase.self)?._address == c._address)
    }
        
    func test_existentialCasting() {
        do {
            let x = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            let y: any Overlay._TfRefBaseProtocol = x
            let z: pxr.UsdStage? = y.as(pxr.UsdStage.self)
            XCTAssertEqual(x, z)
        }
        
        do {
            var y: (any Overlay._TfRefBaseProtocol)?
            do {
                let x = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                assertOpen("HelloWorld.usda")
                y = x
            }
            assertOpen("HelloWorld.usda")
            XCTAssert(y != nil)
            y = nil
            assertClosed("HelloWorld.usda")
        }
    }
    
    func test_collectionCasting() {
        do {
            var a = [pxr.TfRefBase?]()
            let x = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
            a.append(x.as(pxr.TfRefBase.self))
            a.append((x as any Overlay._TfRefBaseProtocol).as(pxr.TfRefBase.self))
            XCTAssertTrue(a[0]!._address == x._address)
            XCTAssertTrue(a[1]!._address == x._address)
            let y = Overlay.Dereference(x.GetRootLayer())
            a.append(y.as(pxr.TfRefBase.self))
            a.append((y as any Overlay._TfRefBaseProtocol).as(pxr.TfRefBase.self))
            XCTAssertTrue(a[2]!._address == y._address)
            XCTAssertTrue(a[3]!._address == y._address)
            
            let b: [any Overlay._TfRefBaseProtocol] = [x, x, y, y]
            XCTAssertEqual(a.count, 4)
            XCTAssertEqual(b.count, 4)
            print(b.count)
            
            XCTAssertTrue(a[0] == b[0].as(pxr.TfRefBase.self))
            XCTAssertTrue(a[1] == b[1].as(pxr.TfRefBase.self))
            XCTAssertTrue(a[2] == b[2].as(pxr.TfRefBase.self))
            XCTAssertTrue(a[3] == b[3].as(pxr.TfRefBase.self))
            
            XCTAssertTrue(a[0]?._address == b[0]._address)
            XCTAssertTrue(a[1]?._address == b[1]._address)
            XCTAssertTrue(a[2]?._address == b[2]._address)
            XCTAssertTrue(a[3]?._address == b[3]._address)
            
            XCTAssertTrue(a[0]?.as(pxr.UsdStage.self) == x)
            XCTAssertTrue(a[1]?.as(pxr.UsdStage.self) == x)
            XCTAssertTrue(a[2]?.as(pxr.UsdStage.self) == nil)
            XCTAssertTrue(a[3]?.as(pxr.UsdStage.self) == nil)
            
            XCTAssertTrue(a[0]?.as(pxr.SdfLayer.self) == nil)
            XCTAssertTrue(a[1]?.as(pxr.SdfLayer.self) == nil)
            XCTAssertTrue(a[2]?.as(pxr.SdfLayer.self) == y)
            XCTAssertTrue(a[3]?.as(pxr.SdfLayer.self) == y)
            
            XCTAssertTrue(b[0].as(pxr.UsdStage.self) == x)
            XCTAssertTrue(b[1].as(pxr.UsdStage.self) == x)
            XCTAssertTrue(b[2].as(pxr.UsdStage.self) == nil)
            XCTAssertTrue(b[3].as(pxr.UsdStage.self) == nil)
            
            XCTAssertTrue(b[0].as(pxr.SdfLayer.self) == nil)
            XCTAssertTrue(b[1].as(pxr.SdfLayer.self) == nil)
            XCTAssertTrue(b[2].as(pxr.SdfLayer.self) == y)
            XCTAssertTrue(b[3].as(pxr.SdfLayer.self) == y)
            
            // Workaround for rdar://141177270 (Runtime crash in Release when Swift array of FRTs is deallocated (regression))
            while !a.isEmpty { _ = a.popLast() }
            
            print("Exiting collection casting do block")
        }
        print("After collection casting do block")
    }
    
    func test_TfRefBase_Lifetimes() {
        do {
            var x: pxr.TfRefBase?
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "TfRefBase1.usda"), .LoadAll))
                assertOpen("TfRefBase1.usda")
                x = stage.as(pxr.TfRefBase.self)
            }
            assertOpen("TfRefBase1.usda")
            let stage: pxr.UsdStage? = x!.as(pxr.UsdStage.self)
            stage!.SetStartTimeCode(5)
        }
        assertClosed("TfRefBase1.usda")
        
        do {
            var x: pxr.TfRefBase?
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "TfRefBase2.usda"), .LoadAll))
                assertOpen("TfRefBase2.usda")
                x = stage.as(pxr.TfRefBase.self)
            }
            assertOpen("TfRefBase2.usda")
            var stage: pxr.UsdStage? = x!.as(pxr.UsdStage.self)
            stage!.SetStartTimeCode(5)
            stage = nil
            assertOpen("TfRefBase2.usda")
            x = nil
            assertClosed("TfRefBase2.usda")
        }
    }
    
    func test__TfRefBaseProtocol_Lifetimes() {
        do {
            var x: (any Overlay._TfRefBaseProtocol)?
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Protocol1.usda"), .LoadAll))
                assertOpen("Protocol1.usda")
                x = stage
            }
            assertOpen("Protocol1.usda")
            let stage: pxr.UsdStage? = x?.as(pxr.UsdStage.self)
            stage!.SetStartTimeCode(5)
        }
        assertClosed("Protocol1.usda")
        
        do {
            var x: (any Overlay._TfRefBaseProtocol)?
            do {
                let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Protocol2.usda"), .LoadAll))
                assertOpen("Protocol2.usda")
                x = stage
            }
            assertOpen("Protocol2.usda")
            var stage: pxr.UsdStage? = x?.as(pxr.UsdStage.self)
            stage!.SetStartTimeCode(5)
            stage = nil
            assertOpen("Protocol2.usda")
            x = nil
            assertClosed("Protocol2.usda")
        }
    }
    
    // MARK: FRT conformances
    func test_TfDiagnosticMgr() {
        assertImmortalReferenceTypeProtocol(pxr.TfDiagnosticMgr.self)
        assertTfWeakBaseProtocol(pxr.TfDiagnosticMgr.self)
    }
    func test_TfRefBase() {
        assertTfRefBaseProtocol(pxr.TfRefBase.self)
    }
    func test_TfRefPtrTracker() {
        assertImmortalReferenceTypeProtocol(pxr.TfRefPtrTracker.self)
        assertTfWeakBaseProtocol(pxr.TfRefPtrTracker.self)
    }
    func test_TfRegTest() {
        assertNotSwiftUsdReferenceTypeProtocol(pxr.TfRegTest.self) // TfSingleton but copyable
    }
    func test_TfSimpleRefBase() {
        assertTfRefBaseProtocol(pxr.TfSimpleRefBase.self)
    }
    func test_TraceAggregateTree() {
        assertTfRefBaseProtocol(pxr.TraceAggregateTree.self)
        assertTfWeakBaseProtocol(pxr.TraceAggregateTree.self)
    }
    func test_TraceAggregateNode() {
        assertTfRefBaseProtocol(pxr.TraceAggregateNode.self)
        assertTfWeakBaseProtocol(pxr.TraceAggregateNode.self)
    }
    func test_TraceCategory() {
        assertNotSwiftUsdReferenceTypeProtocol(pxr.TraceCategory.self) // TfSingleton but copyable
    }
    func test_TraceCollector() {
        assertImmortalReferenceTypeProtocol(pxr.TraceCollector.self)
        assertTfWeakBaseProtocol(pxr.TraceCollector.self)
    }
    func test_TraceEventNode() {
        assertTfRefBaseProtocol(pxr.TraceEventNode.self)
    }
    func test_TraceEventTree() {
        assertTfRefBaseProtocol(pxr.TraceEventTree.self)
        assertTfWeakBaseProtocol(pxr.TraceEventTree.self)
    }
    func test_TraceReporter() {
        assertTfRefBaseProtocol(pxr.TraceReporter.self)
        assertTfWeakBaseProtocol(pxr.TraceReporter.self)
    }
    func test_TraceReporterBase() {
        assertTfRefBaseProtocol(pxr.TraceReporterBase.self)
        assertTfWeakBaseProtocol(pxr.TraceReporterBase.self)
    }
    func test_PlugRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.PlugRegistry.self)
        assertTfWeakBaseProtocol(pxr.PlugRegistry.self)
    }
    func test_KindRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.KindRegistry.self)
        assertTfWeakBaseProtocol(pxr.KindRegistry.self)
    }
    func test_SdrRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.SdrRegistry.self)
        assertTfWeakBaseProtocol(pxr.SdrRegistry.self)
    }
    func test_SdfAbstractData() {
        assertTfRefBaseProtocol(pxr.SdfAbstractData.self)
        assertTfWeakBaseProtocol(pxr.SdfAbstractData.self)
    }
    func test_SdfChangeList() {
        assertNotSwiftUsdReferenceTypeProtocol(pxr.SdfChangeList.self) // TfSingleton but copyable
    }
    func test_SdfData() {
        assertTfRefBaseProtocol(pxr.SdfData.self)
        assertTfWeakBaseProtocol(pxr.SdfData.self)
    }
    func test_SdfFileFormat() {
        assertTfRefBaseProtocol(pxr.SdfFileFormat.self)
        assertTfWeakBaseProtocol(pxr.SdfFileFormat.self)
    }
    func test_SdfLayer() {
        assertTfRefBaseProtocol(pxr.SdfLayer.self)
        assertTfWeakBaseProtocol(pxr.SdfLayer.self)
    }
    func test_SdfLayerStateDelegateBase() {
        assertTfRefBaseProtocol(pxr.SdfLayerStateDelegateBase.self)
        assertTfWeakBaseProtocol(pxr.SdfLayerStateDelegateBase.self)
    }
    func test_SdfSimpleLayerStateDelegate() {
        assertTfRefBaseProtocol(pxr.SdfSimpleLayerStateDelegate.self)
        assertTfWeakBaseProtocol(pxr.SdfSimpleLayerStateDelegate.self)
    }
    func test_SdfLayerTree() {
        assertTfRefBaseProtocol(pxr.SdfLayerTree.self)
        assertTfWeakBaseProtocol(pxr.SdfLayerTree.self)
    }
    func test_SdfSchema() {
        assertImmortalReferenceTypeProtocol(pxr.SdfSchema.self)
        assertTfWeakBaseProtocol(pxr.SdfSchema.self)
    }
    func test_SdfTextFileFormat() {
        assertTfRefBaseProtocol(pxr.SdfTextFileFormat.self)
        assertTfWeakBaseProtocol(pxr.SdfTextFileFormat.self)
    }
    func test_PcpLayerStack() {
        assertTfRefBaseProtocol(pxr.PcpLayerStack.self)
        assertTfWeakBaseProtocol(pxr.PcpLayerStack.self)
    }
    func test_UsdSchemaRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.UsdSchemaRegistry.self)
        assertTfWeakBaseProtocol(pxr.UsdSchemaRegistry.self)
    }
    func test_UsdStage() {
        assertTfRefBaseProtocol(pxr.UsdStage.self)
        assertTfWeakBaseProtocol(pxr.UsdStage.self)
    }
    func test_UsdUsdFileFormat() {
        assertTfRefBaseProtocol(pxr.UsdUsdFileFormat.self)
        assertTfWeakBaseProtocol(pxr.UsdUsdFileFormat.self)
    }
    func test_UsdUsdaFileFormat() {
        assertTfRefBaseProtocol(pxr.UsdUsdaFileFormat.self)
        assertTfWeakBaseProtocol(pxr.UsdUsdaFileFormat.self)
    }
    func test_UsdUsdcFileFormat() {
        assertTfRefBaseProtocol(pxr.UsdUsdcFileFormat.self)
        assertTfWeakBaseProtocol(pxr.UsdUsdcFileFormat.self)
    }
    func test_UsdUsdzFileFormat() {
        assertTfRefBaseProtocol(pxr.UsdUsdzFileFormat.self)
        assertTfWeakBaseProtocol(pxr.UsdUsdzFileFormat.self)
    }
    func test_UsdHydraDiscoveryPlugin() {
        assertTfRefBaseProtocol(pxr.UsdHydraDiscoveryPlugin.self)
        assertTfWeakBaseProtocol(pxr.UsdHydraDiscoveryPlugin.self)
    }
#if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    func test_GarchGLPlatformDebugContext() {
        assertTfRefBaseProtocol(pxr.GarchGLPlatformDebugContext.self)
        assertTfWeakBaseProtocol(pxr.GarchGLPlatformDebugContext.self)
    }
    func test_HioImageRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.HioImageRegistry.self)
        assertNotTfWeakBaseProtocol(pxr.HioImageRegistry.self)
    }
    func test_GlfBindingMap() {
        assertTfRefBaseProtocol(pxr.GlfBindingMap.self)
        assertTfWeakBaseProtocol(pxr.GlfBindingMap.self)
    }
    func test_GlfContextCaps() {
        assertImmortalReferenceTypeProtocol(pxr.GlfContextCaps.self)
        assertNotTfWeakBaseProtocol(pxr.GlfContextCaps.self)
    }
    func test_GlfDrawTarget() {
        assertTfRefBaseProtocol(pxr.GlfDrawTarget.self)
        assertTfWeakBaseProtocol(pxr.GlfDrawTarget.self)
    }
    func test_GlfTexture() {
        assertTfRefBaseProtocol(pxr.GlfTexture.self)
        assertTfWeakBaseProtocol(pxr.GlfTexture.self)
    }
    func test_GlfSimpleLightingContext() {
        assertTfRefBaseProtocol(pxr.GlfSimpleLightingContext.self)
        assertTfWeakBaseProtocol(pxr.GlfSimpleLightingContext.self)
    }
    func test_GlfSimpleShadowArray() {
        assertTfRefBaseProtocol(pxr.GlfSimpleShadowArray.self)
        assertTfWeakBaseProtocol(pxr.GlfSimpleShadowArray.self)
    }
    func test_GlfUniformBlock() {
        assertTfRefBaseProtocol(pxr.GlfUniformBlock.self)
        assertTfWeakBaseProtocol(pxr.GlfUniformBlock.self)
    }
    func test_HdSceneIndexBase() {
        assertTfRefBaseProtocol(pxr.HdSceneIndexBase.self)
        assertTfWeakBaseProtocol(pxr.HdSceneIndexBase.self)
    }
    func test_HdMergingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdMergingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdMergingSceneIndex.self)
    }
    func test_HdFilteringSceneIndexBase() {
        assertTfRefBaseProtocol(pxr.HdFilteringSceneIndexBase.self)
        assertTfWeakBaseProtocol(pxr.HdFilteringSceneIndexBase.self)
    }
    func test_HdSingleInputFilteringSceneIndexBase() {
        assertTfRefBaseProtocol(pxr.HdSingleInputFilteringSceneIndexBase.self)
        assertTfWeakBaseProtocol(pxr.HdSingleInputFilteringSceneIndexBase.self)
    }
    func test_HdLegacyPrimSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdLegacyPrimSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdLegacyPrimSceneIndex.self)
    }
    func test_HdRetainedSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdRetainedSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdRetainedSceneIndex.self)
    }
    func test_HdNoticeBatchingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdNoticeBatchingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdNoticeBatchingSceneIndex.self)
    }
    func test_HdDependencyForwardingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdDependencyForwardingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdDependencyForwardingSceneIndex.self)
    }
    func test_HdFlatteningSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdFlatteningSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdFlatteningSceneIndex.self)
    }
    func test_HdLegacyGeomSubsetSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdLegacyGeomSubsetSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdLegacyGeomSubsetSceneIndex.self)
    }
    func test_HdMaterialFilteringSceneIndexBase() {
        assertTfRefBaseProtocol(pxr.HdMaterialFilteringSceneIndexBase.self)
        assertTfWeakBaseProtocol(pxr.HdMaterialFilteringSceneIndexBase.self)
    }
    func test_HdPerfLog() {
        assertImmortalReferenceTypeProtocol(pxr.HdPerfLog.self)
        assertNotTfWeakBaseProtocol(pxr.HdPerfLog.self)
    }
    func test_HdRendererPluginRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.HdRendererPluginRegistry.self)
        assertNotTfWeakBaseProtocol(pxr.HdRendererPluginRegistry.self)
    }
    func test_HdSceneIndexNameRegistry() {
        assertNotSwiftUsdReferenceTypeProtocol(pxr.HdSceneIndexNameRegistry.self) // TfSingleton but copyable
    }
    func test_HdSceneIndexPluginRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.HdSceneIndexPluginRegistry.self)
        assertNotTfWeakBaseProtocol(pxr.HdSceneIndexPluginRegistry.self)
    }
    func test_HdPrefixingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdPrefixingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdPrefixingSceneIndex.self)
    }
    func test_HdGpGenerativeProceduralFilteringSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdGpGenerativeProceduralFilteringSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdGpGenerativeProceduralFilteringSceneIndex.self)
    }
    func test_HdGpGenerativeProceduralPluginRegistry() {
        assertImmortalReferenceTypeProtocol(pxr.HdGpGenerativeProceduralPluginRegistry.self)
        assertNotTfWeakBaseProtocol(pxr.HdGpGenerativeProceduralPluginRegistry.self)
    }
    func test_HdGpGenerativeProceduralResolvingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdGpGenerativeProceduralResolvingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdGpGenerativeProceduralResolvingSceneIndex.self)
    }
    func test_HdsiCoordSysPrimSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiCoordSysPrimSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiCoordSysPrimSceneIndex.self)
    }
    func test_HdsiExtComputationDependencySceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiExtComputationDependencySceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiExtComputationDependencySceneIndex.self)
    }
    func test_HdSiExtComputationPrimvarPruningSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdSiExtComputationPrimvarPruningSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdSiExtComputationPrimvarPruningSceneIndex.self)
    }
    func test_HdsiImplicitSurfaceSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiImplicitSurfaceSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiImplicitSurfaceSceneIndex.self)
    }
    func test_HdsiLegacyDisplayStyleOverrideSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiLegacyDisplayStyleOverrideSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiLegacyDisplayStyleOverrideSceneIndex.self)
    }
    func test_HdsiLightLinkingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiLightLinkingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiLightLinkingSceneIndex.self)
    }
    func test_HdsiMaterialBindingResolvingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiMaterialBindingResolvingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiMaterialBindingResolvingSceneIndex.self)
    }
    func test_HdsiMaterialOverrideResolvingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiMaterialOverrideResolvingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiMaterialOverrideResolvingSceneIndex.self)
    }
    func test_HdsiMaterialPrimvarTransferSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiMaterialPrimvarTransferSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiMaterialPrimvarTransferSceneIndex.self)
    }
    func test_HdsiNurbsApproximatingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiNurbsApproximatingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiNurbsApproximatingSceneIndex.self)
    }
    func test_HdsiPinnedCurveExpandingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiPinnedCurveExpandingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiPinnedCurveExpandingSceneIndex.self)
    }
    func test_HdsiPrimManagingSceneIndexObserver() {
        assertTfRefBaseProtocol(pxr.HdsiPrimManagingSceneIndexObserver.self)
        assertTfWeakBaseProtocol(pxr.HdsiPrimManagingSceneIndexObserver.self)
    }
    func test_HdsiPrimTypeAndPathPruningSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiPrimTypeAndPathPruningSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiPrimTypeAndPathPruningSceneIndex.self)
    }
    func test_HdsiPrimTypeNoticeBatchingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiPrimTypeNoticeBatchingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiPrimTypeNoticeBatchingSceneIndex.self)
    }
    func test_HdsiPrimTypePruningSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiPrimTypePruningSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiPrimTypePruningSceneIndex.self)
    }
    func test_HdsiRenderSettingsFilteringSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiRenderSettingsFilteringSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiRenderSettingsFilteringSceneIndex.self)
    }
    func test_HdsiSceneGlobalsSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiSceneGlobalsSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiSceneGlobalsSceneIndex.self)
    }
    func test_HdsiSwitchingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiSwitchingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiSwitchingSceneIndex.self)
    }
    func test_HdsiTetMeshConversionSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiTetMeshConversionSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiTetMeshConversionSceneIndex.self)
    }
    func test_HdsiVelocityMotionResolvingSceneIndex() {
        assertTfRefBaseProtocol(pxr.HdsiVelocityMotionResolvingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.HdsiVelocityMotionResolvingSceneIndex.self)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
    func test_UsdImagingAdapterRegistry() {
        assertNotSwiftUsdReferenceTypeProtocol(pxr.UsdImagingAdapterRegistry.self) // TfSingleton but copyable
    }
    func test_UsdImagingDrawModeSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingDrawModeSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingDrawModeSceneIndex.self)
    }
    func test_UsdImagingExtentResolvingSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingExtentResolvingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingExtentResolvingSceneIndex.self)
    }
    func test_UsdImagingStageSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingStageSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingStageSceneIndex.self)
    }
    func test_UsdImagingSelectionSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingSelectionSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingSelectionSceneIndex.self)
    }
    func test_UsdImagingMaterialBindingsResolvingSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingMaterialBindingsResolvingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingMaterialBindingsResolvingSceneIndex.self)
    }
    func test_UsdImagingNiPrototypePropagatingSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingNiPrototypePropagatingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingNiPrototypePropagatingSceneIndex.self)
    }
    func test_UsdImagingPiPrototypePropagatingSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingPiPrototypePropagatingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingPiPrototypePropagatingSceneIndex.self)
    }
    func test_UsdImagingRootOverridesSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingRootOverridesSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingRootOverridesSceneIndex.self)
    }
    func test_UsdImagingUnloadedDrawModeSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingUnloadedDrawModeSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingUnloadedDrawModeSceneIndex.self)
    }
    func test_UsdImagingRenderSettingsFlatteningSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingRenderSettingsFlatteningSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingRenderSettingsFlatteningSceneIndex.self)
    }
    func test_UsdImagingRerootingSceneIndex() {
        assertTfRefBaseProtocol(pxr.UsdImagingRerootingSceneIndex.self)
        assertTfWeakBaseProtocol(pxr.UsdImagingRerootingSceneIndex.self)
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)

    // MARK: Immortal FRT usage
    func test_TfDiagnosticMgr_usage() {
        let mgr = pxr.TfDiagnosticMgr.GetInstance()
        XCTAssertTrue(type(of: mgr) == pxr.TfDiagnosticMgr.self)
        mgr.SetQuiet(false)
        mgr.SetQuiet(true)
    }
    
    func test_TfRefPtrTracker_usage() {
        let tracker = pxr.TfRefPtrTracker.GetInstance()
        XCTAssertTrue(type(of: tracker) == pxr.TfRefPtrTracker.self)
        XCTAssertEqual(tracker.GetWatchedCounts().size(), 0)
        XCTAssertEqual(tracker.GetAllTraces().size(), 0)
    }
    
    func test_TraceCollector_usage() {
        let collector = pxr.TraceCollector.GetInstance()
        XCTAssertTrue(type(of: collector) == pxr.TraceCollector.self)
        XCTAssertFalse(pxr.TraceCollector.IsEnabled())
        collector.SetEnabled(true)
        XCTAssertTrue(pxr.TraceCollector.IsEnabled())
        collector.SetEnabled(false)
    }
    
    func test_PlugRegistry_usage() {
        let registry = pxr.PlugRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.PlugRegistry.self)
        let plugins = registry.GetAllPlugins()
        XCTAssertGreaterThan(plugins.size(), 10)
    }
    
    func test_KindRegistry_usage() {
        let registry = pxr.KindRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.KindRegistry.self)
        // No non-static methods, but still test for the singleton instance
        // and a static method (both of which are only available if the
        // type is imported by Swift)
        XCTAssertFalse(pxr.KindRegistry.HasKind("notarealkind"))
    }
    
    func test_SdfSchema_usage() {
        let schema = pxr.SdfSchema.GetInstance()
        XCTAssertTrue(type(of: schema) == pxr.SdfSchema.self)
        // https://github.com/swiftlang/swift/issues/83114 (Inherited methods from non-imported C++ types aren't available on imported types)
//        XCTAssertTrue(schema.IsRegistered("active"))
//        XCTAssertFalse(schema.IsRegistered("notarealfieldkey"))
//        XCTAssertTrue(schema.HoldsChildren("primChildren"))
//        XCTAssertFalse(schema.HoldsChildren("active"))
    }
    
    func test_SdrRegistry_usage() {
        let registry = pxr.SdrRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.SdrRegistry.self)
        let family = registry.GetShaderNodesByFamily("notarealfamily")
        XCTAssertEqual(family.size(), 0)
    }
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    func test_UsdSchemaRegistry_usage() {
        let registry = pxr.UsdSchemaRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.UsdSchemaRegistry.self)
        let type1 = pxr.UsdSchemaRegistry.GetTypeFromName("ModelAPI")
        let type2 = pxr.UsdSchemaRegistry.GetTypeFromName("Sphere")
        XCTAssertFalse(pxr.UsdSchemaRegistry.IsTyped(type1))
        XCTAssertTrue(pxr.UsdSchemaRegistry.IsTyped(type2))
        XCTAssertNil(registry.__FindConcretePrimDefinitionUnsafe("notarealtype"))
    }
    
    func test_HioImageRegistry_usage() {
        let registry = pxr.HioImageRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.HioImageRegistry.self)
        XCTAssertTrue(registry.IsSupportedImageFile("foo.png"))
        XCTAssertFalse(registry.IsSupportedImageFile("foo.notarealimagefile"))
    }
    
    func test_GlfContextCaps_usage() {
        let caps = pxr.GlfContextCaps.GetInstance()
        XCTAssertTrue(type(of: caps) == pxr.GlfContextCaps.self)
        XCTAssertEqual(0, caps.glVersion)
    }
    
    func test_HdPerfLog_usage() {
        let log = pxr.HdPerfLog.GetInstance()
        XCTAssertTrue(type(of: log) == pxr.HdPerfLog.self)
        log.Enable()
        let counter: pxr.TfToken = "frtprotocolstest.counter"
        log.AddCounter(counter, 4)
        XCTAssertEqual(log.GetCounter(counter), 4)
        log.IncrementCounter(counter)
        XCTAssertEqual(log.GetCounter(counter), 5)
        log.IncrementCounter(counter)
        XCTAssertEqual(log.GetCounter(counter), 6)
        log.DecrementCounter(counter)
        XCTAssertEqual(log.GetCounter(counter), 5)
        log.ResetCounters()
        XCTAssertEqual(log.GetCounter(counter), 0)
    }
    
    func test_HdRendererPluginRegistry_usage() {
        let registry = pxr.HdRendererPluginRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.HdRendererPluginRegistry.self)
        XCTAssertEqual(registry.GetDefaultPluginId(), "HdStormRendererPlugin")
    }
    
    func test_HdSceneIndexPluginRegistry_usage() {
        let registry = pxr.HdSceneIndexPluginRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.HdSceneIndexPluginRegistry.self)
        let x: pxr.HdSceneIndexPluginRegistry.InsertionOrder = .InsertionOrderAtStart
        XCTAssertEqual(String(describing: x), "pxr::HdSceneIndexPluginRegistry::InsertionOrderAtStart")
    }
    
    func test_HdGpGenerativeProceduralPluginRegistry_usage() {
        let registry = pxr.HdGpGenerativeProceduralPluginRegistry.GetInstance()
        XCTAssertTrue(type(of: registry) == pxr.HdGpGenerativeProceduralPluginRegistry.self)
        // // https://github.com/swiftlang/swift/issues/83114 (Inherited methods from non-imported C++ types aren't available on imported types)
        // XCTAssertFalse(registry.IsRegisteredPlugin("notarealregisteredplugin"))
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    
    // MARK: Const ptrs
    
    func test_SdfFileFormatConstPtr_temporaries() {
        let usd: pxr.SdfFileFormatConstPtr = pxr.SdfFileFormat.FindByExtension("usd", "")
        let usda = pxr.SdfFileFormat.FindByExtension("usda", "")
        let usdc = pxr.SdfFileFormat.FindByExtension("usdc", "")
        let notarealfileformat = pxr.SdfFileFormat.FindByExtension("notarealfileformat", "")
        XCTAssertTrue(Bool(usd))
        XCTAssertTrue(Bool(usda))
        XCTAssertTrue(Bool(usdc))
        XCTAssertFalse(Bool(notarealfileformat))
        
        XCTAssertTrue(Overlay.DereferenceOrNil(usd) != nil)
        XCTAssertTrue(Overlay.DereferenceOrNil(usda) != nil)
        XCTAssertTrue(Overlay.DereferenceOrNil(usdc) != nil)
        XCTAssertTrue(Overlay.DereferenceOrNil(notarealfileformat) == nil)
        
        let _ = Overlay.Dereference(usd)
        let _ = Overlay.Dereference(usda)
        let _ = Overlay.Dereference(usdc)
        
        XCTAssertFalse(Overlay.Dereference(usd).IsPackage())
        XCTAssertFalse(Overlay.Dereference(usda).IsPackage())
        XCTAssertFalse(Overlay.Dereference(usdc).IsPackage())
    }
    
    func test_SdfFileFormatConstPtr_noTemporaries() {
        XCTAssertTrue(Bool(pxr.SdfFileFormat.FindByExtension("usd", "")))
        XCTAssertTrue(Bool(pxr.SdfFileFormat.FindByExtension("usda", "")))
        XCTAssertTrue(Bool(pxr.SdfFileFormat.FindByExtension("usdc", "")))
        XCTAssertFalse(Bool(pxr.SdfFileFormat.FindByExtension("notarealfileformat", "")))
        
        XCTAssertTrue(Overlay.DereferenceOrNil(pxr.SdfFileFormat.FindByExtension("usd", "")) != nil)
        XCTAssertTrue(Overlay.DereferenceOrNil(pxr.SdfFileFormat.FindByExtension("usda", "")) != nil)
        XCTAssertTrue(Overlay.DereferenceOrNil(pxr.SdfFileFormat.FindByExtension("usdc", "")) != nil)
        XCTAssertTrue(Overlay.DereferenceOrNil(pxr.SdfFileFormat.FindByExtension("notarealfileformat", "")) == nil)
        
        let _ = Overlay.Dereference(pxr.SdfFileFormat.FindByExtension("usd", ""))
        let _ = Overlay.Dereference(pxr.SdfFileFormat.FindByExtension("usda", ""))
        let _ = Overlay.Dereference(pxr.SdfFileFormat.FindByExtension("usdc", ""))
        
        XCTAssertFalse(Overlay.Dereference(pxr.SdfFileFormat.FindByExtension("usd", "")).IsPackage())
        XCTAssertFalse(Overlay.Dereference(pxr.SdfFileFormat.FindByExtension("usda", "")).IsPackage())
        XCTAssertFalse(Overlay.Dereference(pxr.SdfFileFormat.FindByExtension("usdc", "")).IsPackage())
    }
}
