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

final class UsdValidationTests: TemporaryDirectoryHelper {

    // This test is a translation of `TestCoreUsdStageMetadata` from
    // https://github.com/PixarAnimationStudios/OpenUSD/blob/v26.03/pxr/usdValidation/usdValidation/testenv/testUsdCoreValidators.cpp
    // into Swift.
    func test_TestCoreUsdStageMetadata() {
        // stageMetadataChecker
        let registry = pxr.UsdValidationRegistry.GetInstance()
        let validator = registry.__GetOrLoadValidatorByNameUnsafe(.UsdValidatorNameTokens.stageMetadataChecker)
        XCTAssertNotNil(validator)

        let rootLayer = Overlay.Dereference(pxr.SdfLayer.CreateAnonymous("", .init()))
        let usdStage = Overlay.Dereference(pxr.UsdStage.Open(Overlay.TfWeakPtr(rootLayer)))
        let prim = usdStage.DefinePrim("/test", "Xform")

        var errors = validator!.pointee.Validate(Overlay.TfWeakPtr(usdStage), pxr.UsdValidationTimeRange.init())
        XCTAssertEqual(errors.size(), 1)
        let expectedErrorIdentifier = pxr.TfToken("\(pxr.TfToken.UsdValidatorNameTokens.stageMetadataChecker).\(pxr.TfToken.UsdValidationErrorNameTokens.missingDefaultPrim)")
        withExtendedLifetime(errors[0]) { err in
            XCTAssertEqual(err.__GetValidatorUnsafe(), validator)
            XCTAssertEqual(err.GetIdentifier(), expectedErrorIdentifier)
            XCTAssertEqual(err.GetType(), .Error)
            XCTAssertEqual(err.__GetSitesUnsafe().pointee.size(), 1)
            XCTAssertTrue(err.__GetSitesUnsafe().pointee[0].IsValid())
            let expectedErrorMsg = std.string("Stage with root layer <\(rootLayer.GetIdentifier())> has an invalid or missing defaultPrim.")
            XCTAssertEqual(err.__GetMessageUnsafe().pointee, expectedErrorMsg)
        }

        usdStage.SetDefaultPrim(prim)

        errors = validator!.pointee.Validate(Overlay.TfWeakPtr(usdStage), pxr.UsdValidationTimeRange.init())

        XCTAssertTrue(errors.empty())
    }
}
