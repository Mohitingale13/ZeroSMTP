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
Each entry below links to that vendor's own current documentation rather
than a paraphrase, so you can check your exact model/firmware if the wording
has moved since this was written.

### HP (via the printer's Embedded Web Server / EWS)
`Settings → Networking → TCP/IP Settings` (to find the printer's IP), then in
a browser go to the printer's IP address →
`Networking` or `Scan` tab → `TCP/IP Settings` → `Outgoing Email` /
`Scan to Email` → `Outgoing Email Profiles` → add a profile with the values
from the table above.

### Canon (imageRUNNER / imageCLASS / PIXMA business models / Maxify)
Printer's web interface (Remote UI) → `Settings/Registration` →
`TX Settings` → `E-Mail/I-Fax Settings` → `SMTP Server Settings` → enter
server, port, authentication, and encryption values from the table above.
On the **Maxify MB2755**, this same menu also has an SSL certificate
verification toggle — see the
[known exception below](#4-known-exception-canon-maxify-mb2755-requires-disabling-certificate-verification)
if it needs to be turned off.

### Epson (WorkForce / EcoTank Pro with Scan-to-Email)
Printer's web configuration page → `Network Scan` or `Basic` → `Email Server` →
enter server address, port, and authentication settings from the table above.

### Brother
Printer's web management page (Web Based Management) → `Network` →
`Protocol` → `SMTP Client` → enter server, port, and authentication values
from the table above. Set `SSL/TLS` to `STARTTLS` for port 587 or `SSL` for
port 465.

### Ricoh
Web Image Monitor (browser → printer's IP, log in as administrator) →
`Device Management` → `Configuration` → `Email` (under Device Settings) →
enter `SMTP Server Name`, `SMTP Port No.`, and enable `SMTP Authentication`
with the values from the table above. Field names are consistent across most
Ricoh models even when the surrounding menu layout differs — see
[Ricoh's own SMTP authentication guide](https://kb.gsd.ricoh.com/app/answers/detail/a_id/288857/~/how-to-set-up-smtp-authentication-for-scan-to-email).
Ricoh has also published an
[advisory specifically about the Exchange Online Basic auth phase-out](https://www.ricoh-ap.com/news/2025/05/20/ricohs-response-to-basic-authentication-phase-out-in-microsoft-exchange-online-smtp-authentication)
worth reading if that's why you're here.

### Kyocera (Command Center RX)
Browser → printer's IP → Command Center RX admin login → `Advanced` →
`E-mail` → `SMTP` → `General` → enter the server/port/authentication values
from the table above and set `SMTP Security` to match the port you chose.
See [Kyocera's Command Center RX e-mail settings guide](https://sites.google.com/view/howtoguidesforkyoceraprinters/the-command-center-rx/function-settings/e-mail).

### Xerox (WorkCentre / VersaLink / AltaLink)
Embedded Web Server → `Properties` → `Connectivity` → `Protocols` →
`SMTP Server` → `General` → enter server, port, and connection security from
the table above. Newer app-based models instead use
`Properties → Apps → Email → Setup`. See
[Xerox's own SMTP configuration article](https://www.support.xerox.com/en-us/article/en/2119372)
for your exact model.

### Konica Minolta (bizhub)
Either from the touch panel — `Utility` → `Administrator Settings` →
`Network Settings` → `E-Mail Settings` → `E-Mail TX (SMTP)` — or from the web
admin page — `Network` → `E-mail Setting` → `E-mail TX (SMTP)`. See
[Konica Minolta's E-mail TX (SMTP) manual page](https://manuals.konicaminolta.eu/bizhub-C554-C454-C364-C284-C224/EN/contents/id08-0072.html)
for the exact wording on your model.

### Sharp
`Settings (Administrator)` → `System Settings` → `Network Settings` →
`Service Settings` → `SMTP` tab (some models expose this at the web page's
`Settings → E-mail` instead) — enter `Primary Server`, `Port Number`, and
enable `SMTP Authentication`/`SSL-TLS` from the table above. See
[Sharp's network settings manual](https://global.sharp/restricted/products/copier/downloads/manuals/bpb550wd/en/contents_09-07_018.html).

### Lexmark
Embedded Web Server → `Settings` → `E-mail/FTP Settings` → `SMTP Setup` →
enter the server as `Primary SMTP Gateway`, the port as
`Primary SMTP Gateway Port`, and set `Use SSL/TLS` to `Required`. See
[Lexmark's e-mail SMTP settings guide](https://support.lexmark.com/content/support/guides/en/ug250010/email/configuring-the-email-smtp-settings-v59011346.html).

> **Have a device from one of these brands and a few minutes?** The Canon
> Maxify MB2755 section below exists because a contributor
> ([`@kevinbytnar`](https://github.com/msgwing/ZeroSMTP/discussions/6)) tested
> it on real hardware and reported back exactly what worked. If you confirm
> (or need to correct) any of the paths above on your own device, please
> [open an issue](https://github.com/msgwing/ZeroSMTP/issues/new/choose) or a
> PR with a screenshot — real, hardware-confirmed reports are far more useful
> here than anything written from a manual alone.

## 4. Known exception: Canon Maxify MB2755 requires disabling certificate verification

Most printers validate `mx.msgwing.com`'s certificate correctly and should be
left with certificate verification **enabled** — this is the safe default
and the one recommended in [TROUBLESHOOTING.md](TROUBLESHOOTING.md). One
confirmed exception is the **Canon Maxify MB2755** (2016-era consumer/SOHO
inkjet MFP):

- `mx.msgwing.com` serves a **Let's Encrypt R3** certificate.
- Until September 2021, Let's Encrypt's chain was cross-signed by the
  widely trusted `DST Root CA X3`. Since that root expired, Let's Encrypt
  relies solely on its own `ISRG Root X1`.
- The MB2755's firmware ships a fixed, non-updatable root CA store that was
  never updated to trust `ISRG Root X1`. As a result, full certificate
  validation fails on this model even though the certificate itself is
  valid and correctly served — there is no way to import a root certificate
  into this printer's firmware, and no firmware update exists that adds it.
- On this specific model, using **port `465`** requires disabling **"Nie
  weryfikuj certyfikat" / "Don't verify certificate"** — that is the only
  setting that lets the connection succeed on `465`.
- **Update (production testing, 2026-07):** this printer also connects
  successfully to `mx.msgwing.com` on port **`587`** with **"Bezpieczne
  połącz. (SSL)" / "encrypted connection"** checked — and on `587` it does
  **not** need the certificate-verification workaround: leave "Nie
  weryfikuj certyfikat" **unchecked** (certificate verification enabled).
  **Port `587` should be treated as the default for this model going
  forward, since it avoids the certificate-verification workaround
  entirely; keep port `465` (with verification disabled) configured only
  as a fallback if `587` is ever unreachable on a given network** (see
  "Which port should I use?" in
  [TROUBLESHOOTING.md](TROUBLESHOOTING.md#which-port-should-i-use)).

![Canon Maxify MB2755 mail server settings on port 587 (recommended default; certificate verification stays enabled), sender address redacted](assets/canon-maxify-mb2755-mail-settings-587.png)

<details>
<summary>Port 465 (fallback configuration only — requires disabling certificate verification)</summary>

![Canon Maxify MB2755 mail server settings on port 465 (fallback), sender address redacted](assets/canon-maxify-mb2755-mail-settings.png)

</details>

> **Security note:** disabling certificate verification (only needed on
> port `465` for this model) means the printer no longer confirms it's
> actually talking to `mx.msgwing.com` rather than
> an on-path attacker on the same network (the SMTP session is still
> encrypted, but the server's identity is unverified). Only do this if your
> device is genuinely affected by the root-CA gap above — for any printer
> that isn't an old Canon Maxify (or a similarly outdated embedded device),
> keep certificate verification enabled per
> [TROUBLESHOOTING.md](TROUBLESHOOTING.md#certificate--tls-verification-failed).

## 5. Verifying it works

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
