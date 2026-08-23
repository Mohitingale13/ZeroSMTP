# Device case studies

Manuals tell you where a setting *should* be. They don't tell you that a
specific 2016 printer needs its certificate check turned off because its
firmware never got a root certificate update — that only comes from someone
who actually hit the problem on real hardware.

This page collects those reports: one device, one confirmed fix, credited to
whoever found it.

> **Hitting a certificate error on a printer?** [Printer cannot verify the mail server certificate](PRINTER-CERTIFICATE-ERROR.md)
> explains why a valid certificate gets rejected by older firmware, and what to
> do about it.

## Case studies

### Canon Maxify MB2755 — certificate verification must stay off, on either port

**Reported by:** [`@kevinbytnar`](https://github.com/msgwing/ZeroSMTP/discussions/6)

This 2016-era SOHO inkjet MFP fails certificate validation against
`mx.msgwing.com`'s Let's Encrypt certificate, because its firmware ships a
fixed root CA store that predates modern Let's Encrypt roots — confirmed
with `openssl s_client` and unchanged after a firmware update. Which exact
chain the server presents can shift over time (an ECDSA chain through
`ISRG Root X2` as of this writing, an RSA chain through `ISRG Root X1`
earlier) — the printer's frozen trust store doesn't recognize either, so
the fix is the same regardless: disable certificate verification on the
device, on whichever port you use.

Full writeup, screenshots and the technical explanation:
[PRINTERS.md → Known exception: Canon Maxify MB2755](PRINTERS.md#known-exception-canon-maxify-mb2755).

---

## Have a device with a similar quirk?

If you hit something on real hardware that isn't in [PRINTERS.md](PRINTERS.md)
— a certificate issue, a firmware bug, a menu that's in a different place
than the manual says — report it:

- [Open an issue](https://github.com/msgwing/ZeroSMTP/issues/new/choose) or
  a pull request with what you found (a screenshot helps, with any account
  details redacted).
- Hardware-confirmed reports are worth more here than anything written from
  a manual, and get credited by GitHub username when added.

This list only grows if people who hit the edge cases report them —
consider this an open invitation.
