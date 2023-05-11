// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "notification-center-client-demo",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15),
        .macCatalyst(.v15),
    ],
    products: [
        .library(
            name: "NotificationCenterClient",
            targets: ["NotificationCenterClient"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NotificationCenterClient",
            dependencies: [],
            swiftSettings: .shared
        ),
        .testTarget(
            name: "NotificationCenterClientTests",
            dependencies: ["NotificationCenterClient"],
            swiftSettings: .shared
        ),
    ]
)

extension [SwiftSetting] {
    static let shared: Self = [
        .enableUpcomingFeature("BareSlashRegexLiterals"),
        .enableUpcomingFeature("ConciseMagicFile"),
        .enableUpcomingFeature("ExistentailAny"),
        .enableUpcomingFeature("ForewardTrailingClosures"),
        .enableUpcomingFeature("ImplicitOpenExistentials"),
        .enableUpcomingFeature("StrictConcurrency"),
        .unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"]),
    ]
}
