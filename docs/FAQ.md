# FAQ

## Can I use ZeroSMTP with my own hosting and my own domain?

Yes. ZeroSMTP is a relay: your app, script, website, or hosting connects to
`mx.msgwing.com` and authenticates with your `@msgwing.com` SMTP credentials,
regardless of which domain your hosting or website itself uses. In short:

1. Register a free account at [msgwing.com](https://msgwing.com) and get a
   randomly generated address on the `@msgwing.com` domain.
2. Use that account's SMTP credentials in your app/script/website/hosting
   (server: `mx.msgwing.com`, port `587` with STARTTLS or `465` with SSL/TLS).
3. Your application can then send emails through the relay right away, no
   matter which domain your own hosting or website uses.

This works great for contact forms, password resets, and notifications sent
from any hosting, and for the other use cases listed in the main
[README](../README.md#quickstart) (apps, scripts, printers, IoT, etc.).

## Will emails be sent from my own domain (e.g. you@yourdomain.com)?

No, and this is by design. Emails are always sent **from an `@msgwing.com`
address**, never from your own domain. ZeroSMTP only handles sending through
the `msgwing.com` domain and does not relay mail on behalf of arbitrary
sender domains — mainly for anti-spam and deliverability reasons.

- If you just need reliable outgoing mail for your app/site/hosting (contact
  forms, password resets, notifications, etc.), ZeroSMTP works great,
  regardless of your hosting's domain.
- If you specifically need the "From" address to show your own domain,
  that's not something this service does — it would require your own
  dedicated mail server setup instead.

## Can I get a custom username instead of the randomly generated one?

By default, registration generates a random `@msgwing.com` address. If you'd
like a specific username instead (e.g. `you@msgwing.com`), first register an
account at [msgwing.com](https://msgwing.com), then email your request to
abuse@msgwing.com with the username you'd like and the address of the account
you just registered. Once confirmed, it can be set permanently on your
account.

## What are the sending limits?

See [Sending limits (rate limiting)](TROUBLESHOOTING.md#sending-limits-rate-limiting)
in the troubleshooting guide.

## Can ZeroSMTP receive email too?

No — see [This project cannot receive email](TROUBLESHOOTING.md#this-project-cannot-receive-email).

## Still have questions?

Contact abuse@msgwing.com, or open an issue on this repository.
