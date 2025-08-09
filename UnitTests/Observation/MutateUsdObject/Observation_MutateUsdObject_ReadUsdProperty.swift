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

final class Observation_MutateUsdObject_ReadUsdProperty: ObservationHelper {

    // MARK: SetMetadata
    
    func test_SetMetadata_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")

        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertFalse(value)
        
        expectingSomeNotifications([token], attr.SetMetadata("displayGroup", pxr.VtValue("foo" as std.string)))
        XCTAssertTrue(attr.HasAuthoredDisplayGroup())
    }
    
    // MARK: ClearMetadata
    
    func test_ClearMetadata_HasAuthoredDisplayGroup() {
        let main = Overlay.Dereference(pxr.UsdStage.CreateNew(pathForStage(named: "Main.usda"), Overlay.UsdStage.LoadAll))
        let p = main.DefinePrim("/foo", "Sphere")
        let attr = p.GetAttribute("radius")
        attr.SetMetadata("displayGroup", pxr.VtValue("foo" as std.string))

        let (token, value) = registerNotification(attr.HasAuthoredDisplayGroup())
        XCTAssertTrue(value)
        
        expectingSomeNotifications([token], attr.ClearMetadata("displayGroup"))
        XCTAssertFalse(attr.HasAuthoredDisplayGroup())
    }

}
