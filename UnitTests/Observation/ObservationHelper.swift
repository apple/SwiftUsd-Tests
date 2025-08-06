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

extension String: Error {}

class ObservationHelper: TemporaryDirectoryHelper {
    // When `true`, Observation tests won't check for observation notifications.
    // This is useful because we haven't fully implemented Observation, but we
    // still want to enable the tests to help catch potential regressions.
    // Though, it is fairly unlikely a regression would be caught by one of them,
    // since they just check that properties have changed as expected.
    static let DISABLE_NOTIFICATION_ASSERTIONS = true

    
    // MARK: private implementation
    
    typealias Token = UUID
    
    private struct Context {
        var notifications = [Token]()
    }
    private var context = [Context]()
    
    private func _pushContext() {
        context.append(.init())
    }
    
    private func _popContext() -> [Token] {
        context.popLast()?.notifications ?? []
    }
    
    private func _gotNotification(_ token: Token) {
        if context.isEmpty { return }
        context[context.count - 1].notifications.append(token)
    }
    
    // Should not be autoclosure because this is the private implementation!
    private func _registerNotification<T>(_ token: Token, _ code: @escaping () -> (T)) -> T {
        if Self.DISABLE_NOTIFICATION_ASSERTIONS { return code() }
        
        
        return withObservationTracking {
            code()
        } onChange: {
            self._gotNotification(token)
            _ = self._registerNotification(token, code)
        }
    }
        
    private func _catchNotification<T>(code: () -> (T), notificationsHandler: @escaping ([Token]) -> (Result<Void, String>)) -> T {
        if Self.DISABLE_NOTIFICATION_ASSERTIONS { return code() }
        
        let succeedExpectation = XCTestExpectation()
        succeedExpectation.expectationDescription = "Succeed expectation"
        succeedExpectation.assertForOverFulfill = true
        
        let failExpectation = XCTestExpectation()
        failExpectation.isInverted = true
        failExpectation.expectationDescription = "Fail expectation"
        failExpectation.assertForOverFulfill = true
        
        defer { wait(for: [succeedExpectation, failExpectation], timeout: 0.25) }
        
        _pushContext()
        defer {
            DispatchQueue.main.async {
                switch notificationsHandler(self._popContext()) {
                case .success:
                    succeedExpectation.fulfill()
                    
                case let .failure(message):
                    failExpectation.expectationDescription = message
                    failExpectation.fulfill()
                }
            }
        }
        return code()
    }
    
    // MARK: Public API
    
    // MARK: registerNotification
    
    // Generic trailing and generic autoclosures, that return their return type
    @discardableResult
    func registerNotification<T>(_ code: @escaping () -> (T)) -> (token: Token, value: T) {
        let result = Token()
        return (result, _registerNotification(result, code))
    }
    
    @discardableResult
    func registerNotification<T>(_ code: @autoclosure @escaping () -> (T)) -> (token: Token, value: T) {
        let result = Token()
        return (result, _registerNotification(result, code))
    }
    
    
    // MARK: notExpectingNotification
    
    // Generic trailing and generic autoclosures, that return their return type
    @discardableResult
    func notExpectingNotification<T>(_ code: () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            notifications.isEmpty ? .success(()) : .failure("Got notification but expected none")
        }
    }
    
    @discardableResult
    func notExpectingNotification<T>(_ code: @autoclosure () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            notifications.isEmpty ? .success(()) : .failure("Got notification but expected none")
        }
    }
    
    
    // MARK: expectingAnyNotification
    
    // Generic trailing and generic autoclosures, that return their return type
    @discardableResult
    func expectingAnyNotification<T>(_ code: () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            notifications.isEmpty ? .failure("Expected any notification but got none") : .success(())
        }
    }
    
    @discardableResult
    func expectingAnyNotification<T>(_ code: @autoclosure () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            notifications.isEmpty ? .failure("Expected any notification but got none") : .success(())
        }
    }
    
    // MARK: expectingSomeNotifications
    
    @discardableResult
    func expectingSomeNotifications<T>(_ tokens: [Token], _ code: () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            notifications.contains(where: { tokens.contains($0) }) ? .success(()) : .failure("Expecting some notification in \(tokens) but got \(notifications)")
        }
    }
    
    @discardableResult
    func expectingSomeNotifications<T>(_ tokens: [Token], _ code: @autoclosure () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            notifications.contains { tokens.contains($0) } ? .success(()) : .failure("Expecting some notification in \(tokens) but got \(notifications)")
        }
    }
    
    // MARK: expectingAllNotifications
    
    @discardableResult
    func expectingAllNotifications<T>(_ tokens: [Token], _ code: () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            tokens.allSatisfy { notifications.contains($0) } ? .success(()) : .failure("Expecting all notifications in \(tokens) but got \(notifications) ")
        }
    }
    
    @discardableResult
    func expectingAllNotifications<T>(_ tokens: [Token], _ code: @autoclosure () -> (T)) -> T {
        _catchNotification(code: code) { notifications in
            tokens.allSatisfy { notifications.contains($0) } ? .success(()) : .failure("Expecting all notifications in \(tokens) but got \(notifications) ")
        }
    }
}
