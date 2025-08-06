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

#include "XLanguageARC_Cpp.hpp"
#include "swiftUsd/swiftUsd.h"

// See comment in XLangagueARC_Cpp.hpp for an explanation of MULTI_TARGET_INTEROP.
// Tl;dr, Swift Package Manager doesn't support bidirectional interop, so we have
// to build it ourselves by setting up a function pointer table. 

#if !MULTI_TARGET_INTEROP
#include <XCTest/XCTestCase.h>
#include "UnitTests-Swift.h"
#endif

namespace xlarcf_cpp = _xLanguageARC_functions_cpp;

void xlarcf_cpp::smartStage_passStrong(const pxr::TfRefPtr<pxr::UsdStage>& p) {
    p->SetStartTimeCode(5);
}
void xlarcf_cpp::smartStage_passWeak(const pxr::TfWeakPtr<pxr::UsdStage>& p) {
    p->SetStartTimeCode(5);
}
pxr::TfRefPtr<pxr::UsdStage> xlarcf_cpp::smartStage_return(const std::string& path) {
    return pxr::UsdStage::CreateNew(path);
}


void xlarcf_cpp::smartLayer_passStrong(const pxr::TfRefPtr<pxr::SdfLayer>& p) {
    p->SetStartTimeCode(5);
}
void xlarcf_cpp::smartLayer_passWeak(const pxr::TfWeakPtr<pxr::SdfLayer>& p) {
    p->SetStartTimeCode(5);
}
pxr::TfRefPtr<pxr::SdfLayer> xlarcf_cpp::smartLayer_return(const std::string& path) {
    return pxr::SdfLayer::CreateNew(path);
}



void xlarcf_cpp::smartLayerFromStage_passStrong(const pxr::TfRefPtr<pxr::SdfLayer>& p) {
    p->SetStartTimeCode(5);
}
void xlarcf_cpp::smartLayerFromStage_passWeak(const pxr::TfWeakPtr<pxr::SdfLayer>& p) {
    p->SetStartTimeCode(5);
}
pxr::TfRefPtr<pxr::SdfLayer> xlarcf_cpp::smartLayerFromStage_return(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> stage = pxr::UsdStage::CreateNew(path);
    pxr::TfRefPtr<pxr::SdfLayer> layer = pxr::TfRefPtr<pxr::SdfLayer>(stage->GetRootLayer());
    return layer;
}


void xlarcf_cpp::rawStage_cppPass(pxr::UsdStage* _Nonnull raw) {
    pxr::TfRefPtr<pxr::UsdStage> stage = SwiftUsd::TakeFunctionParameterFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(raw);
    stage->SetStartTimeCode(5);
}
pxr::UsdStage* xlarcf_cpp::rawStage_return(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temp = pxr::UsdStage::CreateNew(path);
    pxr::UsdStage* rawStage = SwiftUsd::PassToSwiftAsReturnValue(temp);
    return rawStage;
}
void xlarcf_cpp::rawLayer_cppPass(pxr::SdfLayer* _Nonnull raw) {
    pxr::TfRefPtr<pxr::SdfLayer> layer = SwiftUsd::TakeFunctionParameterFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(raw);
    layer->SetStartTimeCode(5);
}
pxr::SdfLayer* xlarcf_cpp::rawLayer_return(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temp = pxr::SdfLayer::CreateNew(path);
    pxr::SdfLayer* rawLayer = SwiftUsd::PassToSwiftAsReturnValue(temp);
    return rawLayer;
}
void xlarcf_cpp::rawLayerFromStage_cppPass(pxr::SdfLayer* _Nonnull raw) {
    pxr::TfRefPtr<pxr::SdfLayer> layer = SwiftUsd::TakeFunctionParameterFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(raw);
    layer->SetStartTimeCode(5);
}
pxr::SdfLayer* xlarcf_cpp::rawLayerFromStage_return(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temp = pxr::UsdStage::CreateNew(path)->GetRootLayer();
    pxr::SdfLayer* rawLayer = SwiftUsd::PassToSwiftAsReturnValue(temp);
    return rawLayer;
}


#if MULTI_TARGET_INTEROP
// Here's the actual function pointer table
namespace _xLanguageARC_functionPointers_swift {
    void (^_Nonnull smartStage_passStrong)(const pxr::UsdStageRefPtr*_Nonnull);
    void (^_Nonnull smartStage_passWeak)(const pxr::UsdStageWeakPtr*_Nonnull);
    void (^_Nonnull smartStage_return)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::UsdStage>*_Nonnull);
    void (^_Nonnull smartLayer_passStrong)(const pxr::SdfLayerRefPtr*_Nonnull);
    void (^_Nonnull smartLayer_passWeak)(const pxr::SdfLayerHandle*_Nonnull);
    void (^_Nonnull smartLayer_return)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::SdfLayer>*_Nonnull);
    void (^_Nonnull smartLayerFromStage_passStrong)(const pxr::SdfLayerRefPtr*_Nonnull);
    void (^_Nonnull smartLayerFromStage_passWeak)(const pxr::SdfLayerHandle*_Nonnull);
    void (^_Nonnull smartLayerFromStage_return)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::SdfLayer>*_Nonnull);
 
    void (^_Nonnull rawStage_passBorrowing)(pxr::UsdStage*_Nonnull);
    void (^_Nonnull rawStage_passConsuming)(pxr::UsdStage*_Nonnull);
    void (^_Nonnull rawStage_return)(const std::string*_Nonnull, pxr::UsdStage* _Nonnull*_Nonnull);
    void (^_Nonnull rawLayer_passBorrowing)(pxr::SdfLayer*_Nonnull);
    void (^_Nonnull rawLayer_passConsuming)(pxr::SdfLayer*_Nonnull);
    void (^_Nonnull rawLayer_return)(const std::string*_Nonnull, pxr::SdfLayer* _Nonnull*_Nonnull);
    void (^_Nonnull rawLayerFromStage_passBorrowing)(pxr::SdfLayer*_Nonnull);
    void (^_Nonnull rawLayerFromStage_passConsuming)(pxr::SdfLayer*_Nonnull);
    void (^_Nonnull rawLayerFromStage_return)(const std::string*_Nonnull, pxr::SdfLayer* _Nonnull*_Nonnull);
};

// Swift needs to call these setters, because Swift assigning to the above function pointer table
// raises a duplicate symbol definition linker error
void _xLanguageARC_functionPointers_swift::set_smartStage_passStrong(void (^_Nonnull x)(const pxr::UsdStageRefPtr*_Nonnull)) { smartStage_passStrong = x; }
void _xLanguageARC_functionPointers_swift::set_smartStage_passWeak(void (^_Nonnull x)(const pxr::UsdStageWeakPtr*_Nonnull)) { smartStage_passWeak = x; }
void _xLanguageARC_functionPointers_swift::set_smartStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::UsdStage>*_Nonnull)) { smartStage_return = x; }
void _xLanguageARC_functionPointers_swift::set_smartLayer_passStrong(void (^_Nonnull x)(const pxr::SdfLayerRefPtr*_Nonnull)) { smartLayer_passStrong = x; }
void _xLanguageARC_functionPointers_swift::set_smartLayer_passWeak(void (^_Nonnull x)(const pxr::SdfLayerHandle*_Nonnull)) { smartLayer_passWeak = x; }
void _xLanguageARC_functionPointers_swift::set_smartLayer_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::SdfLayer>*_Nonnull)) { smartLayer_return = x; }
void _xLanguageARC_functionPointers_swift::set_smartLayerFromStage_passStrong(void (^_Nonnull x)(const pxr::SdfLayerRefPtr*_Nonnull)) { smartLayerFromStage_passStrong = x; }
void _xLanguageARC_functionPointers_swift::set_smartLayerFromStage_passWeak(void (^_Nonnull x)(const pxr::SdfLayerHandle*_Nonnull)) { smartLayerFromStage_passWeak = x; }
void _xLanguageARC_functionPointers_swift::set_smartLayerFromStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::TfRefPtr<pxr::SdfLayer>*_Nonnull)) { smartLayerFromStage_return = x; }
 
void _xLanguageARC_functionPointers_swift::set_rawStage_passBorrowing(void (^_Nonnull x)(pxr::UsdStage*_Nonnull)) { rawStage_passBorrowing = x; }
void _xLanguageARC_functionPointers_swift::set_rawStage_passConsuming(void (^_Nonnull x)(pxr::UsdStage*_Nonnull)) { rawStage_passConsuming = x; }
void _xLanguageARC_functionPointers_swift::set_rawStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::UsdStage* _Nonnull*_Nonnull)) { rawStage_return = x; }
void _xLanguageARC_functionPointers_swift::set_rawLayer_passBorrowing(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull)) { rawLayer_passBorrowing = x; }
void _xLanguageARC_functionPointers_swift::set_rawLayer_passConsuming(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull)) { rawLayer_passConsuming = x; }
void _xLanguageARC_functionPointers_swift::set_rawLayer_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::SdfLayer* _Nonnull*_Nonnull)) { rawLayer_return = x; }
void _xLanguageARC_functionPointers_swift::set_rawLayerFromStage_passBorrowing(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull)) { rawLayerFromStage_passBorrowing = x; }
void _xLanguageARC_functionPointers_swift::set_rawLayerFromStage_passConsuming(void (^_Nonnull x)(pxr::SdfLayer*_Nonnull)) { rawLayerFromStage_passConsuming = x; }
void _xLanguageARC_functionPointers_swift::set_rawLayerFromStage_return(void (^_Nonnull x)(const std::string*_Nonnull, pxr::SdfLayer* _Nonnull*_Nonnull)) { rawLayerFromStage_return = x; }

// Hide the fact that the function pointer table uses pointers as function arguments instead of values by
// wrapping it, so that the Xcode and SPM cases have the same interface when called from the bodies of tests. 
namespace _xLanguageARC_swift_interface {
    namespace impl = _xLanguageARC_functionPointers_swift;
    
    void smartStage_passStrong(pxr::UsdStageRefPtr a0) {
        impl::smartStage_passStrong(&a0);
    }
    void smartStage_passWeak(pxr::UsdStageWeakPtr a0) {
        impl::smartStage_passWeak(&a0);
    }
    pxr::TfRefPtr<pxr::UsdStage> smartStage_return(std::string a0) {
        pxr::TfRefPtr<pxr::UsdStage> a1 = nullptr;
        impl::smartStage_return(&a0, &a1);
        return a1;
    }
    void smartLayer_passStrong(pxr::SdfLayerRefPtr a0) {
        impl::smartLayer_passStrong(&a0);
    }
    void smartLayer_passWeak(pxr::SdfLayerHandle a0) {
        impl::smartLayer_passWeak(&a0);
    }
    pxr::TfRefPtr<pxr::SdfLayer> smartLayer_return(std::string a0) {
        pxr::TfRefPtr<pxr::SdfLayer> a1 = nullptr;
        impl::smartLayer_return(&a0, &a1);
        return a1;
    }
    void smartLayerFromStage_passStrong(pxr::SdfLayerRefPtr a0) {
        impl::smartLayerFromStage_passStrong(&a0);
    }
    void smartLayerFromStage_passWeak(pxr::SdfLayerHandle a0) {
        impl::smartLayerFromStage_passWeak(&a0);
    }
    pxr::TfRefPtr<pxr::SdfLayer> smartLayerFromStage_return(std::string a0) {
        pxr::TfRefPtr<pxr::SdfLayer> a1 = nullptr;
        impl::smartLayerFromStage_return(&a0, &a1);
        return a1;
    }
    
    void rawStage_passBorrowing(pxr::UsdStage* _Nonnull a0) {
        impl::rawStage_passBorrowing(a0);
    }
    void rawStage_passConsuming(pxr::UsdStage* _Nonnull a0) {
        impl::rawStage_passConsuming(a0);
    }
    pxr::UsdStage* rawStage_return(std::string a0) {
        pxr::UsdStage* a1 = nullptr;
        impl::rawStage_return(&a0, &a1);
        return a1;
    }
    void rawLayer_passBorrowing(pxr::SdfLayer* _Nonnull a0) {
        impl::rawLayer_passBorrowing(a0);
    }
    void rawLayer_passConsuming(pxr::SdfLayer* _Nonnull a0) {
        impl::rawLayer_passConsuming(a0);
    }
    pxr::SdfLayer* rawLayer_return(std::string a0) {
        pxr::SdfLayer* a1 = nullptr;
        impl::rawLayer_return(&a0, &a1);
        return a1;
    }
    void rawLayerFromStage_passBorrowing(pxr::SdfLayer* _Nonnull a0) {
        impl::rawLayerFromStage_passBorrowing(a0);
    }
    void rawLayerFromStage_passConsuming(pxr::SdfLayer* _Nonnull a0) {
        impl::rawLayerFromStage_passConsuming(a0);
    }
    pxr::SdfLayer* rawLayerFromStage_return(std::string a0) {
        pxr::SdfLayer* a1 = nullptr;
        impl::rawLayerFromStage_return(&a0, &a1);
        return a1;
    }
}
#endif












namespace xltest = _xLanguageARC_tests;
#if MULTI_TARGET_INTEROP
namespace xlarcf_swift = _xLanguageARC_swift_interface;
#else
typedef UnitTests::_xLanguageARC_functions_swift xlarcf_swift;
#endif

// MARK: SmartStage
void xltest::smartStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_swift::smartStage_return(path);
    xlarcf_swift::smartStage_passStrong(temporary);
}
void xltest::smartStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_swift::smartStage_return(path);
    xlarcf_swift::smartStage_passWeak(pxr::TfWeakPtr<pxr::UsdStage>(temporary));
}
void xltest::smartStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_swift::smartStage_return(path);
    xlarcf_cpp::smartStage_passStrong(temporary);
}
void xltest::smartStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_swift::smartStage_return(path);
    xlarcf_cpp::smartStage_passWeak(temporary);
}

void xltest::smartStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    xlarcf_swift::smartStage_passStrong(xlarcf_swift::smartStage_return(path));
}
void xltest::smartStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    xlarcf_swift::smartStage_passWeak(xlarcf_swift::smartStage_return(path));
}
void xltest::smartStage_swiftReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path) {
    xlarcf_cpp::smartStage_passStrong(xlarcf_swift::smartStage_return(path));
}
void xltest::smartStage_swiftReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path) {
    xlarcf_cpp::smartStage_passWeak(xlarcf_swift::smartStage_return(path));
}


void xltest::smartStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_cpp::smartStage_return(path);
    xlarcf_swift::smartStage_passStrong(temporary);
}
void xltest::smartStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_cpp::smartStage_return(path);
    xlarcf_swift::smartStage_passWeak(temporary);
}
void xltest::smartStage_cppReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_cpp::smartStage_return(path);
    xlarcf_cpp::smartStage_passStrong(temporary);
}
void xltest::smartStage_cppReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = xlarcf_cpp::smartStage_return(path);
    xlarcf_cpp::smartStage_passWeak(temporary);
}

void xltest::smartStage_cppReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    xlarcf_swift::smartStage_passStrong(xlarcf_cpp::smartStage_return(path));
}
void xltest::smartStage_cppReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    xlarcf_swift::smartStage_passWeak(xlarcf_cpp::smartStage_return(path));
}
void xltest::smartStage_cppReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path) {
    xlarcf_cpp::smartStage_passStrong(xlarcf_cpp::smartStage_return(path));
}
void xltest::smartStage_cppReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path) {
    xlarcf_cpp::smartStage_passWeak(xlarcf_cpp::smartStage_return(path));
}




// MARK: RawStage
void xltest::rawStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_swift::rawStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_swift::rawStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawStage_swiftReturn_holdTemporary_cppPass_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_cpp::rawStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    // Leaks memory:
    // xlarcf_swift::rawStage_passBorrowing(xlarcf_swift::rawStage_return(path));
    //
    // Triggers static_assert:
    // xlarcf_swift::rawStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path))));
    // Thus, the correct way is to use a temporary, despite being a noTemporary test case:
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_swift::rawStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_swift::rawStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawStage_swiftReturn_noTemporary_cppPass_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_cpp::rawStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_cpp::rawStage_return(path));
    xlarcf_swift::rawStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_cpp::rawStage_return(path));
    xlarcf_swift::rawStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawStage_cppReturn_holdTemporary_cppPass_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::UsdStage> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_cpp::rawStage_return(path));
    xlarcf_cpp::rawStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_swift::rawStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_swift::rawStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawStage_cppReturn_noTemporary_cppPass_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::UsdStage>>(xlarcf_swift::rawStage_return(path));
    xlarcf_cpp::rawStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}





// MARK: SmartLayer
void xltest::smartLayer_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayer_return(path);
    xlarcf_swift::smartLayer_passStrong(temporary);
}
void xltest::smartLayer_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayer_return(path);
    xlarcf_swift::smartLayer_passWeak(temporary);
}
void xltest::smartLayer_swiftReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayer_return(path);
    xlarcf_cpp::smartLayer_passStrong(temporary);
}
void xltest::smartLayer_swiftReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayer_return(path);
    xlarcf_cpp::smartLayer_passWeak(temporary);
}
void xltest::smartLayer_swiftReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayer_passStrong(xlarcf_swift::smartLayer_return(path));
}
void xltest::smartLayer_swiftReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayer_passWeak(xlarcf_swift::smartLayer_return(path));
}
void xltest::smartLayer_swiftReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayer_passStrong(xlarcf_swift::smartLayer_return(path));
}
void xltest::smartLayer_swiftReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayer_passWeak(xlarcf_swift::smartLayer_return(path));
}
void xltest::smartLayer_cppReturn_holdTemporary_swiftPass_strong_swiftEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayer_return(path);
    xlarcf_swift::smartLayer_passStrong(temporary);
}
void xltest::smartLayer_cppReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayer_return(path);
    xlarcf_swift::smartLayer_passWeak(temporary);
}
void xltest::smartLayer_cppReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayer_return(path);
    xlarcf_cpp::smartLayer_passStrong(temporary);
}
void xltest::smartLayer_cppReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayer_return(path);
    xlarcf_cpp::smartLayer_passWeak(temporary);
}
void xltest::smartLayer_cppReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayer_passStrong(xlarcf_cpp::smartLayer_return(path));
}
void xltest::smartLayer_cppReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayer_passWeak(xlarcf_cpp::smartLayer_return(path));
}
void xltest::smartLayer_cppReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayer_passStrong(xlarcf_cpp::smartLayer_return(path));
}
void xltest::smartLayer_cppReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayer_passWeak(xlarcf_cpp::smartLayer_return(path));
}




void xltest::rawLayer_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayer_return(path));
    xlarcf_swift::rawLayer_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayer_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayer_return(path));
    xlarcf_swift::rawLayer_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayer_swiftReturn_holdTemporary_cppPass_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayer_return(path));
    xlarcf_cpp::rawLayer_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayer_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayer_return(path));
    xlarcf_swift::rawLayer_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayer_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayer_return(path));
    xlarcf_swift::rawLayer_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayer_swiftReturn_noTemporary_cppPass_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayer_return(path));
    xlarcf_cpp::rawLayer_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayer_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayer_return(path));
    xlarcf_swift::rawLayer_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayer_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayer_return(path));
    xlarcf_swift::rawLayer_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayer_cppReturn_holdTemporary_cppPass_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayer_return(path));
    xlarcf_cpp::rawLayer_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayer_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayer_return(path));
    xlarcf_swift::rawLayer_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayer_cppReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayer_return(path));
    xlarcf_swift::rawLayer_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayer_cppReturn_noTemporary_cppPass_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayer_return(path));
    xlarcf_cpp::rawLayer_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}





void xltest::smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayerFromStage_return(path);
    xlarcf_swift::smartLayerFromStage_passStrong(temporary);
}
void xltest::smartLayerFromStage_swiftReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayerFromStage_return(path);
    xlarcf_swift::smartLayerFromStage_passWeak(temporary);
}
void xltest::smartLayerFromStage_swiftReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayerFromStage_return(path);
    xlarcf_cpp::smartLayerFromStage_passStrong(temporary);
}
void xltest::smartLayerFromStage_swiftReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_swift::smartLayerFromStage_return(path);
    xlarcf_cpp::smartLayerFromStage_passWeak(temporary);
}
void xltest::smartLayerFromStage_swiftReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayerFromStage_passStrong(xlarcf_swift::smartLayerFromStage_return(path));
}
void xltest::smartLayerFromStage_swiftReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayerFromStage_passWeak(xlarcf_swift::smartLayerFromStage_return(path));
}
void xltest::smartLayerFromStage_swiftReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayerFromStage_passStrong(xlarcf_swift::smartLayerFromStage_return(path));
}
void xltest::smartLayerFromStage_swiftReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayerFromStage_passWeak(xlarcf_swift::smartLayerFromStage_return(path));
}
void xltest::smartLayerFromStage_cppReturn_holdTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayerFromStage_return(path);
    xlarcf_swift::smartLayerFromStage_passStrong(temporary);
}
void xltest::smartLayerFromStage_cppReturn_holdTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayerFromStage_return(path);
    xlarcf_swift::smartLayerFromStage_passWeak(temporary);
}
void xltest::smartLayerFromStage_cppReturn_holdTemporary_cppPass_strong_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayerFromStage_return(path);
    xlarcf_cpp::smartLayerFromStage_passStrong(temporary);
}
void xltest::smartLayerFromStage_cppReturn_holdTemporary_cppPass_weak_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = xlarcf_cpp::smartLayerFromStage_return(path);
    xlarcf_cpp::smartLayerFromStage_passWeak(temporary);
}
void xltest::smartLayerFromStage_cppReturn_noTemporary_swiftPass_strong_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayerFromStage_passStrong(xlarcf_cpp::smartLayerFromStage_return(path));
}
void xltest::smartLayerFromStage_cppReturn_noTemporary_swiftPass_weak_cppEntry(const std::string& path) {
    xlarcf_swift::smartLayerFromStage_passWeak(xlarcf_cpp::smartLayerFromStage_return(path));
}
void xltest::smartLayerFromStage_cppReturn_noTemporary_cppPass_strong_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayerFromStage_passStrong(xlarcf_cpp::smartLayerFromStage_return(path));
}
void xltest::smartLayerFromStage_cppReturn_noTemporary_cppPass_weak_cppEntry(const std::string& path) {
    xlarcf_cpp::smartLayerFromStage_passWeak(xlarcf_cpp::smartLayerFromStage_return(path));
}



void xltest::rawLayerFromStage_swiftReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayerFromStage_swiftReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayerFromStage_swiftReturn_holdTemporary_cppPass_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayerFromStage_return(path));
    xlarcf_cpp::rawLayerFromStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayerFromStage_swiftReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayerFromStage_swiftReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayerFromStage_swiftReturn_noTemporary_cppPass_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_swift::rawLayerFromStage_return(path));
    xlarcf_cpp::rawLayerFromStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayerFromStage_cppReturn_holdTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayerFromStage_cppReturn_holdTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayerFromStage_cppReturn_holdTemporary_cppPass_cppEntry(const std::string& path) {
    pxr::TfRefPtr<pxr::SdfLayer> temporary = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayerFromStage_return(path));
    xlarcf_cpp::rawLayerFromStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temporary));
}
void xltest::rawLayerFromStage_cppReturn_noTemporary_swiftPassBorrowing_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passBorrowing(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayerFromStage_cppReturn_noTemporary_swiftPassConsuming_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayerFromStage_return(path));
    xlarcf_swift::rawLayerFromStage_passConsuming(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
void xltest::rawLayerFromStage_cppReturn_noTemporary_cppPass_cppEntry(const std::string& path) {
    auto temp = SwiftUsd::TakeReturnValueFromSwift<pxr::TfRefPtr<pxr::SdfLayer>>(xlarcf_cpp::rawLayerFromStage_return(path));
    xlarcf_cpp::rawLayerFromStage_cppPass(SwiftUsd::PassToSwiftAsFunctionParameter(temp));
}
