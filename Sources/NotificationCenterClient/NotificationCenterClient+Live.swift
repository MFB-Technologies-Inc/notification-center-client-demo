// NotificationCenterClient+Live.swift
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.

import Combine
import Foundation

public extension NotificationCenterClient {
    static func live(notificationCenter center: NotificationCenter = .default) -> Self {
        Self(
            publisher: { name, object in
                center.publisher(for: name, object: object).eraseToAnyPublisher()
            },
            stream: { name, object in
                AsyncStream(center.notifications(named: name, object: object))
            }
        )
    }
}
