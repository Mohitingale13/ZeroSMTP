# ====================================================================
# check-connection.ps1
# ====================================================================
# Connectivity-only healthcheck for mx.msgwing.com.
# No credentials required, no email sent. Run this first if a send is
# hanging or timing out - see docs/TROUBLESHOOTING.md for context.
# ====================================================================

$SmtpHost = "mx.msgwing.com"
$Ports = 587, 465

Write-Host "== DNS resolution =="
try {
    Resolve-DnsName -Name $SmtpHost -ErrorAction Stop | Format-Table -AutoSize
}
catch {
    Write-Host "Could not resolve $SmtpHost : $($_.Exception.Message)"
}

foreach ($Port in $Ports) {
    Write-Host "`n== TCP connect to ${SmtpHost}:${Port} =="
    $result = Test-NetConnection -ComputerName $SmtpHost -Port $Port -WarningAction SilentlyContinue

    if (-not $result.TcpTestSucceeded) {
        Write-Host "TCP connect: FAILED (likely blocked by your network/provider - see docs/TROUBLESHOOTING.md)"
        continue
    }
    Write-Host "TCP connect: OK"

    if ($Port -eq 465) {
        Write-Host "== TLS handshake on ${SmtpHost}:${Port} (implicit TLS) =="
        $tcpClient = $null
        $sslStream = $null
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient($SmtpHost, $Port)
            $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false)
            $sslStream.AuthenticateAsClient($SmtpHost)
            Write-Host "TLS handshake: OK (protocol: $($sslStream.SslProtocol))"
        }
        catch {
            Write-Host "TLS handshake: FAILED - $($_.Exception.Message)"
        }
        finally {
            if ($sslStream) { $sslStream.Close() }
            if ($tcpClient) { $tcpClient.Close() }
        }
    }
    else {
        Write-Host "Skipping direct TLS handshake on $Port - it requires a STARTTLS negotiation first, and TCP connectivity is already confirmed above"
    }
}

Write-Host "`nNo email was sent by this script."
Write-Host "If both ports failed to connect, your network or cloud provider is very likely blocking outbound SMTP - see docs/TROUBLESHOOTING.md."
