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

#ifndef XLanguageARC_CxxHelper_hpp
#define XLanguageARC_CxxHelper_hpp

#include "pxr/pxr.h"
#include "pxr/usd/sdf/layer.h"
#include "pxr/usd/usd/stage.h"
#include <stdio.h>
#include <string>
#include "swiftUsd/swiftUsd.h"
#include <swift/bridging>

// Swift Package Manager doesn't support mixed-language targets
// (https://github.com/swiftlang/swift-package-manager/issues/8945), but Xcode
// projects do. So, to set up bidirectional interop for SPM, we need to do a fair bit of work
// the compiler would do for us. Here's how we do it. If we can't include the
// Swift generated bridging header, then we're in SPM land (MULTI_TARGET_INTEROP == 1).
// We want to set up a function pointer table in C++, have Swift assign its functions as the
// function pointers, and then call them from C++. We also have to work around this issue:
// rdar://143983057 (Runtime crash when passing long std.string as parameter to function pointer implemented in Swift).
// So, we add an extra level of indirection so that the function pointers take pointers to values instead
// of taking values directly, then wrap that to hide the indirection for a unified interface for
// SPM and Xcode doing bidirectional interop. 

#if __has_include("UnitTests-Swift.h")
#define MULTI_TARGET_INTEROP 0
#else
#define MULTI_TARGET_INTEROP 1
#endif


#if MULTI_TARGET_INTEROP
namespace _xLanguageARC_functionPointers_swift {
    void set_smartStage_passStrong(void (^_Nonnull x)(const pxr::UsdStageRefPtr*_Nonnull));
    void set_smartStage_passWeak(void (^_Nonnull x)(const pxr::UsdStageWeakPtr*_Nonnull));
    void set_smartStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::UsdStage>*_Nonnull));
    void set_smartLayer_passStrong(void (^_Nonnull x)(const pxr::SdfLayerRefPtr*_Nonnull));
    void set_smartLayer_passWeak(void (^_Nonnull x)(const pxr::SdfLayerHandle*_Nonnull));
    void set_smartLayer_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::SdfLayer>*_Nonnull));
    void set_smartLayerFromStage_passStrong(void (^_Nonnull x)(const pxr::SdfLayerRefPtr*_Nonnull));
    void set_smartLayerFromStage_passWeak(void (^_Nonnull x)(const pxr::SdfLayerHandle*_Nonnull));
    void set_smartLayerFromStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::SdfLayer>*_Nonnull));

    void set_rawStage_passBorrowing(void (^_Nonnull x)(pxr::UsdStage*_Nonnull));
    void set_rawStage_passConsuming(void (^_Nonnull x)(pxr::UsdStage*_Nonnull));
    void set_rawStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::UsdStage* _Nonnull*_Nonnull));
    void set_rawLayer_passBorrowing(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull));
    void set_rawLayer_passConsuming(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull));
    void set_rawLayer_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::SdfLayer* _Nonnull*_Nonnull));
    void set_rawLayerFromStage_passBorrowing(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull));
    void set_rawLayerFromStage_passConsuming(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull));
    void set_rawLayerFromStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::SdfLayer* _Nonnull*_Nonnull));
}
#endif

// Important: shared reference types directly returned by raw pointer
// from a top level C++ function whose name starts with or contains
// `create`/`Create`/`copy`/`Copy` or is annotated with
// `__attribute((cf_returns_retained))__`, it is considered to be returning
// an already retained pointer (i.e. at +1)

namespace _xLanguageARC_functions_cpp {
    void smartStage_passStrong(const pxr::TfRefPtr<pxr::UsdStage>& p);
    void smartStage_passWeak(const pxr::TfWeakPtr<pxr::UsdStage>& p);
    pxr::TfRefPtr<pxr::UsdStage> smartStage_return(const std::string& path);


    void smartLayer_passStrong(const pxr::TfRefPtr<pxr::SdfLayer>& p);
    void smartLayer_passWeak(const pxr::TfWeakPtr<pxr::SdfLayer>& p);
    pxr::TfRefPtr<pxr::SdfLayer> smartLayer_return(const std::string& path);
    

    void smartLayerFromStage_passStrong(const pxr::TfRefPtr<pxr::SdfLayer>& p);
    void smartLayerFromStage_passWeak(const pxr::TfWeakPtr<pxr::SdfLayer>& p);
    pxr::TfRefPtr<pxr::SdfLayer> smartLayerFromStage_return(const std::string& path);
    
    
    void rawStage_cppPass(pxr::UsdStage*_Nonnull);
    pxr::UsdStage*_Nonnull rawStage_return(const std::string& path) SWIFT_RETURNS_RETAINED;
    
    void rawLayer_cppPass(pxr::SdfLayer*_Nonnull);
    pxr::SdfLayer*_Nonnull rawLayer_return(const std::string& path) SWIFT_RETURNS_RETAINED;
    
    void rawLayerFromStage_cppPass(pxr::SdfLayer*_Nonnull);
    pxr::SdfLayer*_Nonnull rawLayerFromStage_return(const std::string& path) SWIFT_RETURNS_RETAINED;
    
}

namespace _xLanguageARC_tests {
    // MARK: SmartStage
    void smartStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartStage_swiftReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartStage_swiftReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path);
    
    void smartStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartStage_cppReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartStage_cppReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartStage_cppReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartStage_cppReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartStage_cppReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartStage_cppReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path);
    
    
    // MARK: RawStage
    void rawStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawStage_swiftReturn_holdTemporary_cppPass_cppEntry(const std::string& path);
    void rawStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawStage_swiftReturn_noTemporary_cppPass_cppEntry(const std::string& path);
    void rawStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawStage_cppReturn_holdTemporary_cppPass_cppEntry(const std::string& path);
    void rawStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawStage_cppReturn_noTemporary_cppPass_cppEntry(const std::string& path);


    
    
    // MARK: SmartLayer
    void smartLayer_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartLayer_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayer_swiftReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayer_swiftReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartLayer_swiftReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartLayer_swiftReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayer_swiftReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayer_swiftReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartLayer_cppReturn_holdTemporary_swiftPass_strong_swiftEntry(const std::string& path);
    void smartLayer_cppReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayer_cppReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayer_cppReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartLayer_cppReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartLayer_cppReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayer_cppReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayer_cppReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path);
    
    
    // MARK: RawLayer
    void rawLayer_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayer_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayer_swiftReturn_holdTemporary_cppPass_cppEntry(const std::string& path);
    void rawLayer_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayer_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayer_swiftReturn_noTemporary_cppPass_cppEntry(const std::string& path);
    void rawLayer_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayer_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayer_cppReturn_holdTemporary_cppPass_cppEntry(const std::string& path);
    void rawLayer_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayer_cppReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayer_cppReturn_noTemporary_cppPass_cppEntry(const std::string& path);

    
    
    // MARK: SmartLayerFromStage
    void smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayerFromStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartLayerFromStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayerFromStage_swiftReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_swiftReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path);
    void smartLayerFromStage_cppReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path);
    
    
    // MARK: RawLayerFromStage
    void rawLayerFromStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayerFromStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayerFromStage_swiftReturn_holdTemporary_cppPass_cppEntry(const std::string& path);
    void rawLayerFromStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayerFromStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayerFromStage_swiftReturn_noTemporary_cppPass_cppEntry(const std::string& path);
    void rawLayerFromStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayerFromStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayerFromStage_cppReturn_holdTemporary_cppPass_cppEntry(const std::string& path);
    void rawLayerFromStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path);
    void rawLayerFromStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path);
    void rawLayerFromStage_cppReturn_noTemporary_cppPass_cppEntry(const std::string& path);

}








#endif /* XLanguageARC_CxxHelper_hpp */
