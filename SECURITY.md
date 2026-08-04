# Security Policy

## Reporting a Vulnerability

If you find a security vulnerability in this repository (an example script,
a workflow, a dependency pin, or anything else in this codebase), please
report it privately using [GitHub's private vulnerability reporting](../../security/advisories/new)
for this repository, or email **abuse@msgwing.com**.

Please do not open a public issue for security reports until a fix is
available.

## Scope

This repository contains client-side example code for connecting to the
ZeroSMTP relay (`mx.msgwing.com`). Vulnerabilities in scope include:

- Insecure defaults in any example (disabled certificate verification,
  weak/deprecated protocols, credential handling issues)
- Vulnerable dependency versions pinned in `package.json`, `composer.json`,
  `Cargo.toml`, `Package.swift`, `cs-zerosmtp.csproj`, `pom.xml`, or
  `build.gradle.kts`
- Issues in the CI workflows under `.github/workflows/`

Vulnerabilities in the ZeroSMTP *service* itself (mx.msgwing.com,
msgwing.com) should also be reported to abuse@msgwing.com.

## Infrastructure and third-party integration inquiries

We don't publish operational specifics about the relay — server setup, IP
reputation management, abuse monitoring, or anything else about how
`mx.msgwing.com` stays off blacklists — beyond what's already documented
in the [FAQ](https://docs.msgwing.com/FAQ.html) (rate limits,
SPF/DKIM/DMARC alignment, and the abuse policy). Sharing that level of
detail would make it easier to abuse the shared domain's reputation,
which those trade-offs exist to protect against for everyone using the
service. If you're evaluating ZeroSMTP for a legitimate use case and have
questions about *your own* integration rather than our internals, reach
out at abuse@msgwing.com.

We also don't accept third-party plugins, widgets, or scripts on the
docs site (docs.msgwing.com). It intentionally ships with zero
third-party JavaScript — no analytics, no trackers, no chat widgets, no
translation or accessibility overlays, nothing that executes in a
visitor's browser beyond what's in this repository. A remote script has
to be trusted indefinitely rather than reviewed once, which doesn't fit
the handling of visitor data described in the FAQ. That holds regardless
of price or how simple the integration is. If multilingual support is
ever added, it will be static, self-hosted pages generated from this
repository, not a live third-party widget.

## Supported Versions

This is an examples repository rather than a versioned library — only the
latest commit on `main` is supported. Please update to the latest version
before reporting an issue.
