# FAQ

Answers to the questions we get asked most often about using ZeroSMTP.

- [Can I use ZeroSMTP with my own hosting and my own domain?](#can-i-use-zerosmtp-with-my-own-hosting-and-my-own-domain)
- [Will emails be sent from my own domain (e.g. you@yourdomain.com)?](#will-emails-be-sent-from-my-own-domain-eg-youyourdomaincom)
- [Can I get a custom username instead of the randomly generated one?](#can-i-get-a-custom-username-instead-of-the-randomly-generated-one)
- [What are the sending limits?](#what-are-the-sending-limits)
- [Can ZeroSMTP receive email too?](#can-zerosmtp-receive-email-too)
- [My printer/device shows a certificate error — do I need to disable certificate verification?](#my-printerdevice-shows-a-certificate-error--do-i-need-to-disable-certificate-verification)
- [Why is ZeroSMTP free? What's the catch?](#why-is-zerosmtp-free-whats-the-catch)
- [Still have questions?](#still-have-questions)

## Can I use ZeroSMTP with my own hosting and my own domain?

Yes. ZeroSMTP is an SMTP **relay** — it doesn't care which domain your
hosting or website runs on. Setup is three steps:

1. **Register** a free account at [msgwing.com](https://msgwing.com) and get
   a randomly generated address on the `@msgwing.com` domain.
2. **Configure** that account's SMTP credentials in your app, script,
   website, or hosting panel (server: `mx.msgwing.com`, port `587` with
   STARTTLS or `465` with SSL/TLS).
3. **Send** — your application delivers mail through the relay immediately,
   regardless of your hosting's own domain.

This covers contact forms, password resets, and notifications from any
hosting provider, plus the other use cases in the main
[README](https://github.com/msgwing/ZeroSMTP#quickstart) (apps, scripts, printers, IoT, etc.).

## Will emails be sent from my own domain (e.g. you@yourdomain.com)?

No — by design. Every message is sent **from an `@msgwing.com` address**,
never from your own domain. ZeroSMTP only relays mail through the
`msgwing.com` domain and does not send on behalf of arbitrary sender
domains, mainly for anti-spam and deliverability reasons.

| Your need | Does ZeroSMTP fit? |
| --- | --- |
| Reliable outgoing mail for your app/site (contact forms, password resets, notifications) | ✅ Yes, regardless of your hosting's domain |
| "From" address must show *your* domain | ❌ No — that requires your own dedicated mail server |

## Can I get a custom username instead of the randomly generated one?

Yes. Registration generates a random `@msgwing.com` address by default, but
you can request a specific one (e.g. `you@msgwing.com`):

1. Register an account at [msgwing.com](https://msgwing.com).
2. Email your request to **abuse@msgwing.com** with the username you'd like
   and the address of the account you just registered.
3. Once confirmed, the custom username is set permanently on your account.

## What are the sending limits?

See [Sending limits (rate limiting)](TROUBLESHOOTING.md#sending-limits-rate-limiting)
in the troubleshooting guide.

## Can ZeroSMTP receive email too?

No. See [This project cannot receive email](TROUBLESHOOTING.md#this-project-cannot-receive-email)
— ZeroSMTP is outgoing-only.

## My printer/device shows a certificate error — do I need to disable certificate verification?

Sometimes, yes — but only for **specific older devices**, and it's not a
setting we recommend as a general fix.

**Why this happens:** `mx.msgwing.com` uses a standard Let's Encrypt TLS
certificate, which every modern operating system, browser and mail client
trusts without issue. Some older embedded devices — certain printers,
scanners, NAS units — ship with a **fixed, non-updatable root certificate
store** baked into their firmware. If that firmware predates the specific
Let's Encrypt certificate chain currently in use, the device has no way to
recognize it as trustworthy, even though the certificate itself is entirely
valid. A firmware update rarely fixes this on consumer-grade hardware, and
which exact chain gets presented can shift over time as certificate
authorities rotate intermediates — so this isn't necessarily a one-time,
stays-fixed problem for a given device.

**What to do, in order:**
1. First rule out a network or configuration problem rather than assuming
   it's this — see
   [Certificate / TLS verification failed](TROUBLESHOOTING.md#certificate--tls-verification-failed)
   for how to tell the difference.
2. If you've confirmed it's this specific old-firmware limitation, disabling
   the device's own certificate check (often labeled *"Don't verify
   certificate"* / *"Nie weryfikuj certyfikat"*) is the accepted workaround
   **for that device** — see the fully documented
   [Canon Maxify MB2755 case](PRINTERS.md#known-exception-canon-maxify-mb2755)
   for a real example, including how to confirm the root cause yourself.

**What that trade-off actually costs:** with verification disabled, that one
device no longer confirms it's really talking to `mx.msgwing.com` rather
than an on-path attacker on the same network — the session is still
encrypted, just without checking who's on the other end. Only accept that
for the specific device that needs it; leave verification enabled
everywhere else.

## Why is ZeroSMTP free? What's the catch?

There isn't a hidden one — the trade-offs are the ones already documented
on this page: mail always goes out from a shared `@msgwing.com` address,
not your own domain (see above), and sending is rate-limited per account to
keep the shared domain's reputation good for everyone (see
[Sending limits](TROUBLESHOOTING.md#sending-limits-rate-limiting)).

Beyond that, per the [README](https://github.com/msgwing/ZeroSMTP#readme): your data isn't processed for
marketing or resold, and abuse accounts are actively removed to protect
deliverability for everyone else. If your use case needs more than what's
documented here, ask at abuse@msgwing.com rather than assuming it isn't
supported.

## Still have questions?

Contact **abuse@msgwing.com**, or open an issue on this repository.

{% raw %}
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Can I use ZeroSMTP with my own hosting and my own domain?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. ZeroSMTP is an SMTP relay, so it doesn't care which domain your hosting or website runs on. Register a free account at msgwing.com to get a randomly generated @msgwing.com address, configure that account's SMTP credentials in your app or hosting panel (server mx.msgwing.com, port 587 with STARTTLS or 465 with SSL/TLS), and your application can send mail through the relay immediately, regardless of your hosting's own domain."
      }
    },
    {
      "@type": "Question",
      "name": "Will emails be sent from my own domain (e.g. you@yourdomain.com)?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No, by design. Every message is sent from an @msgwing.com address, never from your own domain. ZeroSMTP only relays mail through the msgwing.com domain and does not send on behalf of arbitrary sender domains, mainly for anti-spam and deliverability reasons. If you need the From address to show your own domain, that requires your own dedicated mail server instead."
      }
    },
    {
      "@type": "Question",
      "name": "Can I get a custom username instead of the randomly generated one?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Registration generates a random @msgwing.com address by default, but you can request a specific one. Register an account at msgwing.com, then email your request to abuse@msgwing.com with the username you'd like and the address of the account you just registered. Once confirmed, the custom username is set permanently on your account."
      }
    },
    {
      "@type": "Question",
      "name": "What are the sending limits?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "ZeroSMTP is rate-limited per account to keep the shared domain's reputation good for everyone: up to 200 emails per day, with hourly and per-minute caps as well. See the Troubleshooting guide's sending limits section for the exact numbers."
      }
    },
    {
      "@type": "Question",
      "name": "Can ZeroSMTP receive email too?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No. ZeroSMTP is outgoing-only: there is no inbox, IMAP, or POP3 access tied to an @msgwing.com account."
      }
    },
    {
      "@type": "Question",
      "name": "My printer/device shows a certificate error - do I need to disable certificate verification?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Sometimes, for specific older devices only - not as a general fix. mx.msgwing.com uses a standard Let's Encrypt certificate that every modern OS and client trusts, but some older printers, scanners and NAS units have a fixed, non-updatable root certificate store in their firmware that predates the Let's Encrypt certificate chain currently in use, so they can't recognize a perfectly valid certificate as trustworthy. A firmware update rarely fixes this on consumer hardware. First rule out a network or configuration problem instead of assuming this is the cause. If confirmed, disabling that device's own certificate verification is the accepted workaround for that device only - see the Canon Maxify MB2755 case study for a documented example. Doing this means the device no longer confirms it is talking to the real server rather than an on-path attacker, though the connection stays encrypted; only accept that trade-off for the specific device that needs it."
      }
    },
    {
      "@type": "Question",
      "name": "Why is ZeroSMTP free? What's the catch?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "There isn't a hidden one. The trade-offs are the ones already documented: mail always goes out from a shared @msgwing.com address, not your own domain, and sending is rate-limited per account to keep the shared domain's reputation good for everyone. Beyond that, your data isn't processed for marketing or resold, and abuse accounts are actively removed to protect deliverability for everyone else."
      }
    }
  ]
}
</script>
{% endraw %}
