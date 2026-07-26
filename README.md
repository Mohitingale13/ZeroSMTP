**Czytaj po polsku:** [README.pl.md](README.pl.md)

[![Lint examples](https://github.com/msgwing/ZeroSMTP/actions/workflows/lint.yml/badge.svg)](https://github.com/msgwing/ZeroSMTP/actions/workflows/lint.yml)

# Send Emails Without Hassle. For Free.

Free SMTP Account with @msgwing.com domain

## Quickstart

1. Register and activate a free account at [msgwing.com](https://msgwing.com), then copy your randomly generated `@msgwing.com` login and password.
2. Copy [`.env.example`](.env.example) to `.env` and fill in your credentials.
3. Send a test email with curl (no dependencies beyond curl itself):

   ```bash
   export $(grep -v '^#' .env | xargs)
   curl --url "smtps://mx.msgwing.com:465" \
     --user "$ZEROSMTP_USERNAME:$ZEROSMTP_PASSWORD" \
     --mail-from "$ZEROSMTP_FROM" --mail-rcpt "$ZEROSMTP_TO" \
     --upload-file <(printf 'Subject: Test\r\n\r\nHello from ZeroSMTP!') --ssl-reqd
   ```

   Or pick your language from the [Code Examples](#code-examples) table below — every example reads the same `.env` variables.
4. Having trouble? See [Troubleshooting](docs/TROUBLESHOOTING.md) — most first-run failures are a cloud provider blocking outbound SMTP ports, not a misconfiguration.

After registration, your SMTP account is automatically and randomly generated - giving you an email address with excellent reputation, which significantly improves email deliverability to the recipient's mailbox.

Quick registration, instant account, and total freedom to send emails.

Send messages from your apps, scripts, websites, and even network printers - everything works right away.

Perfect for:
- Web and mobile applications
- Automation scripts (Python, PHP, Node.js, etc.)
- Contact forms and notifications
- Password resets and transactional emails
- Network printers (Scan-to-Email function)
- IoT devices and any hardware that supports SMTP

Setup guides: [Network printers](docs/PRINTERS.md) · [Popular applications](docs/APPS.md) · [Troubleshooting](docs/TROUBLESHOOTING.md)

## Code Examples

Ready-to-run, production-ready examples for `mx.msgwing.com:465` (SSL/TLS) or
`:587` (STARTTLS), one file per language:

| Language | File |
| --- | --- |
| Python | [python-zerosmtp.py](python-zerosmtp.py) |
| PHP (PHPMailer) | [php-zerosmtp.php](php-zerosmtp.php) |
| PHP (Symfony Mailer) | [php-symfony-mailer-zerosmtp.php](php-symfony-mailer-zerosmtp.php) |
| Node.js | [node-zerosmtp.mjs](node-zerosmtp.mjs) |
| TypeScript | [ts-zerosmtp.ts](ts-zerosmtp.ts) |
| Bash (curl) | [bash-curl-zerosmtp.sh](bash-curl-zerosmtp.sh) |
| Bash (swaks) | [bash-swaks-zerosmtp.sh](bash-swaks-zerosmtp.sh) |
| Java | [java-zerosmtp.java](java-zerosmtp.java) |
| C# (.NET / MailKit) | [cs-zerosmtp.cs](cs-zerosmtp.cs) |
| Go | [go-zerosmtp.go](go-zerosmtp.go) |
| Ruby | [ruby-zerosmtp.rb](ruby-zerosmtp.rb) |
| Rust | [rust-zerosmtp.rs](rust-zerosmtp.rs) |
| Kotlin | [kotlin-zerosmtp.kt](kotlin-zerosmtp.kt) |
| Swift | [swift-zerosmtp.swift](swift-zerosmtp.swift) |
| PowerShell | [pwsh-zerosmtp.ps1](pwsh-zerosmtp.ps1) |

Each example reads credentials from `ZEROSMTP_*` environment variables
(`ZEROSMTP_USERNAME`, `ZEROSMTP_PASSWORD`, `ZEROSMTP_FROM`, `ZEROSMTP_TO`,
`ZEROSMTP_SUBJECT`) — never hardcode real credentials into a script.

Easy Configuration:
- Login: randomly generated address @msgwing.com
- SMTP Server: mx.msgwing.com
- Port: 587 (STARTTLS) or 465 (SSL/TLS)
- Encryption: SSL/TLS - required

We respect your privacy - your data is not processed for any marketing or commercial purposes.

## Security & Deliverability

**✓ Domain Reputation Enhanced**: The msgwing.com domain reputation has been improved, with strict anti-spam measures enforced. All spam accounts have been blocked and removed to ensure optimal email deliverability for legitimate users.

### Verify Your Domain Reputation

Interested in checking the reputation of msgwing.com? You can test this yourself using [mail-tester.com](https://mail-tester.com/):

1. Create a free SMTP account at [msgwing.com](https://msgwing.com)
2. Use our PowerShell test script: [SendEmailTest_mail-tester.com.ps1](SendEmailTest_mail-tester.com.ps1)
3. Generate a random email at mail-tester.com and send a test message from your @msgwing.com address
4. Check the reputation score and detailed analysis

**✓ Security Improvements**: We have implemented comprehensive security enhancements to the msgwing.com service, including improved authentication protocols, enhanced abuse monitoring, and strengthened infrastructure security measures.

---

If you have any questions, feel free to contact us: abuse@msgwing.com

Great deliverability • Random high-reputation account • No costs • Full privacy • Works with everything

Start sending emails today - completely free and with no hidden rules!

Registration is available at: https://msgwing.com
