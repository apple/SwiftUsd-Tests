//
//  ObservationTests.swift
//  UnitTests
//
//  Created by Maddy Adams on 12/19/23.
//

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
