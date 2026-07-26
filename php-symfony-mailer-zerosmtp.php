<?php
/**
 * php-symfony-mailer-zerosmtp.php
 * PHP 8.3+ Symfony Mailer 7.x - ZeroSMTP mx.msgwing.com:465 SSL/TLS
 * Production-ready | Let's Encrypt | No deprecated APIs
 *
 * NOTE: this file used to demonstrate SwiftMailer, which reached end-of-life
 * in December 2021 and no longer receives security updates. It now uses
 * Symfony Mailer, SwiftMailer's actively maintained successor.
 *
 * Requirements:
 * - Symfony Mailer installed via Composer
 * - Valid ZeroSMTP credentials (free account at https://msgwing.com)
 *
 * Installation:
 * composer require symfony/mailer
 *
 * Usage:
 * Set environment variables before running:
 * export ZEROSMTP_USERNAME="your-email@msgwing.com"
 * export ZEROSMTP_PASSWORD="your-password"
 * export ZEROSMTP_FROM="your-email@msgwing.com"
 * export ZEROSMTP_TO="recipient@example.com"
 * export ZEROSMTP_SUBJECT="Test Email from ZeroSMTP"
 * php php-symfony-mailer-zerosmtp.php
 */

declare(strict_types=1);

require_once __DIR__ . '/vendor/autoload.php';

use Symfony\Component\Mailer\Exception\TransportExceptionInterface;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport\Dsn;
use Symfony\Component\Mailer\Transport\Smtp\EsmtpTransport;
use Symfony\Component\Mime\Email;

// ZeroSMTP configuration from environment variables
// NOTE: variable names are prefixed with ZEROSMTP_ to avoid colliding with
// reserved/OS-level variables (e.g. USERNAME is auto-set on Windows).
$smtpConfig = [
    'host'     => 'mx.msgwing.com',
    'port'     => 465,
    'username' => getenv('ZEROSMTP_USERNAME') ?: 'your-email@msgwing.com',
    'password' => getenv('ZEROSMTP_PASSWORD') ?: 'your-password',
    'from'     => getenv('ZEROSMTP_FROM') ?: 'your-email@msgwing.com',
    'fromName' => 'ZeroSMTP User',
    'to'       => getenv('ZEROSMTP_TO') ?: 'recipient@example.com',
    'subject'  => getenv('ZEROSMTP_SUBJECT') ?: 'Hello from ZeroSMTP!',
];

try {
    // Implicit TLS on port 465, full certificate verification (default)
    $transport = new EsmtpTransport($smtpConfig['host'], $smtpConfig['port'], tls: true);
    $transport->setUsername($smtpConfig['username']);
    $transport->setPassword($smtpConfig['password']);

    $mailer = new Mailer($transport);

    $email = (new Email())
        ->from(sprintf('%s <%s>', $smtpConfig['fromName'], $smtpConfig['from']))
        ->to($smtpConfig['to'])
        ->subject($smtpConfig['subject'])
        ->text('This email was sent using ZeroSMTP with Symfony Mailer. No cost. No limits. Visit https://msgwing.com')
        ->html(
            '<html><body>' .
            '<h1>Welcome to ZeroSMTP!</h1>' .
            '<p>This email was sent using ZeroSMTP with Symfony Mailer.</p>' .
            '<p>No cost. No limits. Free SMTP relay for developers.</p>' .
            '<p>Service: <a href="https://msgwing.com">msgwing.com</a></p>' .
            '</body></html>'
        );

    $mailer->send($email);

    echo "Email sent successfully via ZeroSMTP!\n";
    exit(0);
} catch (TransportExceptionInterface $e) {
    fwrite(STDERR, "Failed to send email: " . $e->getMessage() . "\n");
    exit(1);
}
