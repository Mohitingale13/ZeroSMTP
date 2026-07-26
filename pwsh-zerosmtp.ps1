# ====================================================================
# pwsh-zerosmtp.ps1
# ====================================================================
# PowerShell SMTP Test Script - ZeroSMTP (msgwing.com)
# 
# Features:
#   - Port 587 (STARTTLS) - Recommended for PowerShell Send-MailMessage
#   - Full parameter support via PSCredential
#   - Environment variable fallback
#   - Production-ready error handling
#   - TLS 1.2+ security enforcement
#
# Requirements:
#   - PowerShell 5.1+ (Windows PowerShell) or PowerShell 7.0+ (cross-platform)
#   - Active ZeroSMTP account at https://msgwing.com
#
# Usage:
#   ./pwsh-zerosmtp.ps1 -Username "user@msgwing.com" -Password "yourpassword" `
#                       -From "user@msgwing.com" -To "recipient@example.com"
#
#   Or with environment variables:
#   $env:USERNAME="user@msgwing.com"
#   $env:PASSWORD="yourpassword"
#   $env:FROM="user@msgwing.com"
#   $env:TO="recipient@example.com"
#   ./pwsh-zerosmtp.ps1
# ====================================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$Username = $env:USERNAME,

    [Parameter(Mandatory=$false)]
    [string]$Password = $env:PASSWORD,

    [Parameter(Mandatory=$false)]
    [string]$From = $env:FROM,

    [Parameter(Mandatory=$false)]
    [string]$To = $env:TO,

    [Parameter(Mandatory=$false)]
    [string]$Subject = $env:SUBJECT,

    [Parameter(Mandatory=$false)]
    [string]$Body = $env:BODY
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
Security: TLS 1.2+

Thank you for using ZeroSMTP!
"@ }

# ====================================================================
# CONFIGURATION
# ====================================================================

$SmtpServer = "mx.msgwing.com"
$SmtpPort = 587  # STARTTLS - Only port fully supported by PowerShell Send-MailMessage
$UseSsl = $true  # Use STARTTLS

# ====================================================================
# SCRIPT EXECUTION
# ====================================================================

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "ZeroSMTP PowerShell Email Test" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Enforce TLS 1.2+ for modern security
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Tls13
    Write-Host "`n✓ Security Protocol: TLS 1.2+ enforced" -ForegroundColor Green
}
catch {
    Write-Host "`n⚠ Warning: Could not enforce TLS 1.2+" -ForegroundColor Yellow
}

# Create PSCredential object
try {
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
    Write-Host "✓ Credentials configured" -ForegroundColor Green
}
catch {
    Write-Host "`n✗ Error: Failed to configure credentials" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Display configuration
Write-Host "`nConfiguration:" -ForegroundColor Yellow
Write-Host "  SMTP Server: $SmtpServer"
Write-Host "  Port: $SmtpPort"
Write-Host "  Security: STARTTLS (Explicit TLS)"
Write-Host "  From: $From"
Write-Host "  To: $To"
Write-Host "  Subject: $Subject`n"

# Send email using Send-MailMessage
try {
    Write-Host "Sending email..." -ForegroundColor Cyan
    
    Send-MailMessage `
        -SmtpServer $SmtpServer `
        -Port $SmtpPort `
        -UseSsl `
        -Credential $Credential `
        -From $From `
        -To $To `
        -Subject $Subject `
        -Body $Body `
        -Encoding UTF8 `
        -ErrorAction Stop

    Write-Host "`n✓ Email sent successfully!" -ForegroundColor Green
    Write-Host "`nEmail Details:" -ForegroundColor Green
    Write-Host "  From: $From"
    Write-Host "  To: $To"
    Write-Host "  Subject: $Subject"
    Write-Host "  Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
    exit 0
}
catch [System.Net.Mail.SmtpException] {
    Write-Host "`n✗ SMTP Error" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nTroubleshooting:" -ForegroundColor Yellow
    Write-Host "  - Verify username and password"
    Write-Host "  - Ensure @msgwing.com account is active"
    Write-Host "  - Check network connectivity"
    Write-Host "  - Verify recipient email address is valid`n"
    exit 1
}
catch [System.UnauthorizedAccessException] {
    Write-Host "`n✗ Authentication Failed" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nCommon causes:" -ForegroundColor Yellow
    Write-Host "  - Incorrect password"
    Write-Host "  - Account disabled"
    Write-Host "  - Firewall/proxy blocking connection`n"
    exit 1
}
catch {
    Write-Host "`n✗ Unexpected Error" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Type: $($_.Exception.GetType().Name)`n"
    exit 1
}
