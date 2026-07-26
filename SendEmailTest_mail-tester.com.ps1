# ====================================================================
# SendEmailTest_mail-tester.com.ps1
# ====================================================================
# PowerShell SMTP Authentication Test Script for mail-tester.com
#
# This script demonstrates how to send test emails using ZeroSMTP
# service (msgwing.com) to verify domain reputation on mail-tester.com.
#
# This script uses the Send-MailKitMessage module (built on MailKit)
# instead of the built-in Send-MailMessage cmdlet, which Microsoft marks
# Obsolete ("This cmdlet does not guarantee secure connections to SMTP
# servers."). Unlike Send-MailMessage, MailKit fully supports both
# port 587 (STARTTLS) and port 465 (Implicit SSL/TLS).
#
# Requirements:
# - Send-MailKitMessage module: Install-Module -Name Send-MailKitMessage -Scope CurrentUser
# - Active ZeroSMTP account at https://msgwing.com
# - Credentials for your @msgwing.com email address
# - Test email address from https://mail-tester.com
#
# Usage:
# 1. Register at https://msgwing.com and note your @msgwing.com email address
# 2. Register at https://mail-tester.com and get a unique test email address
# 3. Set the environment variables below with your credentials
# 4. Run this script in PowerShell
# 5. Check mail-tester.com for the reputation score and detailed report
#
#   $env:ZEROSMTP_USERNAME="your-email@msgwing.com"
#   $env:ZEROSMTP_PASSWORD="yourpassword"
#   $env:ZEROSMTP_TEST_RECIPIENT="test-XXXXX@srv1.mail-tester.com"
#   ./SendEmailTest_mail-tester.com.ps1
# ====================================================================

# ====================================================================
# CONFIGURATION SECTION
# ====================================================================
# NOTE: credentials are read from environment variables rather than
# hardcoded here, so real secrets are never accidentally committed to
# version control. Variable names are prefixed with ZEROSMTP_ to avoid
# colliding with reserved/OS-level variables (e.g. USERNAME is auto-set
# on Windows).

$SmtpServer = "mx.msgwing.com"                  # ZeroSMTP server
$SmtpPort = 587                                 # STARTTLS
$SmtpUser = if ($env:ZEROSMTP_USERNAME) { $env:ZEROSMTP_USERNAME } else { "your-email@msgwing.com" }
$SmtpPassword = if ($env:ZEROSMTP_PASSWORD) { $env:ZEROSMTP_PASSWORD } else { "your-password" }
$TestRecipient = if ($env:ZEROSMTP_TEST_RECIPIENT) { $env:ZEROSMTP_TEST_RECIPIENT } else { "test-XXXXX@srv1.mail-tester.com" }

# ====================================================================
# SCRIPT EXECUTION
# ====================================================================

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "ZeroSMTP Domain Reputation Test" -ForegroundColor Cyan
Write-Host "mail-tester.com Integration Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

if (-not (Get-Module -ListAvailable -Name Send-MailKitMessage)) {
    Write-Host "`n[ERROR] Send-MailKitMessage module is not installed" -ForegroundColor Red
    Write-Host "  Install it with: Install-Module -Name Send-MailKitMessage -Scope CurrentUser`n" -ForegroundColor Yellow
    exit 1
}
Import-Module Send-MailKitMessage

# Convert plain text password to SecureString for credential object
try {
    $SecurePassword = ConvertTo-SecureString -String $SmtpPassword -AsPlainText -Force
    $SmtpCredential = New-Object System.Management.Automation.PSCredential($SmtpUser, $SecurePassword)
    Write-Host "[OK] Credentials configured successfully" -ForegroundColor Green
}
catch {
    Write-Host "`n[ERROR] Error configuring credentials" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# ====================================================================
# PORT 587 TEST (STARTTLS)
# ====================================================================

Write-Host "`n=========================================`n" -ForegroundColor Cyan
Write-Host "Testing SMTP Authentication - Port 587 (STARTTLS)" -ForegroundColor Yellow
Write-Host "=========================================`n" -ForegroundColor Cyan

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  SMTP Server: $SmtpServer"
Write-Host "  Port: $SmtpPort"
Write-Host "  Authentication: STARTTLS (Explicit TLS, full certificate validation)"
Write-Host "  From: $SmtpUser"
Write-Host "  To: $TestRecipient`n"

try {
    $MailFrom = [MimeKit.MailboxAddress]$SmtpUser
    $RecipientList = [MimeKit.InternetAddressList]::new()
    $RecipientList.Add([MimeKit.InternetAddress]$TestRecipient)

    $Body = @"
This is a test email from ZeroSMTP (msgwing.com) service.

Send Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Test Email Address: $TestRecipient
Connection Method: STARTTLS (Port 587)

This email is being used to verify the domain reputation of msgwing.com
on mail-tester.com. Please check your mail-tester.com account for
detailed reputation analysis and scoring.

Email Authentication Checks:
  - SPF (Sender Policy Framework)
  - DKIM (DomainKeys Identified Mail)
  - DMARC (Domain-based Message Authentication, Reporting and Conformance)

Thank you for using ZeroSMTP!
"@

    Send-MailKitMessage `
        -UseSecureConnectionIfAvailable `
        -Credential $SmtpCredential `
        -SMTPServer $SmtpServer `
        -Port $SmtpPort `
        -From $MailFrom `
        -RecipientList $RecipientList `
        -Subject "ZeroSMTP Test Email - mail-tester.com Reputation Check" `
        -TextBody $Body

    Write-Host "[OK] Email sent successfully on port 587 (STARTTLS)!" -ForegroundColor Green
    Write-Host "`n  Next Steps:`n" -ForegroundColor Green
    Write-Host "  1. Log in to https://mail-tester.com"
    Write-Host "  2. Check your test email address for the incoming message"
    Write-Host "  3. Review the reputation score and detailed analysis"
    Write-Host "  4. Check SPF, DKIM, and DMARC authentication results`n"
}
catch {
    Write-Host "[ERROR] Error sending email on port 587" -ForegroundColor Red
    Write-Host "  Exception: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`n  Troubleshooting Tips:`n" -ForegroundColor Yellow
    Write-Host "  - Verify your ZeroSMTP credentials"
    Write-Host "  - Ensure your @msgwing.com account is active"
    Write-Host "  - Check your network connectivity"
    Write-Host "  - Verify the mail-tester.com test email address is correct`n"
    exit 1
}

# ====================================================================
# SUMMARY
# ====================================================================

Write-Host "=========================================`n" -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "=========================================`n" -ForegroundColor Cyan

Write-Host "Email Test Results:" -ForegroundColor Yellow
Write-Host "  Service: ZeroSMTP (msgwing.com)"
Write-Host "  Domain: msgwing.com"
Write-Host "  Sender: $SmtpUser"
Write-Host "  Recipient: $TestRecipient`n"

Write-Host "What to Verify on mail-tester.com:" -ForegroundColor Yellow
Write-Host "  [ ] SPF (Sender Policy Framework) - Authentication status"
Write-Host "  [ ] DKIM (DomainKeys Identified Mail) - Signature verification"
Write-Host "  [ ] DMARC (Domain-based Message Authentication) - Policy compliance"
Write-Host "  [ ] Reputation Score - Domain trustworthiness"
Write-Host "  [ ] Blacklist Status - Check for any listing issues"
Write-Host "  [ ] TLS Version - Verify secure connection`n"

Write-Host "Supported Ports (via Send-MailKitMessage):" -ForegroundColor Yellow
Write-Host "  - Port 587 (STARTTLS) - used by this script"
Write-Host "  - Port 465 (Implicit SSL/TLS) - also supported, see pwsh-zerosmtp.ps1 / other language examples`n"

Write-Host "For more information:" -ForegroundColor Cyan
Write-Host "  - ZeroSMTP: https://msgwing.com"
Write-Host "  - Mail-tester: https://mail-tester.com"
Write-Host "  - Report Issues: abuse@msgwing.com`n"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Script execution completed successfully" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
