![ZeroSMTP — free SMTP relay for developers and sysadmins, mx.msgwing.com, port 587/465, TLS](assets/banner.png)

# ZeroSMTP — a free SMTP relay that still accepts basic auth

**Your printer, scanner or app stopped sending email through Microsoft 365?**
You're most likely hitting the Basic authentication shutdown. This site
explains what happened, lists every way to fix it, and documents one free
option among them.

```
535 5.7.139 Authentication unsuccessful, basic authentication is disabled
```

If that's the error you're seeing, start with
[Exchange Online SMTP AUTH migration](EXCHANGE-ONLINE-SMTP-AUTH.md).

<div id="zc-fc" style="
  position:relative;overflow:hidden;
  background:radial-gradient(ellipse at 50% 120%, #2d1b4e 0%, #0d0620 55%, #050310 100%);
  border:1px solid #ff2ec4;border-radius:12px;max-width:640px;
  padding:28px 20px 22px;margin:20px auto;
  font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif;
  text-align:center;
  box-shadow:0 0 30px rgba(255,46,196,.25), inset 0 0 60px rgba(60,20,120,.4);
">
  <noscript>Basic authentication for SMTP AUTH is disabled by default on existing Microsoft 365 tenants at the end of December 2026.</noscript>
  <div id="zc-fc-stars" style="position:absolute;inset:0;pointer-events:none;"></div>

  <div style="position:relative;font-size:11px;letter-spacing:.25em;text-transform:uppercase;
              color:#ff2ec4;text-shadow:0 0 8px #ff2ec4;margin-bottom:10px;font-weight:700;">
    🚀 It's the final countdown <span style="opacity:.6;">&mdash; for Basic Auth on SMTP AUTH</span>
  </div>

  <div id="zc-fc-digits" style="position:relative;display:flex;justify-content:center;gap:14px;flex-wrap:wrap;"></div>

  <div style="position:relative;font-size:12px;color:#8be9fd;margin-top:12px;text-shadow:0 0 6px rgba(139,233,253,.6);">
    Microsoft disables it by default on existing tenants &mdash; end of December 2026
  </div>

  <span style="position:absolute;left:-9999px;">
    Countdown to the Microsoft 365 SMTP AUTH Basic authentication default change, end of December 2026.
  </span>
</div>
<style>
  @keyframes zc-fc-pulse { 0%,100%{ text-shadow:0 0 12px currentColor,0 0 24px currentColor; } 50%{ text-shadow:0 0 20px currentColor,0 0 40px currentColor; } }
  @keyframes zc-fc-twinkle { 0%,100%{ opacity:.15; } 50%{ opacity:.9; } }
  .zc-fc-unit { min-width:64px; }
  .zc-fc-num {
    font-family:'Courier New',monospace; font-weight:700; font-size:2.4rem; line-height:1;
    color:#8be9fd; animation:zc-fc-pulse 2.2s ease-in-out infinite;
  }
  .zc-fc-label { font-size:.65rem;letter-spacing:.15em;text-transform:uppercase;color:#c792ea;margin-top:4px; }
  .zc-fc-sep { font-size:2.4rem;font-weight:700;color:#ff2ec4;align-self:flex-start;text-shadow:0 0 10px #ff2ec4; }
</style>
<script>
(function(){
  var wrap = document.getElementById('zc-fc');
  var digitsEl = document.getElementById('zc-fc-digits');
  var starsEl = document.getElementById('zc-fc-stars');
  if (!wrap || !digitsEl) return;

  for (var i = 0; i < 40; i++) {
    var s = document.createElement('div');
    var size = Math.random() < 0.8 ? 1 : 2;
    s.style.cssText = 'position:absolute;width:' + size + 'px;height:' + size + 'px;' +
      'left:' + (Math.random()*100) + '%;top:' + (Math.random()*100) + '%;' +
      'background:#fff;border-radius:50%;' +
      'animation:zc-fc-twinkle ' + (2 + Math.random()*3).toFixed(1) + 's ease-in-out infinite;' +
      'animation-delay:' + (Math.random()*3).toFixed(1) + 's;';
    starsEl.appendChild(s);
  }

  var deadline = new Date('2026-12-31T23:59:59Z');

  function pad(n){ return String(n).padStart(2, '0'); }

  function unit(value, label){
    return '<div class="zc-fc-unit"><div class="zc-fc-num">' + value + '</div>' +
           '<div class="zc-fc-label">' + label + '</div></div>';
  }

  function render(){
    var diff = deadline - new Date();
    if (diff <= 0) {
      digitsEl.innerHTML = '<div class="zc-fc-num" style="font-size:1.4rem;">The default has flipped &mdash; Basic auth is off.</div>';
      return;
    }
    var d = Math.floor(diff / 86400000);
    var h = Math.floor((diff % 86400000) / 3600000);
    var m = Math.floor((diff % 3600000) / 60000);
    var s = Math.floor((diff % 60000) / 1000);

    digitsEl.innerHTML =
      unit(d, d === 1 ? 'day' : 'days') +
      '<div class="zc-fc-sep">:</div>' +
      unit(pad(h), 'hrs') +
      '<div class="zc-fc-sep">:</div>' +
      unit(pad(m), 'min') +
      '<div class="zc-fc-sep">:</div>' +
      unit(pad(s), 'sec');
  }

  render();
  setInterval(render, 1000);
})();
</script>

---

## Start here

| If you… | Go to |
| --- | --- |
| Got an authentication error from `smtp.office365.com` | [Exchange Online SMTP AUTH migration](EXCHANGE-ONLINE-SMTP-AUTH.md) |
| Need to know **what else** in your environment will break | [What breaks: affected systems](AFFECTED-SYSTEMS.md) |
| Have a printer or MFP to reconfigure | [Printer scan-to-email setup by brand](PRINTERS.md) |
| Manage Windows Server / IIS / Exchange | [Windows Server guide](WINDOWS-SERVER.md) |
| Manage Linux servers | [Linux](LINUX.md) · [system-wide relay](SYSTEM-MTA.md) |
| Are sending from an app or script | [Code examples in 15 languages](CODE-EXAMPLES.md) |
| Have it failing or timing out | [Troubleshooting](TROUBLESHOOTING.md) |
| Have monitoring/alerting tools that need to send mail | [Monitoring alerts](MONITORING.md) |
| Want to see confirmed fixes for specific hardware | [Device case studies](DEVICE-CASE-STUDIES.md) |
| Just want the short answers | [FAQ](FAQ.md) |

## What is happening

Microsoft is retiring Basic authentication (username + password) for SMTP
AUTH in Exchange Online. Per Microsoft's
[updated timeline](https://techcommunity.microsoft.com/blog/exchange/updated-exchange-online-smtp-auth-basic-authentication-deprecation-timeline/4489835),
it is **disabled by default on existing tenants at the end of December 2026**,
unavailable by default for tenants created after that, with final removal
announced in the second half of 2027.

Devices that can run OAuth 2.0 can be updated. Older printers, scanners,
NAS units and line-of-business software generally cannot — and for many of
them no firmware update will ever exist.

## What ZeroSMTP is

A free SMTP relay at `mx.msgwing.com` that **still accepts a plain username
and password over TLS**. For a device with no OAuth path, migrating means
changing three fields:

| Setting | From | To |
| --- | --- | --- |
| Server | `smtp.office365.com` | `mx.msgwing.com` |
| Port | 587 | 587 (STARTTLS) or 465 (SSL/TLS) |
| Credentials | Microsoft 365 account | free `@msgwing.com` account |

**The trade-off, stated plainly:** mail is sent *from* an `@msgwing.com`
address, **not your own domain**
([why](FAQ.md#will-emails-be-sent-from-my-own-domain-eg-youyourdomaincom)),
and there is a [200 emails/day limit](TROUBLESHOOTING.md#sending-limits-rate-limiting).

That makes it a good fit for scan-to-email, device and backup alerts,
monitoring notifications, homelabs, schools and small offices — anywhere the
message just needs to arrive. It is **not** the right answer for
customer-facing mail or anything that must come from your company domain. The
[migration guide](EXCHANGE-ONLINE-SMTP-AUTH.md) covers the options that are,
including Microsoft's own.

## Get started

1. Register a free account at [msgwing.com](https://msgwing.com).
2. Copy the generated `@msgwing.com` username and password.
3. Point your device or app at `mx.msgwing.com` on port 587 with STARTTLS.

Full quickstart, 15 language examples and setup guides are in the
[GitHub repository](https://github.com/msgwing/ZeroSMTP).

---

<p><small>
Service status is checked automatically every 6 hours —
<a href="https://github.com/msgwing/ZeroSMTP/actions/workflows/service-healthcheck.yml">see the live check</a>.
Questions or corrections: <a href="https://github.com/msgwing/ZeroSMTP/issues/new/choose">open an issue</a>.
</small></p>
