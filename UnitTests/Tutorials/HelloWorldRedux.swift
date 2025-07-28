//
//  HelloWorldReduxTests.swift
//  UsdInteropTests
//
//  Created by Maddy Adams on 8/7/23.
//

import XCTest
import OpenUSD

// This file is a translation of https://openusd.org/release/tut_helloworld_redux.html into Swift,
// and then adapted as a unit test. The files at `SwiftUsdTests/UnitTests/Resources/Tutorials/HelloWorldRedux` are
// an adaptation of files at https://github.com/PixarAnimationStudios/OpenUSD/tree/v25.05.01/extras/usd/tutorials/authoringProperties.


final class HelloWorldRedux: TutorialsHelper {
    override class var name: String { "HelloWorldRedux" }
    
    func testTutorial() throws {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "HelloWorldRedux.usda"), .LoadAll))
        let _ = stage.DefinePrim("/hello", .UsdGeomTokens.Xform)
        let _ = stage.DefinePrim("/hello/world", .UsdGeomTokens.Sphere)
        let layer = Overlay.Dereference(stage.GetRootLayer())
        layer.Save(false)
        
        XCTAssertEqual(try contentsOfStage(named: "HelloWorldRedux.usda"), try expected(1))
    }
}
