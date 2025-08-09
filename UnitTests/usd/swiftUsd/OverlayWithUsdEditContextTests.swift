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

final class OverlayWithUsdEditContextTests: TemporaryDirectoryHelper {
    func instanceMethod() {}
    
    func throwingInstanceMethod(shouldThrow: Bool) throws {
        if shouldThrow {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func assertThrows(_ code: () throws -> ()) {
        var threw = false
        do {
            try code()
        } catch {
            threw = true
        }
        if !threw {
            XCTFail("Did not throw")
        }
    }
    
    func assertNoThrows(_ code: () throws -> ()) {
        do {
            try code()
        } catch {
            XCTFail("Threw")
        }
    }
    
    // MARK: Two argument overload
    
    func test_two_nonescaping_compiles_without_self_dot() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            instanceMethod()
        }
        withExtendedLifetime(fooBar) {}
    }
    
    func test_two_rethrowing_compiles() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        do {
            try Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
                try throwingInstanceMethod(shouldThrow: false)
            }
        } catch {
            // pass
        }
        withExtendedLifetime(fooBar) {}
    }
    
    func test_two_rethrowing_rethrows_after_throw() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        assertThrows {
            try Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
                try throwingInstanceMethod(shouldThrow: true)
            }
        }
        withExtendedLifetime(fooBar) {}
    }
    
    func test_two_rethrowing_preserves_changes_before_rethrow() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        try? Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            helloWorld.DefinePrim("/hello", "Cube")
            try throwingInstanceMethod(shouldThrow: true)
            helloWorld.DefinePrim("/there", "Sphere")
        }
        
        helloWorld.Save()
        hiThere.Save()
        fooBar.Save()

        var expectedHelloWorld = (try? contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/9.txt")) ?? ""
        expectedHelloWorld = expectedHelloWorld.replacingOccurrences(of: "${HiThere.usda}", with: String(pathForStage(named: "HiThere.usda")))
        expectedHelloWorld = expectedHelloWorld.replacingOccurrences(of: "${FooBar.usda}", with: String(pathForStage(named: "FooBar.usda")))
        XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), expectedHelloWorld)
        XCTAssertEqual(try contentsOfStage(named: "HiThere.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/10.txt"))
        XCTAssertEqual(try contentsOfStage(named: "FooBar.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/11.txt"))
    }

    func test_two_rethrowing_doesnt_rethrow_after_not_throwing() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        assertNoThrows {
            try Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
                helloWorld.DefinePrim("/hello", "Cube")
                try throwingInstanceMethod(shouldThrow: false)
                helloWorld.DefinePrim("/there", "Sphere")
            }
        }
        withExtendedLifetime(fooBar) {}
    }
    
    func test_two_rethrowing_resets_edit_target_on_throw() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)

        let firstEditTarget = helloWorld.GetEditTarget()
        try? Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            helloWorld.DefinePrim("/hello", "Cube")
            try throwingInstanceMethod(shouldThrow: true)
            helloWorld.DefinePrim("/there", "Sphere")
        }
        XCTAssertEqual(firstEditTarget, helloWorld.GetEditTarget())
        withExtendedLifetime(fooBar) {}
    }
    
    func test_two_edit_target_changed_in_closure() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        let firstEditTarget = helloWorld.GetEditTarget()
        Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            XCTAssertNotEqual(firstEditTarget, helloWorld.GetEditTarget())
        }
        withExtendedLifetime(fooBar) {}
    }
    
    func test_two_edit_target_reset_after_closure_no_manual_set() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        let firstEditTarget = helloWorld.GetEditTarget()
        Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            XCTAssertNotEqual(firstEditTarget, helloWorld.GetEditTarget())
        }
        XCTAssertEqual(firstEditTarget, helloWorld.GetEditTarget())
        withExtendedLifetime(fooBar) {}
    }
    
    func test_two_edit_target_reset_after_closure_yes_manual_set() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        let firstEditTarget = helloWorld.GetEditTarget()
        Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            helloWorld.SetEditTarget(pxr.UsdEditTarget(fooBar.GetRootLayer(), pxr.SdfLayerOffset(0, 1)))
        }
        XCTAssertEqual(firstEditTarget, helloWorld.GetEditTarget())
    }
    
    func test_two_edits_go_to_edit_target() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            helloWorld.DefinePrim("/hello", "Cube")
        }
        
        helloWorld.Save()
        hiThere.Save()
        fooBar.Save()

        var expectedHelloWorld = (try? contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/1.txt")) ?? ""
        expectedHelloWorld = expectedHelloWorld.replacingOccurrences(of: "${HiThere.usda}", with: String(pathForStage(named: "HiThere.usda")))
        expectedHelloWorld = expectedHelloWorld.replacingOccurrences(of: "${FooBar.usda}", with: String(pathForStage(named: "FooBar.usda")))
        XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), expectedHelloWorld)
        XCTAssertEqual(try contentsOfStage(named: "HiThere.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/2.txt"))
        XCTAssertEqual(try contentsOfStage(named: "FooBar.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/3.txt"))
    }
    
    func test_two_nested_withUsdEditContext_works_correctly() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)
        
        Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            helloWorld.DefinePrim("/hello", "Cube")
            Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(fooBar.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
                helloWorld.DefinePrim("/foo", "Sphere")
            }
            helloWorld.DefinePrim("/world", "Cube")
        }
        helloWorld.DefinePrim("/global", "Sphere")
        
        helloWorld.Save()
        hiThere.Save()
        fooBar.Save()

        var expectedHelloWorld = (try? contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/4.txt")) ?? ""
        expectedHelloWorld = expectedHelloWorld.replacingOccurrences(of: "${HiThere.usda}", with: String(pathForStage(named: "HiThere.usda")))
        expectedHelloWorld = expectedHelloWorld.replacingOccurrences(of: "${FooBar.usda}", with: String(pathForStage(named: "FooBar.usda")))
        XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), expectedHelloWorld)
        XCTAssertEqual(try contentsOfStage(named: "HiThere.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/5.txt"))
        XCTAssertEqual(try contentsOfStage(named: "FooBar.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/6.txt"))
    }
    
    func test_two_returnsClosureReturnValue() {
        let helloWorld = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let hiThere = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HiThere.usda"), .LoadAll))
        let fooBar = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "FooBar.usda"), .LoadAll))
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "HiThere.usda"), 0)
        Overlay.Dereference(helloWorld.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "FooBar.usda"), 0)

        let p = Overlay.withUsdEditContext(helloWorld, pxr.UsdEditTarget(hiThere.GetRootLayer(), pxr.SdfLayerOffset(0, 1))) {
            helloWorld.DefinePrim("/hello", "Cube")
        }
        XCTAssertTrue(Bool(p))
        helloWorld.MuteLayer(pathForStage(named: "HiThere.usda"))
        XCTAssertFalse(Bool(p))
        withExtendedLifetime(fooBar) {}
    }
        
    // MARK: One argument overload
    
    func test_one_nonescaping_compiles_without_self_dot() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            instanceMethod()
        }
    }
    
    func test_one_rethrowing_compiles() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        do {
            try Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
                try throwingInstanceMethod(shouldThrow: false)
            }
        } catch {
            // pass
        }
    }

    func test_one_rethrowing_rethrows_after_throw() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        
        assertThrows {
            try Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
                try throwingInstanceMethod(shouldThrow: true)
            }
        }
    }

    func test_one_rethrowing_preserves_changes_before_rethrow() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        let colorAttr = rootPrim.GetAttribute(.UsdGeomTokens.primvarsDisplayColor)
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        try? Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(1, 0, 0)]
            colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
            try throwingInstanceMethod(shouldThrow: true)
            rootPrim.GetAttribute(.UsdGeomTokens.radius).Set(2.718 as Double, .Default())
        }
        stage.DefinePrim("/bar", "Cube")
        stage.Save()
                        
        XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/12.txt"))
    }
    
    func test_one_rethrowing_doesnt_rethrow_after_not_throwing() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        let colorAttr = rootPrim.GetAttribute(.UsdGeomTokens.primvarsDisplayColor)
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        assertNoThrows {
            try Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
                let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(1, 0, 0)]
                colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
                try throwingInstanceMethod(shouldThrow: false)
                rootPrim.GetAttribute(.UsdGeomTokens.radius).Set(2.718 as Double, .Default())
            }
        }
    }
    
    func test_one_rethrowing_resets_edit_target_on_throw() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        let colorAttr = rootPrim.GetAttribute(.UsdGeomTokens.primvarsDisplayColor)
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        let firstEditTarget = stage.GetEditTarget()
        try? Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(1, 0, 0)]
            colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
            try throwingInstanceMethod(shouldThrow: true)
            rootPrim.GetAttribute(.UsdGeomTokens.radius).Set(2.718 as Double, .Default())
        }
        XCTAssertEqual(firstEditTarget, stage.GetEditTarget())
    }
    
    func test_one_edit_target_changed_in_closure() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        let firstEditTarget = stage.GetEditTarget()
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            XCTAssertNotEqual(firstEditTarget, stage.GetEditTarget())
        }
    }
    
    func test_one_edit_target_reset_after_closure_no_manual_set() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        let firstEditTarget = stage.GetEditTarget()
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            XCTAssertNotEqual(firstEditTarget, stage.GetEditTarget())
        }
        XCTAssertEqual(firstEditTarget, stage.GetEditTarget())
    }
    
    func test_one_edit_target_reset_after_closure_yes_manual_set() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        let firstEditTarget = stage.GetEditTarget()
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            stage.SetEditTarget(pxr.UsdEditTarget(stage.GetSessionLayer(), pxr.SdfLayerOffset(0, 1)))
        }
        XCTAssertEqual(firstEditTarget, stage.GetEditTarget())
    }
    
    func test_one_edits_go_to_edit_target() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        let colorAttr = rootPrim.GetAttribute(.UsdGeomTokens.primvarsDisplayColor)
        var vsets = rootPrim.GetVariantSets()
        var vset = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("red", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset.SetVariantSelection("red")
        Overlay.withUsdEditContext(vset.GetVariantEditContext(pxr.SdfLayerHandle())) {
            let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(1, 0, 0)]
            colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
        }
        stage.DefinePrim("/bar", "Cube")
        stage.Save()
        
        XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/7.txt"))
    }
    
    func test_one_nested_withUsdEditContext_works_correctly() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        let colorAttr = rootPrim.GetAttribute(.UsdGeomTokens.primvarsDisplayColor)
        var vsets = rootPrim.GetVariantSets()
        var vset1 = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset1.AddVariant("red", .UsdListPositionBackOfPrependList)
        
        let otherPrim = stage.DefinePrim("/foo/bar", "Cube")
        let otherAttr = otherPrim.GetAttribute(.UsdGeomTokens.primvarsDisplayColor)
        var otherVsets = otherPrim.GetVariantSets()
        var vset2 = otherVsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset2.AddVariant("green", .UsdListPositionBackOfPrependList)

        // Author a color in the "red" variant
        vset1.SetVariantSelection("red")
        Overlay.withUsdEditContext(vset1.GetVariantEditContext(pxr.SdfLayerHandle())) {
            let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(1, 0, 0)]
            colorAttr.Set(colorValue, pxr.UsdTimeCode.Default())
            
            vset2.SetVariantSelection("green")
            Overlay.withUsdEditContext(vset2.GetVariantEditContext(pxr.SdfLayerHandle())) {
                otherAttr.Set([pxr.GfVec3f(0, 1, 0)] as pxr.VtVec3fArray, pxr.UsdTimeCode.Default())
            }
            
            stage.DefinePrim("/foo/conditional", "Cube")
        }
        stage.Save()
        
        XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), try contentsOfResource(subPath: "swiftUsd/OverlayWithUsdEditContext/8.txt"))
    }
    
    func test_one_returnsClosureReturnValue() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let rootPrim = stage.DefinePrim("/foo", "Sphere")
        var vsets = rootPrim.GetVariantSets()
        var vset1 = vsets.AddVariantSet("shadingVariant", .UsdListPositionBackOfPrependList)
        vset1.AddVariant("red", .UsdListPositionBackOfPrependList)
        vset1.AddVariant("green", .UsdListPositionBackOfPrependList)
        
        // Author a color in the "red" variant
        vset1.SetVariantSelection("red")
        let p = Overlay.withUsdEditContext(vset1.GetVariantEditContext(pxr.SdfLayerHandle())) {
            stage.DefinePrim("/foo/bar", "Sphere")
        }

        XCTAssertTrue(Bool(p))
        vset1.SetVariantSelection("green")
        XCTAssertFalse(Bool(p))
    }
}

