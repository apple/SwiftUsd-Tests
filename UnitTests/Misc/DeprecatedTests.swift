//
//  DeprecatedTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 3/27/24.
//

import XCTest
import OpenUSD

@available(*, deprecated)
final class DeprecatedTests_Deprecated_Swift_6_1: TemporaryDirectoryHelper {
    func test_SdfLayer_IsMuted() {
        let _: (std.string) -> Bool = { Overlay.SdfLayer.IsMuted($0) }
    }
    
    func test_UsdZipFileWriterWrapper() {
        let _: pxr.UsdZipFileWriter.Type = Overlay.UsdZipFileWriterWrapper.self
        let _: Overlay.UsdZipFileWriterWrapper.Type = pxr.UsdZipFileWriter.self
    }
    
    func test_VtValue_Bool() {
        var x = Overlay.VtValue(true)
        var y = Overlay.VtValue(false)
        
        let a = x.Get() as Bool
        let b = y.Get() as Bool
        
        XCTAssertTrue(a)
        XCTAssertFalse(b)
    }
    
    func test_VtArray_push_back() {
        var x = pxr.VtBoolArray()
        Overlay.push_back(&x, true)
        Overlay.push_back(&x, false)
        XCTAssertEqual(x, [true, false])
    }
    
    func test_UsdGeomXformOp_GetOpType() {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        let xformable = pxr.UsdGeomXformable(stage.DefinePrim("/foo", "Cube"))
        let translateOp = xformable.AddTranslateOp(.PrecisionDouble, "", false)
        let scaleOp = xformable.AddScaleOp(.PrecisionFloat, "", false)
        let rotateXOp = xformable.AddRotateXOp(.PrecisionFloat, "", false)
        let rotateYOp = xformable.AddRotateYOp(.PrecisionFloat, "", false)
        let rotateZOp = xformable.AddRotateZOp(.PrecisionFloat, "", false)
        let rotateXYZOp = xformable.AddRotateXYZOp(.PrecisionFloat, "", false)
        let rotateXZYOp = xformable.AddRotateXZYOp(.PrecisionFloat, "", false)
        let rotateYXZOp = xformable.AddRotateYXZOp(.PrecisionFloat, "", false)
        let rotateYZXOp = xformable.AddRotateYZXOp(.PrecisionFloat, "", false)
        let rotateZXYOp = xformable.AddRotateZXYOp(.PrecisionFloat, "", false)
        let rotateZYXOp = xformable.AddRotateZYXOp(.PrecisionFloat, "", false)
        let orientOp = xformable.AddOrientOp(.PrecisionFloat, "", false)
        let transformOp = xformable.AddTransformOp(.PrecisionDouble, "", false)

        XCTAssertEqual(Overlay.GetOpType(translateOp), .TypeTranslate)
        XCTAssertEqual(Overlay.GetOpType(scaleOp), .TypeScale)
        XCTAssertEqual(Overlay.GetOpType(rotateXOp), .TypeRotateX)
        XCTAssertEqual(Overlay.GetOpType(rotateYOp), .TypeRotateY)
        XCTAssertEqual(Overlay.GetOpType(rotateZOp), .TypeRotateZ)
        XCTAssertEqual(Overlay.GetOpType(rotateXYZOp), .TypeRotateXYZ)
        XCTAssertEqual(Overlay.GetOpType(rotateXZYOp), .TypeRotateXZY)
        XCTAssertEqual(Overlay.GetOpType(rotateYXZOp), .TypeRotateYXZ)
        XCTAssertEqual(Overlay.GetOpType(rotateYZXOp), .TypeRotateYZX)
        XCTAssertEqual(Overlay.GetOpType(rotateZXYOp), .TypeRotateZXY)
        XCTAssertEqual(Overlay.GetOpType(rotateZYXOp), .TypeRotateZYX)
        XCTAssertEqual(Overlay.GetOpType(orientOp), .TypeOrient)
        XCTAssertEqual(Overlay.GetOpType(transformOp), .TypeTransform)

    }
    
    func test_SdfLayerStateDelegateBaseRefPtr() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())

        let value = layer.GetStateDelegate()
        
        let delegateForSetting = pxr.SdfSimpleLayerStateDelegate.New()
        layer.SetStateDelegate(Overlay.SdfLayerStateDelegateBaseRefPtr(delegateForSetting))
        let secondGet = layer.GetStateDelegate()
        XCTAssertEqual(Overlay.SdfLayerStateDelegateBasePtr(delegateForSetting), secondGet)
        XCTAssertNotEqual(value, secondGet)
    }
    
    func test_SdfLayerStateDelegateBasePtr() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        let a: pxr.SdfLayerStateDelegateBasePtr = layer.GetStateDelegate()
        let b: pxr.SdfLayerStateDelegateBasePtr = Overlay.SdfLayerStateDelegateBasePtr(pxr.SdfSimpleLayerStateDelegate.New())
        let c: pxr.SdfLayerStateDelegateBasePtr = layer.GetStateDelegate()
        XCTAssertNotEqual(a, b)
        XCTAssertNotEqual(b, c)
        XCTAssertEqual(a, c)
    }
}
