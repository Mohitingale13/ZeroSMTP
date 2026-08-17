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
        yaml.safe_load(raw)
    except Exception as exc:
        print(f"::error file={path}::does not parse as YAML: {exc}")
        bad = True

print("Workflow files: clean." if not bad else "Workflow files: problems above.")
sys.exit(1 if bad else 0)
