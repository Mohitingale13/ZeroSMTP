// swift-zerosmtp.swift
/**
 * Swift 6.3+ swift-smtp 2.18 - ZeroSMTP mx.msgwing.com:465 SSL/TLS
 * Production-ready | Let's Encrypt | async/await, SwiftNIO-based
 *
 * NOTE: this file used to demonstrate Kitura/Swift-SMTP, which is
 * unmaintained and fails to build against the OpenSSL version on current
 * Linux distributions (a transitive dependency calls the removed/renamed
 * SSL_get_peer_certificate). It now uses sersoft-gmbh/swift-smtp, an
 * actively maintained, SwiftNIO-based library.
 */

import Foundation
import NIOCore
import NIOPosix
import SwiftSMTP

@main
struct ZeroSMTPMailer {
    static func main() async {
        // NOTE: variable names are prefixed with ZEROSMTP_ to avoid colliding with
        // reserved/OS-level variables (e.g. USERNAME is auto-set on Windows).
        let config = EmailConfig(
            username: ProcessInfo.processInfo.environment["ZEROSMTP_USERNAME"] ?? "your-username",
            password: ProcessInfo.processInfo.environment["ZEROSMTP_PASSWORD"] ?? "your-password",
            from: ProcessInfo.processInfo.environment["ZEROSMTP_FROM"] ?? "sender@example.com",
            to: ProcessInfo.processInfo.environment["ZEROSMTP_TO"] ?? "recipient@example.com",
            subject: ProcessInfo.processInfo.environment["ZEROSMTP_SUBJECT"] ?? "Test Email from ZeroSMTP"
        )

        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer { try? group.syncShutdownGracefully() }

        switch await sendEmail(config: config, group: group) {
        case .success:
            print("Email sent successfully")
            exit(0)
        case .failure(let error):
            fputs("Error: \(error)\n", stderr)
            exit(1)
        }
    }
}

struct EmailConfig {
    let username: String
    let password: String
    let from: String
    let to: String
    let subject: String
}

enum MailResult {
    case success
    case failure(String)
}

func sendEmail(config: EmailConfig, group: any EventLoopGroup) async -> MailResult {
    let configuration = Configuration(
        server: Configuration.Server(
            hostname: "mx.msgwing.com",
            port: 465,
            encryption: .ssl
        ),
        credentials: Configuration.Credentials(
            username: config.username,
            password: config.password
        )
    )
    let mailer = Mailer(group: group, configuration: configuration)

    let email = Email(
        sender: Email.Contact(name: "ZeroSMTP User", emailAddress: config.from),
        recipients: [Email.Contact(emailAddress: config.to)],
        subject: config.subject,
        body: .universal(
            plain: "Hello from ZeroSMTP! This is plain text.",
            html: "<html><body><h1>Hello from ZeroSMTP!</h1><p>This is an HTML email sent via mx.msgwing.com:465</p></body></html>"
        )
    )

    do {
        try await mailer.send(email)
        return .success
    } catch {
        return .failure("SMTP error: \(error)")
    }
}
