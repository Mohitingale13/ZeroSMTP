# ZeroSMTP vs. other free SMTP relays

Free transactional SMTP relays fall into two groups: services built for
sending from **your own domain** (SMTP2GO, Brevo, MailerSend, and similar),
and ZeroSMTP, built for sending when you **don't want to touch DNS at all**.
Neither is "better" in the abstract — they solve different problems.

![Setup path: a typical free relay takes five steps including DNS configuration; ZeroSMTP takes three steps with no DNS work](assets/setup-comparison.svg)

## The one difference that matters

Every relay below gives you SMTP credentials (username + password) — that
part is standard. What differs is what happens *before* you can use them.

| | ZeroSMTP | SMTP2GO / Brevo / MailerSend (typical) |
| --- | --- | --- |
| **Time to first email** | ~2 minutes | Minutes to 48 hours (DNS propagation) |
| **DNS records to configure** | None | SPF + DKIM (and DMARC, recommended) |
| **Sends from your own domain** | ❌ shared `@msgwing.com` address | ✅ once verified |
| **Sender reputation** | Managed for you — shared domain, actively monitored for abuse | Yours to build and protect — a fresh domain/IP has no reputation yet, and one bad list wrecks it |
| **Free tier** | 200/day, permanent | 100/month to 12,000/month — [the numbers are below](#what-the-free-tiers-actually-allow) |
| **Credit card required** | No | Usually no |
| **Best fit** | Printers, NAS units, scripts, legacy devices — anything that just needs mail to leave, from anyone | Apps and products sending under your own brand |

Sources: [SMTP2GO — verified senders](https://support.smtp2go.com/hc/en-gb/articles/115004408567-Verified-Senders)
(verification required for normal sending), [Brevo domain authentication](https://community.brevo.com/t/smtp-domain-authentication-sender-domain-verification/760)
(not required to start, recommended for deliverability).

## What the free tiers actually allow

The vague version of this comparison — "roughly 300/day to 3,000/month" — was
doing us no favours and is not much use to anybody deciding. The published free
tiers, as surveyed by
[EmailToolTester's roundup of free SMTP servers](https://www.emailtooltester.com/en/blog/free-smtp-servers/):

| Service | Free tier | Own domain |
| --- | --- | --- |
| SendPulse | 12,000/month | required |
| Brevo | 300/day | recommended |
| Mailtrap | 4,000/month | required |
| Maileroo | 3,000/month | required |
| MailerSend | 500/month | required |
| Mailjet | 200/day | required |
| **ZeroSMTP** | **200/day** | **not possible** |
| SendGrid | 100/day | required |
| Elastic Email | 100/day | required |
| Postmark | 100/month | required |

Two things worth reading off that table, and the second is against us.

**On volume we are mid-pack, not bottom.** 200 a day matches Mailjet, doubles
SendGrid and Elastic Email, and is sixty times what Postmark's free tier
allows. For a printer sending scans this is not the constraint anybody thinks
it is.

**On everything else those services are more capable.** They send from your
domain, report deliverability, handle bounces and suppression lists, and scale
when you outgrow the free tier. We do none of that and never will. If you are
building a product that emails customers, one of them is the right answer and
this is not a close call.

Limits move. These were current when this page was last reviewed; check the
provider before deciding on the strength of a number in somebody else's table,
including ours.

## Which one fits you

- ✅ **Pick ZeroSMTP if:** you don't have a domain to spare for this, don't
  want to learn what an SPF record is, or the device sending the mail
  (a printer, a NAS, a cron job) doesn't care whose address it comes from —
  see [Printers](PRINTERS.md) and [Device case studies](DEVICE-CASE-STUDIES.md).
- ✅ **Pick a domain-based relay if:** the mail needs to visibly come from
  *your* company, you're past a couple hundred messages a day, or the
  sending identity is part of your product (receipts, customer
  notifications, marketing).

This is the same honest split covered in
[option 4 of the Exchange Online migration guide](EXCHANGE-ONLINE-SMTP-AUTH.md#4-a-third-party-smtp-service-that-still-accepts-usernamepassword) —
this page just puts the comparison front and center instead of as one
paragraph among several options.

[**Get a free account →**](https://msgwing.com) if ZeroSMTP is the fit. If
it isn't, no hard feelings — [FAQ](FAQ.md) covers the trade-offs in more
detail, and the guides above name providers built for the other case.
