//
//  CxxDictionaryTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 1/26/24.
//

import XCTest
import OpenUSD

final class CxxDictionaryTests: TemporaryDirectoryHelper {

    func assertConforms<T>(_ t: T.Type) {
        XCTAssertTrue(T.self is any CxxDictionary.Type)
    }
    
    func test_VtDictionary() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), .LoadAll))
        let layer = Overlay.Dereference(main.GetRootLayer())
        layer.SetFieldDictValueByKey("/", "expressionVariables", "WHICH_SUBLAYER", pxr.VtValue(pathForStage(named: "Sub1.usda")))
        let x: pxr.VtDictionary = layer.GetExpressionVariables()
        XCTAssertEqual(x["WHICH_SUBLAYER"], pxr.VtValue(pathForStage(named: "Sub1.usda")))
        assertConforms(pxr.VtDictionary.self)
    }
    
    func test_VtDictionary_erase() {
        var x: pxr.VtDictionary = ["a" : pxr.VtValue("b" as std.string), "c" : pxr.VtValue("d" as std.string), "e" : pxr.VtValue("f" as std.string)]
        let y: pxr.VtDictionary.iterator = x.__eraseUnsafe(x.__beginMutatingUnsafe())
        XCTAssertEqual(y, x.__findMutatingUnsafe("c"))
        
        let z: pxr.VtDictionary.iterator = x.__eraseUnsafe(x.__findMutatingUnsafe("c"))
        XCTAssertEqual(z, x.__findMutatingUnsafe("e"))
        
        var temp = x["e"]
        XCTAssertEqual(temp.Get() as std.string, "f")
    }
    
    func test_VtDictionary_for_in() {
        let x: pxr.VtDictionary = ["a" : pxr.VtValue("b" as std.string), "c" : pxr.VtValue("d" as std.string), "e" : pxr.VtValue("f" as std.string)]
        var y: pxr.VtDictionary = [:]
        
        for kvPair in x {
            y[kvPair.first] = kvPair.second
        }
        XCTAssertTrue(y["a"] == pxr.VtValue("b" as std.string))
        XCTAssertTrue(y["c"] == pxr.VtValue("d" as std.string))
        XCTAssertTrue(y["e"] == pxr.VtValue("f" as std.string))
        XCTAssertEqual(y.size(), 3)
    }
}
