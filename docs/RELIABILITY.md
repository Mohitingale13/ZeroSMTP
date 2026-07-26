# Handling Transient Failures (Retry with Backoff)

The examples in this repository are intentionally minimal — they send one
email and report success or failure. For a production sender (contact
forms, password resets, notifications) that runs unattended, it's worth
retrying on **transient** failures instead of dropping the message:

- SMTP `4xx` response codes (e.g. `421 Service not available`, `450
  Mailbox busy`) mean "try again later" — this is also how a
  [rate limit](TROUBLESHOOTING.md#sending-limits-rate-limiting) rejection
  usually surfaces.
- SMTP `5xx` response codes (e.g. `550 No such user`) are **permanent** —
  retrying an unchanged message will fail again. Don't retry these; surface
  the error instead.
- A dropped connection or timeout is worth one or two retries, since it's
  often a transient network blip.

## Pattern: exponential backoff with jitter

Retry a handful of times with an increasing delay, plus a small random
jitter so multiple failed sends don't all retry at the exact same instant.
Reference implementation in Python, built on
[`python-zerosmtp.py`](../python-zerosmtp.py):

```python
import random
import time
from smtplib import SMTPResponseException, SMTPServerDisconnected


def send_with_retry(send_fn, max_attempts=4, base_delay=2.0):
    """Call send_fn() and retry on transient (4xx) SMTP failures.

    Permanent (5xx) errors and non-SMTP exceptions are raised immediately.
    """
    for attempt in range(1, max_attempts + 1):
        try:
            return send_fn()
        except (SMTPResponseException, SMTPServerDisconnected) as e:
            is_permanent = isinstance(e, SMTPResponseException) and e.smtp_code >= 500
            if is_permanent or attempt == max_attempts:
                raise
            delay = base_delay * (2 ** (attempt - 1)) + random.uniform(0, 1)
            time.sleep(delay)


# Usage:
# send_with_retry(lambda: send_email_via_zerosmtp(**config))
```

The same shape applies in any language: catch the transient-vs-permanent
distinction from your SMTP library's exception/response code, retry only
the transient case a bounded number of times, and always cap the total
number of attempts — an unattended sender that retries forever on a
permanently-misconfigured address is itself a bug.

## What not to do

- Don't retry in a tight loop with no delay — that just recreates the load
  that triggered a rate limit in the first place.
- Don't silently swallow a permanent (5xx) failure — surface it so a bad
  recipient address gets fixed instead of retried forever.
