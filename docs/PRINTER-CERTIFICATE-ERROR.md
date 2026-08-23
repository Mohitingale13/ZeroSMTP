---
title: "Printer cannot verify the mail server certificate"
description: "Why an older printer rejects a valid Let's Encrypt certificate, and the one case where turning verification off is the right answer."
---

# Printer cannot verify the mail server certificate

Some printers refuse to send because they do not trust the mail server's
certificate — even when the certificate is perfectly valid and every browser
and phone accepts it.

This is a different failure from a rejected password, and the fix is different
too. Nothing is expired, misconfigured or under attack.

## Why a valid certificate gets rejected

A printer decides whether to trust a server by checking its certificate against
a list of root certificates baked into the firmware. On a computer that list is
updated constantly. On a printer it was frozen the day the firmware shipped.

Let's Encrypt, which secures a very large share of the web, issues through
roots called **ISRG Root X1** (RSA) and **ISRG Root X2** (ECDSA). A printer
from 2016 has never heard of either. It is not detecting a problem; it is
failing to recognise something newer than itself.

Which chain a server presents can also change over time — `mx.msgwing.com` has
presented an ECDSA chain through ISRG Root X2 and an RSA chain through ISRG
Root X1 at different points. A frozen trust store recognises neither, so the
behaviour is the same either way.

## Confirm it is the certificate and not something else

From a computer on the same network:

```bash
npx zerosmtp-check
```

It reports the certificate the server presents, who issued it, when it expires
and whether verification passed. If it passes there and fails on the printer,
the server is fine and the printer's trust store is the difference — which is
the whole diagnosis.

The same thing directly, if you prefer:

```bash
openssl s_client -starttls smtp -connect mx.msgwing.com:587
```

## Confirmed cases

**Canon Maxify MB2755** — a 2016 SOHO inkjet MFP. Fails validation on either
port, confirmed with `openssl s_client`, and **unchanged after a firmware
update**. Reported by
[`@kevinbytnar`](https://github.com/msgwing/ZeroSMTP/discussions/6); the full
writeup is in
[PRINTERS.md](PRINTERS.md#known-exception-canon-maxify-mb2755).

That last detail is the useful one: updating the firmware is the obvious first
move and on this device it changed nothing, because the manufacturer stopped
shipping root store updates rather than because the update was missed.

## What to do

**Try a firmware update first.** On hardware still supported it sometimes
carries a refreshed root store, and it costs an evening to find out.

**If that does not help, disabling certificate verification on that one device
is the accepted answer** — and it is worth being precise about what it costs.
The connection stays encrypted; what you lose is the device's confirmation that
it is talking to the real server rather than something in between. On a printer
on your own network, sending scans to your own mailbox, that is a reasonable
trade. It is not a general fix and should never be applied to a whole fleet
because one device needed it.

**Never disable verification in code.** No example in this repository does, and
none should. A script runs on a machine whose trust store you can update; a
printer is not.

## Related

- [Scan-to-email setup by brand](PRINTERS.md)
- [Device case studies](DEVICE-CASE-STUDIES.md) — confirmed fixes on real hardware
- [Troubleshooting](TROUBLESHOOTING.md) — when it is not the certificate
