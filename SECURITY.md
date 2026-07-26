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

## Supported Versions

This is an examples repository rather than a versioned library — only the
latest commit on `main` is supported. Please update to the latest version
before reporting an issue.
