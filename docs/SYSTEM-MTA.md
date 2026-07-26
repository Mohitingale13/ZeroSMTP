# System-Wide Mail Relay on Debian/Ubuntu (Postfix, msmtp, Exim4)

Everything else in this repo shows how to send mail *from a script or app*.
This page is different: it's for making your **whole Debian/Ubuntu system**
— cron jobs, `mail`/`sendmail`, monitoring tools like Monit/logwatch,
`apt`/`unattended-upgrades` failure notices — relay through ZeroSMTP instead
of trying (and usually failing) to deliver mail directly.

Get your credentials first: register and activate an account at
[msgwing.com](https://msgwing.com), then copy your `@msgwing.com` login and
password.

## Top pick: Postfix (satellite / smarthost mode)

Postfix is Debian's and most Ubuntu servers' default MTA, so this is almost
always the right starting point if Postfix is already installed
(`dpkg -l postfix`).

```bash
sudo apt install -y postfix mailutils libsasl2-modules
```
During install, choose **"Satellite system"** when debconf asks (or run
`sudo dpkg-reconfigure postfix` afterwards to change it) — this tells
Postfix "don't try to deliver mail yourself, send everything to a relay."

Create the credentials file:

```bash
sudo tee /etc/postfix/sasl_passwd > /dev/null <<'EOF'
[mx.msgwing.com]:587 your-username@msgwing.com:your-password
EOF
sudo chmod 600 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd
```

Before editing `main.cf`, check which lookup table type your system
actually uses — this changed across Debian/Ubuntu releases, and using the
wrong one will make Postfix fail to start:

```bash
postconf default_database_type
```

Add to `/etc/postfix/main.cf` (replace `hash` below with whatever
`default_database_type` printed, e.g. `lmdb` on newer releases):

```ini
relayhost = [mx.msgwing.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
```

For port 465 (implicit SSL/TLS) instead of 587 (STARTTLS), use
`relayhost = [mx.msgwing.com]:465` and add
`smtp_tls_wrappermode = yes` (port 465 needs TLS immediately, not a
STARTTLS upgrade — `smtp_tls_security_level = encrypt` alone isn't enough
on that port).

Apply and test:

```bash
sudo systemctl restart postfix
echo "Test from Postfix satellite" | mail -s "ZeroSMTP test" you@example.com
tail -f /var/log/mail.log
```

## Alternative: msmtp (simplest option, no mail queue)

Good if you don't want a full MTA — just a way for `cron`/scripts to send
mail via the standard `sendmail` command.

```bash
sudo apt install -y msmtp msmtp-mta mailutils
```

`/etc/msmtprc` (or `~/.msmtprc` for a single user):

```ini
defaults
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile /var/log/msmtp.log

account zerosmtp
host mx.msgwing.com
port 587
tls_starttls on
auth on
user your-username@msgwing.com
password your-password
from your-username@msgwing.com

account default : zerosmtp
```

For port 465, set `port 465` and `tls_starttls off` (implicit TLS starts
immediately on connect, no STARTTLS upgrade). Restrict permissions since
the password is in plain text: `sudo chmod 600 /etc/msmtprc`.

`msmtp-mta` provides `/usr/sbin/sendmail`, so anything that already calls
`sendmail`/`mail` (cron, logwatch, etc.) picks this up automatically.

**Do not use `ssmtp`** for this — it's unmaintained (orphaned since 2019,
removed from Debian testing in 2024); msmtp is its official replacement.

## Alternative: Exim4 (Debian's classic alternative MTA)

If your system already runs Exim4 instead of Postfix:

```bash
sudo apt install -y exim4
sudo dpkg-reconfigure exim4-config
```

In the wizard, choose **"mail sent by smarthost; no local mail"**, and set
the smarthost to `mx.msgwing.com::587` (the double colon forces that exact
port). Then add credentials:

```bash
sudo tee -a /etc/exim4/passwd.client > /dev/null <<'EOF'
mx.msgwing.com:your-username@msgwing.com:your-password
EOF
sudo chmod 640 /etc/exim4/passwd.client
sudo update-exim4.conf
sudo systemctl restart exim4
```

## Verifying it works

Use [`check-connection.sh`](../check-connection.sh) first to confirm the
network path to `mx.msgwing.com` is open before debugging the MTA config
itself — see [TROUBLESHOOTING.md](TROUBLESHOOTING.md) if it isn't.
