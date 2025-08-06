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
