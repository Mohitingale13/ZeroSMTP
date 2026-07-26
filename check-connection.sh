#!/bin/bash
# check-connection.sh
# Connectivity-only healthcheck for mx.msgwing.com.
# No credentials required, no email sent. Run this first if a send is
# hanging or timing out — see docs/TROUBLESHOOTING.md for context.

set -uo pipefail

HOST="mx.msgwing.com"
PORTS=(587 465)

echo "== DNS resolution =="
if command -v getent >/dev/null 2>&1; then
  getent hosts "$HOST" || echo "Could not resolve $HOST"
elif command -v host >/dev/null 2>&1; then
  host "$HOST" || echo "Could not resolve $HOST"
else
  echo "No getent/host command available to test DNS resolution"
fi

for port in "${PORTS[@]}"; do
  echo
  echo "== TCP connect to $HOST:$port =="
  if timeout 10 bash -c "exec 3<>/dev/tcp/$HOST/$port" 2>/dev/null; then
    echo "TCP connect: OK"
  else
    echo "TCP connect: FAILED (likely blocked by your network/provider — see docs/TROUBLESHOOTING.md)"
    continue
  fi

  echo "== TLS handshake on $HOST:$port =="
  if ! command -v openssl >/dev/null 2>&1; then
    echo "openssl not found, skipping TLS handshake check"
    continue
  fi
  if [ "$port" = "465" ]; then
    tls_check=$(openssl s_client -connect "$HOST:$port" -servername "$HOST" </dev/null 2>/dev/null)
  else
    tls_check=$(openssl s_client -starttls smtp -connect "$HOST:$port" -servername "$HOST" </dev/null 2>/dev/null)
  fi
  if echo "$tls_check" | grep -q "Verify return code: 0"; then
    echo "TLS handshake: OK"
  else
    echo "TLS handshake: FAILED or certificate could not be verified"
  fi
done

echo
echo "No email was sent by this script."
echo "If both ports failed to connect, your network or cloud provider is very likely blocking outbound SMTP — see docs/TROUBLESHOOTING.md."
