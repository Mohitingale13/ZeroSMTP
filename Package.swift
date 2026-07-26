// swift-tools-version:6.3
import PackageDescription

let package = Package(
    name: "zerosmtp-swift",
    platforms: [.macOS(.v13)],
    dependencies: [
        // sersoft-gmbh/swift-smtp: actively maintained, SwiftNIO-based.
        // Replaces the previously used Kitura/Swift-SMTP, which is
        // unmaintained and fails to build against current OpenSSL.
        .package(url: "https://github.com/sersoft-gmbh/swift-smtp", from: "2.18.0")
    ],
    targets: [
        .executableTarget(
            name: "zerosmtp-swift",
            dependencies: [
                .product(name: "SwiftSMTP", package: "swift-smtp")
            ],
            path: ".",
            sources: ["swift-zerosmtp.swift"]
        )
    ]
)
