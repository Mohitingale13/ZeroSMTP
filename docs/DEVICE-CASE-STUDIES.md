# Device case studies

Manuals tell you where a setting *should* be. They don't tell you that a
specific 2016 printer needs its certificate check turned off because its
firmware never got a root certificate update — that only comes from someone
who actually hit the problem on real hardware.

This page collects those reports: one device, one confirmed fix, credited to
whoever found it.

## Case studies

### Canon Maxify MB2755 — certificate verification must stay off on port 465

**Reported by:** [`@kevinbytnar`](https://github.com/msgwing/ZeroSMTP/discussions/6)

This 2016-era SOHO inkjet MFP fails certificate validation against
`mx.msgwing.com`'s Let's Encrypt certificate on port 465, because its
firmware's root CA store was never updated to trust `ISRG Root X1`. On port
587 it connects successfully with certificate verification left **on** — no
workaround needed there.

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
