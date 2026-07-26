# Troubleshooting

## "It just hangs / times out" — your cloud provider is probably blocking the port

This is, by far, the most common reason a first attempt fails, and it has
nothing to do with ZeroSMTP configuration. Many cloud and hosting providers
block outbound SMTP ports by default on new accounts, specifically to fight
spam:

| Provider | Default outbound SMTP behavior |
| --- | --- |
| AWS EC2 / Lightsail | Port 25 blocked by default on all accounts; a support ticket ("EC2 email sending limit removal") is required to lift it. Ports 587/465 are generally not blocked. |
| Google Cloud (GCE) | Port 25 blocked; 587/465 generally allowed. |
| Microsoft Azure | Port 25 blocked on most subscription types; 587/465 generally allowed. |
| DigitalOcean | Port 25 blocked by default for new accounts; can be requested to be lifted via support. 587/465 generally allowed. |
| Hetzner | Similar default restrictions on port 25; open a support ticket if outbound mail is core to your use case. |
| Home / office network (ISP) | Residential ISPs very commonly block outbound 25, and sometimes 587, to stop compromised machines from spamming. Check your ISP's Acceptable Use Policy. |

**This is why every example in this repository defaults to port `465`
(implicit SSL/TLS) or `587` (STARTTLS), never port `25`.** If a script hangs
until it times out rather than failing immediately, this is the first thing
to check — try connecting from a different network to confirm:

```bash
# Bash/Linux/macOS — quick manual connectivity check
curl -v --connect-timeout 10 telnet://mx.msgwing.com:587
curl -v --connect-timeout 10 telnet://mx.msgwing.com:465
```

```powershell
# Windows PowerShell
Test-NetConnection -ComputerName mx.msgwing.com -Port 587
Test-NetConnection -ComputerName mx.msgwing.com -Port 465
```

If both time out from a cloud VM but work from your home network, contact
your provider's support to unblock outbound SMTP for your account/instance.

## Authentication failed

- Confirm you copied the login/password from [msgwing.com](https://msgwing.com)
  exactly — the password is shown once, right after activation.
- Confirm your account is activated (registration alone is not enough).
- Confirm the environment variables are actually set: a typo like `USERNAME`
  instead of `ZEROSMTP_USERNAME` will silently fall back to a placeholder
  value or (on Windows) your OS login name — see the note in
  [`.env.example`](../.env.example).

## Certificate / TLS verification failed

- Do not disable certificate verification to "fix" this (no example in this
  repo does, and none should) — a cert error almost always means an
  intercepting proxy, an outdated system CA bundle, or a wrong hostname, not
  a problem with `mx.msgwing.com` itself.
- Make sure you're connecting to `mx.msgwing.com` (not an IP address) so
  hostname verification succeeds.
- Update your system's CA certificate bundle if it's very old.

## Which port should I use?

- **587 (STARTTLS)** — the safest default; supported by nearly every SMTP
  client, library, and printer.
- **465 (Implicit SSL/TLS)** — use this if your client/device offers an
  explicit "SSL" mode separate from "STARTTLS"/"TLS", or if your network
  blocks STARTTLS negotiation on 587 but allows 465.
- **25** — not supported by ZeroSMTP for client submission, and blocked by
  most providers anyway (see above).

## This project cannot receive email

ZeroSMTP is outgoing-only: there is no inbox, IMAP, or POP3 access tied to a
`@msgwing.com` account. If a test message doesn't "come back", that's
expected — send it to a mailbox you actually control (e.g. your personal
email, or a service like [mail-tester.com](https://mail-tester.com)) to
verify delivery, as shown in
[`SendEmailTest_mail-tester.com.ps1`](../SendEmailTest_mail-tester.com.ps1).

## Still stuck?

Contact abuse@msgwing.com, or open an issue on this repository with:
the language/example you're using, the exact error message, and which port
you tried.
