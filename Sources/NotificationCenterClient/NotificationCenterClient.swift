// NotificationCenterClient.swift
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.

import Combine
import Foundation

/// Dependency injection client for NotificationCenter
public struct NotificationCenterClient: Sendable {
    private let _publisher: @Sendable (
        _ name: Notification.Name,
        _ object: AnyObject?
    ) async -> AnyPublisher<Notification, Never>
    private let _stream: @Sendable (
        _ name: Notification.Name,
        _ object: AnyObject?
    ) async -> AsyncStream<Notification>

    public init(
        @_inheritActorContext publisher: @escaping @Sendable (
            _ name: Notification.Name,
            _ object: AnyObject?
        ) async -> AnyPublisher<Notification, Never>,
        @_inheritActorContext stream: @escaping @Sendable (
            _ name: Notification.Name,
            _ object: AnyObject?
        ) async -> AsyncStream<Notification>
    ) {
        _publisher = publisher
        _stream = stream
    }

    public func publisher(
        name: Notification.Name,
        object: AnyObject? = nil
    ) async -> AnyPublisher<Notification, Never> {
        await _publisher(name, object)
    }

    public func stream(
        name: Notification.Name,
        object: AnyObject? = nil
    ) async -> AsyncStream<Notification> {
        await _stream(name, object)
    }
}
