---
title: "Scan to email from a home printer"
description: "What an SMTP server is, why Gmail and Hotmail stopped working with printers, and how to get scan-to-email working again for free."
---

# Scan to email from a home printer

Your printer can scan a page and email it to you. To do that it needs a **mail
server** to hand the message to — printers cannot send email by themselves, the
same way a letter needs a post office.

That setting is called **SMTP**, and this page is about what to put in it when
the obvious answer stopped working.

## What is an SMTP server?

It is a computer that accepts your message and delivers it. Your printer
connects to it, proves who it is with a username and password, hands over the
scan, and disconnects. Three things go in the printer's settings:

| Setting | What it is |
| --- | --- |
| Server (or *SMTP server*, *outgoing server*) | the address to connect to |
| Port | which door to use — almost always `587` or `465` |
| Username and password | proof you are allowed to send |

That is the whole idea. Everything else on this page is about which server to
use.

## Why Gmail and Hotmail stopped working

For years people typed their own Gmail or Hotmail address and password into the
printer, and it worked.

It does not any more. Google and Microsoft both stopped accepting a plain
password from devices, because a password typed into a printer is a password
sitting in a printer. They now want a sign-in method almost no printer can do.

If your printer says **"SMTP server requires authentication"**, **"login
failed"**, or simply stops sending after years of working, this is usually why.
Nothing is broken and retyping the password will not help.

Some Gmail accounts can still use an **app password**, which is a separate
password just for the printer. If you have two-step verification switched on,
that is worth trying first — it costs nothing and keeps everything in one place.

## If that does not work, use a relay

A relay is a mail server whose whole job is to accept mail from devices like
yours. ZeroSMTP is one, it is free, and it does not ask for a card:

| Setting | Value |
| --- | --- |
| Server | `mx.msgwing.com` |
| Port | `587` — or `465` if your printer only offers SSL |
| Authentication | On |
| Username / password | from [registration](https://msgwing.com) |
| From address | the one you are given |

[**Get a free account →**](https://msgwing.com)

**Two things to know before you start**, because they matter more at home than
anywhere else:

Scans arrive **from a generated `@msgwing.com` address**, not from your own.
For scanning a document to yourself, to family, or to an accountant, that is
usually fine — the attachment is what matters. If it has to look like it came
from your own address, this is the wrong tool and
[the alternatives page](ALTERNATIVES.md) says which one is right.

The limit is **200 messages a day** and no paid tier lifts it. A household will
never reach that. A small office scanning invoices all day might.

## Where the setting lives on your printer

Almost every printer hides this behind its **web interface**: find the
printer's IP address on its own screen (usually under `Network` or `Wi-Fi`
settings), then type that number into a browser on a computer on the same
network.

| Brand | Where to look |
| --- | --- |
| HP | `Scan` or `Networking` → `Outgoing Email Profiles` — [full HP guide](HP-PRINTER-SMTP.md) |
| Canon | Remote UI → `Settings/Registration` → `TX Settings` → `E-Mail Settings` |
| Epson | Web Config → `Network` → `Email Server` → `Basic` |
| Brother | Web Based Management → `Network` → `Protocol` → `SMTP` |
| Others | [every brand, with menu paths](PRINTERS.md) |

## It still does not send

Check whether the printer can reach a mail server at all. From a computer on
the same network:

```bash
npx zerosmtp-check
```

It tests the connection and reports what it found. No installation and no mail
is sent. If it cannot connect either, the problem is the network rather than
the printer — some internet providers block these ports on home connections,
and [troubleshooting](TROUBLESHOOTING.md) covers what to do about it.

If the printer shows an error code or message instead, paste it:

```bash
npx zerosmtp-check --explain "535 5.7.139 Authentication unsuccessful"
```

## Related

- [HP printer: "SMTP server requires authentication"](HP-PRINTER-SMTP.md)
- [Scan-to-email setup for every brand](PRINTERS.md)
- [What the error messages mean](ERROR-MESSAGES.md)
