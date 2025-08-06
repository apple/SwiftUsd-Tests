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

import XCTest
import Observation

@Observable fileprivate class MyClass {
    var x = 4
    var y = 5
}

final class TestingObservationTests: ObservationHelper {
    
    // MARK: Tests of the testing system
        
    func test_receive_expectedNotification() {
        let c = MyClass()
        let (token, value) = registerNotification(c.x)
        XCTAssertEqual(value, 4)
        
        expectingSomeNotifications([token], c.x = 6)
        XCTAssertEqual(c.x, 6)
    }
    
    func test_receive_unexpectedNotification() {
        let c = MyClass()
        let (token, value) = registerNotification(c.x)
        XCTAssertEqual(value, 4)

        if !ObservationHelper.DISABLE_NOTIFICATION_ASSERTIONS {
            #if canImport(Darwin)
            XCTExpectFailure("We do expect a notification, because we read c.x and now we're changing c.x")
            #endif // #if canImport(Darwin)
        }
        notExpectingNotification(c.x = 6)
        XCTAssertEqual(c.x, 6)
        withExtendedLifetime(token) {}
    }
    
    func test_miss_expectedNotification() {
        let c = MyClass()
        let (token, value) = registerNotification(c.x)
        XCTAssertEqual(value, 4)
        
        if !ObservationHelper.DISABLE_NOTIFICATION_ASSERTIONS {
            #if canImport(Darwin)
            XCTExpectFailure("We don't expect a notification, because we're changing c.y without anyone reading it")
            #endif // #if canImport(Darwin)
        }
        expectingAnyNotification(c.y = 9)
        XCTAssertEqual(c.x, 4)
        withExtendedLifetime(token) {}
    }
    
    func test_miss_unexpectedNotification() {
        let c = MyClass()
        let (token, value) = registerNotification(c.x)
        XCTAssertEqual(value, 4)
        
        notExpectingNotification(c.x)
        XCTAssertEqual(c.x, 4)
        withExtendedLifetime(token) {}
    }
}
