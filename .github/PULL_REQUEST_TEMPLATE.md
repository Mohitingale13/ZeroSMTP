## What does this PR change?

<!-- One or two sentences. -->

## Checklist

- [ ] Credentials are read from `ZEROSMTP_*` environment variables, not hardcoded
- [ ] No certificate verification is disabled/bypassed anywhere in the diff
- [ ] Port 587 (STARTTLS) or 465 (implicit SSL/TLS) only — never 25
- [ ] Code comments/docs are in English (see [CONTRIBUTING.md](../CONTRIBUTING.md))
- [ ] If you added or changed a language example: it builds/runs locally, or
      you've noted in this PR which CI job (`.github/workflows/lint.yml`)
      should cover it
- [ ] If you changed a dependency version: you checked it actually exists
      on the relevant registry (npm/Packagist/crates.io/Maven Central/NuGet)
