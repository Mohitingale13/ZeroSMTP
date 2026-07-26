# Changelog

## [1.1.0] - 2026-07-26

### Added
- `docs/PRINTERS.md` and `docs/APPS.md`: SMTP relay setup guides for
  popular network printers (HP, Canon, Epson, Brother, Xerox/Konica
  Minolta) and applications (WordPress, Home Assistant, Grafana,
  Zabbix), with original illustrative diagrams
- Language index table in `README.md` / `README.pl.md` linking to all
  15 code examples
- `.github/workflows/lint.yml`: CI syntax-check for the Bash,
  PowerShell, Python, Ruby, PHP, Go, Node.js, and TypeScript examples
- `.gitattributes` enforcing LF line endings on scripts, so a Windows
  checkout can't accidentally introduce CRLF and break a shebang line
  on Linux/macOS

### Fixed
- Ruby example had an invalid `frozen_string_literal: true` magic
  comment (missing `#`), which raised a `SyntaxError` and prevented
  the script from running at all
- All examples read credentials from a plain `USERNAME` environment
  variable, which collides with the OS-reserved `USERNAME` variable on
  Windows; renamed to `ZEROSMTP_USERNAME` (and `ZEROSMTP_PASSWORD`,
  `ZEROSMTP_FROM`, `ZEROSMTP_TO`, `ZEROSMTP_SUBJECT`, `ZEROSMTP_BODY`)
  across every example and the Copilot prompts file
- `php-zerosmtp.php` referenced a non-functional placeholder path
  (`/path/to/vendor/autoload.php`) instead of `__DIR__`
- `bash-curl-zerosmtp.sh` hardcoded a Debian/Ubuntu-specific CA bundle
  path that doesn't exist on RHEL/Fedora/macOS
- `SendEmailTest_mail-tester.com.ps1` was saved as UTF-8 without a BOM
  with Unicode status symbols (✓/✗), which corrupted parsing under
  Windows PowerShell 5.1; replaced with plain ASCII markers

### Changed
- Replaced `php-swiftmailer-zerosmtp.php` (SwiftMailer reached
  end-of-life in December 2021) with
  `php-symfony-mailer-zerosmtp.php`, using the actively maintained
  Symfony Mailer
- Replaced the deprecated `Send-MailMessage` cmdlet with
  `Send-MailKitMessage` in both PowerShell scripts
- Simplified `go-zerosmtp.go` (direct `Rcpt` call instead of
  range-over-func for a single recipient; randomized MIME boundary)
  and `kotlin-zerosmtp.kt` (removed experimental context receivers)
- Added a connection timeout to the `SmtpTransport` in
  `rust-zerosmtp.rs`

## [1.0.1] - 2026-04-02

### Added
- PowerShell test script for domain reputation verification via mail-tester.com
- Comprehensive documentation for testing email deliverability
- Enhanced security examples and best practices

### Fixed
- Improved domain reputation status
- Spam account blocking and removal
- Enhanced email authentication infrastructure

### Security
- Implemented comprehensive security enhancements to msgwing.com service
- Improved authentication protocols and procedures
- Enhanced abuse monitoring and prevention systems
- Strengthened infrastructure security measures
- Updated contact email from general address to dedicated abuse@msgwing.com for security reports

## [1.0.0] - 2026-03-30

### Added
- Multi-language support for:
  - PHP
  - Python
  - Node.js
  - TypeScript
  - Bash
  - Java
  - C#
  - Go
  - Ruby
  - Rust
  - PowerShell
  - Kotlin
  - Swift

### Changed
- Improved configuration for SSL/TLS support.

### Fixed
- Enhanced email format support for better compatibility across different email clients.
