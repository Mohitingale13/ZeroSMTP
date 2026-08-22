#!/usr/bin/env python3
"""Validate action.yml against what GitHub Marketplace actually enforces.

Written after a publish attempt was rejected. The documentation page on
publishing lists the requirements that stop you having a listing at all -
public repository, one action.yml at the root, a unique name - and says nothing
about the description length. That one is only enforced by the release form,
which means the first time anybody sees it is when a person is standing in
front of the publish button with the release already drafted.

So it is checked here instead, where it costs nothing to find out.

    python tools/check-action.py
"""

import pathlib
import sys

import yaml

KORZEN = pathlib.Path(__file__).resolve().parent.parent
PLIK = KORZEN / "action.yml"

# Measured from the release form's own validator on 2026-08-22: "Description
# must be less than 125 characters." Strictly less than, so 124 is the ceiling.
MAX_OPISU = 125

# Marketplace accepts only these for branding. Anything else fails the form.
KOLORY = {"white", "yellow", "blue", "green", "orange", "red", "purple", "gray-dark"}


def main() -> int:
    if not PLIK.exists():
        print("action.yml is missing from the repository root - without it there "
              "is no Marketplace listing at all", file=sys.stderr)
        return 1

    dane = yaml.safe_load(PLIK.read_text(encoding="utf-8"))
    bledy = []

    for pole in ("name", "description", "runs"):
        if not dane.get(pole):
            bledy.append(f"{pole}: missing")

    opis = dane.get("description", "")
    if len(opis) >= MAX_OPISU:
        bledy.append(
            f"description: {len(opis)} characters, and the release form rejects "
            f"anything from {MAX_OPISU} up. Trim it here rather than finding out "
            f"at the publish button.")

    marka = dane.get("branding") or {}
    if not marka.get("icon"):
        bledy.append("branding.icon: missing - the listing has no icon without it")
    kolor = marka.get("color")
    if kolor and kolor not in KOLORY:
        bledy.append(f"branding.color: {kolor!r} is not one of {sorted(KOLORY)}")

    if bledy:
        for b in bledy:
            print(f"::error file=action.yml::{b}", file=sys.stderr)
        return 1

    print(f"action.yml is publishable - description {len(opis)}/{MAX_OPISU - 1} "
          f"characters, branding {marka.get('icon')}/{kolor}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
