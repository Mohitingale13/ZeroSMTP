---
title: "HP printer: SMTP server requires authentication"
description: "What an HP printer means by SMTP server requires authentication, and what changes when Microsoft 365 drops Basic auth in December 2026."
---

# HP printer: "SMTP server requires authentication"

The message means the mail server refused the printer's login. It is not a
fault in the printer, and replacing it will not fix anything.

There are three reasons an HP printer sees it, and they need different answers.

## 1. No credentials were entered

The outgoing email profile has a server and a port but no username and
password, or "server requires authentication" is unticked. Most mail servers
stopped accepting anonymous mail years ago, so the printer connects, offers no
identity, and is turned away.

Fix it in the profile: Embedded Web Server (a browser pointed at the printer's
IP) → `Networking` or `Scan` → `TCP/IP Settings` → `Outgoing Email` /
`Scan to Email` → `Outgoing Email Profiles`. The printer's IP is on the panel
under `Settings → Networking → TCP/IP Settings`.

## 2. The credentials are right and the server refuses them anyway

This is the one that is growing, and it is not a mistake anybody made.

Microsoft is switching off Basic authentication — username and password — for
SMTP AUTH in Exchange Online at the end of December 2026. A printer that has
worked for years starts being refused on a day nobody touched it. The password
is still correct; the *method* is no longer accepted.

Confirm which case you are in from a laptop on the same network:

```bash
npx zerosmtp-check --explain "535 5.7.139 Authentication unsuccessful"
```

Nothing is installed and no mail is sent. [Every SMTP AUTH error and what it
means](ERROR-MESSAGES.md) covers seventeen of these strings, and says for each
whether the cause can still be turned back on before the deadline.

## 3. A consumer account that no longer allows it

Pointing an HP printer at Hotmail, Outlook.com or Gmail with the account
password stopped working some time ago; those providers now require OAuth or an
app password, and most printers can offer neither. If that is the setup, this
is the cause and no amount of retyping the password will change it.

## Can an HP printer do OAuth instead?

Sometimes, and the answer depends on the exact model rather than on HP as a
brand.

HP documents OAuth 2.0 for Microsoft 365 Scan to Email on **HP Enterprise and
HP Managed** printers running **FutureSmart firmware 5.7 or newer**. HP also
states that certain **LaserJet Pro** models — the M478-M479 and M428-M429f
among them — **do not support OAuth 2.0** at all.

That second half is the part worth reading twice. On those models there is no
firmware coming that will fix this, so waiting is not a plan. Check your exact
product family against
[HP's own statement](https://support.hp.com/nz-en/document/ish_13623350-13600809-16),
and the [full compatibility list](DEVICE-COMPATIBILITY.md) for every other
vendor.

## If the model cannot do OAuth

The printer needs a mail server that still accepts a username and password.
That is what ZeroSMTP is for:

| Setting | Value |
| --- | --- |
| Server | `mx.msgwing.com` |
| Port | `587` (STARTTLS) or `465` (SSL/TLS) |
| Authentication | On, with the username and password from registration |

Mail sent this way leaves from a generated `@msgwing.com` address rather than
your own domain, and the cap is 200 messages a day with no paid tier that lifts
it. For scan-to-email from a printer that is usually the right trade; if the
From address has to be your own domain,
[the alternatives page](ALTERNATIVES.md) says which tool is.

[**Get a free account →**](https://msgwing.com)

## Still refused after changing the server?

Then the printer is not reaching the server at all, which looks identical from
the panel. Check the network path from a machine on the same subnet:

```bash
npx zerosmtp-check
```

It tests ports 25, 587 and 465 and reports which of them the network actually
lets out — a firewall blocking outbound 587 produces the same silence as a
wrong password. [Troubleshooting](TROUBLESHOOTING.md) covers the rest.

## Related

- [Scan-to-email setup for every brand](PRINTERS.md)
- [Which devices have OAuth firmware](DEVICE-COMPATIBILITY.md)
- [Devices whose vendor has ruled OAuth out](NO-OAUTH-FIRMWARE.md)
