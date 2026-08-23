#!/usr/bin/env python3
"""Reject workflow files GitHub would refuse to parse.

A workflow with a syntax error fails at startup: no job, no log, and a run
named after the file path instead of the workflow. Nothing points at the
cause. Two files sat like that for twelve runs each on 2026-08-17, each
carrying a control character a scripted edit had written into a regex where
an escape sequence was meant.
"""
import ast
import glob
import os
import re
import sys

import yaml

# Third-party modules and the pip package that provides them. Only what this
# repository actually imports; an unknown module is reported under its own name
# rather than guessed at.
PAKIET = {"yaml": "pyyaml"}


def importy_zewnetrzne(sciezka):
    """Top-level third-party imports of a Python file, as module names."""
    try:
        drzewo = ast.parse(open(sciezka, encoding="utf-8").read())
    except Exception:
        return set()
    moduly = set()
    for w in ast.walk(drzewo):
        if isinstance(w, ast.Import):
            moduly |= {a.name.split(".")[0] for a in w.names}
        elif isinstance(w, ast.ImportFrom) and w.level == 0 and w.module:
            moduly.add(w.module.split(".")[0])
    katalog = os.path.dirname(sciezka) or "."
    lokalne = {f[:-3] for f in os.listdir(katalog) if f.endswith(".py")}
    return {m for m in moduly
            if m not in sys.stdlib_module_names and m not in lokalne}


def sprawdz_kolejnosc(job, nazwa, path):
    """A python script must not run before its dependencies are installed.

    tools/check-action.py was added on 2026-08-22 above the step that ran
    `pip install pyyaml`, so every run of that job died on ModuleNotFoundError
    before reaching the install. The first person to see the red check was an
    outside contributor on their first pull request, on a change to a JSON file.

    Each check in this file reads one file at a time. This one is the only one
    that reads a job as a sequence, which is the shape that failure had: every
    individual step was correct and the order was not.
    """
    zle = False
    zainstalowane = set()
    for krok in job.get("steps") or []:
        if not isinstance(krok, dict):
            continue
        run = krok.get("run")
        if not isinstance(run, str):
            continue

        for m in re.finditer(r"pip3?\s+install\s+([^\n|;&]+)", run):
            for slowo in m.group(1).split():
                if not slowo.startswith("-"):
                    zainstalowane.add(slowo.lower())

        for m in re.finditer(r"python3?\s+([\w./-]+\.py)", run):
            skrypt = m.group(1)
            if not os.path.exists(skrypt):
                continue
            for modul in importy_zewnetrzne(skrypt):
                pakiet = PAKIET.get(modul, modul).lower()
                if pakiet in zainstalowane or modul.lower() in zainstalowane:
                    continue
                krok_nazwa = krok.get("name") or run.strip().splitlines()[0]
                print(f"::error file={path}::job `{nazwa}`, step "
                      f"`{krok_nazwa}` runs {skrypt}, which imports "
                      f"`{modul}` - but nothing installed `{pakiet}` earlier "
                      f"in this job. It will die on ModuleNotFoundError.")
                zle = True
    return zle


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
                if sprawdz_kolejnosc(job, name, path):
                    bad = True

print("Workflow files: clean." if not bad else "Workflow files: problems above.")
sys.exit(1 if bad else 0)
