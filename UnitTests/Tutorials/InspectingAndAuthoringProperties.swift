//
//  InspectingAndAuthoringPropertiesTests.swift
//  UsdInteropTests
//
//  Created by Maddy Adams on 8/7/23.
//

import XCTest
import OpenUSD

// This file is a translation of https://openusd.org/release/tut_inspect_and_author_props.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/InspectingAndAuthoringProperties` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/authoringProperties.

final class InspectingAndAuthoringProperties: TutorialsHelper {
    override class var name: String { "InspectingAndAuthoringProperties" }
    
    func testTutorial() throws {
        let stagePath = try copyResourceToWorkingDirectory(subPath: "Tutorials/InspectingAndAuthoringProperties/1.txt", destName: "HelloWorld.usda")
        
        let stage = Overlay.Dereference(pxr.UsdStage.Open(stagePath, .LoadAll))
        let xform = stage.GetPrimAtPath("/hello")
        let sphere = stage.GetPrimAtPath("/hello/world")
        
        var propertyNames = xform.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc)
        XCTAssertEqual(String(describing: propertyNames), try expected(2))
        
        propertyNames = sphere.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc)
        XCTAssertEqual(String(describing: propertyNames), try expected(3))
        
        let extentAttr = sphere.GetAttribute(.UsdGeomTokens.extent)
        var extentValue = pxr.VtVec3fArray()
        extentAttr.Get(&extentValue, pxr.UsdTimeCode.Default())
        XCTAssertEqual(String(describing: extentValue), try expected(4))
        
        let radiusAttr = sphere.GetAttribute(.UsdGeomTokens.radius)
        radiusAttr.Set(2.0, pxr.UsdTimeCode.Default())
        extentAttr.Get(&extentValue, pxr.UsdTimeCode.Default())
        for i in 0..<extentValue.size() {
            extentValue[i] *= 2
        }
        extentAttr.Set(extentValue, pxr.UsdTimeCode.Default())
        let rootLayer = Overlay.Dereference(stage.GetRootLayer())
        XCTAssertEqual(rootLayer.ExportToString(), try expected(5))
        
        let sphereSchema = pxr.UsdGeomSphere(sphere)
        let color = sphereSchema.GetDisplayColorAttr()
        let colorValue: pxr.VtVec3fArray = [pxr.GfVec3f(0, 0, 1)]
        color.Set(colorValue, pxr.UsdTimeCode.Default())
        rootLayer.Save(false)
                                       
        try XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), expected(6))
    }
}
