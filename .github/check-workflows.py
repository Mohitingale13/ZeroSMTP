#!/usr/bin/env python3
"""Reject workflow files GitHub would refuse to parse.

A workflow with a syntax error fails at startup: no job, no log, and a run
named after the file path instead of the workflow. Nothing points at the
cause. Two files sat like that for twelve runs each on 2026-08-17, each
carrying a control character a scripted edit had written into a regex where
an escape sequence was meant.
"""
import glob
import sys

import yaml

ALLOWED_CONTROL = {"\n", "\r"}

# The complete set GITHUB_TOKEN accepts. Anything else makes GitHub reject the
# whole workflow at startup, with the same silent, logless failure a syntax
# error produces - `administration: read` did exactly that on 2026-08-17,
# added while trying to reach the traffic API, which the Actions token cannot
# read under any permission.
VALID_PERMISSIONS = {
    "actions", "attestations", "checks", "contents", "deployments",
    "discussions", "id-token", "issues", "models", "packages", "pages",
    "pull-requests", "repository-projects", "security-events", "statuses",
}

bad = False
for path in sorted(glob.glob(".github/workflows/*.yml")):
    raw = open(path, encoding="utf-8", newline="").read()

    control = sorted({hex(ord(c)) for c in raw
                      if ord(c) < 32 and c not in ALLOWED_CONTROL and c != "\t"})
    if control:
        print(f"::error file={path}::control characters {control} — GitHub "
              f"rejects the whole file, and the run reports no reason")
        bad = True

    if "\t" in raw:
        print(f"::error file={path}::literal tab — write \t in a regex "
              f"rather than embedding a real tab")
        bad = True

    try:
        doc = yaml.safe_load(raw)
    except Exception as exc:
        print(f"::error file={path}::does not parse as YAML: {exc}")
        bad = True
        continue

    # Valid YAML is not the same as a valid workflow. An unknown key under
    # `permissions:` makes GitHub reject the file at startup with the same
    # silent, logless failure - `administration: read` did exactly that on
    # 2026-08-17 while trying to reach the traffic API, which the Actions
    # token cannot read at all.
    def check_permissions(perms, where):
        global bad
        if not isinstance(perms, dict):
            return
        unknown = sorted(set(perms) - VALID_PERMISSIONS)
        if unknown:
            print(f"::error file={path}::unknown permission(s) {unknown} "
                  f"in {where} — GitHub rejects the whole workflow")
            bad = True

    if isinstance(doc, dict):
        check_permissions(doc.get("permissions"), "top-level permissions")
        for name, job in (doc.get("jobs") or {}).items():
            if isinstance(job, dict):
                check_permissions(job.get("permissions"), f"job `{name}`")

print("Workflow files: clean." if not bad else "Workflow files: problems above.")
sys.exit(1 if bad else 0)
