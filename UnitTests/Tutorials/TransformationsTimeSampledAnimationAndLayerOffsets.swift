//
//  TransformationsTimeSampledAnimationAndLayerOffsetsTests.swift
//  UsdInteropTests
//
//  Created by Maddy Adams on 8/7/23.
//

import XCTest
import OpenUSD

// This file is a translation of https://openusd.org/release/tut_xforms.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/TransformationsTimeSampledAnimationAndLayerOffsets` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/animatedTop.
// `SwiftUsdTests/UnitTests/Resources/Tutorials/TransformationsTimeSampledAnimationAndLayerOffsets/1.txt` is an adaptation of
// https://github.com/PixarAnimationStudios/OpenUSD/blob/v25.05.01/extras/usd/tutorials/animatedTop/top.geom.usd.

final class TransformationsTimeSampledAnimationAndLayerOffsets: TutorialsHelper {
    override class var name: String { "TransformationsTimeSampledAnimationAndLayerOffsets" }

    func testTutorial() throws {
        func MakeInitialStage(path: String) -> pxr.UsdStage {
            let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: path), .LoadAll))
            pxr.UsdGeomSetStageUpAxis(Overlay.TfWeakPtr(stage), .UsdGeomTokens.z)
            stage.SetStartTimeCode(0)
            stage.SetEndTimeCode(192)
            return stage
        }
        
        func Step1() {
            let stage = MakeInitialStage(path: "Step1.usda")
            stage.SetMetadata("comment", "Step 1: Start and end time codes" as std.string)
            stage.Save()
            XCTAssertEqual(try contentsOfStage(named: "Step1.usda"), try expected(2))
        }
        
        func AddReferenceToGeometry(stage: pxr.UsdStage, path: pxr.SdfPath) -> pxr.UsdGeomXform {
            let geom = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), path)
            
            Overlay.GetPrim(geom).GetReferences().AddReference("./top.geom.usd", pxr.SdfLayerOffset(0, 1), .UsdListPositionBackOfPrependList)
            return geom
        }
        
        func Step2() {
            let stage = MakeInitialStage(path: "Step2.usda")
            stage.SetMetadata("comment", "Step 2: Geometry reference" as std.string)
            let _ = AddReferenceToGeometry(stage: stage, path: "/Top")
            stage.Save()
            XCTAssertEqual(try contentsOfStage(named: "Step2.usda"), try expected(3))
        }
        
        func AddSpin(top: pxr.UsdGeomXform) {
            let spin = top.AddRotateZOp(.PrecisionFloat, "spin", false)
            spin.Set(0 as Float, pxr.UsdTimeCode(0))
            spin.Set(1440 as Float, pxr.UsdTimeCode(192))
        }
        
        func Step3() {
            let stage = MakeInitialStage(path: "Step3.usda")
            stage.SetMetadata("comment", "Step 3: Adding spin animation" as std.string)
            let top = AddReferenceToGeometry(stage: stage, path: "/Top")
            AddSpin(top: top)
            stage.Save()
            XCTAssertEqual(try contentsOfStage(named: "Step3.usda"), try expected(4))
        }
        
        func AddTilt(top: pxr.UsdGeomXform) {
            let tilt = top.AddRotateXOp(.PrecisionFloat, "tilt", false)
            tilt.Set(12 as Float, pxr.UsdTimeCode.Default())
        }
        
        func Step4() {
            let stage = MakeInitialStage(path: "Step4.usda")
            stage.SetMetadata("comment", "Step 4: Adding tilt" as std.string)
            let top = AddReferenceToGeometry(stage: stage, path: "/Top")
            AddTilt(top: top)
            AddSpin(top: top)
            stage.Save()
            XCTAssertEqual(try contentsOfStage(named: "Step4.usda"), try expected(5))
        }
        
        func Step4a() {
            let stage = MakeInitialStage(path: "Step4a.usda")
            stage.SetMetadata("comment", "Step 4a: Adding spin, then tilt" as std.string)
            let top = AddReferenceToGeometry(stage: stage, path: "/Top")
            AddSpin(top: top)
            AddTilt(top: top)
            stage.Save()
            XCTAssertEqual(try contentsOfStage(named: "Step4a.usda"), try expected(6))
        }
        
        func AddOffset(top: pxr.UsdGeomXform) {
            top.AddTranslateOp(.PrecisionDouble, "offset", false).Set(pxr.GfVec3d(0, 0.1, 0), pxr.UsdTimeCode.Default())
        }
        
        func AddPrecession(top: pxr.UsdGeomXform) {
            let precess = top.AddRotateZOp(.PrecisionFloat, "precess", false)
            precess.Set(0 as Float, pxr.UsdTimeCode(0))
            precess.Set(360 as Float, pxr.UsdTimeCode(192))
        }
        
        func Step5() {
            let stage = MakeInitialStage(path: "Step5.usda")
            stage.SetMetadata("comment", "Step 5: Adding precession and offset" as std.string)
            let top = AddReferenceToGeometry(stage: stage, path: "/Top")
            AddPrecession(top: top)
            AddOffset(top: top)
            AddTilt(top: top)
            AddSpin(top: top)
            stage.Save()
            XCTAssertEqual(try contentsOfStage(named: "Step5.usda"), try expected(7))
        }
        
        func Step6() {
            let anim_layer_path: std.string = "./Step5.usda"
            
            let stage = MakeInitialStage(path: "Step6.usda")
            stage.SetMetadata("comment", "Step 6: Layer offsets and animation" as std.string)
            
            let _ = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/Left")
            let left_top = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/Left/Top")
            Overlay.GetPrim(left_top).GetReferences().AddReference(
                anim_layer_path,
                "/Top",
                pxr.SdfLayerOffset(0, 1),
                .UsdListPositionBackOfPrependList
            )
            
            let middle = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/Middle")
            middle.AddTranslateOp(.PrecisionDouble, pxr.TfToken(), false).Set(pxr.GfVec3d(2, 0, 0), pxr.UsdTimeCode.Default())
            let middle_top = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/Middle/Top")
            Overlay.GetPrim(middle_top).GetReferences().AddReference(
                anim_layer_path,
                "/Top",
                pxr.SdfLayerOffset(96, 1),
                .UsdListPositionBackOfPrependList
            )
            
            let right = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/Right")
            right.AddTranslateOp(.PrecisionDouble, pxr.TfToken(), false).Set(pxr.GfVec3d(4, 0, 0), pxr.UsdTimeCode.Default())
            let right_top = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/Right/Top")
            Overlay.GetPrim(right_top).GetReferences().AddReference(
                anim_layer_path,
                "/Top",
                pxr.SdfLayerOffset(0, 0.25),
                .UsdListPositionBackOfPrependList
            )
            stage.Save()
            XCTAssertEqual(try contentsOfStage(named: "Step6.usda"), try expected(8))
        }
        
        _ = try copyResourceToWorkingDirectory(subPath: "Tutorials/TransformationsTimeSampledAnimationAndLayerOffsets/1.txt", destName: "top.geom.usd")
        
        Step1()
        Step2()
        Step3()
        Step4()
        Step4a()
        Step5()
        Step6()
    }
}
