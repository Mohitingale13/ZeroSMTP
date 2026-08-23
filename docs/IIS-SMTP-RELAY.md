---
title: "IIS SMTP relay and Microsoft 365"
description: "The IIS SMTP Server feature relaying to Microsoft 365: what breaks when Basic auth ends in December 2026, and what to do about it."
---

# IIS SMTP relay and the Microsoft 365 Basic auth shutdown

The IIS **SMTP Server** feature is the local relay a great deal of Windows
software still points at. An application drops mail on `localhost:25`, the SMTP
virtual server forwards it to a smart host, and nobody has thought about it for
a decade.

If that smart host is `smtp.office365.com` with a username and password, it
stops working at the end of December 2026.

## Why this page exists separately

Microsoft has not supported this component since 2008. It ships with Windows
Server, it works, and the usual advice — "reconfigure the application" — is
useless when the application is a vendor binary whose only mail setting is
*deliver to local SMTP server*. That case is common and it deserves a straight
answer rather than a recommendation to rewrite software you do not own.

## What actually breaks

Nothing about the IIS side. The virtual server keeps accepting mail on port 25
from localhost exactly as before.

The failure is at the smart host: Microsoft 365 refuses the username and
password, the message sits in the **Queue** folder, and IIS retries on its own
schedule without telling anybody. There is no alert. The first symptom is
usually somebody noticing that a report stopped arriving weeks ago.

Confirm it is authentication rather than the network:

```powershell
npx zerosmtp-check smtp.office365.com
```

If the ports are reachable and TLS is fine, the refusal is the credentials
being rejected, not a firewall. Paste what the queue or the event log recorded:

```powershell
npx zerosmtp-check --explain "535 5.7.139 Authentication unsuccessful"
```

## Your three options

**Re-enable SMTP AUTH on the tenant.** Works until the end of December 2026 and
not after. Legitimate as breathing room; a trap as a plan. The
[migration guide](EXCHANGE-ONLINE-SMTP-AUTH.md) covers what happens to it.

**Point the smart host somewhere that still accepts a password.** The
application keeps delivering to `localhost:25` and never learns anything
changed. Mail goes out from a generated `@msgwing.com` address rather than your
own domain, which rules this out for customer-facing mail and makes it a
reasonable fit for machine-generated notifications — see the
[FAQ](FAQ.md#will-emails-be-sent-from-my-own-domain-eg-youyourdomaincom) before
deciding.

**Replace the relay.** A modern MTA on the same box does the same job with
modern authentication. More work, and the right answer if the mail matters.

## Configuring the smart host

The console is IIS 6.0 Manager, which is a separate feature from the IIS
Manager you are used to. Microsoft's own instructions for installing and
configuring the feature are
[here](https://learn.microsoft.com/en-us/iis/application-frameworks/install-and-configure-php-on-iis/configure-smtp-e-mail-in-iis-7-and-above).

The three settings that matter, on the SMTP virtual server's **Properties**:

| Where | What |
| --- | --- |
| `Delivery → Outbound Security` | Basic authentication, with the relay username and password, **TLS encryption enabled** |
| `Delivery → Outbound connections` | Port `587` |
| `Delivery → Advanced → Smart host` | `mx.msgwing.com` |

Leave the virtual server's own access control alone: it should still accept
only from `127.0.0.1`, because a relay that accepts from anywhere is an open
relay and will be found.

## Check the queue before you call it fixed

The queue is a directory, and it is the honest test:

```powershell
Get-ChildItem C:\inetpub\mailroot\Queue
Get-ChildItem C:\inetpub\mailroot\Badmail
```

An empty `Queue` means mail is leaving. Files accumulating in `Badmail` mean it
is being rejected and IIS has given up on it — that directory is where the
December 2026 failure will pile up silently, and it is worth a scheduled check
regardless of which option you take.

## Related

- [Windows Server: every way to send mail](WINDOWS-SERVER.md)
- [Every SMTP AUTH error and what it means](ERROR-MESSAGES.md)
- [What breaks in December 2026](AFFECTED-SYSTEMS.md)
