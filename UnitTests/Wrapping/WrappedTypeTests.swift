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

final class WrappedTypeTests: HydraHelper {
    // MARK: UsdPrimTypeInfoWrapper
    func test_UsdPrimTypeInfoWrapper_equalsEquals() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let foo = Overlay.UsdPrimTypeInfoWrapper(stage.DefinePrim("/foo", "Cube"))
        let bar = Overlay.UsdPrimTypeInfoWrapper(stage.DefinePrim("/bar", "Cube"))
        let baz = Overlay.UsdPrimTypeInfoWrapper(stage.DefinePrim("/baz", "Sphere"))

        XCTAssertTrue(foo == bar)
        XCTAssertFalse(foo == baz)
        XCTAssertFalse(bar == baz)
    }
    
    func test_UsdPrimTypeInfoWrapper_notEquals() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let foo = Overlay.UsdPrimTypeInfoWrapper(stage.DefinePrim("/foo", "Cube"))
        let bar = Overlay.UsdPrimTypeInfoWrapper(stage.DefinePrim("/bar", "Cube"))
        let baz = Overlay.UsdPrimTypeInfoWrapper(stage.DefinePrim("/baz", "Sphere"))

        XCTAssertFalse(foo != bar)
        XCTAssertTrue(foo != baz)
        XCTAssertTrue(bar != baz)
    }
    
    func test_UsdPrimTypeInfoWrapper_GetAppliedAPISchemas() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/foo", "Cube")
        var typeInfo = Overlay.UsdPrimTypeInfoWrapper(prim)
        let firstAppliedSchemas = typeInfo.GetAppliedAPISchemas()
        XCTAssertEqual(firstAppliedSchemas, [])
        pxr.UsdPhysicsRigidBodyAPI.Apply(prim)
        typeInfo = Overlay.UsdPrimTypeInfoWrapper(prim)
        let secondAppliedSchemas = typeInfo.GetAppliedAPISchemas()
        XCTAssertEqual(secondAppliedSchemas, [.UsdPhysicsTokens.PhysicsRigidBodyAPI])
    }
    
    func test_UsdPrimTypeInfoWrapper_GetSchemaType() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/foo", "Cube")
        let typeInfo = Overlay.UsdPrimTypeInfoWrapper(prim)
        let schemaType = typeInfo.GetSchemaType()
        XCTAssertTrue(prim.IsA(schemaType))
        XCTAssertEqual(schemaType.GetTypeName(), "UsdGeomCube")
        XCTAssertTrue(schemaType == pxr.TfType.FindByName("UsdGeomCube"))
    }
    
    func test_UsdPrimTypeInfoWrapper_GetTypeName() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let prim = stage.DefinePrim("/foo", "Cube")
        let typeInfo = Overlay.UsdPrimTypeInfoWrapper(prim)
        XCTAssertEqual(typeInfo.GetTypeName(), "Cube")
    }
    
    func test_UsdPrimTypeInfoWrapper_GetEmptyPrimType() {
        let typeInfo = Overlay.UsdPrimTypeInfoWrapper.GetEmptyPrimType()
        XCTAssertEqual(typeInfo.GetSchemaTypeName(), "")
    }
    
    // MARK: HgiWrapper
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    func test_HgiWrapper() {
        let t: Overlay.HgiWrapper.Type = Overlay.HgiWrapper.self
        withExtendedLifetime(t) {}
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT) && canImport(Metal)
    func test_HgiMetalWrapper() {
        let t: Overlay.HgiMetalWrapper.Type = Overlay.HgiMetalWrapper.self
        withExtendedLifetime(t) {}
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT) && canImport(Metal)
    
    #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
    func test_UsdImagingGLEngineWrapper() {
        let t: Overlay.UsdImagingGLEngineWrapper.Type = Overlay.UsdImagingGLEngineWrapper.self
        withExtendedLifetime(t) {}
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_USD_IMAGING_SUPPORT)
    
    // MARK: HioImageWrapper
    
    #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    func test_HioImageWrapper() {
        let t: Overlay.HioImageWrapper.Type = Overlay.HioImageWrapper.self
        withExtendedLifetime(t) {}
    }
    
    func test_HioImageWrapper_IsSupportedImageFile() {
        let x: (std.string) -> Bool = Overlay.HioImageWrapper.IsSupportedImageFile
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_OpenForReading() {
        let x: (std.string, Int32, Int32, Overlay.HioImageWrapper.SourceColorSpace, Bool) -> Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForReading
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_Read() {
        // Since Read is a non-const method, we can't store it in a variable. Instead, make a closure we don't execute,
        // just to check that it exists at compile time
        let x = {
            var wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForReading("", 0, 0, Overlay.HioImageWrapper.Raw, false)
            wrapper.Read(Overlay.HioImageWrapper.StorageSpec())
            
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_ReadCropped() {
        let x = {
            var wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForReading("", 0, 0, Overlay.HioImageWrapper.Raw, false)
            wrapper.ReadCropped(0, 0, 0, 0, Overlay.HioImageWrapper.StorageSpec())
            
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_OpenForWriting() {
        let x: (std.string) -> Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_Write() {
        let x = {
            var wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            wrapper.Write(Overlay.HioImageWrapper.StorageSpec(), pxr.VtDictionary())
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetFilename() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let y: std.string = wrapper.GetFilename()
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetWidth() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let y: Int32 = wrapper.GetWidth()
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetHeight() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let y: Int32 = wrapper.GetHeight()
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetFormat() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let y: pxr.HioFormat = wrapper.GetFormat()
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetBytesPerPixel() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let y: Int32 = wrapper.GetBytesPerPixel()
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetNumMipLevels() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let y: Int32 = wrapper.GetNumMipLevels()
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_IsColorSpaceSRGB () {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let y: Bool = wrapper.IsColorSpaceSRGB()
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetMetadata_Templated() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            var v1: Bool = false
            let _: Bool = wrapper.GetMetadata("" as pxr.TfToken, &v1)
            var v2: Double = 0.0
            let _: Bool = wrapper.GetMetadata("" as pxr.TfToken, &v2)
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetMetadata_VtValue() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            var v1: pxr.VtValue = pxr.VtValue()
            let _: Bool = wrapper.GetMetadata("" as pxr.TfToken, &v1)
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_GetSamplerMetadata() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            var addressMode: pxr.HioAddressMode = .HioAddressModeRepeat
            let y: Bool = wrapper.GetSamplerMetadata(Overlay.HioAddressDimensionU, &addressMode)
            withExtendedLifetime(y) {}
        }
        withExtendedLifetime(x) {}
    }
    
    func test_HioImageWrapper_BoolInit() {
        let x = {
            let wrapper: Overlay.HioImageWrapper = Overlay.HioImageWrapper.OpenForWriting("")
            let valid: Bool = Bool(wrapper)
            withExtendedLifetime(valid) {}
        }
        withExtendedLifetime(x) {}
    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_IMAGING_SUPPORT)
    
    // MARK: UsdZipFileWriterWrapper
    // UsdZipFileWriter was removed after support for movable non-copyable C++ types were
    // added. We might as well keep the tests around, since they might catch a regression
    // in OpenUSD or Swift-Cxx interop
    
    func assertExists(_ path: std.string, _ exists: Bool) {
        XCTAssertEqual(FileManager.default.fileExists(atPath: String(path)), exists)
    }
    
    func test_UsdZipFileWriterWrapper_Save() {
        
        var writer = pxr.UsdZipFileWriter.CreateNew(pathForStage(named: "HelloWorld.usdz"))
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
        
        let modelStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), .LoadAll))
        modelStage.DefinePrim("/mymodel", "Sphere")
        modelStage.Save()
        
        let colorStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Color.usda"), .LoadAll))
        Overlay.Dereference(colorStage.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        let sphere = pxr.UsdGeomSphere.Get(Overlay.TfWeakPtr(colorStage), "/mymodel")
        let displayColorAttr = sphere.GetDisplayColorAttr()
        displayColorAttr.Set([pxr.GfVec3f(1, 0, 1)] as pxr.VtVec3fArray, .Default())
        colorStage.Save()
        
        writer.AddFile(pathForStage(named: "Color.usda"), "First.usda")
        writer.AddFile(pathForStage(named: "Model.usda"), "Second.usda")
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
        writer.Save()
        assertExists(pathForStage(named: "HelloWorld.usdz"), true)
        
        let openedUsdz = Overlay.Dereference(pxr.UsdStage.Open(pathForStage(named: "HelloWorld.usdz"), .LoadAll))
        var readDisplayColor = pxr.VtVec3fArray()
        pxr.UsdGeomSphere.Get(Overlay.TfWeakPtr(openedUsdz), "/mymodel").GetDisplayColorAttr().Get(&readDisplayColor, .Default())
        XCTAssertEqual(readDisplayColor, [pxr.GfVec3f(1, 0, 1)])
    }
    
    func test_UsdZipFileWriterWrapper_Discard() {
        
        var writer = pxr.UsdZipFileWriter.CreateNew(pathForStage(named: "HelloWorld.usdz"))
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
        
        let modelStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Model.usda"), .LoadAll))
        modelStage.DefinePrim("/mymodel", "Sphere")
        modelStage.Save()
        
        let colorStage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Color.usda"), Overlay.UsdStage.LoadAll))
        Overlay.Dereference(colorStage.GetRootLayer()).InsertSubLayerPath(pathForStage(named: "Model.usda"), 0)
        let sphere = pxr.UsdGeomSphere.Get(Overlay.TfWeakPtr(colorStage), "/mymodel")
        let displayColorAttr = sphere.GetDisplayColorAttr()
        displayColorAttr.Set([pxr.GfVec3f(1, 0, 1)] as pxr.VtVec3fArray, .Default())
        colorStage.Save()
        
        writer.AddFile(pathForStage(named: "Color.usda"), "First.usda")
        writer.AddFile(pathForStage(named: "Model.usda"), "Second.usda")
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
        writer.Discard()
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
    }
    
    // MARK: TfErrorMarkWrapper
    
    func test_TfErrorMarkWrapper_Noncopyable() {
        func assertNonCopyable<T: ~Copyable>(_ x: T.Type = T.self) {
            // pass
        }
        func assertNonCopyable<T>(_ x: T.Type = T.self) {
            if x != Int.self {
                XCTFail("TfErrorMarkWrapper is Copyable but shouldn't be")
            }
        }
        struct NC: ~Copyable {}
        assertNonCopyable(NC.self)
        assertNonCopyable(Int.self)
        assertNonCopyable(Overlay.TfErrorMarkWrapper.self)
    }
    
    func test_TfErrorMarkWrapper_SetMark_1() {
        Overlay.withTfErrorMark {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            $0.SetMark()
            XCTAssertNil(stage2)
            XCTAssertTrue($0.IsClean())
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
        }
    }
    
    func test_TfErrorMarkWrapper_SetMark_2() {
        Overlay.withTfErrorMark {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            $0.SetMark()
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertNil(stage2)
            XCTAssertFalse($0.IsClean())
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
        }
    }
    
    func test_TfErrorMarkWrapper_SetMark_3() {
        Overlay.withTfErrorMark { (mark: borrowing Overlay.TfErrorMarkWrapper) in
            mark.SetMark()
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage3 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertEqual(Array(mark.errors).count, 2)
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
            withExtendedLifetime(stage3) {}
        }
    }
    
    func test_TfErrorMarkWrapper_SetMark_4() {
        Overlay.withTfErrorMark { (mark: borrowing Overlay.TfErrorMarkWrapper) in
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            mark.SetMark()
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage3 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertEqual(Array(mark.errors).count, 2)
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
            withExtendedLifetime(stage3) {}
        }
    }
    
    func test_TfErrorMarkWrapper_SetMark_5() {
        Overlay.withTfErrorMark { (mark: borrowing Overlay.TfErrorMarkWrapper) in
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            mark.SetMark()
            let stage3 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertEqual(Array(mark.errors).count, 1)
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
            withExtendedLifetime(stage3) {}
        }
    }
    
    func test_TfErrorMarkWrapper_SetMark_6() {
        Overlay.withTfErrorMark { (mark: borrowing Overlay.TfErrorMarkWrapper) in
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage3 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            mark.SetMark()
            XCTAssertEqual(Array(mark.errors).count, 0)
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
            withExtendedLifetime(stage3) {}
        }
    }
    
    func test_TfErrorMarkWrapper_CreateStageNoError_IsClean() {
        Overlay.withTfErrorMark {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertTrue($0.IsClean())
            withExtendedLifetime(stage) {}
        }
    }
    
    func test_TfErrorMarkWrapper_CreateStageError_IsClean() {
        Overlay.withTfErrorMark {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertNil(stage2)
            XCTAssertFalse($0.IsClean())
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
        }
    }
                           
    func test_TfErrorMarkWrapper_CreateStageErrorBefore_IsClean() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        XCTAssertNil(stage2)
        Overlay.withTfErrorMark {
            XCTAssertTrue($0.IsClean())
        }
        withExtendedLifetime(stage1) {}
        withExtendedLifetime(stage2) {}
    }
    
    func test_TfErrorMarkWrapper_Clear() {
        Overlay.withTfErrorMark {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            XCTAssertFalse($0.IsClean())
            $0.Clear()
            XCTAssertTrue($0.IsClean())
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
        }
    }
    
    func test_TfErrorMarkWrapper_Transport_1() async {
        var transports = [pxr.TfErrorTransport]()
        
        let basePath = String(pathForStage(named: "HelloWorld"))
        
        for i in 0..<100 {
            let path = std.string(basePath + "\(i).usda")
            transports.append(await Task {
                try! await Task.sleep(for: .seconds(0.01))
                return Overlay.withTfErrorMark {
                    let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(path, .LoadAll))
                    let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(path, .LoadAll))
                    XCTAssertFalse($0.IsClean())
                    let transport = $0.Transport()
                    XCTAssertTrue($0.IsClean())
                    XCTAssertFalse(transport.IsEmpty())
                    withExtendedLifetime(stage1) {}
                    withExtendedLifetime(stage2) {}
                    return transport
                }
            }.value)
        }
        
        for transport in transports {
            await Task {
                try! await Task.sleep(for: .seconds(0.01))
                Overlay.withTfErrorMark {
                    XCTAssertTrue($0.IsClean())
                    var t = transport
                    t.Post()
                    XCTAssertFalse($0.IsClean())
                    XCTAssertTrue(t.IsEmpty())
                    XCTAssertFalse(transport.IsEmpty())
                }
            }.value
        }
    }
    
    func test_TfErrorMarkWrapper_TransportTo_1() async {
        var transports = [pxr.TfErrorTransport]()
        
        let basePath = String(pathForStage(named: "HelloWorld"))
        
        for i in 0..<100 {
            let path = std.string(basePath + "\(i).usda")
            transports.append(await Task {
                try! await Task.sleep(for: .seconds(0.01))
                return Overlay.withTfErrorMark {
                    let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(path, .LoadAll))
                    let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(path, .LoadAll))
                    withExtendedLifetime(stage1) {}
                    withExtendedLifetime(stage2) {}
                    XCTAssertFalse($0.IsClean())
                    var transport = pxr.TfErrorTransport()
                    XCTAssertTrue(transport.IsEmpty())
                    $0.TransportTo(&transport)
                    XCTAssertTrue($0.IsClean())
                    XCTAssertFalse(transport.IsEmpty())
                    return transport
                }
            }.value)
        }
        
        for transport in transports {
            await Task {
                try! await Task.sleep(for: .seconds(0.01))
                Overlay.withTfErrorMark {
                    XCTAssertTrue($0.IsClean())
                    var t = transport
                    t.Post()
                    XCTAssertFalse($0.IsClean())
                    XCTAssertTrue(t.IsEmpty())
                    XCTAssertFalse(transport.IsEmpty())
                }
            }.value
        }
    }
    
    func test_TfErrorMarkWrapper_Sequence_1() {
        Overlay.withTfErrorMark {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            
            var loopCount = 0
            for err in $0.errors {
                loopCount += 1
                XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/sdf/layer.cpp"))
                XCTAssertEqual(err.GetSourceLineNumber(), 600)
                XCTAssertEqual(String(err.GetCommentary()), "A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'")
                XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::SdfLayer::_CreateNew")
                XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                XCTAssertTrue(err.IsCodingError())
            }
            XCTAssertEqual(loopCount, 1)
        }
    }
    
    func test_TfErrorMarkWrapper_Sequence_2() {
        Overlay.withTfErrorMark {
            let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
            withExtendedLifetime(stage1) {}
            withExtendedLifetime(stage2) {}
            XCTAssertFalse($0.IsClean())
            XCTAssertEqual(Array($0.errors).count, 1)
            pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(stage1), "/hello").GetRadiusAttr().Set([1] as pxr.VtIntArray, .Default())
            XCTAssertEqual(Array($0.errors).count, 2)
            
            var loopCount = 0
            for err in $0.errors {
                loopCount += 1
                if loopCount == 1 {
                    XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/sdf/layer.cpp"))
                    XCTAssertEqual(err.GetSourceLineNumber(), 600)
                    XCTAssertEqual(String(err.GetCommentary()), "A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'")
                    XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::SdfLayer::_CreateNew")
                    XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                    XCTAssertTrue(err.IsCodingError())
                } else {
                    XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/usd/stage.cpp"))
                    XCTAssertEqual(err.GetSourceLineNumber(), 7061)
                    XCTAssertEqual(err.GetCommentary(), "Type mismatch for </hello.radius>: expected 'double', got 'VtArray<int>'")
                    XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::UsdStage::_SetValueImpl")
                    XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                    XCTAssertTrue(err.IsCodingError())
                }
            }
            XCTAssertEqual(loopCount, 2)
        }
    }
    
    func test_TfErrorMarkWrapper_ErrorSequence_NotACollection() {
        func assertNotACollection<T>(_ x: T.Type = T.self) { }
        func assertNotACollection<T: Collection>(_ x: T.Type = T.self) {
            if x != [Int].self {
                XCTFail()
            }
        }
        
        assertNotACollection(Int.self)
        assertNotACollection([Int].self)
        assertNotACollection(Overlay.TfErrorMarkWrapper.ErrorSequence.self)
    }
    
    func test_TfErrorMark_NestingDoesntSuppressByDefault() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        Overlay.withTfErrorMark { outer in
            XCTAssertTrue(outer.IsClean())
            Overlay.withTfErrorMark { inner in
                XCTAssertTrue(inner.IsClean())
                let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                withExtendedLifetime(stage1) {}
                withExtendedLifetime(stage2) {}
                XCTAssertFalse(inner.IsClean())
                XCTAssertFalse(outer.IsClean())
                
                var loopCount = 0
                for err in inner.errors {
                    loopCount += 1
                    XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/sdf/layer.cpp"))
                    XCTAssertEqual(err.GetSourceLineNumber(), 600)
                    XCTAssertEqual(String(err.GetCommentary()), "A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'")
                    XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::SdfLayer::_CreateNew")
                    XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                    XCTAssertTrue(err.IsCodingError())
                }
                XCTAssertEqual(loopCount, 1)
                
                loopCount = 0
                for err in outer.errors {
                    loopCount += 1
                    XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/sdf/layer.cpp"))
                    XCTAssertEqual(err.GetSourceLineNumber(), 600)
                    XCTAssertEqual(String(err.GetCommentary()), "A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'")
                    XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::SdfLayer::_CreateNew")
                    XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                    XCTAssertTrue(err.IsCodingError())
                }
                XCTAssertEqual(loopCount, 1)
            }
            
            var loopCount = 0
            for err in outer.errors {
                loopCount += 1
                XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/sdf/layer.cpp"))
                XCTAssertEqual(err.GetSourceLineNumber(), 600)
                XCTAssertEqual(String(err.GetCommentary()), "A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'")
                XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::SdfLayer::_CreateNew")
                XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                XCTAssertTrue(err.IsCodingError())
            }
            XCTAssertEqual(loopCount, 1)
        }
    }
    
    func test_TfErrorMark_NestingCanSuppress() {
        let stage1 = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        Overlay.withTfErrorMark { outer in
            XCTAssertTrue(outer.IsClean())
            Overlay.withTfErrorMark { inner in
                XCTAssertTrue(inner.IsClean())
                let stage2 = Overlay.DereferenceOrNil(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
                withExtendedLifetime(stage1) {}
                withExtendedLifetime(stage2) {}
                XCTAssertFalse(inner.IsClean())
                XCTAssertFalse(outer.IsClean())
                
                var loopCount = 0
                for err in inner.errors {
                    loopCount += 1
                    XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/sdf/layer.cpp"))
                    XCTAssertEqual(err.GetSourceLineNumber(), 600)
                    XCTAssertEqual(String(err.GetCommentary()), "A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'")
                    XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::SdfLayer::_CreateNew")
                    XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                    XCTAssertTrue(err.IsCodingError())
                }
                XCTAssertEqual(loopCount, 1)
                
                loopCount = 0
                for err in outer.errors {
                    loopCount += 1
                    XCTAssertTrue(String(err.GetSourceFileName()).hasSuffix("/pxr/usd/sdf/layer.cpp"))
                    XCTAssertEqual(err.GetSourceLineNumber(), 600)
                    XCTAssertEqual(String(err.GetCommentary()), "A layer already exists with identifier '\(pathForStage(named: "HelloWorld.usda"))'")
                    XCTAssertEqual(err.GetSourceFunction(), "pxrInternal_v0_25_8__pxrReserved__::SdfLayer::_CreateNew")
                    XCTAssertEqual(err.GetDiagnosticCode().GetValue(), pxr.TF_DIAGNOSTIC_CODING_ERROR_TYPE)
                    XCTAssertTrue(err.IsCodingError())
                }
                XCTAssertEqual(loopCount, 1)
                
                inner.Clear()
            }
            XCTAssertTrue(outer.IsClean())
        }
    }
    
    func test_TfErrorMark_Throws() {
        struct MyError: Error {
            var foo: String { "foo" }
        }
        
        func mightThrowAny() throws {}
        func doesThrowAny() throws {
            throw MyError()
        }
        func mightThrowMyError() throws(MyError) {}
        func doesThrowMyError() throws(MyError) {
            throw MyError()
        }
        
        var x = 0
        do {
            try Overlay.withTfErrorMark { _ in
                try mightThrowAny()
            }
            x += 1
        } catch {
            XCTFail()
        }
        XCTAssertEqual(x, 1)
        
        do {
            try Overlay.withTfErrorMark { _ in
                try doesThrowAny()
            }
            XCTFail()
        } catch {
            XCTAssertTrue(error is MyError)
            x += 1
        }
        XCTAssertEqual(x, 2)
        
        do {
            try Overlay.withTfErrorMark { (_) throws(MyError) -> () in
               try mightThrowMyError()
            }
            x += 1
        } catch {
            XCTFail()
            print(error.foo)
        }
        XCTAssertEqual(x, 3)
        
        do {
            try Overlay.withTfErrorMark { (_) throws(MyError) -> () in
                try doesThrowMyError()
            }
            XCTFail()
        } catch {
            x += 1
            XCTAssertEqual(error.foo, "foo")
        }
        XCTAssertEqual(x, 4)
    }
    
    // MARK: ArResolverWrapper
    
    func test_ArResolverWrapper() {
        let resolver: Overlay.ArResolverWrapper = Overlay.ArGetResolver()
        let unresolvedPath: pxr.ArResolvedPath = resolver.Resolve("input.usda")
        XCTAssertTrue(unresolvedPath.IsEmpty())
        
        let copyDestination = try! copyResourceToWorkingDirectory(subPath: "Wrapping/ArResolverWrapper", destName: "ArResolverWrapper")
        FileManager.default.changeCurrentDirectoryPath(String(copyDestination))
        let resolvedPath: pxr.ArResolvedPath = resolver.Resolve("input.usda")
        XCTAssertFalse(resolvedPath.IsEmpty())
    }
    
    // MARK: UsdZipFileIteratorWrapper
    
    func test_UsdZipFileIteratorWrapper() {
        let path = try! copyResourceToWorkingDirectory(subPath: "Wrapping/usdzipfileiteratorwrapper.usdz", destName: "input.usdz")
        let zipFile = pxr.UsdZipFile.Open(path)
        
        let fileNames = zipFile.map(\.pointee)
        XCTAssertEqual(fileNames, ["src/a.txt", "src/b.png"])
        
        for file in zipFile {
            if file.pointee == "src/b.png" { continue }
            
            XCTAssertTrue(file == zipFile.Find("src/a.txt"))
            XCTAssertTrue(file != zipFile.Find("src/b.png"))
            XCTAssertFalse(file == zipFile.Find("doesntexist"))
            
            let data = Data(bytes: file.GetFile()!, count: file.GetFileInfo().size)
            let s = "This is a file named a.txt. It is used for a test.\n\nIt has multiple lines in it.\n\n"
            XCTAssertEqual(s.data(using: .utf8), data)
            
            XCTAssertEqual(file.GetFileInfo().dataOffset, 64)
            XCTAssertEqual(file.GetFileInfo().size, 82)
            XCTAssertEqual(file.GetFileInfo().uncompressedSize, 82)
            XCTAssertEqual(file.GetFileInfo().crc, 3011207731)
            XCTAssertEqual(file.GetFileInfo().compressionMethod, 0)
            XCTAssertFalse(file.GetFileInfo().encrypted)
        }
        
        let file = zipFile.Find("src/b.png")
        XCTAssertNotNil(file.GetFile())
        XCTAssertEqual(file.GetFileInfo().dataOffset, 192)
        XCTAssertEqual(file.GetFileInfo().size, 7228)
        XCTAssertEqual(file.GetFileInfo().uncompressedSize, 7228)
        XCTAssertEqual(file.GetFileInfo().crc, 384784137)
        XCTAssertEqual(file.GetFileInfo().compressionMethod, 0)
        XCTAssertFalse(file.GetFileInfo().encrypted)
        
        XCTAssertNil(zipFile.Find("doesntexist").GetFile())
    }
    
    // MARK: UsdAppUtilsFrameRecorderWrapper
    
    func test_UsdAppUtilsFrameRecorderWrapper() {
        let renderUrl = tempDirectory.appending(path: UUID().uuidString + ".png")
        let renderPath = std.string(renderUrl.path(percentEncoded: false))
        
        let modelUrl = urlForResource(subPath: "Wrapping/UsdAppUtilsFrameRecorderWrapper/test.usda")
        let stage = Overlay.Dereference(pxr.UsdStage.Open(std.string(modelUrl.path(percentEncoded: false))))
        
        var recorder = Overlay.UsdAppUtilsFrameRecorderWrapper("", true, true)
        recorder.SetDomeLightVisibility(true)
        recorder.SetColorCorrectionMode("sRGB")
        recorder.Record(Overlay.TfWeakPtr(stage), pxr.UsdGeomCamera(pxr.UsdPrim()),
                        .Default(), renderPath)
        assertImagesEqual(urlForResource(subPath: "Wrapping/UsdAppUtilsFrameRecorderWrapper/expected-out.png"), renderUrl, file: #file, line: #line)
    }
}

