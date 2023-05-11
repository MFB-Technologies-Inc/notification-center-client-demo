// Notification+Test.swift
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.

import Foundation

extension Notification {
    var testValue: Int? {
        userInfo?["value"] as? Int
    }

    static func test(value: Int) -> Notification {
        Notification(name: .test, userInfo: ["value": value])
    }
}

extension Notification.Name {
    static let test = Self(rawValue: "testNotification")
}
