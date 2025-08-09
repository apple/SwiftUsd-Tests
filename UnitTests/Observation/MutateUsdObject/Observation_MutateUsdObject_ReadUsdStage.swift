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

final class Observation_MutateUsdObject_ReadUsdStage: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        
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
        
        expectingSomeNotifications([token], attr.SetMetadata("colorSpace", pxr.VtValue("foo" as pxr.TfToken)))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
            double radius (
                colorSpace = "foo"
            )
        }


        """#)
    }
        
    func test_SetMetadata_GetStartTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(main.GetStartTimeCode())
        XCTAssertEqual(value, 0)
        
        expectingSomeNotifications([token], p.SetMetadata("startTimeCode", pxr.VtValue(7.28)))
        XCTAssertEqual(main.GetStartTimeCode(), 7.28)
    }
    
    func test_SetMetadata_HasAuthoredTimeCodeRange() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        main.SetStartTimeCode(2)
        
        let (token, value) = registerNotification(main.HasAuthoredTimeCodeRange())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], p.SetMetadata("endTimeCode", pxr.VtValue(7.28)))
        XCTAssertTrue(main.HasAuthoredTimeCodeRange())
    }
    
    func test_SetMetadata_GetTimeCodesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        
        let (token, value) = registerNotification(main.GetTimeCodesPerSecond())
        XCTAssertEqual(value, 24)
        
        expectingSomeNotifications([token], p.SetMetadata("timeCodesPerSecond", pxr.VtValue(7.28)))
        XCTAssertEqual(main.GetTimeCodesPerSecond(), 7.28)
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        attr.SetMetadata("colorSpace", pxr.VtValue("foo" as pxr.TfToken))
        
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
                colorSpace = "foo"
            )
        }


        """#)
        
        expectingSomeNotifications([token], attr.ClearMetadata("colorSpace"))
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
    
    func test_ClearMetadata_GetEndTimeCode() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        main.SetEndTimeCode(7.28)
        
        let (token, value) = registerNotification(main.GetEndTimeCode())
        XCTAssertEqual(value, 7.28)
        
        expectingSomeNotifications([token], p.ClearMetadata("endTimeCode"))
        XCTAssertEqual(main.GetEndTimeCode(), 0)
    }
    
    func test_ClearMetadata_GetFramesPerSecond() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.GetPseudoRoot()
        main.SetFramesPerSecond(7.28)
        
        let (token, value) = registerNotification(main.GetFramesPerSecond())
        XCTAssertEqual(value, 7.28)
        
        expectingSomeNotifications([token], p.ClearMetadata("framesPerSecond"))
        XCTAssertEqual(main.GetFramesPerSecond(), 24)
    }
    
    // MARK: SetMetadataByDictKey
    
    func test_SetMetadataByDictKey_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            assetInfo = {
                string name = "fizzy"
            }
        )
        {
        }


        """#)
    }
    
    // MARK: ClearMetadataByDictKey
    
    func test_ClearMetadataByDictKey_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetMetadataByDictKey("assetInfo", "name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            assetInfo = {
                string name = "fizzy"
            }
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearMetadataByDictKey("assetInfo", "name"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: SetHidden
    
    func test_SetHidden_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetHidden(true))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            hidden = true
        )
        {
        }


        """#)
    }
    
    // MARK: ClearHidden
    
    func test_ClearHidden_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetHidden(true)
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            hidden = true
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearHidden())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: SetCustomData
    
    func test_SetCustomData_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)]))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            customData = {
                token fizz = "buzz"
            }
        )
        {
        }


        """#)
    }
    
    // MARK: SetCustomDataByKey
    
    func test_SetCustomDataByKey_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetCustomDataByKey("fizz", pxr.VtValue("buzz" as pxr.TfToken)))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            customData = {
                token fizz = "buzz"
            }
        )
        {
        }


        """#)
    }
    
    // MARK: ClearCustomData
    
    func test_ClearCustomData_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            customData = {
                token fizz = "buzz"
            }
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearCustomData())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: ClearCustomDataByKey
    
    func test_ClearCustomDataByKey_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetCustomData(["fizz" : pxr.VtValue("buzz" as pxr.TfToken)])
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            customData = {
                token fizz = "buzz"
            }
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearCustomDataByKey("fizz"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: SetAssetInfo
    
    func test_SetAssetInfo_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)]))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            assetInfo = {
                string name = "fizzy"
            }
        )
        {
        }


        """#)
    }
    
    // MARK: SetAssetInfoByKey
    
    func test_SetAssetInfoByKey_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetAssetInfoByKey("name", pxr.VtValue("fizzy" as std.string)))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            assetInfo = {
                string name = "fizzy"
            }
        )
        {
        }


        """#)
    }
    
    // MARK: ClearAssetInfo
    
    func test_ClearAssetInfo_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfo(["name" : pxr.VtValue("fizzy" as std.string)])
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            assetInfo = {
                string name = "fizzy"
            }
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearAssetInfo())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: ClearAssetInfoByKey
    
    func test_ClearAssetInfoByKey_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetAssetInfoByKey("name", pxr.VtValue("fizzy" as std.string))
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            assetInfo = {
                string name = "fizzy"
            }
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearAssetInfoByKey("name"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: SetDocumentation
    
    func test_SetDocumentation_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetDocumentation("my documentation string"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            doc = "my documentation string"
        )
        {
        }


        """#)
    }
    
    // MARK: ClearDocumentation
    
    func test_ClearDocumentation_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDocumentation("my documentation string")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            doc = "my documentation string"
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearDocumentation())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
    
    // MARK: SetDisplayName
    
    func test_SetDisplayName_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        
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
        
        expectingSomeNotifications([token], p.SetDisplayName("bar"))
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            displayName = "bar"
        )
        {
        }


        """#)
    }
    
    // MARK: ClearDisplayName
    
    func test_ClearDisplayName_ExportToString() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        p.SetDisplayName("bar")
        
        let (token, value) = registerNotification(main.ExportToString())
        XCTAssertEqual(value, #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo" (
            displayName = "bar"
        )
        {
        }


        """#)
        
        expectingSomeNotifications([token], p.ClearDisplayName())
        XCTAssertEqual(main.ExportToString(), #"""
        #usda 1.0
        (
            doc = """Generated from Composed Stage of root layer \#(pathForStage(named: "Main.usda"))
        """
        )

        def Sphere "foo"
        {
        }


        """#)
    }
}
