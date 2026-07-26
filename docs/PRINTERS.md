# Configuring Network Printers to Send Email via ZeroSMTP

ZeroSMTP is an **outgoing-only** SMTP relay: it lets a printer's "Scan-to-Email"
or "Scan-to-PC" feature send scanned documents by email. There is no inbox
associated with a ZeroSMTP account, so a printer configured this way can send
scans out, but cannot check or receive email.

## 1. Get your credentials

1. Register a free account at [msgwing.com](https://msgwing.com) and activate it.
2. While logged in, copy the randomly generated `@msgwing.com` username and password.
   They are shown once — store them securely (e.g. in the printer's own
   credential store, not in a shared document).

## 2. Connection values (same for every printer brand)

| Setting | Value |
| --- | --- |
| SMTP server / outgoing server | `mx.msgwing.com` |
| Port | `587` (STARTTLS) or `465` (SSL/TLS) |
| Encryption | STARTTLS on 587, or SSL/TLS on 465 — **required**, do not select "None" |
| Authentication | Enabled, method: LOGIN/PLAIN |
| Username | your `@msgwing.com` login |
| Password | your `@msgwing.com` password |
| From address | your `@msgwing.com` login (some printers require From == Username) |

![Generic SMTP settings fields](assets/smtp-settings-fields.svg)

![Connection flow: printer to mx.msgwing.com to recipient](assets/smtp-connection-flow.svg)

> Prefer port `587` if the printer's menu only lists one port and one
> "use SSL/encryption" toggle — this is the most widely supported combination
> across printer firmware. Use `465` only if the printer explicitly offers an
> "SSL" (implicit TLS) mode separate from "STARTTLS"/"TLS".

## 3. Where to find these settings by brand

Menu wording changes between firmware versions, but the location is
consistent enough to be a reliable starting point. Always confirm against
your exact model's manual, since manufacturers do rename menus over time.

### HP (via the printer's Embedded Web Server / EWS)
`Settings → Networking → TCP/IP Settings` (to find the printer's IP), then in
a browser go to the printer's IP address →
`Networking` or `Scan` tab → `TCP/IP Settings` → `Outgoing Email` /
`Scan to Email` → `Outgoing Email Profiles` → add a profile with the values
from the table above.

### Canon (imageRUNNER / imageCLASS / PIXMA business models)
Printer's web interface (Remote UI) → `Settings/Registration` →
`TX Settings` → `E-Mail/I-Fax Settings` → `SMTP Server Settings` → enter
server, port, authentication, and encryption values from the table above.

### Epson (WorkForce / EcoTank Pro with Scan-to-Email)
Printer's web configuration page → `Network Scan` or `Basic` → `Email Server` →
enter server address, port, and authentication settings from the table above.

### Brother
Printer's web management page (Web Based Management) → `Network` →
`Protocol` → `SMTP Client` → enter server, port, and authentication values
from the table above. Set `SSL/TLS` to `STARTTLS` for port 587 or `SSL` for
port 465.

### Xerox / Konica Minolta (typical enterprise MFPs)
Device web UI → `Properties` / `System Settings` → `Connectivity` →
`Protocols` → `SMTP Server` → enter server, port, authentication, and
encryption values from the table above.

## 4. Verifying it works

1. Send a test scan-to-email from the printer to your own inbox.
2. If it fails, check the printer's event log for an authentication or TLS
   error, and re-verify the values in the table above (a common mistake is
   picking "None" for encryption, which ZeroSMTP does not allow).
3. For deliverability/reputation testing (SPF/DKIM/DMARC), see the root
   [`SendEmailTest_mail-tester.com.ps1`](../SendEmailTest_mail-tester.com.ps1)
   script and the "Verify Your Domain Reputation" section in the
   [README](../README.md).

## Limitations

- Send-only: no IMAP/POP3, no inbox, no "receive" test.
- One authenticated `@msgwing.com` account = one From address; printers
  that require a different From address for each user should use a
  shared queue or app-level relay (see [APPS.md](APPS.md)) instead of
  configuring dozens of individual printers.
