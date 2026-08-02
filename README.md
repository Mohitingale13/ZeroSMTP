**Czytaj po polsku:** [README.pl.md](README.pl.md)

[![Lint examples](https://github.com/msgwing/ZeroSMTP/actions/workflows/lint.yml/badge.svg)](https://github.com/msgwing/ZeroSMTP/actions/workflows/lint.yml)
[![mx.msgwing.com status](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/msgwing/ZeroSMTP/status/status.json)](https://github.com/msgwing/ZeroSMTP/actions/workflows/service-healthcheck.yml)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/msgwing/ZeroSMTP)

Every language runtime used by the examples below (Python, PHP, Node, Ruby, Go, Java, Kotlin/Gradle, .NET, Rust) comes preinstalled if you open this repo in a [Dev Container or Codespace](.devcontainer/devcontainer.json) — no local setup needed.

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

Setup guides: [Network printers](docs/PRINTERS.md) · [Popular applications](docs/APPS.md) · [Linux (Debian/Ubuntu/Rocky/Fedora/openSUSE)](docs/LINUX.md) · [System-wide mail relay (Postfix/msmtp/Exim4)](docs/SYSTEM-MTA.md) · [Windows Server](docs/WINDOWS-SERVER.md) · [Troubleshooting](docs/TROUBLESHOOTING.md) · [Reliability (retries)](docs/RELIABILITY.md) · [FAQ](docs/FAQ.md)

## How does this compare to other options?

|  | ZeroSMTP | Gmail SMTP relay | Amazon SES | Mailgun / SendGrid / Brevo (typical free tier) |
| --- | --- | --- | --- | --- |
| Cost | Free, no card required | Free (personal Google account) | Pay-per-email (a limited free allowance only applies from AWS EC2, first 12 months) | Free tier, usually capped low and gated behind signup + domain verification |
| Setup | Register, copy SMTP credentials, done | Needs a Google account; Google's terms discourage automated/bulk sending over it | Needs an AWS account, plus a "production access" request before sending to unverified addresses | Signup + domain verification for full features |
| Custom "From" domain | No — always `@msgwing.com` (see [FAQ](docs/FAQ.md#will-emails-be-sent-from-my-own-domain-eg-youyourdomaincom)) | Yes, your Gmail/Workspace address | Yes | Yes, once your domain is verified |
| Best fit | Contact forms, password resets, notifications, printers/IoT — anywhere the from-address doesn't need to be your own domain | Low-volume personal scripts | Production apps that need it and can handle the AWS setup | Businesses that need branded sending and can handle the setup |

Free-tier terms above change over time — check each provider's current
pricing page before committing to one.

### What about self-hosting my own mail server?

Popular self-hosted options like [docker-mailserver](https://github.com/docker-mailserver/docker-mailserver),
[Mailu](https://github.com/Mailu/Mailu), or [mailcow](https://github.com/mailcow/mailcow-dockerized)
give you a mailbox on your own domain and full control — but you're the one
running Postfix, DKIM/SPF/DMARC, spam filtering, and IP/domain reputation,
which is real ongoing maintenance, not a one-time setup. ZeroSMTP is the
other end of that trade-off: zero setup and zero maintenance, in exchange
for sending from the shared `@msgwing.com` address instead of your own
domain. If you already run one of those and it's working, there's no reason
to switch. If you're not sure the effort is worth it yet for a script,
contact form, or side project, ZeroSMTP costs nothing to try first.

## GitHub Actions

Using ZeroSMTP from a workflow (CI failure alerts, deploy notifications,
scheduled reports)? [`msgwing/send-email-action`](https://github.com/msgwing/send-email-action)
on the [GitHub Marketplace](https://github.com/marketplace/actions/zerosmtp-send-email)
wraps the setup below into one step:

```yaml
- uses: msgwing/send-email-action@v1
  with:
    username: ${{ secrets.ZEROSMTP_USERNAME }}
    password: ${{ secrets.ZEROSMTP_PASSWORD }}
    from: ${{ secrets.ZEROSMTP_USERNAME }}
    to: you@example.com
    subject: "Build failed"
    body: "See the run: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
```

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

### Installing dependencies

Every example that needs a third-party library has a matching manifest at
the repo root, so you can install with each ecosystem's normal command
instead of hunting down library names/versions yourself:

| Language(s) | Install with |
| --- | --- |
| Node.js / TypeScript | `npm install` |
| PHP | `composer install` |
| Rust | `cargo build` (fetches deps automatically) |
| C# | `dotnet build cs-zerosmtp.csproj` |
| Java | `mvn compile` |
| Kotlin | `gradle build` |
| Swift | `swift build` |
| Python, Ruby, Go, Bash, PowerShell | none — standard library only |

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

## Star History

[![GitHub stars](https://img.shields.io/github/stars/msgwing/ZeroSMTP?style=social)](https://star-history.com/#msgwing/ZeroSMTP&Date)
