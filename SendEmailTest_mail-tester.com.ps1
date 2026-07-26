# ====================================================================
# SendEmailTest_mail-tester.com.ps1
# ====================================================================
# PowerShell SMTP Authentication Test Script for mail-tester.com
# 
# This script demonstrates how to send test emails using ZeroSMTP
# service (msgwing.com) to verify domain reputation on mail-tester.com.
#
# IMPORTANT: This script uses PORT 587 (STARTTLS) which is fully supported
#            by PowerShell's Send-MailMessage cmdlet.
#            Port 465 (Implicit SSL) is NOT supported by PowerShell's
#            Send-MailMessage and will cause connection failures.
#
# Requirements:
# - Active ZeroSMTP account at https://msgwing.com
# - Credentials for your @msgwing.com email address
# - Test email address from https://mail-tester.com
#
# Usage:
# 1. Register at https://msgwing.com and note your @msgwing.com email address
# 2. Register at https://mail-tester.com and get a unique test email address
# 3. Update the variables below with your credentials
# 4. Run this script in PowerShell
# 5. Check mail-tester.com for the reputation score and detailed report
# ====================================================================

# ====================================================================
# CONFIGURATION SECTION - Update with your credentials
# ====================================================================

$SmtpServer = "mx.msgwing.com"                  # ZeroSMTP server
$SmtpUser = "your-email@msgwing.com"            # YOUR registered ZeroSMTP account (example format)
$SmtpPassword = "your-password"                 # YOUR ZeroSMTP account password
$TestRecipient = "test-XXXXX@srv1.mail-tester.com"  # YOUR unique test email from mail-tester.com

# ====================================================================
# SCRIPT EXECUTION
# ====================================================================

Write-Host "`n=========================================" -ForegroundColor Cyan
Write-Host "ZeroSMTP Domain Reputation Test" -ForegroundColor Cyan
Write-Host "mail-tester.com Integration Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Ensure TLS 1.2+ compatibility
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Tls13
Write-Host "`n✓ Security Protocol: TLS 1.2+ enabled" -ForegroundColor Green

# Convert plain text password to SecureString for credential object
try {
    $SecurePassword = ConvertTo-SecureString -String $SmtpPassword -AsPlainText -Force
    $SmtpCredential = New-Object System.Management.Automation.PSCredential($SmtpUser, $SecurePassword)
    Write-Host "✓ Credentials configured successfully" -ForegroundColor Green
}
catch {
    Write-Host "`n✗ Error configuring credentials" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# ====================================================================
# PORT 587 TEST (STARTTLS - Recommended)
# ====================================================================

Write-Host "`n=========================================`n" -ForegroundColor Cyan
Write-Host "Testing SMTP Authentication - Port 587 (STARTTLS)" -ForegroundColor Yellow
Write-Host "=========================================`n" -ForegroundColor Cyan

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  SMTP Server: $SmtpServer" 
Write-Host "  Port: 587"
Write-Host "  Authentication: STARTTLS (Explicit TLS)"
Write-Host "  From: $SmtpUser"
Write-Host "  To: $TestRecipient"
Write-Host "  Status: ✓ Fully supported by PowerShell Send-MailMessage`n"

try {
    # Construct mail parameters for port 587
    $MailParams = @{
        SmtpServer = $SmtpServer
        Port = 587
        UseSsl = $true
        Credential = $SmtpCredential
        From = $SmtpUser
        To = $TestRecipient
        Subject = "ZeroSMTP Test Email - mail-tester.com Reputation Check"
        Body = @"
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
        Encoding = "UTF8"
        ErrorAction = "Stop"
    }

    # Send the test email
    Send-MailMessage @MailParams

    Write-Host "✓ Email sent successfully on port 587 (STARTTLS)!" -ForegroundColor Green
    Write-Host "`n  Next Steps:`n" -ForegroundColor Green
    Write-Host "  1. Log in to https://mail-tester.com" 
    Write-Host "  2. Check your test email address for the incoming message"
    Write-Host "  3. Review the reputation score and detailed analysis"
    Write-Host "  4. Check SPF, DKIM, and DMARC authentication results`n"
}
catch {
    Write-Host "✗ Error sending email on port 587" -ForegroundColor Red
    Write-Host "  Exception: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`n  Troubleshooting Tips:`n" -ForegroundColor Yellow
    Write-Host "  - Verify your ZeroSMTP credentials"
    Write-Host "  - Ensure your @msgwing.com account is active"
    Write-Host "  - Check your network connectivity"
    Write-Host "  - Verify the mail-tester.com test email address is correct"
    Write-Host "  - Ensure TLS 1.2+ is supported by your system`n"
    exit 1
}

# ====================================================================
# REFERENCE: Port 465 (Implicit SSL) - Why NOT Supported
# ====================================================================

Write-Host "=========================================`n" -ForegroundColor Cyan
Write-Host "Reference: Port 465 (Implicit SSL) - Why Not in This Script" -ForegroundColor Yellow
Write-Host "=========================================`n" -ForegroundColor Cyan

Write-Host "PowerShell Send-MailMessage Limitation:" -ForegroundColor Yellow
Write-Host "  ✗ Does NOT support port 465 (Implicit SSL)"
Write-Host "  ✓ Only supports port 587 (STARTTLS/Explicit TLS)"
Write-Host "  ✓ Only supports port 25 (Plain/STARTTLS)`n"

Write-Host "Technical Details:" -ForegroundColor Cyan
Write-Host "  - Port 465: Requires immediate TLS encryption (Implicit SSL)"
Write-Host "  - Port 587: Allows STARTTLS (explicit upgrade to TLS)"
Write-Host "  - PowerShell: Only implements the port 587 pattern`n"

Write-Host "If you need port 465:" -ForegroundColor Green
Write-Host "  1. Use the Bash curl script: bash-curl-zerosmtp.sh"
Write-Host "  2. Use .NET SmtpClient directly with advanced configuration"
Write-Host "  3. Use third-party PowerShell modules like MailKit"
Write-Host "  4. Use alternative scripting languages (Python, Node.js, etc.)`n"

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
Write-Host "  ☐ SPF (Sender Policy Framework) - Authentication status"
Write-Host "  ☐ DKIM (DomainKeys Identified Mail) - Signature verification"
Write-Host "  ☐ DMARC (Domain-based Message Authentication) - Policy compliance"
Write-Host "  ☐ Reputation Score - Domain trustworthiness"
Write-Host "  ☐ Blacklist Status - Check for any listing issues"
Write-Host "  ☐ TLS Version - Verify secure connection`n"

Write-Host "Supported Ports for PowerShell:" -ForegroundColor Yellow
Write-Host "  ✓ Port 25 (Plain/STARTTLS) - Legacy, not recommended"
Write-Host "  ✓ Port 587 (STARTTLS) - RECOMMENDED"
Write-Host "  ✗ Port 465 (Implicit SSL) - NOT SUPPORTED by Send-MailMessage`n"

Write-Host "For more information:" -ForegroundColor Cyan
Write-Host "  - ZeroSMTP: https://msgwing.com"
Write-Host "  - Mail-tester: https://mail-tester.com"
Write-Host "  - Report Issues: abuse@msgwing.com"
Write-Host "  - PowerShell Mail: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/send-mailmessage`n"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Script execution completed successfully" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
