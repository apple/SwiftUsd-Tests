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
#if canImport(XLangTestingUtil)
import XLangTestingUtil
#endif

extension __vector_pair_string_bool: CxxSequence {}

final class InternalUtilTests: TemporaryDirectoryHelper {
    func test_replace_all_t() {
        let results = Array(testReplaceAllResults())
        for msgSuccessPair in results {
            XCTAssertTrue(msgSuccessPair.second, String(msgSuccessPair.first))
        }
    }
}
