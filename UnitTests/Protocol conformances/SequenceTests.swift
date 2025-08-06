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
import Synchronization

final class SequenceTests: TemporaryDirectoryHelper {
    
    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any Sequence.Type)
    }
    
    private func _descriptionForPrim(_ p: pxr.UsdPrim) -> String {
        let stage = Overlay.Dereference(p.GetStage())
        let rootLayerIdentifier = Overlay.Dereference(stage.GetRootLayer()).GetIdentifier()
        let sessionLayerIdentifier = Overlay.Dereference(stage.GetSessionLayer()).GetIdentifier()
        let typeName = p.GetTypeName()
        let interpolatedTypeName = typeName == "" ? " " : "'\(typeName)' "
        let path = p.GetPath()
        return "\(interpolatedTypeName)prim <\(path)> on stage with rootLayer @\(rootLayerIdentifier)@, sessionLayer @\(sessionLayerIdentifier)@"
    }

    private func _descriptionForPrim(_ stage: pxr.UsdStage, _ path: pxr.SdfPath) -> String {
        return _descriptionForPrim(stage.GetPrimAtPath(path))
    }
    
    func test_UsdPrimRangeIteratedSequence_empty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        for (_, _) in stage.Traverse().withIterator() {
            XCTFail()
        }
        assertConforms(Overlay.UsdPrimRangeIteratedSequence.self)
    }

    func test_UsdPrimRangeIteratedSequence_fourPrims() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "Cube")
        stage.DefinePrim("/bar", "Cube")
        stage.DefinePrim("/bar/fizz", "Cube")
        stage.DefinePrim("/bar/buzz", "Cube")
        
        
        var i = 0
        for (_, prim) in stage.Traverse().withIterator() {
            XCTAssertEqual(prim.description, [_descriptionForPrim(stage, "/foo"), _descriptionForPrim(stage, "/bar"), _descriptionForPrim(stage, "/bar/fizz"), _descriptionForPrim(stage, "/bar/buzz")][i])
            i += 1
        }
        XCTAssertEqual(i, 4)
        assertConforms(Overlay.UsdPrimRangeIteratedSequence.self)
    }
    
    func test_UsdPrimRange_empty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        for _ in stage.Traverse() {
            XCTFail()
        }
        assertConforms(pxr.UsdPrimRange.self)
    }

    func test_UsdPrimRange_fourPrims() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "Cube")
        stage.DefinePrim("/bar", "Cube")
        stage.DefinePrim("/bar/fizz", "Cube")
        stage.DefinePrim("/bar/buzz", "Cube")
        
        var i = 0
        for prim in stage.Traverse() {
            XCTAssertEqual(prim.description, [_descriptionForPrim(stage, "/foo"), _descriptionForPrim(stage, "/bar"), _descriptionForPrim(stage, "/bar/fizz"), _descriptionForPrim(stage, "/bar/buzz")][i])
            i += 1
        }
        XCTAssertEqual(i, 4)
        assertConforms(pxr.UsdPrimRange.self)
    }
    
    func test_UsdPrimSiblingRange_empty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let root = stage.DefinePrim("/foo", "Cube")
        for _ in root.GetChildren() {
            XCTFail()
        }
        assertConforms(pxr.UsdPrimSiblingRange.self)
    }

    func test_UsdPrimSiblingRange_fourPrims() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", "Cube")
        stage.DefinePrim("/bar", "Cube")
        stage.DefinePrim("/bar/fizz", "Cube")
        stage.DefinePrim("/bar/buzz", "Cube")
        
        var i = 0
        for prim in stage.GetPrimAtPath("/bar").GetChildren() {
            XCTAssertEqual(prim.description, [_descriptionForPrim(stage, "/bar/fizz"), _descriptionForPrim(stage, "/bar/buzz")][i])
            i += 1
        }
        XCTAssertEqual(i, 2)
        assertConforms(pxr.UsdPrimSiblingRange.self)
    }
    
    func test_SdfNameOrderProxy() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        layer.SetRootPrimOrder(["bar", "foo"])
        
        let x: pxr.SdfNameOrderProxy = layer.GetRootPrimOrder()
        XCTAssertEqual(Array(x), ["bar", "foo"])
        assertConforms(pxr.SdfNameOrderProxy.self)
    }
    func test_SdfListProxyIteratorWrapper_empty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let layer = Overlay.Dereference(stage.GetRootLayer())
        let sublayers: [pxr.SdfAssetPath] = Array(layer.GetSubLayerPaths())
        XCTAssertEqual(sublayers, [])
        assertConforms(pxr.SdfSubLayerProxy.self)
    }
    func test_SdfListProxyIteratorWrapper_nonEmpty() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let stage2 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let layer = Overlay.Dereference(stage.GetRootLayer())
        layer.InsertSubLayerPath(pathForStage(named: "HelloWorld.usda"), -1)
        let sublayers: [pxr.SdfAssetPath] = Array(layer.GetSubLayerPaths())
        XCTAssertEqual(sublayers, [pxr.SdfAssetPath(pathForStage(named: "HelloWorld.usda"))])
        assertConforms(pxr.SdfSubLayerProxy.self)
        withExtendedLifetime(stage2) {}
    }
    func test_SdfAttributeSpecView() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        prim.CreateAttribute("customattr", .Bool, true, .SdfVariabilityVarying)
        
        let layer = Overlay.Dereference(stage.GetRootLayer())
        let primSpec = layer.GetPrimAtPath("/foo").pointee
        let attributes: pxr.SdfAttributeSpecView = primSpec.GetAttributes()
        XCTAssertEqual(Array(attributes), [layer.GetAttributeAtPath("/foo.customattr")])
        assertConforms(pxr.SdfAttributeSpecView.self)
    }
    func test_SdfPrimSpecView() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        stage.DefinePrim("/foo/bar", .UsdGeomTokens.Sphere)
        
        let layer = Overlay.Dereference(stage.GetRootLayer())
        let primSpec = layer.GetPrimAtPath("/foo").pointee
        let children: pxr.SdfPrimSpecView = primSpec.GetNameChildren()
        XCTAssertEqual(Array(children), [layer.GetPrimAtPath("/foo/bar")])
        assertConforms(pxr.SdfPrimSpecView.self)
    }
    func test_SdfPropertySpecView() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        prim.CreateAttribute("customattr", .Bool, true, .SdfVariabilityVarying)

        let layer = Overlay.Dereference(stage.GetRootLayer())
        let primSpec = layer.GetPrimAtPath("/foo").pointee
        let properties: pxr.SdfPropertySpecView = primSpec.GetProperties()
        XCTAssertEqual(Array(properties), [layer.GetPropertyAtPath("/foo.customattr")])
        assertConforms(pxr.SdfPropertySpecView.self)
    }
    func test_SdfRelationalAttributeSpecView() {
        assertConforms(pxr.SdfRelationalAttributeSpecView.self)
    }
    func test_SdfRelationshipSpecView() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/foo", .UsdGeomTokens.Sphere)
        prim.CreateRelationship("myrelationship", true)

        let layer = Overlay.Dereference(stage.GetRootLayer())
        let primSpec = layer.GetPrimAtPath("/foo").pointee
        let relationships = primSpec.GetRelationships()
        XCTAssertEqual(Array(relationships), [layer.GetRelationshipAtPath("/foo.myrelationship")])
        assertConforms(pxr.SdfRelationshipSpecView.self)
    }
    func test_SdfVariantView() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/foo", .UsdGeomTokens.Cube)
        var vsets = prim.GetVariantSets()
        var vset = vsets.AddVariantSet("myvariant", .UsdListPositionBackOfPrependList)
        vset.AddVariant("beta", .UsdListPositionBackOfPrependList)
        vset.AddVariant("alpha", .UsdListPositionBackOfPrependList)
        
        let layer = Overlay.Dereference(stage.GetRootLayer())
        let primSpec = layer.GetPrimAtPath("/foo").pointee
        let vsetsSpec = primSpec.GetVariantSets()
        let variants: pxr.SdfVariantView = vsetsSpec.__findUnsafe("myvariant").pointee.second.pointee.GetVariants()
        
        XCTAssertEqual(Array(variants).map { $0.pointee.GetName() }, ["beta", "alpha"])
        assertConforms(pxr.SdfVariantView.self)
    }
    func test_SdfVariantSetView() {
        assertConforms(pxr.SdfVariantSetView.self)
    }
    
    func test_UsdPrimSubtreeRange() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let bar = main.OverridePrim("/foo/bar")
        
        let x: pxr.UsdPrimSubtreeRange = p.GetAllDescendants()
        XCTAssertEqual(Array(x), [bar])
        assertConforms(pxr.UsdPrimSubtreeRange.self)
    }
    
    func test_SdfPathSet() {
        let x: pxr.SdfPathSet = ["/hello"]
        XCTAssertEqual(Array(x), ["/hello"])
        assertConforms(pxr.SdfPathSet.self)
    }
    
    func test_StringSet() {
        let x: Overlay.String_Set = pxr.SdfLayer.GetMutedLayers()
        for l in x { pxr.SdfLayer.RemoveFromMutedLayers(l) }
        assertConforms(Overlay.String_Set.self)
    }
    
    // MARK: VtArray specializations
    
    func test_VtArray_Bool() {
        let x: pxr.VtBoolArray = [true, false]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtBoolArray.self)
    }
    
    func test_VtArray_Int8() {
        let x: pxr.VtCharArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtCharArray.self)
    }
    func test_VtArray_Double() {
        let x: pxr.VtDoubleArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtDoubleArray.self)
    }
    func test_VtArray_Float() {
        let x: pxr.VtFloatArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtFloatArray.self)
    }
    func test_VtArray_Half() {
        let x: pxr.VtHalfArray = [pxr.GfHalf(3), pxr.GfHalf(1), pxr.GfHalf(4)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtHalfArray.self)
    }
    func test_VtArray_Int32() {
        let x: pxr.VtIntArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtIntArray.self)
    }
    func test_VtArray_Int64() {
        let x: pxr.VtInt64Array = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtInt64Array.self)
    }
    func test_VtArray_Int16() {
        let x: pxr.VtShortArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtShortArray.self)
    }
    func test_VtArray_stdString() {
        let x: pxr.VtStringArray = ["foo", "bar"]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtStringArray.self)
    }
    func test_VtArray_TfToken() {
        let x: pxr.VtTokenArray = ["foo", "bar"]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtTokenArray.self)
    }
    func test_VtArray_UInt8() {
        let x: pxr.VtUCharArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtUCharArray.self)
    }
    func test_VtArray_UInt16() {
        let x: pxr.VtUShortArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtUShortArray.self)
    }
    func test_VtArray_UInt32() {
        let x: pxr.VtUIntArray = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtUIntArray.self)
    }
    func test_VtArray_UInt64() {
        let x: pxr.VtUInt64Array = [3, 1, 4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtUInt64Array.self)
    }
    func test_VtArray_GfMatrix2d() {
        let x: pxr.VtMatrix2dArray = [pxr.GfMatrix2d(1, 2, 3, 4)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtMatrix2dArray.self)
    }
    func test_VtArray_GfMatrix2f() {
        let x: pxr.VtMatrix2fArray = [pxr.GfMatrix2f(1, 2, 3, 4)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtMatrix2fArray.self)
    }
    func test_VtArray_GfMatrix3d() {
        let x: pxr.VtMatrix3dArray = [pxr.GfMatrix3d(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtMatrix3dArray.self)
    }
    func test_VtArray_GfMatrix3f() {
        let x: pxr.VtMatrix3fArray = [pxr.GfMatrix3f(1, 2, 3, 4, 5, 6, 7, 8, 9)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtMatrix3fArray.self)
    }
    func test_VtArray_GfMatrix4d() {
        let x: pxr.VtMatrix4dArray = [pxr.GfMatrix4d(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtMatrix4dArray.self)
    }
    func test_VtArray_GfMatrix4f() {
        let x: pxr.VtMatrix4fArray = [pxr.GfMatrix4f(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtMatrix4fArray.self)
    }
    func test_VtArray_GfQuatd() {
        let x: pxr.VtQuatdArray = [pxr.GfQuatd(3, 1, 4, 1)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtQuatdArray.self)
    }
    func test_VtArray_GfQuaternion() {
        let x: pxr.VtQuaternionArray = [pxr.GfQuaternion(3, pxr.GfVec3d(1, 4, 1))]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtQuaternionArray.self)
    }
    func test_VtArray_GfQuatf() {
        let x: pxr.VtQuatfArray = [pxr.GfQuatf(3, 1, 4, 1)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtQuatfArray.self)
    }
    func test_VtArray_GfQuath() {
        let x: pxr.VtQuathArray = [pxr.GfQuath(3, 1, 4, 1)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtQuathArray.self)
    }
    func test_VtArray_GfVec2d() {
        let x: pxr.VtVec2dArray = [pxr.GfVec2d(1, 2)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec2dArray.self)
    }
    func test_VtArray_GfVec2f() {
        let x: pxr.VtVec2fArray = [pxr.GfVec2f(1, 2)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec2fArray.self)
    }
    func test_VtArray_GfVec2h() {
        let x: pxr.VtVec2hArray = [pxr.GfVec2h(1, 2)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec2hArray.self)
    }
    func test_VtArray_GfVec2i() {
        let x: pxr.VtVec2iArray = [pxr.GfVec2i(1, 2)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec2iArray.self)
    }
    func test_VtArray_GfVec3d() {
        let x: pxr.VtVec3dArray = [pxr.GfVec3d(1, 2, 1)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec3dArray.self)
    }
    func test_VtArray_GfVec3f() {
        let x: pxr.VtVec3fArray = [pxr.GfVec3f(1, 2, 1)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec3fArray.self)
    }
    func test_VtArray_GfVec3h() {
        let x: pxr.VtVec3hArray = [pxr.GfVec3h(pxr.GfHalf(1), 2, 1)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec3hArray.self)
    }
    func test_VtArray_GfVec3i() {
        let x: pxr.VtVec3iArray = [pxr.GfVec3i(1, 2, 1)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec3iArray.self)
    }
    func test_VtArray_GfVec4d() {
        let x: pxr.VtVec4dArray = [pxr.GfVec4d(1, 2, 1, 0)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec4dArray.self)
    }
    func test_VtArray_GfVec4f() {
        let x: pxr.VtVec4fArray = [pxr.GfVec4f(1, 2, 1, 0)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec4fArray.self)
    }
    func test_VtArray_GfVec4h() {
        let x: pxr.VtVec4hArray = [pxr.GfVec4h(1, 2, 1, 0)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec4hArray.self)
    }
    func test_VtArray_GfVec4i() {
        let x: pxr.VtVec4iArray = [pxr.GfVec4i(1, 2, 1, 0)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtVec4iArray.self)
    }
    func test_VtArray_GfInterval() {
        let x: pxr.VtIntervalArray = [pxr.GfInterval(2.718, 3.1415, true, false)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtIntervalArray.self)
    }
    func test_VtArray_GfRange1d() {
        let x: pxr.VtRange1dArray = [pxr.GfRange1d(2.718, 3.1415)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtRange1dArray.self)
    }
    func test_VtArray_GfRange1f() {
        let x: pxr.VtRange1fArray = [pxr.GfRange1f(2.718, 3.1415)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtRange1fArray.self)
    }
    func test_VtArray_GfRange2d() {
        let x: pxr.VtRange2dArray = [pxr.GfRange2d(pxr.GfVec2d(0, 1), pxr.GfVec2d(3, 4))]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtRange2dArray.self)
    }
    func test_VtArray_GfRange2f() {
        let x: pxr.VtRange2fArray = [pxr.GfRange2f(pxr.GfVec2f(0, 1), pxr.GfVec2f(3, 4))]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtRange2fArray.self)
    }
    func test_VtArray_GfRange3d() {
        let x: pxr.VtRange3dArray = [pxr.GfRange3d(pxr.GfVec3d(0, 1, 2), pxr.GfVec3d(3, 4, 5))]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtRange3dArray.self)
    }
    func test_VtArray_GfRange3f() {
        let x: pxr.VtRange3fArray = [pxr.GfRange3f(pxr.GfVec3f(0, 1, 2), pxr.GfVec3f(3, 4, 5))]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtRange3fArray.self)
    }

    func test_VtArray_GfRect2i() {
        let x: pxr.VtRect2iArray = [pxr.GfRect2i(pxr.GfVec2i(1, 2), pxr.GfVec2i(3, 4))]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.VtRect2iArray.self)
    }
    
    func test_VtArray_SdfPath() {
        let x: Overlay.SdfAssetPath_VtArray = [pxr.SdfAssetPath("/foo"), pxr.SdfAssetPath("/bar")]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(Overlay.SdfAssetPath_VtArray.self)
    }
    
    // MARK: std::vector specializations
        
    func test_StringVector() {
        let x: Overlay.String_Vector = ["x", "y"]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(Overlay.String_Vector.self)
    }
    
    func test_Double_Vector() {
        let x: Overlay.Double_Vector = [1.2, 3.4]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(Overlay.String_Vector.self)
    }
    
    func test_TfTokenVector() {
        let x: pxr.TfTokenVector = ["x", "y"]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.TfTokenVector.self)
    }
    
    func test_SdfPathVector() {
        let x: pxr.SdfPathVector = ["/x", "/y"]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.SdfPathVector.self)
    }
    
    func test_SdfLayerOffsetVector() {
        let x: pxr.SdfLayerOffsetVector = [pxr.SdfLayerOffset(0, 1), pxr.SdfLayerOffset(1, 2)]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.SdfLayerOffsetVector.self)
    }
    
    func test_SdfPropertySpecHandleVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Sphere").GetAttribute("radius").Set(5.0, 4.0)
        main.DefinePrim("/bar", "Sphere").GetAttribute("radius").Set(5.0, 4.0)
        
        let x: pxr.SdfPropertySpecHandleVector = [layer.GetPropertyAtPath("/foo.radius"), layer.GetPropertyAtPath("/bar.radius")]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.SdfPropertySpecHandleVector.self)
    }
    
    func test_SdfPrimSpecHandleVector() throws {
        let main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        
        let x: pxr.SdfPrimSpecHandleVector = [layer.GetPrimAtPath("/foo"), layer.GetPrimAtPath("/bar")]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(pxr.SdfPrimSpecHandleVector.self)
    }
    
    func test_UsdAttributeVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        main.DefinePrim("/foo", "Sphere")
        main.DefinePrim("/bar", "Sphere")
        
        let x: Overlay.UsdAttribute_Vector = [main.GetAttributeAtPath("/foo.radius"), main.GetAttributeAtPath("/bar.radius")]
        XCTAssertEqual(Array(x), x.map { $0 })
        assertConforms(Overlay.UsdAttribute_Vector.self)
    }
    
    func test_UsdRelationshipVector() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        main.DefinePrim("/foo", "Sphere").CreateRelationship("myRel", true)
        main.DefinePrim("/bar", "Sphere").CreateRelationship("myRel", true)
        

        //#if !DEBUG
        let x: Overlay.UsdRelationship_Vector = [main.GetRelationshipAtPath("/foo.myRel"), main.GetRelationshipAtPath("/bar.myRel")]
        XCTAssertEqual(Array(x), x.map { $0 })
        //#endif
        assertConforms(Overlay.UsdRelationship_Vector.self)
    }
    
    func test_TfDiagnosticBase_Shared_Ptr_Vector() {
        assertConforms(Overlay.TfDiagnosticBase_Shared_Ptr_Vector.self)
    }
    
    func test_UsdMetadataValueMap() {
        assertConforms(pxr.UsdMetadataValueMap.self)
    }
    
    func test_UsdUtilsTimeCodeRange() {
        // https://github.com/swiftlang/swift/pull/79791 (Runtime crash using `==` on two instances of C++ enum `pxr.HdCamera.Projection`)
        // In Swift 6.1 in debug, the compiler looks up the Equatable conformance of types by their last
        // name component instead of using the fully qualified name. So, pxr.UsdUtilsTimeCodeRange.const_iterator
        // and pxr.HdPrimSceneIndexView.const_iterator are treated as the same type, which causes obscure crashes
        // when trying to use `Array(someUsdUtilsTimeCodeRange)`.
        
        let empty = pxr.UsdUtilsTimeCodeRange()
        XCTAssertTrue(Array(empty).isEmpty)
        let emptyData = try! JSONEncoder().encode(empty)
        let decodedEmpty = try! JSONDecoder().decode(pxr.UsdUtilsTimeCodeRange.self, from: emptyData)
        XCTAssertEqual(empty, decodedEmpty)
        
        let single = pxr.UsdUtilsTimeCodeRange(3.0)
        XCTAssertEqual(Array(single), [3.0])
        let singleData = try! JSONEncoder().encode(single)
        let decodedSingle = try! JSONDecoder().decode(pxr.UsdUtilsTimeCodeRange.self, from: singleData)
        XCTAssertEqual(single, decodedSingle)
        
        let defaultStride = pxr.UsdUtilsTimeCodeRange(3.0, 7)
        #if !DEBUG
        XCTAssertEqual(Array(defaultStride), [3, 4, 5, 6, 7 as pxr.UsdTimeCode])
        #endif // #if !DEBUG
        let defaultStrideData = try! JSONEncoder().encode(defaultStride)
        let decodedDefaultStride = try! JSONDecoder().decode(pxr.UsdUtilsTimeCodeRange.self, from: defaultStrideData)
        XCTAssertEqual(defaultStride, decodedDefaultStride)
        
        let customStride = pxr.UsdUtilsTimeCodeRange(3, 7, 2)
        #if !DEBUG
        XCTAssertEqual(Array(customStride), [3, 5, 7])
        #endif // #if !DEBUG
        let customStrideData = try! JSONEncoder().encode(customStride)
        let decodedCustomStride = try! JSONDecoder().decode(pxr.UsdUtilsTimeCodeRange.self, from: customStrideData)
        XCTAssertEqual(customStride, decodedCustomStride)
        
        assertConforms(pxr.UsdUtilsTimeCodeRange.self)
    }
    
    func test_UsdNotice_ObjectsChanged_PathRange() {
        let counter = SendableCounter(0)
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        
        pxr.TfNotice.Register(stage, pxr.UsdNotice.ObjectsChanged.self) { notice in
            let resynced = notice.GetResyncedPaths()
            if counter == 0 {
                XCTAssertEqual(Array(resynced), ["/foo"])
            } else if counter == 1 {
                XCTAssertEqual(Array(resynced), ["/foo/bar"])
            } else if counter == 2 {
                XCTAssertEqual(Array(resynced), ["/foo/bar.myattr"])
            } else {
                XCTFail()
            }
        }
        
        stage.DefinePrim("/foo", .UsdGeomTokens.Cube)
        counter += 1
        stage.DefinePrim("/foo/bar", .UsdGeomTokens.Sphere)
        counter += 1
        stage.GetPrimAtPath("/foo/bar").CreateAttribute("myattr", .Bool, true, .SdfVariabilityVarying)
        counter += 1
        
        assertConforms(pxr.UsdNotice.ObjectsChanged.PathRange.self)
    }
}

fileprivate typealias SendableCounter = Mutex<Int>
fileprivate func +=(lhs: borrowing SendableCounter, rhs: Int) {
    lhs.withLock { $0 += rhs }
}
fileprivate func ==(lhs: borrowing SendableCounter, rhs: Int) -> Bool {
    lhs.withLock { $0 == rhs }
}
fileprivate func XCTAssertEqual(_ lhs: borrowing SendableCounter, _ rhs: Int, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs.withLock { $0 }, rhs, file: file, line: line)
}
