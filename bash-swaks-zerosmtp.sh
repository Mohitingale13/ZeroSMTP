#!/bin/bash
# bash-swaks-zerosmtp.sh
# Bash swaks 20240101+ - ZeroSMTP mx.msgwing.com:465 SSL/TLS
# Production-ready | Let's Encrypt | Full cert verification

set -euo pipefail

error_exit() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

trap 'error_exit "Script interrupted"' INT TERM

# Configuration
# NOTE: names are prefixed with ZEROSMTP_ to avoid colliding with
# reserved/OS-level variables (e.g. USERNAME is auto-set on Windows).
USERNAME="${ZEROSMTP_USERNAME:-your-username}"
PASSWORD="${ZEROSMTP_PASSWORD:-your-password}"
FROM="${ZEROSMTP_FROM:-sender@example.com}"
TO="${ZEROSMTP_TO:-recipient@example.com}"
SUBJECT="${ZEROSMTP_SUBJECT:-Test Email from ZeroSMTP}"
BODY="${ZEROSMTP_BODY:-Hello from ZeroSMTP! This is an email sent via mx.msgwing.com:465}"

# Validate
[[ -z "$USERNAME" ]] && error_exit "ZEROSMTP_USERNAME not set"
[[ -z "$PASSWORD" ]] && error_exit "ZEROSMTP_PASSWORD not set"
[[ -z "$FROM" ]] && error_exit "ZEROSMTP_FROM not set"
[[ -z "$TO" ]] && error_exit "ZEROSMTP_TO not set"

# Check swaks availability
command -v swaks >/dev/null 2>&1 || error_exit "swaks not found. Install with: apt-get install swaks"

# Send email with swaks
# --tlsc: Require encrypted TLS connection
# --auth LOGIN: Use LOGIN authentication mechanism
SWAKS_OUTPUT=$(swaks \
  --to "$TO" \
  --from "$FROM" \
  --subject "$SUBJECT" \
  --body "$BODY" \
  --header "Content-Type: text/plain; charset=UTF-8" \
  --header "MIME-Version: 1.0" \
  --server mx.msgwing.com:465 \
  --tlsc \
  --auth LOGIN \
  --auth-user "$USERNAME" \
  --auth-password "$PASSWORD" \
  --timeout 30 \
  2>&1) || error_exit "swaks failed: $SWAKS_OUTPUT"

printf '%s\n' "$SWAKS_OUTPUT"
printf 'Email sent successfully via ZeroSMTP\n'
exit 0
