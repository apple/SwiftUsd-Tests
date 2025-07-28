//
//  NonCopyableTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 10/21/24.
//

import XCTest
import OpenUSD

final class NonCopyableTests: TemporaryDirectoryHelper {

    func test_TraceEvent_BeginTag() {
        let x = Overlay.TraceEvent.Begin
        XCTAssertEqual(x.description, "pxr::TraceEvent::Begin")
    }

    func test_PcpPrimIndexOutputs_PayloadState() {
        let x: pxr.PcpPrimIndexOutputs.PayloadState = .NoPayload
        XCTAssertEqual(x.description, "pxr::PcpPrimIndexOutputs::NoPayload")
    }
    
    private func _isSendable<T: ~Copyable>(_ x: T.Type) -> Bool { false }
    private func _isSendable<T: Sendable & ~Copyable>(_ x: T.Type) -> Bool { true }
    
    func test_UsdZipFileWriter_IsSendable() {
        XCTAssertFalse(_isSendable(pxr.UsdZipFileWriter.self))
    }
    
    func assertExists(_ path: std.string, _ exists: Bool) {
        XCTAssertEqual(FileManager.default.fileExists(atPath: String(path)), exists)
    }
    
    func test_UsdZipFileWriter_Save() {
        var wrapper = pxr.UsdZipFileWriter.CreateNew(pathForStage(named: "HelloWorld.usdz"))
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
        
        wrapper.AddFile(pathForStage(named: "Color.usda"), "First.usda")
        wrapper.AddFile(pathForStage(named: "Model.usda"), "Second.usda")
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
        wrapper.Save()
        assertExists(pathForStage(named: "HelloWorld.usdz"), true)
        
        let openedUsdz = Overlay.Dereference(pxr.UsdStage.Open(pathForStage(named: "HelloWorld.usdz"), .LoadAll))
        var readDisplayColor = pxr.VtVec3fArray()
        pxr.UsdGeomSphere.Get(Overlay.TfWeakPtr(openedUsdz), "/mymodel").GetDisplayColorAttr().Get(&readDisplayColor, .Default())
        XCTAssertEqual(readDisplayColor, [pxr.GfVec3f(1, 0, 1)])
    }
    
    func test_UsdZipFileWriter_Discard() {
        var wrapper = pxr.UsdZipFileWriter.CreateNew(pathForStage(named: "HelloWorld.usdz"))
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
        
        wrapper.AddFile(pathForStage(named: "Color.usda"), "First.usda")
        wrapper.AddFile(pathForStage(named: "Model.usda"), "Second.usda")
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
        wrapper.Discard()
        assertExists(pathForStage(named: "HelloWorld.usdz"), false)
    }
}
