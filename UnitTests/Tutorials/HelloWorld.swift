//
//  HelloWorld.swift
//  SwiftUsdTestsTests
//
//  Created by Maddy Adams on 12/1/23.
//

import XCTest
import OpenUSD

// This file is a translation of https://openusd.org/release/tut_helloworld.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/HelloWorld` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/authoringProperties.

final class HelloWorld: TutorialsHelper {
    override class var name: String { "HelloWorld" }
    
    func testHelloWorldTutorial() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorld.usda"), .LoadAll))
        let _ = pxr.UsdGeomXform.Define(Overlay.TfWeakPtr(stage), "/hello")
        let _ = pxr.UsdGeomSphere.Define(Overlay.TfWeakPtr(stage), "/hello/world")
        let layer = Overlay.Dereference(stage.GetRootLayer())
        layer.Save(false)
        
        XCTAssertEqual(try contentsOfStage(named: "HelloWorld.usda"), try expected(1))
    }
}
