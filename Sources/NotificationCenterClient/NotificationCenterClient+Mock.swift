// NotificationCenterClient+Mock.swift
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.

@preconcurrency import Combine
import Foundation

public extension NotificationCenterClient {
    static func mock(_ mockClient: MockNotificationCenterClient) -> Self {
        Self(publisher: mockClient.publisher, stream: mockClient.stream)
    }
}

public final class MockNotificationCenterClient: Sendable {
    private let subject: PassthroughSubject<Notification, Never>
    private let lock: NSLock

    @Sendable
    public func post(_ notification: Notification) {
        lock.lock()
        subject.send(notification)
        lock.unlock()
    }

    @Sendable
    public func publisher(name: Notification.Name, object: AnyObject?) async -> AnyPublisher<Notification, Never> {
        subject.filter { notification in
            notification.name == name
                && (notification.object as? AnyObject) === object
        }
        .eraseToAnyPublisher()
    }

    @Sendable
    public func stream(name _: Notification.Name, object _: AnyObject?) async -> AsyncStream<Notification> {
        AsyncStream(subject.values)
    }

    public init() {
        subject = PassthroughSubject()
        lock = NSLock()
    }
}
