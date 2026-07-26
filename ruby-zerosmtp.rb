#!/usr/bin/env ruby
# frozen_string_literal: true

# ruby-zerosmtp.rb
# Ruby 3.4+ Net::SMTP - ZeroSMTP mx.msgwing.com:465 SSL/TLS
# Production-ready | Let's Encrypt | Pattern matching, frozen strings

require 'net/smtp'
require 'openssl'

class ZeroSMTPMailer
  CONFIG = {
    username: ENV.fetch('ZEROSMTP_USERNAME', 'your-username').freeze,
    password: ENV.fetch('ZEROSMTP_PASSWORD', 'your-password').freeze,
    from:     ENV.fetch('ZEROSMTP_FROM', 'sender@example.com').freeze,
    to:       ENV.fetch('ZEROSMTP_TO', 'recipient@example.com').freeze,
    subject:  ENV.fetch('ZEROSMTP_SUBJECT', 'Test Email from ZeroSMTP').freeze,
  }.freeze

  def self.send_email
    new.send_email
  end

  def send_email
    context = OpenSSL::SSL::SSLContext.new
    context.verify_mode = OpenSSL::SSL::VERIFY_PEER

    Net::SMTP.start(
      'mx.msgwing.com',
      465,
      ssl_context: context,
    ) do |smtp|
      smtp.auth_login(CONFIG[:username], CONFIG[:password])

      boundary = "boundary_zerosmtp_#{Time.now.to_i}"
      body = build_multipart_body(boundary)

      smtp.send_message(body, CONFIG[:from], CONFIG[:to])
    end

    true
  rescue Net::SMTPAuthenticationError => e
    warn "Authentication failed: #{e.message}"
    false
  rescue OpenSSL::SSL::SSLError => e
    warn "Certificate verification failed: #{e.message}"
    false
  rescue => e
    warn "SMTP error: #{e.message}"
    false
  end

  private

  def build_multipart_body(boundary)
    <<~MAIL
      From: #{CONFIG[:from]}
      To: #{CONFIG[:to]}
      Subject: #{CONFIG[:subject]}
      MIME-Version: 1.0
      Content-Type: multipart/alternative; boundary="#{boundary}"

      --#{boundary}
      Content-Type: text/plain; charset="UTF-8"

      Hello from ZeroSMTP! This is plain text.

      --#{boundary}
      Content-Type: text/html; charset="UTF-8"

      <html><body><h1>Hello from ZeroSMTP!</h1><p>This is an HTML email sent via mx.msgwing.com:465</p></body></html>

      --#{boundary}--
    MAIL
  end
end

exit ZeroSMTPMailer.send_email ? 0 : 1
