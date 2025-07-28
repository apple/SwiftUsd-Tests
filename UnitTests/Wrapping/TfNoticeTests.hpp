//
//  TfNoticeTests.hpp
//  UnitTests
//
//  Created by Maddy Adams on 1/8/25.
//

#ifndef TfNoticeTests_hpp
#define TfNoticeTests_hpp

#include <stdio.h>
#include "swiftUsd/swiftUsd.h"
#include "pxr/base/tf/notice.h"
#include <utility>

namespace _xLanguage_TfNotice {
    bool test_revokeOneCppKeyViaSwiftUsd();
    bool test_revokeManyCppKeyViaSwiftUsd();
    bool test_revokeOneSwiftKeyViaSwiftUsd(pxr::UsdStage*, pxr::TfNotice::SwiftKey, int (^callbackCount)());
    bool test_revokeManySwiftKeyViaSwiftUsd(pxr::UsdStage*, pxr::TfNotice::SwiftKey, int (^callbackCount1)(), pxr::UsdStage*, pxr::TfNotice::SwiftKey, int (^callbackCount2)());
    
    
    bool test_promoteCppKeyInCpp();
    std::pair<pxr::TfNotice::Key, int (^)()> test_promoteCppKeyInSwift();
}

#endif /* TfNoticeTests_hpp */
