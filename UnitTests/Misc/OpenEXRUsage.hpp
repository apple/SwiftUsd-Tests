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

#ifndef SwiftUsdTests_OpenEXRUsage_hpp
#define SwiftUsdTests_OpenEXRUsage_hpp

#include <stdio.h>
#include <string>
#include "swiftUsd/swiftUsd.h"

// SwiftUsd 5.0.x didn't include the OpenEXR dylibs despite building them,
// which caused linker errors for some users. In OpenUSD v25.08,
// OpenEXR is a dependency of OpenImageIO, Alembic, and OpenVDB
#if defined(SwiftUsd_PXR_ENABLE_OPENIMAGEIO_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_OPENVDB_SUPPORT)
struct ReadOpenEXRResult {
    bool success;
    int width;
    int height;
};

ReadOpenEXRResult readOpenEXR(std::string path, int rowBytes);
#endif // #if defined(SwiftUsd_PXR_ENABLE_OPENIMAGEIO_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_OPENVDB_SUPPORT)


#endif /* SwiftUsdTests_OpenEXRUsage_hpp */
