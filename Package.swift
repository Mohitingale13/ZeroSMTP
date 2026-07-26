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
                // `package:` must match the dependency's own declared
                // package name ("SwiftSMTP"), not its repository name
                // ("Swift-SMTP").
                .product(name: "SwiftSMTP", package: "SwiftSMTP")
            ],
            path: ".",
            sources: ["swift-zerosmtp.swift"]
        )
    ]
)
