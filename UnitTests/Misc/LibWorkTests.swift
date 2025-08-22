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

import XCTest
import OpenUSD
import Synchronization

// Helper class that checks for parallel speedup of some serial work.
// Tries to look for relative speedups (default 4x) rather than fixed
// benchmarks
final fileprivate class ParallelismChecker {
    public struct Number: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
        public let debug: Double
        public let release: Double
        
        public init(floatLiteral: Double) {
            self.init(debug: floatLiteral, release: floatLiteral)
        }
        
        public init(integerLiteral: Int) {
            self.init(debug: Double(integerLiteral), release: Double(integerLiteral))
        }
        
        public init(debug: Double, release: Double) {
            self.debug = debug
            self.release = release
        }
        
        public var currentValue: Double {
            #if DEBUG
            debug
            #else
            release
            #endif
        }
    }
    
    private var name: String
    private var n: Int
    private var scopedTimerStart: Date?
    private var scopedTimerEnd: Date?
    private var serialDuration: Double = 0
    
    private func measure(_ work: (Int, ParallelismChecker) -> ()) -> Double {
        scopedTimerStart = nil
        scopedTimerEnd = nil
        
        let start = Date()
        work(n, self)
        let end = Date()
        
        if let scopedTimerStart, let scopedTimerEnd {
            return scopedTimerEnd.timeIntervalSince(scopedTimerStart)
        } else {
            return end.timeIntervalSince(start)
        }
    }
    
    private func measure(_ work: (Int, ParallelismChecker) async -> ()) async -> Double {
        scopedTimerStart = nil
        scopedTimerEnd = nil
        
        let start = Date()
        await work(n, self)
        let end = Date()
        
        if let scopedTimerStart, let scopedTimerEnd {
            return scopedTimerEnd.timeIntervalSince(scopedTimerStart)
        } else {
            return end.timeIntervalSince(start)
        }
    }
    
    // Tell the checker to only record the time for the code argument instead
    // of recording setup time as well
    public func time<T>(_ code: () -> (T)) -> T {
        guard scopedTimerStart == nil, scopedTimerEnd == nil else {
            fatalError("\(name): Cannot nest calls to time()")
        }
        
        scopedTimerStart = Date()
        let result = code()
        scopedTimerEnd = Date()
        return result
    }
    
    public func time<T>(_ code: () async -> (T)) async -> T {
        guard scopedTimerStart == nil, scopedTimerEnd == nil else {
            fatalError("\(name): Cannot nest calls to time()")
        }
        
        scopedTimerStart = Date()
        let result = await code()
        scopedTimerEnd = Date()
        return result
    }
        
    // Creates a checker with the given serial callback
    public static func withSerial(_ name: String,
                           minimumSize: Int = 8, maximumSize: Int = 1_000_000_000,
                           targetSerialDuration: Number = 1.0, _ code: (Int) -> ()) -> ParallelismChecker {
        ParallelismChecker.init(name, minimumSize, maximumSize, targetSerialDuration, { n, slf in code(n) })
    }
    
    // Creates a checker with the given serial callback
    public static func withSerial(_ name: String,
                           minimumSize: Int = 8, maximumSize: Int = 1_000_000_000,
                           targetSerialDuration: Number = 1.0, _ code: (Int, ParallelismChecker) -> ()) -> ParallelismChecker {
        ParallelismChecker.init(name, minimumSize, maximumSize, targetSerialDuration, code)
    }

    // Scales n by factors of 2 until the work takes at least targetSerialDuration
    private func growToTargetSerialDuration(minimumSize: Int, maximumSize: Int, targetSerialDuration: Number, work: (Int, ParallelismChecker) -> ()) {
        n = minimumSize
        while true {
            let timeForN = measure(work)
            if timeForN > targetSerialDuration.currentValue || n * 2 > maximumSize {
                serialDuration = timeForN
                print("\(name).SERIAL using n=\(n), serial=\(String(format: "%.4f", serialDuration))s (target was \(targetSerialDuration.currentValue)s)")
                return
            }
            n *= 2
        }
    }
    
    private init(_ name: String, _ minimumSize: Int, _ maximumSize: Int, _ targetSerialDuration: Number, _ code: (Int, ParallelismChecker) -> ()) {
        self.name = name
        self.n = minimumSize
        growToTargetSerialDuration(minimumSize: minimumSize, maximumSize: maximumSize, targetSerialDuration: targetSerialDuration, work: code)
    }
    
    private func report(_ name: String, _ elapsedTime: Double, _ maxFractionOfSerialTime: Number, file: StaticString, line: UInt) -> ParallelismChecker {
        func format(_ x: Double) -> String {
            String(format: "%.4f", x)
        }
        
        let maxAllowed = maxFractionOfSerialTime.currentValue * serialDuration
        let fractionOfSerial = elapsedTime / serialDuration
        XCTAssertLessThan(elapsedTime, maxAllowed, name, file: file, line: line)
        print("\(self.name).\(name)(\(n)) executed in \(format(elapsedTime))s, \(format(fractionOfSerial))x of \(format(serialDuration))s. max allowed was \(format(maxFractionOfSerialTime.currentValue))x => \(format(maxAllowed))s")
        return self
    }
    
    // Tells the checker to make sure the code argument executes quickly
    @discardableResult
    public func checkParallelism(_ name: String, maxFractionOfSerialTime: Number = 0.25,
                                 file: StaticString = #filePath, line: UInt = #line,
                                 _ code: (Int, ParallelismChecker) -> ()) -> ParallelismChecker {
        print("Checking parallelism of \(name)")
        let elapsedTime = measure(code)
        return report(name, elapsedTime, maxFractionOfSerialTime, file: file, line: line)
    }
    
    // Tells the checker to make sure the code argument executes quickly
    @discardableResult
    public func checkParallelism(_ name: String, maxFractionOfSerialTime: Number = 0.25,
                                 file: StaticString = #filePath, line: UInt = #line,
                                 _ code: (Int) -> ()) -> ParallelismChecker {
        checkParallelism(name, maxFractionOfSerialTime: maxFractionOfSerialTime, file: file, line: line, { (n, slf) in code(n) })
    }
    
    @discardableResult
    public func checkParallelism(_ name: String, maxFractionOfSerialTime: Number = 0.25,
                                 file: StaticString = #filePath, line: UInt = #line,
                                 _ code: (Int, ParallelismChecker) async -> ()) async -> ParallelismChecker {
        print("Checking parallelism of \(name)")
        let elapsedTime = await measure(code)
        return report(name, elapsedTime, maxFractionOfSerialTime, file: file, line: line)
    }
    
    @discardableResult
    public func checkParallelism(_ name: String, maxFractionOfSerialTime: Number = 0.25,
                                 file: StaticString = #filePath, line: UInt = #line,
                                 _ code: (Int) async -> ()) async -> ParallelismChecker {
        await checkParallelism(name, maxFractionOfSerialTime: maxFractionOfSerialTime, file: file, line: line, { (n, slf) in await code(n) })
    }
}

final class LibWorkTests: TemporaryDirectoryHelper {
    func test_detachedTask() {
        let flag = Mutex<Int>(0)
        let outerStart = Date()
        let detachedStart = Mutex<Date>(.now)
        let detachedEnd = Mutex<Date>(.now)
        
        pxr.WorkRunDetachedTask {
            detachedStart.withLock { $0 = Date() }
            Thread.sleep(forTimeInterval: 1.0)
            flag.withLock { $0 += 1 }
            Thread.sleep(forTimeInterval: 1.0)
            detachedEnd.withLock { $0 = Date() }
        }
        
        Thread.sleep(forTimeInterval: 3.0)
        
        let endFlag = flag.withLock { $0 }
        let endDetachedStart = detachedStart.withLock { $0 }
        let endDetachedEnd = detachedEnd.withLock { $0 }
        
        XCTAssertEqual(endFlag, 1)
        XCTAssertLessThan(Swift.abs(endDetachedStart.timeIntervalSince(outerStart)), 0.1)
        XCTAssertLessThan(Swift.abs(endDetachedEnd.timeIntervalSince(outerStart) - 2), 0.1)
    }
    
    func test_loops() async {
        func expectedSum(_ n: Int) -> Int { n * (n - 1) / 2 }
        
        // Cap N at ~4 billion, because Int64 can hold ~4 billion squared values,
        // and sum(0...N) ~= N^2
        await ParallelismChecker.withSerial("loops", maximumSize: 4_000_000_000) {
            var result = 0
            for i in 0..<$0 { result += i }
            XCTAssertEqual(result, expectedSum($0))
        }
        .checkParallelism("WorkSerialForN", maxFractionOfSerialTime: 1.3) {
            let result = Mutex<Int>(0)
            pxr.WorkSerialForN($0) {
                var tmp = 0
                for i in $0..<$1 { tmp += Int(i) }
                result.withLock { $0 += tmp }
            }
            XCTAssertEqual(result.withLock { $0 }, expectedSum($0))
        }
        .checkParallelism("WorkParallelForN_noGrain", maxFractionOfSerialTime: .init(debug: 0.85, release: 0.25)) {
            let result = Mutex<Int>(0)
            pxr.WorkParallelForN($0) {
                var tmp = 0
                for i in $0..<$1 { tmp += Int(i) }
                result.withLock { $0 += tmp }
            }
            XCTAssertEqual(result.withLock { $0 }, expectedSum($0))
        }
        .checkParallelism("WorkParallelForN_grain10", maxFractionOfSerialTime: .init(debug: 0.85, release: 0.25)) {
            let result = Mutex<Int>(0)
            pxr.WorkParallelForN($0, 10) {
                var tmp = 0
                for i in $0..<$1 { tmp += Int(i) }
                result.withLock { $0 += tmp }
            }
            XCTAssertEqual(result.withLock { $0 }, expectedSum($0))
        }
        .checkParallelism("WorkParallelForEach_manuallyPartitioned", maxFractionOfSerialTime: 0.65) {
            let result = Mutex<Int>(0)
            let bigCollection = Array(0..<$0)
            var partitions: [[Int]] = []
            let partitionSize = $0 / 1000
            for el in bigCollection {
                if partitions.isEmpty {
                    partitions = [[el]]
                } else if partitions.last!.count >= partitionSize {
                    partitions.append([el])
                } else {
                    partitions[partitions.count - 1].append(el)
                }
            }
            $1.time {
                pxr.WorkParallelForEach(partitions) { partition in
                    var tmp = 0
                    for el in partition { tmp += el }
                    result.withLock { $0 += tmp }
                }
            }
            XCTAssertEqual(result.withLock { $0 }, expectedSum($0))
        }
        .checkParallelism("TaskGroup no mutex", maxFractionOfSerialTime: .init(debug: 0.85, release: 0.25)) { n in
            let childCount = 32
            let result = await withTaskGroup { taskGroup in
                for i in 0..<childCount {
                    taskGroup.addTask {
                        var tmp = 0
                        for j in (i * n / childCount)..<(i + 1) * n / childCount {
                            tmp += j
                        }
                        return tmp
                    }
                }
                
                var tmp = 0
                for await child in taskGroup {
                    tmp += child
                }
                return tmp
            }
            XCTAssertEqual(result, expectedSum(n))
        }
    }
    
    func test_reduce() async {
        func getInput(_ n: Int) -> (minP: pxr.GfVec3d, maxP: pxr.GfVec3d, points: [pxr.GfVec3d]) {
            var points = Array<pxr.GfVec3d>()
            var minP = pxr.GfVec3d(1, 1, 1)
            var maxP = pxr.GfVec3d(0, 0, 0)
            
            for _ in 0..<n{
                let x = Double.random(in: 0...1)
                let y = Double.random(in: 0...1)
                let z = Double.random(in: 0...1)
                
                minP[0] = min(minP[0], x)
                minP[1] = min(minP[1], y)
                minP[2] = min(minP[2], z)
                
                maxP[0] = max(maxP[0], x)
                maxP[1] = max(maxP[1], y)
                maxP[2] = max(maxP[2], z)
                
                points.append(.init(x, y, z))
            }
            
            return (minP, maxP, points)
        }
        
        func checkOutput(_ minP: pxr.GfVec3d, _ maxP: pxr.GfVec3d, _ bbox: pxr.GfBBox3d, file: StaticString = #file, line: UInt = #line) {
            XCTAssertEqual(bbox.GetRange().GetMin(), minP, file: file, line: line)
            XCTAssertEqual(bbox.GetRange().GetMax(), maxP, file: file, line: line)
        }
        
        await ParallelismChecker.withSerial("reduce") {
            let (minP, maxP, points) = getInput($0)
            let bbox = $1.time {
                var bbox = pxr.GfBBox3d()
                for p in points {
                    let new = pxr.GfBBox3d(pxr.GfRange3d(p, p))
                    bbox = pxr.GfBBox3d.Combine(bbox, new)
                }
                return bbox
            }
            checkOutput(minP, maxP, bbox)
        }
        .checkParallelism("WorkParallelReduceN", maxFractionOfSerialTime: .init(debug: 0.4, release: 0.25)) {
            let (minP, maxP, points) = getInput($0)
            let bbox = $1.time {
                pxr.WorkParallelReduceN(pxr.GfBBox3d(),
                                        points.count,
                                        { (start, end, identity) in
                    var bbox = identity
                    
                    for i in start..<end {
                        let new = pxr.GfBBox3d(pxr.GfRange3d(points[i], points[i]))
                        bbox = pxr.GfBBox3d.Combine(bbox, new)
                    }
                    
                    return bbox
                }, pxr.GfBBox3d.Combine)
            }
            checkOutput(minP, maxP, bbox)
        }
        .checkParallelism("TaskGroup no mutex", maxFractionOfSerialTime: .init(debug: 0.4, release: 0.25)) { n, checker in
            let childCount = 32
            let (minP, maxP, points) = getInput(n)
            
            let bbox = await checker.time {
                await withTaskGroup { taskGroup in
                    for i in 0..<childCount {
                        taskGroup.addTask {
                            var bbox = pxr.GfBBox3d()
                            for j in (i * n / childCount)..<(i + 1) * n / childCount {
                                let new = pxr.GfBBox3d(pxr.GfRange3d(points[j], points[j]))
                                bbox = pxr.GfBBox3d.Combine(bbox, new)
                            }
                            return bbox
                        }
                    }
                    
                    var result: pxr.GfBBox3d!
                    for await child in taskGroup {
                        if result == nil { result = child }
                        else { result = pxr.GfBBox3d.Combine(result, child) }
                    }
                    return result
                }
            }
            checkOutput(minP, maxP, bbox!)
        }
    }
}
