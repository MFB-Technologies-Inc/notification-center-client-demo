// InternalTests.swift
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.

import Foundation
@testable import NotificationCenterClient
import XCTest

final class InternalTests: XCTestCase {
    func testAsyncStreamFromAsyncSequence() async throws {
        let originalStream = AsyncStream(Int.self, bufferingPolicy: .unbounded) { continuation in
            for int in 0 ..< 10 {
                continuation.yield(int)
            }
            continuation.finish()
        }

        let wrappedStream = AsyncStream(originalStream)

        let task = Task {
            var received = [Int]()
            for await int in wrappedStream {
                received.append(int)
            }
            return received
        }

        let finalReceived = await task.value
        XCTAssertEqual(finalReceived, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    }
}
