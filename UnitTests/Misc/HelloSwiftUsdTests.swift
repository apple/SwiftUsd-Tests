//
//  HelloSwiftUsdTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/18/23.
//

import XCTest
import OpenUSD

final class HelloSwiftUsdTests: TemporaryDirectoryHelper {
    func makeHelloWorldString() -> String {
        let stage = Overlay.Dereference(pxr.UsdStage.CreateInMemory(.LoadAll))
        stage.DefinePrim("/hello", .UsdGeomTokens.Cube)
        stage.DefinePrim("/hello/world", .UsdGeomTokens.Sphere)
        return stage.ExportToString() ?? "nil"
    }
    
    func test_makeHelloWorldString() {
        XCTAssertEqual(makeHelloWorldString(), try contentsOfResource(subPath: "HelloSwiftUsd.txt"))
    }

}
