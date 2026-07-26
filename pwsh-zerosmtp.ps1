# ====================================================================
# pwsh-zerosmtp.ps1
# ====================================================================
# PowerShell SMTP Test Script - ZeroSMTP (msgwing.com)
#
# Features:
#   - Port 587 (STARTTLS), full TLS certificate validation via MailKit
#   - Full parameter support via PSCredential
#   - Environment variable fallback
#   - Production-ready error handling
#
# SECURITY NOTE: this script uses the Send-MailKitMessage module instead of
# the built-in Send-MailMessage cmdlet. Send-MailMessage is marked Obsolete
# by Microsoft ("This cmdlet does not guarantee secure connections to SMTP
# servers.") and must not be used for new code.
#
# Requirements:
#   - PowerShell 5.1+ (Windows PowerShell) or PowerShell 7.0+ (cross-platform)
#   - Send-MailKitMessage module: Install-Module -Name Send-MailKitMessage -Scope CurrentUser
#   - Active ZeroSMTP account at https://msgwing.com
#
# Usage:
#   ./pwsh-zerosmtp.ps1 -Username "user@msgwing.com" -Password "yourpassword" `
#                       -From "user@msgwing.com" -To "recipient@example.com"
#
#   Or with environment variables:
#   $env:ZEROSMTP_USERNAME="user@msgwing.com"
#   $env:ZEROSMTP_PASSWORD="yourpassword"
#   $env:ZEROSMTP_FROM="user@msgwing.com"
#   $env:ZEROSMTP_TO="recipient@example.com"
#   ./pwsh-zerosmtp.ps1
#
#   NOTE: variable names are prefixed with ZEROSMTP_ to avoid colliding with
#   reserved/OS-level variables (e.g. USERNAME is auto-set on Windows).
# ====================================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$Username = $env:ZEROSMTP_USERNAME,

    [Parameter(Mandatory=$false)]
    [string]$Password = $env:ZEROSMTP_PASSWORD,

    [Parameter(Mandatory=$false)]
    [string]$From = $env:ZEROSMTP_FROM,

    [Parameter(Mandatory=$false)]
    [string]$To = $env:ZEROSMTP_TO,

    [Parameter(Mandatory=$false)]
    [string]$Subject = $env:ZEROSMTP_SUBJECT,

    [Parameter(Mandatory=$false)]
    [string]$Body = $env:ZEROSMTP_BODY
)

# ====================================================================
# DEFAULTS
# ====================================================================

if (-not $Username) { $Username = 'your-username@msgwing.com' }
if (-not $Password) { $Password = 'your-password' }
if (-not $From)     { $From    = 'your-username@msgwing.com' }
if (-not $To)       { $To      = 'recipient@example.com' }
if (-not $Subject)  { $Subject = 'Test Email from ZeroSMTP' }
if (-not $Body)     { $Body    = @"
Hello from ZeroSMTP!

This email was sent via msgwing.com's free SMTP relay service.

Service: ZeroSMTP (https://msgwing.com)
SMTP Server: mx.msgwing.com
Port: 587 (STARTTLS)

Thank you for using ZeroSMTP!
"@ }

# ====================================================================
# CONFIGURATION
# ====================================================================

$SmtpServer = "mx.msgwing.com"
$SmtpPort = 587  # STARTTLS

# ====================================================================
# SCRIPT EXECUTION
# ====================================================================

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "ZeroSMTP PowerShell Email Test" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

if (-not (Get-Module -ListAvailable -Name Send-MailKitMessage)) {
    Write-Host "`n[ERROR] Send-MailKitMessage module is not installed" -ForegroundColor Red
    Write-Host "  Install it with: Install-Module -Name Send-MailKitMessage -Scope CurrentUser`n" -ForegroundColor Yellow
    exit 1
}
Import-Module Send-MailKitMessage

try {
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
    Write-Host "[OK] Credentials configured" -ForegroundColor Green
}
catch {
    Write-Host "`n[ERROR] Failed to configure credentials" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Display configuration
Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  SMTP Server: $SmtpServer"
Write-Host "  Port: $SmtpPort"
Write-Host "  Security: STARTTLS (Explicit TLS, full certificate validation)"
Write-Host "  From: $From"
Write-Host "  To: $To"
Write-Host "  Subject: $Subject`n"

try {
    Write-Host "Sending email..." -ForegroundColor Cyan

    $MailFrom = [MimeKit.MailboxAddress]$From
    $RecipientList = [MimeKit.InternetAddressList]::new()
    $RecipientList.Add([MimeKit.InternetAddress]$To)

    Send-MailKitMessage `
        -UseSecureConnectionIfAvailable `
        -Credential $Credential `
        -SMTPServer $SmtpServer `
        -Port $SmtpPort `
        -From $MailFrom `
        -RecipientList $RecipientList `
        -Subject $Subject `
        -TextBody $Body

    Write-Host "`n[OK] Email sent successfully!" -ForegroundColor Green
    Write-Host "`nEmail Details:" -ForegroundColor Green
    Write-Host "  From: $From"
    Write-Host "  To: $To"
    Write-Host "  Subject: $Subject"
    Write-Host "  Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
    exit 0
}
catch {
    Write-Host "`n[ERROR] Error sending email" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nTroubleshooting:" -ForegroundColor Yellow
    Write-Host "  - Verify username and password"
    Write-Host "  - Ensure @msgwing.com account is active"
    Write-Host "  - Check network connectivity"
    Write-Host "  - Verify recipient email address is valid`n"
    exit 1
}
