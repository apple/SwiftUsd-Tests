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

import Foundation
import OpenUSD

// TemporaryImplementations is for holding symbols, functions, and types
// that haven't been moved into the framework yet, tested, and documented

#warning("non-empty temporary implementations")

// MARK: CustomStringConvertible
// rdar://122021150 (Conforming std::set specialization to CxxSequence in a framework crashes swiftc when using the framework)
// Because of that, we can't move pxr.SdfPathSet: CustomStringConvertible in, because it relies on Sequence conformance
extension pxr.SdfPathSet: CustomStringConvertible {
    public var description: String {
        "[" + map { String($0) }.joined(separator: ", ") + "]"
    }
}


// MARK: Sequence, IteratorProtocol
// rdar://122021150 (Conforming std::set specialization to CxxSequence in a framework crashes swiftc when using the framework)
extension pxr.SdfPathSet: CxxSequence {}
extension Overlay.String_Set: CxxSequence {}


extension Overlay.UsdRelationship_Vector: CxxSequence {}
extension Overlay.UsdProperty_Vector: CxxSequence {}
