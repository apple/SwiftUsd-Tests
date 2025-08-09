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

final class Observation_MutateUsdProperty_ReadUsdStage: ObservationHelper {

    // MARK: SetDisplayGroup
    
    func test_SetDisplayGroup_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
        
        expectingSomeNotifications([token], attr.SetDisplayGroup("buzz"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double radius (
                displayGroup = "buzz"
            )
        }


        """#)
    }
    
    // MARK: ClearDisplayGroup
    
    func test_ClearDisplayGroup_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        attr.SetDisplayGroup("buzz")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double radius (
                displayGroup = "buzz"
            )
        }


        """#)
        
        expectingSomeNotifications([token], attr.ClearDisplayGroup())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double radius
        }


        """#)
    }
    
    // MARK: SetNestedDisplayGroups
    
    func test_SetNestedDisplayGroups_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").GetAttribute("radius")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
        
        expectingSomeNotifications([token], attr.SetNestedDisplayGroups(["buzz", "bar"]))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double radius (
                displayGroup = "buzz:bar"
            )
        }


        """#)
    }

    // MARK: SetCustom
    
    func test_SetCustom_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double myAttr
        }


        """#)
        
        expectingSomeNotifications([token], attr.SetCustom(true))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            custom double myAttr
        }


        """#)
    }
    
    // MARK: FlattenTo
    
    func test_FlattenTo_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let attr = main.DefinePrim("/foo", "Sphere").CreateAttribute("myAttr", .Double, false, Overlay.SdfVariabilityVarying)
        let otherPrim = main.DefinePrim("/bar", "Sphere")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double myAttr
        }
        
        def Sphere "bar"
        {
        }


        """#)
        
        expectingSomeNotifications([token], attr.FlattenTo(otherPrim))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double myAttr
        }
        
        def Sphere "bar"
        {
            double myAttr
        }


        """#)
    }
}
