//
//  TfNoticeTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/6/25.
//

import XCTest
import OpenUSD
import Synchronization
#if canImport(XLangTestingUtil)
import XLangTestingUtil
#endif

/*
 Want to test:
    - Each of the six Register functions
    - Casting where supported
    - Both forms of casting
    - Revoking one key
    - Revoking many keys
    - Revoking no keys
    - Non-concurrency of callbacks
    - Type inference for each Register function
    - That Register functions support the protocol
    - That each notice conforms to the protocol
    - Revoking from C++, for all four
    - Promoting C++ keys in C++ and Swift
    - Casting and copying gets the underlying notification data, like objects changed
    - Lifetime of casting and you can't escape the notice caster
 */


// Make thread-safe testing of register callbacks firing as expected easier to write.
fileprivate typealias SendableCounter = Mutex<Int>
fileprivate func +=(lhs: borrowing SendableCounter, rhs: Int) {
    lhs.withLock { $0 += rhs }
}
fileprivate func XCTAssertEqual(_ lhs: borrowing SendableCounter, _ rhs: Int, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs.withLock { $0 }, rhs, file: file, line: line)
}


fileprivate typealias SendableFlag = Mutex<Bool>
extension SendableFlag {
    func set(_ x: Bool) {
        withLock { $0 = x }
    }
}
fileprivate func XCTAssertTrue(_ x: borrowing SendableFlag, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(x.withLock { $0 }, file: file, line: line)
}
fileprivate func XCTAssertFalse(_ x: borrowing SendableFlag, file: StaticString = #file, line: UInt = #line) {
    XCTAssertFalse(x.withLock { $0 }, file: file, line: line)
}

// The use of `nonisolated(unsafe)` variables is a workaround for
// rdar://142563027 ('Capture of non-sendable type in @Sendable closure' warning causes unrelated 'Ambiguous use' error)

#if os(Linux)
#warning("TfNoticeTests disabled on Linux because they rely on Objc blocks")
// rdar://146138311 (Swift closure wrapped in ObjC block wrapped in std::function crashes at runtime on Linux)
#else
final class TfNoticeTests: TemporaryDirectoryHelper {
    func test_RegisterA() {
        let gotNotice = SendableCounter(0)
        pxr.TfNotice.Register(pxr.UsdNotice.StageNotice.self) { notice in
            gotNotice += 1
        }
        XCTAssertEqual(gotNotice, 0)
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        XCTAssertEqual(gotNotice, 0)
        stage.SetStartTimeCode(5)
        XCTAssertEqual(gotNotice, 2) // Incremented by two because UsdNotice.StageNotice is a base class with a subclass that fires
        stage.SetStartTimeCode(2)
        XCTAssertEqual(gotNotice, 4)
        
        func checkGenericCompiles<T: SwiftUsd.TfNoticeProtocol>(t: T.Type = T.self) {
            pxr.TfNotice.Register(t) { n in
                let x: T = n
                print(x)
            }
        }
    }
    
    func test_RegisterB() {
        let gotNotice = SendableCounter(0)
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        
        pxr.TfNotice.Register(stage1) { (notice: pxr.UsdNotice.ObjectsChanged) in
            gotNotice += 1
        }
        
        XCTAssertEqual(gotNotice, 0)
        stage1.SetStartTimeCode(5)
        XCTAssertEqual(gotNotice, 1)
        stage2.SetStartTimeCode(6)
        XCTAssertEqual(gotNotice, 1)
        stage1.SetStartTimeCode(2)
        XCTAssertEqual(gotNotice, 2)
        stage2.SetStartTimeCode(3)
        XCTAssertEqual(gotNotice, 2)
        
        func checkGenericCompiles<T: SwiftUsd.TfNoticeProtocol, S: Overlay._TfWeakBaseProtocol>(t: T.Type = T.self, s: S) where S == S._SelfType {
            pxr.TfNotice.Register(s, t) { n in
                let x: T = n
                print(x)
            }
        }
    }
    
    func test_RegisterC() {
        let gotNotice = SendableCounter(0)
        nonisolated(unsafe) let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        
        pxr.TfNotice.Register(stage1) { (notice: pxr.UsdNotice.ObjectsChanged, sender: pxr.UsdStage) in
            gotNotice += 1
            XCTAssertEqual(stage1, sender)
        }
        
        XCTAssertEqual(gotNotice, 0)
        stage1.SetStartTimeCode(5)
        XCTAssertEqual(gotNotice, 1)
        stage2.SetStartTimeCode(6)
        XCTAssertEqual(gotNotice, 1)
        stage1.SetStartTimeCode(2)
        XCTAssertEqual(gotNotice, 2)
        stage2.SetStartTimeCode(3)
        XCTAssertEqual(gotNotice, 2)
        
        func checkGenericCompiles<T: SwiftUsd.TfNoticeProtocol, S: Overlay._TfWeakBaseProtocol>(t: T.Type = T.self, s: S) where S == S._SelfType {
            pxr.TfNotice.Register(s, t) { (n, notifSender) in
                let x: T = n
                let sender: S = notifSender
                print(x)
                print(sender)
            }
        }
    }
    
    func test_RegisterD() {
        let gotStageContentsChangedNotice = SendableCounter(0)
        let gotObjectsChangedNotice = SendableCounter(0)
        
        pxr.TfNotice.Register(pxr.UsdNotice.StageNotice.self) { baseNotice, caster in
            if let stageContentsChanged = caster(pxr.UsdNotice.StageContentsChanged.self) {
                gotStageContentsChangedNotice += 1
                withExtendedLifetime(stageContentsChanged) {}
            }
            if let objectsChanged = caster(pxr.UsdNotice.ObjectsChanged.self) {
                gotObjectsChangedNotice += 1
                withExtendedLifetime(objectsChanged) {}
            }
        }
        
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        XCTAssertEqual(gotStageContentsChangedNotice, 0)
        XCTAssertEqual(gotObjectsChangedNotice, 0)
        stage.SetStartTimeCode(1)
        XCTAssertEqual(gotStageContentsChangedNotice, 1)
        XCTAssertEqual(gotObjectsChangedNotice, 1)
        stage.SetStartTimeCode(2)
        XCTAssertEqual(gotStageContentsChangedNotice, 2)
        XCTAssertEqual(gotObjectsChangedNotice, 2)
        
        func checkGenericCompiles<T: SwiftUsd.TfNoticeProtocol>(t: T.Type = T.self) {
            pxr.TfNotice.Register(t) { (n, caster) in
                let x: T = n
                withExtendedLifetime(x) {}
                if let y = caster(pxr.UsdNotice.StageNotice.self) {
                    print(y)
                }
                let c: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
                print(c)
            }
        }
    }
    
    func test_RegisterE() {
        let gotStageContentsChangedNotice = SendableCounter(0)
        let gotObjectsChangedNotice = SendableCounter(0)
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        
        pxr.TfNotice.Register(stage1) { (notice: pxr.UsdNotice.StageNotice, caster) in
            if let stageContentsChanged = caster(pxr.UsdNotice.StageContentsChanged.self) {
                gotStageContentsChangedNotice += 1
                withExtendedLifetime(stageContentsChanged) {}
            }
            if let objectsChanged = caster(pxr.UsdNotice.ObjectsChanged.self) {
                gotObjectsChangedNotice += 1
                withExtendedLifetime(objectsChanged) {}
            }
        }
        
        XCTAssertEqual(gotStageContentsChangedNotice, 0)
        XCTAssertEqual(gotObjectsChangedNotice, 0)
        stage1.SetStartTimeCode(1)
        XCTAssertEqual(gotStageContentsChangedNotice, 1)
        XCTAssertEqual(gotObjectsChangedNotice, 1)
        stage2.SetStartTimeCode(2)
        XCTAssertEqual(gotStageContentsChangedNotice, 1)
        XCTAssertEqual(gotObjectsChangedNotice, 1)
        stage1.SetStartTimeCode(3)
        XCTAssertEqual(gotStageContentsChangedNotice, 2)
        XCTAssertEqual(gotObjectsChangedNotice, 2)
        
        func checkGenericCompiles<T: SwiftUsd.TfNoticeProtocol, S: Overlay._TfWeakBaseProtocol>(t: T.Type = T.self, s: S) where S == S._SelfType {
            pxr.TfNotice.Register(s, t) { (n, caster) in
                let x: T = n
                withExtendedLifetime(x) {}
                if let y = caster(pxr.UsdNotice.StageNotice.self) {
                    print(y)
                }
                let c: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
                print(c)
            }
        }
    }
    
    func test_RegisterF() {
        let gotStageContentsChangedNotice = SendableCounter(0)
        let gotObjectsChangedNotice = SendableCounter(0)
        nonisolated(unsafe) let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        
        pxr.TfNotice.Register(stage1) { (notice: pxr.UsdNotice.StageNotice, sender, caster) in
            if let stageContentsChanged = caster(pxr.UsdNotice.StageContentsChanged.self) {
                gotStageContentsChangedNotice += 1
                withExtendedLifetime(stageContentsChanged) {}
            }
            if let objectsChanged = caster(pxr.UsdNotice.ObjectsChanged.self) {
                gotObjectsChangedNotice += 1
                withExtendedLifetime(objectsChanged) {}
            }
            XCTAssertEqual(stage1, sender)
        }
        
        XCTAssertEqual(gotStageContentsChangedNotice, 0)
        XCTAssertEqual(gotObjectsChangedNotice, 0)
        stage1.SetStartTimeCode(1)
        XCTAssertEqual(gotStageContentsChangedNotice, 1)
        XCTAssertEqual(gotObjectsChangedNotice, 1)
        stage2.SetStartTimeCode(2)
        XCTAssertEqual(gotStageContentsChangedNotice, 1)
        XCTAssertEqual(gotObjectsChangedNotice, 1)
        stage1.SetStartTimeCode(3)
        XCTAssertEqual(gotStageContentsChangedNotice, 2)
        XCTAssertEqual(gotObjectsChangedNotice, 2)
        
        func checkGenericCompiles<T: SwiftUsd.TfNoticeProtocol, S: Overlay._TfWeakBaseProtocol>(t: T.Type = T.self, s: S) where S == S._SelfType {
            pxr.TfNotice.Register(s, t) { (n, notifSender, caster) in
                let x: T = n
                withExtendedLifetime(x) {}
                let sender: S = notifSender
                withExtendedLifetime(sender) {}
                if let y = caster(pxr.UsdNotice.StageNotice.self) {
                    print(y)
                }
                let c: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
                print(c)
            }
        }
    }
    
    func test_CastingOne() throws {
        let stageContentsChanged = SendableCounter(0)
        let layerMutingChanged = SendableCounter(0)
        
        pxr.TfNotice.Register(pxr.TfNotice.self) { _, caster in
            if let notice = caster(pxr.UsdNotice.StageContentsChanged.self) {
                stageContentsChanged += 1
                print(notice)
            } else if let notice = caster.cast(to: pxr.UsdNotice.LayerMutingChanged.self) {
                layerMutingChanged += 1
                // Swift 6.1 crashes when printing values of type `pxr.UsdNotice.LayerMutingChanged`, but not other notice types. Not sure why.
                #if compiler(<6.1)
                print(notice)
                #endif
            }
        }
        
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        XCTAssertEqual(stageContentsChanged, 0)
        XCTAssertEqual(layerMutingChanged, 0)
        
        let path = pathForStage(named: "sublayer.usda")
        let sublayer = Overlay.Dereference(pxr.SdfLayer.CreateNew(path, .init()))
        withExtendedLifetime(sublayer) {}
        XCTAssertEqual(stageContentsChanged, 0)
        XCTAssertEqual(layerMutingChanged, 0)
        
        Overlay.Dereference(stage.GetRootLayer()).InsertSubLayerPath(path, 0)
        XCTAssertEqual(stageContentsChanged, 1)
        XCTAssertEqual(layerMutingChanged, 0)
        
        // On v25.02a, stage.MuteLayer(path) doesn't increment stageContentsChanged.
        // On v25.05, it does increment stageContentsChanged. The release notes (https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.05.01/CHANGELOG.md#2505---2025-04-28) mention:
        // > Fixed a regression by reintroducing the behavior of emitting empty ObjectsChanged and StageContentsChanged notices when muting or unmuting empty sublayers. Note that this is in an intermediate state, which will be addressed in a following release.
        // On a future release, maybe stage.MuteLayer(path) won't increment stageContentsChanged
        stage.MuteLayer(path)
        XCTAssertEqual(stageContentsChanged, 2)
        XCTAssertEqual(layerMutingChanged, 1)
        
        stage.SetStartTimeCode(5)
        XCTAssertEqual(stageContentsChanged, 3)
        XCTAssertEqual(layerMutingChanged, 1)
        
        func checkGenericCompiles<T: SwiftUsd.TfNoticeProtocol,
                                  U: SwiftUsd.TfNoticeProtocol,
                                  V: SwiftUsd.TfNoticeProtocol>
        (t: T.Type = T.self, u: U.Type = U.self, v: V.Type = V.self) {
            pxr.TfNotice.Register(t) { _, caster in
                if let tn = caster(t) {
                    print(tn)
                }
                if let un = caster.callAsFunction(u) {
                    print(un)
                }
                if let vn = caster.cast(to: v) {
                    print(vn)
                }
            }
        }
    }
    
    func test_RevokeOneKey() {
        let gotNotice = SendableCounter(0)
        let key = pxr.TfNotice.Register { (_: pxr.UsdNotice.StageContentsChanged) in
            gotNotice += 1
        }
        XCTAssertEqual(gotNotice, 0)
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        XCTAssertEqual(gotNotice, 0)
        stage.SetStartTimeCode(5)
        XCTAssertEqual(gotNotice, 1)
        pxr.TfNotice.Revoke(key)
        XCTAssertEqual(gotNotice, 1)
        stage.SetStartTimeCode(2)
        XCTAssertEqual(gotNotice, 1)
    }
    
    func test_RevokeManyKeys() {
        let aCtr = SendableCounter(0)
        let bCtr = SendableCounter(0)
        
        let aStage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        let bStage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        
        var keys = pxr.TfNotice.SwiftKeys()
        
        keys.push_back(pxr.TfNotice.Register(pxr.UsdNotice.StageContentsChanged.self) { _ in
            aCtr += 1
        })
        keys.push_back(pxr.TfNotice.Register(bStage, pxr.UsdNotice.StageContentsChanged.self) { _ in
            bCtr += 1
        })
        
        XCTAssertEqual(aCtr, 0)
        XCTAssertEqual(bCtr, 0)
        
        aStage.SetStartTimeCode(5)
        XCTAssertEqual(aCtr, 1)
        XCTAssertEqual(bCtr, 0)
        
        bStage.SetStartTimeCode(6)
        XCTAssertEqual(aCtr, 2)
        XCTAssertEqual(bCtr, 1)
                
        pxr.TfNotice.Revoke(&keys)
        XCTAssertTrue(keys.empty())
        
        aStage.SetStartTimeCode(7)
        XCTAssertEqual(aCtr, 2)
        XCTAssertEqual(bCtr, 1)

        bStage.SetStartTimeCode(8)
        XCTAssertEqual(aCtr, 2)
        XCTAssertEqual(bCtr, 1)
    }
    
    func test_RevokeNoKeys() {
        var swiftKeys = pxr.TfNotice.SwiftKeys()
        var cppKeys = pxr.TfNotice.Keys()
        var cppKey = pxr.TfNotice.Key()

        pxr.TfNotice.Revoke(&swiftKeys)
        pxr.TfNotice.Revoke(pxr.TfNotice.SwiftKey())
        pxr.TfNotice.Revoke(&cppKeys)
        pxr.TfNotice.Revoke(&cppKey)
    }
    
    func test_RevokeAndWaitOneKey() {
        let gotNotice = SendableCounter(0)
        let key = pxr.TfNotice.Register { (_: pxr.UsdNotice.StageContentsChanged) in
            gotNotice += 1
        }
        XCTAssertEqual(gotNotice, 0)
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        XCTAssertEqual(gotNotice, 0)
        stage.SetStartTimeCode(5)
        XCTAssertEqual(gotNotice, 1)
        pxr.TfNotice.RevokeAndWait(key)
        XCTAssertEqual(gotNotice, 1)
        stage.SetStartTimeCode(2)
        XCTAssertEqual(gotNotice, 1)
    }
    
    func test_RevokeAndWaitManyKeys() {
        let aCtr = SendableCounter(0)
        let bCtr = SendableCounter(0)
        
        let aStage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        let bStage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        
        var keys = pxr.TfNotice.SwiftKeys()
        
        keys.push_back(pxr.TfNotice.Register(pxr.UsdNotice.StageContentsChanged.self) { _ in
            aCtr += 1
        })
        keys.push_back(pxr.TfNotice.Register(bStage, pxr.UsdNotice.StageContentsChanged.self) { _ in
            bCtr += 1
        })
        
        XCTAssertEqual(aCtr, 0)
        XCTAssertEqual(bCtr, 0)
        
        aStage.SetStartTimeCode(5)
        XCTAssertEqual(aCtr, 1)
        XCTAssertEqual(bCtr, 0)
        
        bStage.SetStartTimeCode(6)
        XCTAssertEqual(aCtr, 2)
        XCTAssertEqual(bCtr, 1)
                
        pxr.TfNotice.RevokeAndWait(&keys)
        XCTAssertTrue(keys.empty())
        
        aStage.SetStartTimeCode(7)
        XCTAssertEqual(aCtr, 2)
        XCTAssertEqual(bCtr, 1)

        bStage.SetStartTimeCode(8)
        XCTAssertEqual(aCtr, 2)
        XCTAssertEqual(bCtr, 1)
    }
    
    func test_RevokeAndWaitNoKeys() {
        var swiftKeys = pxr.TfNotice.SwiftKeys()
        var cppKeys = pxr.TfNotice.Keys()
        var cppKey = pxr.TfNotice.Key()

        pxr.TfNotice.RevokeAndWait(&swiftKeys)
        pxr.TfNotice.RevokeAndWait(pxr.TfNotice.SwiftKey())
        pxr.TfNotice.RevokeAndWait(&cppKeys)
        pxr.TfNotice.RevokeAndWait(&cppKey)
    }
    
    func test_callbacksAreNonConcurrent() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
        
        let isCallbackRunning = SendableFlag(false)
        let counter = SendableCounter(0)
                
        let key = pxr.TfNotice.Register(pxr.UsdNotice.StageContentsChanged.self) { _ in
            XCTAssertFalse(isCallbackRunning)
            isCallbackRunning.set(true)
            XCTAssertTrue(isCallbackRunning)
            
            counter += 1
            Thread.sleep(forTimeInterval: 0.5)
            
            XCTAssertTrue(isCallbackRunning)
            isCallbackRunning.set(false)
            XCTAssertFalse(isCallbackRunning)
        }
        // Stop us from holding up all tests by sleeping for half a second
        defer { pxr.TfNotice.Revoke(key) }
        
        XCTAssertEqual(counter, 0)
        XCTAssertFalse(isCallbackRunning)
        stage.SetStartTimeCode(5)
        XCTAssertFalse(isCallbackRunning)
        XCTAssertEqual(counter, 1)
        
        XCTAssertEqual(counter, 1)
        XCTAssertFalse(isCallbackRunning)
        stage.SetStartTimeCode(6)
        XCTAssertFalse(isCallbackRunning)
        XCTAssertEqual(counter, 2)
    }
        
    func assertConforms<T>(_ x: T.Type = T.self, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(T.self is any SwiftUsd.TfNoticeProtocol.Type, file: file, line: line)
    }
    func test_conformances() {
        assertConforms(pxr.TfDebugSymbolsChangedNotice.self)
        assertConforms(pxr.TfDebugSymbolEnableChangedNotice.self)
        assertConforms(pxr.TfNotice.self)
        assertConforms(pxr.TfTypeWasDeclaredNotice.self)
        assertConforms(pxr.TraceCollectionAvailable.self)
        assertConforms(pxr.PlugNotice.Base.self)
        assertConforms(pxr.PlugNotice.DidRegisterPlugins.self)
        assertConforms(pxr.ArNotice.ResolverNotice.self)
        assertConforms(pxr.ArNotice.ResolverChanged.self)
        assertConforms(pxr.SdfNotice.Base.self)
        assertConforms(pxr.SdfNotice.LayersDidChangeSentPerLayer.self)
        assertConforms(pxr.SdfNotice.LayersDidChange.self)
        assertConforms(pxr.SdfNotice.LayerInfoDidChange.self)
        assertConforms(pxr.SdfNotice.LayerIdentifierDidChange.self)
        assertConforms(pxr.SdfNotice.LayerDidReplaceContent.self)
        assertConforms(pxr.SdfNotice.LayerDidReloadContent.self)
        assertConforms(pxr.SdfNotice.LayerDidSaveLayerToFile.self)
        assertConforms(pxr.SdfNotice.LayerDirtinessChanged.self)
        assertConforms(pxr.SdfNotice.LayerMutenessChanged.self)
        assertConforms(pxr.UsdNotice.StageNotice.self)
        assertConforms(pxr.UsdNotice.StageContentsChanged.self)
        assertConforms(pxr.UsdNotice.ObjectsChanged.self)
        assertConforms(pxr.UsdNotice.StageEditTargetChanged.self)
        assertConforms(pxr.UsdNotice.LayerMutingChanged.self)
    }
    
    func test_noticeCasterCantEscape() {
        func assertNonCopyable<T: ~Copyable>(_ x: T.Type = T.self, file: StaticString = #file, line: UInt = #line) {
            // pass
        }
        func assertNonCopyable<T>(_ x: T.Type = T.self, file: StaticString = #file, line: UInt = #line) {
            XCTFail("\(x) is copyable", file: file, line: line)
        }
        assertNonCopyable(pxr.TfNotice.NoticeCaster.self)
        
        func a<T: SwiftUsd.TfNoticeProtocol>(_ callback: @escaping @Sendable (T, borrowing pxr.TfNotice.NoticeCaster) -> ()) {
            pxr.TfNotice.Register(T.self, callback)
        }
        func b<T: SwiftUsd.TfNoticeProtocol, S: Overlay._TfWeakBaseProtocol>(_ sender: S, _ callback: @escaping @Sendable (T, borrowing pxr.TfNotice.NoticeCaster) -> ()) where S == S._SelfType {
            pxr.TfNotice.Register(sender, T.self, callback)
        }
        func c<T: SwiftUsd.TfNoticeProtocol, S: Overlay._TfWeakBaseProtocol>(_ sender: S, _ callback: @escaping @Sendable (T, S, borrowing pxr.TfNotice.NoticeCaster) -> ()) where S == S._SelfType {
            pxr.TfNotice.Register(sender, T.self, callback)
        }
    }
    
    func test_TypeInference() {
        // A
        pxr.TfNotice.Register(pxr.UsdNotice.StageContentsChanged.self) { notice in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
        }
        pxr.TfNotice.Register { (notice: pxr.UsdNotice.StageContentsChanged) in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
        }
        // B
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        pxr.TfNotice.Register(stage, pxr.UsdNotice.StageContentsChanged.self) { notice in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
        }
        pxr.TfNotice.Register(stage) { (notice: pxr.UsdNotice.StageContentsChanged) in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
        }
        // C
        pxr.TfNotice.Register(stage, pxr.UsdNotice.StageContentsChanged.self) { notice, innerStage in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.UsdStage = innerStage
            print(y)
        }
        pxr.TfNotice.Register(stage) { (notice: pxr.UsdNotice.StageContentsChanged, innerStage) in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.UsdStage = innerStage
            print(y)
        }
        // D
        pxr.TfNotice.Register(pxr.UsdNotice.StageContentsChanged.self) { notice, caster in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
            print(y)
        }
        pxr.TfNotice.Register { (notice: pxr.UsdNotice.StageContentsChanged, caster) in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
            print(y)
        }
        // E
        pxr.TfNotice.Register(stage, pxr.UsdNotice.StageContentsChanged.self) { notice, caster in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
            print(y)
        }
        pxr.TfNotice.Register(stage) { (notice: pxr.UsdNotice.StageContentsChanged, caster) in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
            print(y)
        }
        // F
        pxr.TfNotice.Register(stage, pxr.UsdNotice.StageContentsChanged.self) { notice, innerStage, caster in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.UsdStage = innerStage
            print(y)
            let z: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
            print(z)
        }
        pxr.TfNotice.Register(stage) { (notice: pxr.UsdNotice.StageContentsChanged, innerStage, caster) in
            let x: pxr.UsdNotice.StageContentsChanged = notice
            print(x)
            let y: pxr.UsdStage = innerStage
            print(y)
            let z: pxr.TfNotice.NoticeCaster.Type = type(of: caster)
            print(z)
        }
    }
    
    func test_xlanguage_revocation() {
        XCTAssertTrue(_xLanguage_TfNotice.test_revokeOneCppKeyViaSwiftUsd())
        XCTAssertTrue(_xLanguage_TfNotice.test_revokeManyCppKeyViaSwiftUsd())
        
        do {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
            let callbackCount = SendableCounter(0)
            let key = pxr.TfNotice.Register(stage, pxr.UsdNotice.StageContentsChanged.self) { _ in
                callbackCount += 1
            }
            XCTAssertTrue(_xLanguage_TfNotice.test_revokeOneSwiftKeyViaSwiftUsd(
                stage, key, { callbackCount.withLock { Int32($0) } }
            ))
        }
        
        do {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
            let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
            let callbackCount1 = SendableCounter(0)
            let callbackCount2 = SendableCounter(0)
            let key1 = pxr.TfNotice.Register(stage1, pxr.UsdNotice.StageContentsChanged.self) { _ in
                callbackCount1 += 1
            }
            let key2 = pxr.TfNotice.Register(stage2, pxr.UsdNotice.StageContentsChanged.self) { _ in
                callbackCount2 += 1
            }
            XCTAssertTrue(_xLanguage_TfNotice.test_revokeManySwiftKeyViaSwiftUsd(
                stage1, key1, { callbackCount1.withLock { Int32($0) } },
                stage2, key2, { callbackCount2.withLock { Int32($0) } }
            ))
        }
    }
    
    func test_xlanguage_promotion() {
        XCTAssertTrue(_xLanguage_TfNotice.test_promoteCppKeyInCpp())
        do {
            let p = _xLanguage_TfNotice.test_promoteCppKeyInSwift()
            let cppKey = p.first
            let callbackCount = p.second!
            
            let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory())
            XCTAssertTrue(callbackCount() == 0)
            
            stage.SetStartTimeCode(5)
            XCTAssertTrue(callbackCount() == 1)
            
            stage.SetStartTimeCode(6)
            XCTAssertTrue(callbackCount() == 2)
            
            pxr.TfNotice.Revoke(pxr.TfNotice.SwiftKey(cppKey))
            XCTAssertTrue(callbackCount() == 2)
            
            stage.SetStartTimeCode(7)
            XCTAssertTrue(callbackCount() == 2)
        }
    }
    
    func test_casting_UsdNotice_StageNotice() {
        nonisolated(unsafe) let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        nonisolated(unsafe) let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        
        let stage1Count = SendableCounter(0)
        let stage2Count = SendableCounter(0)
        
        pxr.TfNotice.Register(pxr.TfNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.StageNotice.self) else { return }
            if Overlay.Dereference(notice.GetStage()) == stage1 {
                stage1Count += 1
            } else if Overlay.Dereference(notice.GetStage()) == stage2 {
                stage2Count += 1
            }
        }
        
        XCTAssertEqual(stage1Count, 0)
        XCTAssertEqual(stage2Count, 0)
        
        stage1.SetStartTimeCode(5)
        XCTAssertEqual(stage1Count, 2) // Increment by 2 because UsdNotice.StageNotice has children
        XCTAssertEqual(stage2Count, 0)

        stage2.SetStartTimeCode(6)
        XCTAssertEqual(stage1Count, 2)
        XCTAssertEqual(stage2Count, 2)

        stage1.SetStartTimeCode(7)
        XCTAssertEqual(stage1Count, 4)
        XCTAssertEqual(stage2Count, 2)

        stage2.SetStartTimeCode(8)
        XCTAssertEqual(stage1Count, 4)
        XCTAssertEqual(stage2Count, 4)
    }
    
    func test_casting_UsdNotice_StageContentsChanged() {
        nonisolated(unsafe) let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        nonisolated(unsafe) let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        
        let stage1Count = SendableCounter(0)
        let stage2Count = SendableCounter(0)
        
        pxr.TfNotice.Register(pxr.TfNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.StageContentsChanged.self) else { return }
            if Overlay.Dereference(notice.GetStage()) == stage1 {
                stage1Count += 1
            } else if Overlay.Dereference(notice.GetStage()) == stage2 {
                stage2Count += 1
            }
        }
        
        XCTAssertEqual(stage1Count, 0)
        XCTAssertEqual(stage2Count, 0)
        
        stage1.SetStartTimeCode(5)
        XCTAssertEqual(stage1Count, 1)
        XCTAssertEqual(stage2Count, 0)

        stage2.SetStartTimeCode(6)
        XCTAssertEqual(stage1Count, 1)
        XCTAssertEqual(stage2Count, 1)

        stage1.SetStartTimeCode(7)
        XCTAssertEqual(stage1Count, 2)
        XCTAssertEqual(stage2Count, 1)

        stage2.SetStartTimeCode(8)
        XCTAssertEqual(stage1Count, 2)
        XCTAssertEqual(stage2Count, 2)
    }
    
    func test_casting_UsdNotice_LayerMutingChanged() {
        let stagePath = pathForStage(named: "HelloWorld.usda")
        let layerPath = pathForStage(named: "Sublayer.usda")
        nonisolated(unsafe) let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(stagePath, .LoadAll))
        nonisolated(unsafe) let sublayer = Overlay.Dereference(pxr.SdfLayer.CreateNew(layerPath, .init()))
        Overlay.Dereference(stage.GetRootLayer()).InsertSubLayerPath(layerPath, 0)
        
        var keys = pxr.TfNotice.SwiftKeys()
        
        let baseNoticeCount = SendableCounter(0)
        keys.push_back(pxr.TfNotice.Register(pxr.TfNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.LayerMutingChanged.self) else { return }
            XCTAssertTrue(Overlay.Dereference(notice.GetStage()) == stage)
            baseNoticeCount += 1
            if baseNoticeCount.withLock({ $0 }) % 2 == 1 {
                XCTAssertEqual(notice.GetMutedLayers(), [layerPath])
                XCTAssertEqual(notice.GetUnmutedLayers(), [])
            } else {
                XCTAssertEqual(notice.GetMutedLayers(), [])
                XCTAssertEqual(notice.GetUnmutedLayers(), [layerPath])
            }
        })
        
        let intermediateNoticeCount = SendableCounter(0)
        keys.push_back(pxr.TfNotice.Register(pxr.UsdNotice.StageNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.LayerMutingChanged.self) else { return }
            XCTAssertTrue(Overlay.Dereference(notice.GetStage()) == stage)
            intermediateNoticeCount += 1
            if intermediateNoticeCount.withLock({ $0 }) % 2 == 1 {
                XCTAssertEqual(notice.GetMutedLayers(), [layerPath])
                XCTAssertEqual(notice.GetUnmutedLayers(), [])
            } else {
                XCTAssertEqual(notice.GetMutedLayers(), [])
                XCTAssertEqual(notice.GetUnmutedLayers(), [layerPath])
            }
        })
        
        XCTAssertEqual(baseNoticeCount, 0)
        XCTAssertEqual(intermediateNoticeCount, 0)
        
        stage.MuteLayer(layerPath)
        XCTAssertEqual(baseNoticeCount, 1)
        XCTAssertEqual(intermediateNoticeCount, 1)
        
        stage.UnmuteLayer(layerPath)
        XCTAssertEqual(baseNoticeCount, 2)
        XCTAssertEqual(intermediateNoticeCount, 2)
        
        pxr.TfNotice.Revoke(&keys)
    }
    
    func test_casting_UsdNotice_StageEditTargetChanged() {
        nonisolated(unsafe) let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var keys = pxr.TfNotice.SwiftKeys()
        
        let baseNoticeCount = SendableCounter(0)
        keys.push_back(pxr.TfNotice.Register(pxr.TfNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.StageEditTargetChanged.self) else { return }
            XCTAssertTrue(Overlay.Dereference(notice.GetStage()) == stage)
            baseNoticeCount += 1
        })
        
        let intermediateNoticeCount = SendableCounter(0)
        keys.push_back(pxr.TfNotice.Register(pxr.UsdNotice.StageNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.StageEditTargetChanged.self) else { return }
            XCTAssertTrue(Overlay.Dereference(notice.GetStage()) == stage)
            intermediateNoticeCount += 1
        })

        let rootLayer = stage.GetRootLayer()
        let sessionLayer = stage.GetSessionLayer()
        
        XCTAssertEqual(baseNoticeCount, 0)
        XCTAssertEqual(intermediateNoticeCount, 0)
        
        stage.SetEditTarget(.init(sessionLayer, .init(0, 1)))
        XCTAssertEqual(baseNoticeCount, 1)
        XCTAssertEqual(intermediateNoticeCount, 1)
        
        stage.SetEditTarget(.init(rootLayer, .init(0, 1)))
        XCTAssertEqual(baseNoticeCount, 2)
        XCTAssertEqual(intermediateNoticeCount, 2)
        
        
        Overlay.withUsdEditContext(stage, .init(sessionLayer, .init(0, 1))) {
            XCTAssertEqual(baseNoticeCount, 3)
            XCTAssertEqual(intermediateNoticeCount, 3)
        }
        XCTAssertEqual(baseNoticeCount, 4)
        XCTAssertEqual(intermediateNoticeCount, 4)
        

        pxr.TfNotice.Revoke(&keys)
    }
    
    func test_casting_UsdNotice_ObjectsChanged() {
        nonisolated(unsafe) let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        var keys = pxr.TfNotice.SwiftKeys()
        
        let baseNoticeCount = SendableCounter(0)
        keys.push_back(pxr.TfNotice.Register(pxr.TfNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.ObjectsChanged.self) else { return }
            takeCasted(notice, baseNoticeCount)
        })
        
        let intermediateNoticeCount = SendableCounter(0)
        keys.push_back(pxr.TfNotice.Register(pxr.UsdNotice.StageNotice.self) { _, caster in
            guard let notice = caster(pxr.UsdNotice.ObjectsChanged.self) else { return }
            takeCasted(notice, intermediateNoticeCount)
        })
        
        @Sendable
        func takeCasted(_ notice: pxr.UsdNotice.ObjectsChanged, _ counter: borrowing SendableCounter) {
            counter += 1
            XCTAssertEqual(Overlay.Dereference(notice.GetStage()), stage)
            switch counter.withLock({ $0 }) {
            case 1:
                // Set start time code
                XCTAssertEqual(Array(notice.GetResyncedPaths()), [])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), ["/"])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/"), ["startTimeCode"])
                XCTAssertTrue(notice.HasChangedFields("/"))
                
            case 2:
                // Define /hello Sphere
                XCTAssertEqual(Array(notice.GetResyncedPaths()), ["/hello"])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), [])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello"), ["specifier", "typeName"])
                
            case 3:
                // Define /hello/world Cube
                XCTAssertEqual(Array(notice.GetResyncedPaths()), ["/hello/world"])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), [])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello/world"), ["specifier", "typeName"])
                
            case 4:
                // Define /hello/world/foo Xform
                XCTAssertEqual(Array(notice.GetResyncedPaths()), ["/hello/world/foo"])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), [])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello/world/foo"), ["specifier", "typeName"])
                
            case 5:
                // /hello/world.active = false
                XCTAssertEqual(Array(notice.GetResyncedPaths()), ["/hello/world"])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), [])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello/world"), ["active"])

            case 6:
                // /hello/world.active = true
                XCTAssertEqual(Array(notice.GetResyncedPaths()), ["/hello/world"])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), [])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello/world"), ["active"])
                
            case 7:
                // /hello.radius = 5, part 1
                XCTAssertEqual(Array(notice.GetResyncedPaths()), ["/hello.radius"])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), [])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello.radius"), ["typeName"])
                
            case 8:
                // /hello.radius = 5, part 2
                XCTAssertEqual(Array(notice.GetResyncedPaths()), [])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), ["/hello.radius"])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello.radius"), ["default"])
                
            case 9:
                // /hello.radius[4] = 2
                XCTAssertEqual(Array(notice.GetResyncedPaths()), [])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), ["/hello.radius"])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello.radius"), [])
                
            case 10:
                // /hello.radius[6] = 10
                XCTAssertEqual(Array(notice.GetResyncedPaths()), [])
                XCTAssertEqual(Array(notice.GetChangedInfoOnlyPaths()), ["/hello.radius"])
                XCTAssertEqual(Array(notice.GetResolvedAssetPathsResyncedPaths()), [])
                XCTAssertEqual(notice.GetChangedFields("/hello.radius"), [])
                
            default: XCTFail()
            }
        }
        
        stage.SetStartTimeCode(5)
        XCTAssertEqual(baseNoticeCount, 1)
        XCTAssertEqual(intermediateNoticeCount, 1)
        
        stage.DefinePrim("/hello", .UsdGeomTokens.Sphere)
        XCTAssertEqual(baseNoticeCount, 2)
        XCTAssertEqual(intermediateNoticeCount, 2)
        
        stage.DefinePrim("/hello/world", .UsdGeomTokens.Cube)
        XCTAssertEqual(baseNoticeCount, 3)
        XCTAssertEqual(intermediateNoticeCount, 3)
        
        stage.DefinePrim("/hello/world/foo", .UsdGeomTokens.Xform)
        XCTAssertEqual(baseNoticeCount, 4)
        XCTAssertEqual(intermediateNoticeCount, 4)
        
        let cube = stage.GetPrimAtPath("/hello/world")
        cube.SetActive(false)
        XCTAssertEqual(baseNoticeCount, 5)
        XCTAssertEqual(intermediateNoticeCount, 5)
        
        cube.SetActive(true)
        XCTAssertEqual(baseNoticeCount, 6)
        XCTAssertEqual(intermediateNoticeCount, 6)
        
        let attr = stage.GetAttributeAtPath("/hello.radius")
        attr.Set(5 as Double, .Default()) // This mutation involves a resync for the typeName, then a changedInfo for the default
        XCTAssertEqual(baseNoticeCount, 8) // So, increment by 2
        XCTAssertEqual(intermediateNoticeCount, 8)

        attr.Set(2 as Double, 4)
        XCTAssertEqual(baseNoticeCount, 9)
        XCTAssertEqual(intermediateNoticeCount, 9)

        attr.Set(10 as Double, 6)
        XCTAssertEqual(baseNoticeCount, 10)
        XCTAssertEqual(intermediateNoticeCount, 10)


        
        pxr.TfNotice.Revoke(&keys)
    }
    
    func test_TfNoticeRevoke_returnValue() {
        XCTAssertFalse(pxr.TfNotice.Revoke(pxr.TfNotice.SwiftKey()))
        
        let k = pxr.TfNotice.Register(pxr.UsdNotice.StageContentsChanged.self) { _ in
        }
        XCTAssertTrue(pxr.TfNotice.Revoke(k))
        XCTAssertFalse(pxr.TfNotice.Revoke(k))
    }
    
    func test_TfNotice_multipleStages() {
        let stage1Counter = SendableCounter(0)
        let stage2Counter = SendableCounter(0)
        
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        
        pxr.TfNotice.Register(stage1, pxr.UsdNotice.ObjectsChanged.self) { _ in
            stage1Counter += 1
        }
        
        pxr.TfNotice.Register(stage2, pxr.UsdNotice.ObjectsChanged.self) { _ in
            stage2Counter += 1
        }
        
        XCTAssertEqual(stage1Counter, 0)
        XCTAssertEqual(stage2Counter, 0)
        
        stage1.DefinePrim("/foo", .UsdGeomTokens.Cube)
        
        XCTAssertEqual(stage1Counter, 1)
        XCTAssertEqual(stage2Counter, 0)
        
        stage1.DefinePrim("/foo/bar", .UsdGeomTokens.Cube)
        
        XCTAssertEqual(stage1Counter, 2)
        XCTAssertEqual(stage2Counter, 0)
        
        stage2.DefinePrim("/fizz", .UsdGeomTokens.Cube)
        
        XCTAssertEqual(stage1Counter, 2)
        XCTAssertEqual(stage2Counter, 1)
        
        stage2.DefinePrim("/fizz/buzz", .UsdGeomTokens.Cube)
        
        XCTAssertEqual(stage1Counter, 2)
        XCTAssertEqual(stage2Counter, 2)
        
        stage2.DefinePrim("/fizz/buzz/foobar", .UsdGeomTokens.Cube)
        
        XCTAssertEqual(stage1Counter, 2)
        XCTAssertEqual(stage2Counter, 3)
    }
}
#endif // #if os(Linux)
