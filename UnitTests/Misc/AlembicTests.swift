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

final class AlembicTests: TemporaryDirectoryHelper {
    #if canImport(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT)
    func test_loadAndExportAlembic() throws {
        let url = urlForResource(subPath: "Alembic/Cube.abc")
        let path = std.string(url.path(percentEncoded: false))
        guard let stage = Overlay.DereferenceOrNil(pxr.UsdStage.Open(path, .LoadAll)) else {
            XCTFail("Couldn't open Cube.abc")
            return
        }
        
        guard let actual = stage.ExportToString(addSourceFileComment: false) else {
            XCTFail("Couldn't export to string")
            return
        }
        
        let expected = try contentsOfResource(subPath: "Alembic/Cube.txt")
         XCTAssertEqual(expected, actual)

    }
    #endif // #if canImport(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT)
}
