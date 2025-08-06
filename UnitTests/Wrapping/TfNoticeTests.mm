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

#include "TfNoticeTests.hpp"
#include "pxr/base/tf/notice.h"
#include "pxr/usd/usd/stage.h"
#include "pxr/base/tf/refPtr.h"
#include "pxr/usd/usd/prim.h"
#include "pxr/usd/usd/notice.h"

bool _xLanguage_TfNotice::test_revokeOneCppKeyViaSwiftUsd() {
    bool testPasses = true;
    
    struct Listener: public pxr::TfWeakBase {
        Listener() {
            key = pxr::TfNotice::Register(pxr::TfCreateWeakPtr(this), &Listener::HandleCallback);
        }
        
        void HandleCallback(const pxr::UsdNotice::StageContentsChanged&) {
            callbackCount += 1;
        }
        
        pxr::TfNotice::Key key;
        int callbackCount = 0;
    };
    
    Listener l;
    auto stage = pxr::UsdStage::CreateInMemory();
    testPasses &= l.callbackCount == 0;
    
    stage->SetStartTimeCode(5);
    testPasses &= l.callbackCount == 1;
    
    stage->SetStartTimeCode(6);
    testPasses &= l.callbackCount == 2;
    
    pxr::TfNotice::Revoke(l.key);
    testPasses &= l.callbackCount == 2;
    
    stage->SetStartTimeCode(7);
    testPasses &= l.callbackCount == 2;
    
    return testPasses;
}

bool _xLanguage_TfNotice::test_revokeManyCppKeyViaSwiftUsd() {
    bool testPasses = true;
    
    struct Listener: public pxr::TfWeakBase {
        Listener(pxr::UsdStageWeakPtr p) {
            key = pxr::TfNotice::Register(pxr::TfCreateWeakPtr(this), &Listener::HandleCallback, p);
        }
        
        void HandleCallback(const pxr::UsdNotice::StageContentsChanged&) {
            callbackCount += 1;
        }
        
        pxr::TfNotice::Key key;
        int callbackCount = 0;
    };
    
    auto stage1 = pxr::UsdStage::CreateInMemory();
    auto stage2 = pxr::UsdStage::CreateInMemory();
    
    Listener l1(stage1);
    Listener l2(stage2);
    testPasses &= l1.callbackCount == 0;
    testPasses &= l2.callbackCount == 0;
    
    stage1->SetStartTimeCode(5);
    testPasses &= l1.callbackCount == 1;
    testPasses &= l2.callbackCount == 0;

    stage2->SetStartTimeCode(6);
    testPasses &= l1.callbackCount == 1;
    testPasses &= l2.callbackCount == 1;

    stage1->SetStartTimeCode(7);
    testPasses &= l1.callbackCount == 2;
    testPasses &= l2.callbackCount == 1;

    stage2->SetStartTimeCode(8);
    testPasses &= l1.callbackCount == 2;
    testPasses &= l2.callbackCount == 2;
    
    pxr::TfNotice::Keys keys = {l1.key, l2.key};
    pxr::TfNotice::Revoke(&keys);
    testPasses &= keys.empty();
        
    stage1->SetStartTimeCode(9);
    testPasses &= l1.callbackCount == 2;
    testPasses &= l2.callbackCount == 2;

    stage2->SetStartTimeCode(10);
    testPasses &= l1.callbackCount == 2;
    testPasses &= l2.callbackCount == 2;

    return testPasses;
}

bool _xLanguage_TfNotice::test_revokeOneSwiftKeyViaSwiftUsd(pxr::UsdStage* _stage, pxr::TfNotice::SwiftKey key, int (^callbackCount)()) {
    auto stage = SwiftUsd::TakeFunctionParameterFromSwift<pxr::UsdStageRefPtr>(_stage);
    
    bool testPasses = true;
    
    testPasses &= callbackCount() == 0;
    
    stage->SetStartTimeCode(5);
    testPasses &= callbackCount() == 1;
    
    stage->SetStartTimeCode(6);
    testPasses &= callbackCount() == 2;
    
    pxr::TfNotice::Revoke(key);
    testPasses &= callbackCount() == 2;
    
    stage->SetStartTimeCode(7);
    testPasses &= callbackCount() == 2;
    
    return testPasses;
}

bool _xLanguage_TfNotice::test_revokeManySwiftKeyViaSwiftUsd(pxr::UsdStage* _stage1, pxr::TfNotice::SwiftKey key1, int (^callbackCount1)(), pxr::UsdStage* _stage2, pxr::TfNotice::SwiftKey key2, int (^callbackCount2)()) {
    auto stage1 = SwiftUsd::TakeFunctionParameterFromSwift<pxr::UsdStageRefPtr>(_stage1);
    auto stage2 = SwiftUsd::TakeFunctionParameterFromSwift<pxr::UsdStageRefPtr>(_stage2);
    
    bool testPasses = true;
    
    testPasses &= callbackCount1() == 0;
    testPasses &= callbackCount2() == 0;
    
    stage1->SetStartTimeCode(5);
    testPasses &= callbackCount1() == 1;
    testPasses &= callbackCount2() == 0;

    stage2->SetStartTimeCode(6);
    testPasses &= callbackCount1() == 1;
    testPasses &= callbackCount2() == 1;

    stage1->SetStartTimeCode(7);
    testPasses &= callbackCount1() == 2;
    testPasses &= callbackCount2() == 1;

    stage2->SetStartTimeCode(8);
    testPasses &= callbackCount1() == 2;
    testPasses &= callbackCount2() == 2;
    
    pxr::TfNotice::SwiftKeys keys = {key1, key2};
    pxr::TfNotice::Revoke(&keys);
    testPasses &= keys.empty();
        
    stage1->SetStartTimeCode(9);
    testPasses &= callbackCount1() == 2;
    testPasses &= callbackCount2() == 2;

    stage2->SetStartTimeCode(10);
    testPasses &= callbackCount1() == 2;
    testPasses &= callbackCount2() == 2;

    return testPasses;
}

bool _xLanguage_TfNotice::test_promoteCppKeyInCpp() {
    bool testPasses = true;
    
    struct Listener: public pxr::TfWeakBase {
        Listener() {
            key = pxr::TfNotice::Register(pxr::TfCreateWeakPtr(this), &Listener::HandleCallback);
        }
        
        void HandleCallback(const pxr::UsdNotice::StageContentsChanged&) {
            callbackCount += 1;
        }
        
        pxr::TfNotice::SwiftKey key;
        int callbackCount = 0;
    };
    
    Listener l;
    auto stage = pxr::UsdStage::CreateInMemory();
    testPasses &= l.callbackCount == 0;
    
    stage->SetStartTimeCode(5);
    testPasses &= l.callbackCount == 1;
    
    stage->SetStartTimeCode(6);
    testPasses &= l.callbackCount == 2;
    
    pxr::TfNotice::Revoke(l.key);
    testPasses &= l.callbackCount == 2;
    
    stage->SetStartTimeCode(7);
    testPasses &= l.callbackCount == 2;
    
    return testPasses;
}

std::pair<pxr::TfNotice::Key, int (^)()> _xLanguage_TfNotice::test_promoteCppKeyInSwift() {
    struct Listener: public pxr::TfWeakBase {
        Listener() {
            key = pxr::TfNotice::Register(pxr::TfCreateWeakPtr(this), &Listener::HandleCallback);
        }
        
        void HandleCallback(const pxr::UsdNotice::StageContentsChanged&) {
            callbackCount += 1;
        }
        
        pxr::TfNotice::Key key;
        int callbackCount = 0;
    };
    
    // Leak the listener so it lives forever.
    // It's a small amount of memory in a unit test, so this is fine
    Listener* l = new Listener();
    
    return {l->key, ^int(){ return l->callbackCount; }};
}
