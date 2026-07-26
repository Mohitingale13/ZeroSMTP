<?php
/**
 * php-swiftmailer-zerosmtp.php
 * PHP 8.3+ SwiftMailer 6.9.5 - ZeroSMTP mx.msgwing.com:465 SSL/TLS
 * Production-ready | Let's Encrypt | No deprecated APIs
 * 
 * Requirements:
 * - SwiftMailer library installed via Composer
 * - Valid ZeroSMTP credentials (free account at https://msgwing.com)
 * 
 * Installation:
 * composer require swiftmailer/swiftmailer
 * 
 * Usage:
 * Set environment variables before running:
 * export USERNAME="your-email@msgwing.com"
 * export PASSWORD="your-password"
 * export FROM="your-email@msgwing.com"
 * export TO="recipient@example.com"
 * export SUBJECT="Test Email from ZeroSMTP"
 * php php-swiftmailer-zerosmtp.php
 */

require_once __DIR__ . '/vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use Swift_SmtpTransport;
use Swift_Mailer;
use Swift_Message;

// ZeroSMTP Configuration from environment variables
$smtpConfig = [
    'host'     => 'mx.msgwing.com',
    'port'     => 465,
    'username' => getenv('USERNAME') ?: 'your-email@msgwing.com',      // Your ZeroSMTP email address
    'password' => getenv('PASSWORD') ?: 'your-password',               // Your ZeroSMTP password
    'from'     => getenv('FROM') ?: 'your-email@msgwing.com',          // Sender email address (example format)
    'fromName' => 'ZeroSMTP User',                                     // Sender display name
];

try {
    // Create SMTP Transport with SSL/TLS encryption
    $transport = (new Swift_SmtpTransport($smtpConfig['host'], $smtpConfig['port'], 'ssl'))
        ->setUsername($smtpConfig['username'])
        ->setPassword($smtpConfig['password']);

    // Create Mailer instance
    $mailer = new Swift_Mailer($transport);

    // Create Message
    $message = (new Swift_Message(getenv('SUBJECT') ?: 'Hello from ZeroSMTP!'))
        ->setFrom([$smtpConfig['from'] => $smtpConfig['fromName']])
        ->setTo([
            getenv('TO') ?: 'recipient@example.com' => 'Recipient Name',
        ])
        ->setReplyTo([$smtpConfig['from']])
        ->setBody(
            '<html><body>' .
            '<h1>Welcome to ZeroSMTP!</h1>' .
            '<p>This email was sent using ZeroSMTP with SwiftMailer.</p>' .
            '<p>No cost. No limits. Free SMTP relay for developers.</p>' .
            '<p>Service: <a href="https://msgwing.com">msgwing.com</a></p>' .
            '</body></html>',
            'text/html'
        );

    // Add alternative text version
    $message->addPart(
        'This email was sent using ZeroSMTP with SwiftMailer. No cost. No limits. Visit https://msgwing.com',
        'text/plain'
    );

    // Send the message
    $result = $mailer->send($message);

    if ($result) {
        echo "✓ Email sent successfully via ZeroSMTP!\n";
        echo "Recipients: " . $result . "\n";
        exit(0);
    } else {
        echo "✗ Failed to send email.\n";
        exit(1);
    }

} catch (Exception $e) {
    echo "✗ Error: " . $e->getMessage() . "\n";
    exit(1);
}
