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

#include "OpenEXRUsage.hpp"

// SwiftUsd 5.0.x didn't include the OpenEXR dylibs despite building them,
// which caused linker errors for some users. In OpenUSD v25.08,
// OpenEXR is a dependency of OpenImageIO, Alembic, OpenVDB
#if defined(SwiftUsd_PXR_ENABLE_OPENIMAGEIO_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_OPENVDB_SUPPORT)

#include <OpenEXR/openexr.h>
#include <OpenEXR/ImfRgbaFile.h>
#include <OpenEXR/ImfArray.h>

#include <iostream>

ReadOpenEXRResult readOpenEXR(std::string path, int rowBytes) {
    ReadOpenEXRResult result;
    result.width = -1;
    result.height = -1;
    result.success = false;
    

    Imf::RgbaInputFile file(path.c_str());
    auto dw = file.dataWindow();
    
    result.width = dw.max.x - dw.min.x + 1;
    result.height = dw.max.y - dw.min.y + 1;
    int exrrowbytes = result.width * sizeof(Imf::Rgba);
    if (exrrowbytes != rowBytes) {
        result.success = false;
    } else {
        result.success = true;
    }
    
    return result;
}

#endif // #if defined(SwiftUsd_PXR_ENABLE_OPENIMAGEIO_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_ALEMBIC_SUPPORT) || defined(SwiftUsd_PXR_ENABLE_OPENVDB_SUPPORT)
