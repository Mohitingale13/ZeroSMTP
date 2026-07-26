// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "zerosmtp-swift",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/Kitura/Swift-SMTP", from: "5.1.0")
    ],
    targets: [
        .executableTarget(
            name: "zerosmtp-swift",
            dependencies: [
                .product(name: "SwiftSMTP", package: "Swift-SMTP")
            ],
            path: ".",
            sources: ["swift-zerosmtp.swift"]
        )
    ]
)
