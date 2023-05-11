// LiveNotificationCenterClientTests.swift
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.

import Combine
import Foundation
import NotificationCenterClient
import XCTest

final class LiveNotificationCenterClientTests: XCTestCase {
    var cancellables = [AnyCancellable]()
    var client: NotificationCenterClient = .live()

    override func setUp() async throws {
        client = .live()
        try await super.setUp()
    }

    override func tearDown() async throws {
        cancellables.forEach { $0.cancel() }
        cancellables = []
        try await super.tearDown()
    }

    func testPublisher() async throws {
        let expectation1 = expectation(description: "Receive notification 1")
        let expectation2 = expectation(description: "Receive notification 2")

        var received = [Int]()

        await client.publisher(name: .test)
            .sink { notification in
                XCTAssertEqual(notification.name, .test)
                switch notification.testValue {
                case 1:
                    received.append(1)
                    NotificationCenter.default.post(Notification.test(value: 2))
                    expectation1.fulfill()
                case 2:
                    received.append(2)
                    expectation2.fulfill()
                default:
                    XCTFail("Invalid Notification.testValue of \(notification.testValue.debugDescription)")
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default.post(Notification.test(value: 1))

        await fulfillment(of: [expectation1, expectation2], timeout: 2)

        XCTAssertEqual(received, [1, 2])
    }

    func testStream() async throws {
        let task = Task { [client] in
            let stream = await client.stream(name: .test, object: nil)
            var received = [Int]()
            for await notification in stream {
                XCTAssertEqual(notification.name, .test)
                switch notification.testValue {
                case 1:
                    received.append(1)
                    NotificationCenter.default.post(Notification.test(value: 2))
                case 2:
                    received.append(2)
                    return received
                default:
                    XCTFail("Invalid Notification.testValue of \(notification.testValue.debugDescription)")
                    return received
                }
            }
            return received
        }

        NotificationCenter.default.post(Notification.test(value: 1))

        let finalValues = await task.value

        XCTAssertEqual(finalValues, [1, 2])
    }
}
