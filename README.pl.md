**Czytaj po angielsku:** [README.md](README.md)

[![Lint examples](https://github.com/msgwing/ZeroSMTP/actions/workflows/lint.yml/badge.svg)](https://github.com/msgwing/ZeroSMTP/actions/workflows/lint.yml)
[![CodeQL](https://github.com/msgwing/ZeroSMTP/actions/workflows/codeql.yml/badge.svg)](https://github.com/msgwing/ZeroSMTP/actions/workflows/codeql.yml)
[![mx.msgwing.com status](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/msgwing/ZeroSMTP/status/status.json)](https://github.com/msgwing/ZeroSMTP/actions/workflows/service-healthcheck.yml)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/msgwing/ZeroSMTP)

Każde środowisko uruchomieniowe używane w przykładach poniżej (Python, PHP, Node, Ruby, Go, Java, Kotlin/Gradle, .NET, Rust) jest już zainstalowane, jeśli otworzysz to repo w [Dev Container lub Codespace](.devcontainer/devcontainer.json) — bez lokalnej konfiguracji.

# Wysyłaj maile bez problemów. Za darmo.

Darmowe konto SMTP w domenie @msgwing.com

## Szybki start

1. Zarejestruj i aktywuj darmowe konto na [msgwing.com](https://msgwing.com), a następnie skopiuj wygenerowany losowo login `@msgwing.com` i hasło.
2. Skopiuj [`.env.example`](.env.example) do `.env` i uzupełnij swoimi danymi.
3. Wyślij testowego maila przez curl (bez żadnych zależności poza samym curl):

   ```bash
   export $(grep -v '^#' .env | xargs)
   curl --url "smtps://mx.msgwing.com:465" \
     --user "$ZEROSMTP_USERNAME:$ZEROSMTP_PASSWORD" \
     --mail-from "$ZEROSMTP_FROM" --mail-rcpt "$ZEROSMTP_TO" \
     --upload-file <(printf 'Subject: Test\r\n\r\nHello from ZeroSMTP!') --ssl-reqd
   ```

   Albo wybierz swój język z tabeli [Przykłady kodu](#przykłady-kodu) poniżej — każdy przykład korzysta z tych samych zmiennych w `.env`.
4. Coś nie działa? Zobacz [Rozwiązywanie problemów](docs/TROUBLESHOOTING.md) — najczęstszą przyczyną nieudanego pierwszego uruchomienia jest blokowanie wychodzących portów SMTP przez dostawcę chmury, a nie błąd w konfiguracji.

Po rejestracji konto SMTP generuje się automatycznie i losowo - dzięki temu otrzymujesz adres z bardzo dobrą reputacją, co znacznie zwiększa szansę na dostarczenie maili do skrzynki odbiorcy.

Szybka rejestracja, natychmiastowe konto i pełna swoboda wysyłania.

Wysyłaj wiadomości z aplikacji, skryptów, stron internetowych oraz urządzeń drukujących - wszystko działa od razu.

Idealne dla:
- Aplikacji webowych i mobilnych
- Automatyzacji i skryptów (Python, PHP, Node.js itp.)
- Formularzy kontaktowych i powiadomień
- Resetów haseł i maili transakcyjnych
- Drukarek sieciowych (skan-do-mail)
- Urządzeń IoT i innych sprzętów z obsługą SMTP

Przewodniki konfiguracji: [Drukarki sieciowe](docs/PRINTERS.md) · [Popularne aplikacje](docs/APPS.md) · [Linux (Debian/Ubuntu/Rocky/Fedora/openSUSE)](docs/LINUX.md) · [Systemowy relay pocztowy (Postfix/msmtp/Exim4)](docs/SYSTEM-MTA.md) · [Windows Server](docs/WINDOWS-SERVER.md) · [Rozwiązywanie problemów](docs/TROUBLESHOOTING.md) · [Niezawodność (ponawianie prób)](docs/RELIABILITY.md) · [FAQ](docs/FAQ.md)

## Przykłady kodu

Gotowe do użycia przykłady dla `mx.msgwing.com:465` (SSL/TLS) lub `:587`
(STARTTLS), po jednym pliku na język:

| Język | Plik |
| --- | --- |
| Python | [python-zerosmtp.py](python-zerosmtp.py) |
| PHP (PHPMailer) | [php-zerosmtp.php](php-zerosmtp.php) |
| PHP (Symfony Mailer) | [php-symfony-mailer-zerosmtp.php](php-symfony-mailer-zerosmtp.php) |
| Node.js | [node-zerosmtp.mjs](node-zerosmtp.mjs) |
| TypeScript | [ts-zerosmtp.ts](ts-zerosmtp.ts) |
| Bash (curl) | [bash-curl-zerosmtp.sh](bash-curl-zerosmtp.sh) |
| Bash (swaks) | [bash-swaks-zerosmtp.sh](bash-swaks-zerosmtp.sh) |
| Java | [java-zerosmtp.java](java-zerosmtp.java) |
| C# (.NET / MailKit) | [cs-zerosmtp.cs](cs-zerosmtp.cs) |
| Go | [go-zerosmtp.go](go-zerosmtp.go) |
| Ruby | [ruby-zerosmtp.rb](ruby-zerosmtp.rb) |
| Rust | [rust-zerosmtp.rs](rust-zerosmtp.rs) |
| Kotlin | [kotlin-zerosmtp.kt](kotlin-zerosmtp.kt) |
| Swift | [swift-zerosmtp.swift](swift-zerosmtp.swift) |
| PowerShell | [pwsh-zerosmtp.ps1](pwsh-zerosmtp.ps1) |

Każdy przykład pobiera dane logowania ze zmiennych środowiskowych
`ZEROSMTP_*` (`ZEROSMTP_USERNAME`, `ZEROSMTP_PASSWORD`, `ZEROSMTP_FROM`,
`ZEROSMTP_TO`, `ZEROSMTP_SUBJECT`) — nigdy nie wpisuj prawdziwych danych na
sztywno w skrypcie.

### Instalacja zależności

Każdy przykład wymagający zewnętrznej biblioteki ma odpowiadający mu manifest
w katalogu głównym repo, więc instalujesz standardową komendą danego
ekosystemu, zamiast ręcznie szukać nazw i wersji bibliotek:

| Język(i) | Instalacja |
| --- | --- |
| Node.js / TypeScript | `npm install` |
| PHP | `composer install` |
| Rust | `cargo build` (zależności pobierają się automatycznie) |
| C# | `dotnet build cs-zerosmtp.csproj` |
| Java | `mvn compile` |
| Kotlin | `gradle build` |
| Swift | `swift build` |
| Python, Ruby, Go, Bash, PowerShell | brak — tylko biblioteka standardowa |

Dane do konfiguracji:
- Login: losowo wygenerowany adres @msgwing.com
- Serwer SMTP: mx.msgwing.com
- Port: 587 (STARTTLS) lub 465 (SSL/TLS)
- Szyfrowanie: SSL/TLS - wymagane

Dbamy o Twoją prywatność - Twoje dane nie są przetwarzane w żadnych celach marketingowych ani handlowych.

## Bezpieczeństwo i Dostarczalność

**✓ Poprawa Reputacji Domeny**: Reputacja domeny msgwing.com została znacznie poprawiona, a wszystkie konta spamowe zostały zablokowane i usunięte. Gwarantujemy optymalną dostarczalność dla wszystkich legytymnych użytkowników.

### Sprawdź Reputację Domeny Samodzielnie

Chcesz zweryfikować reputację msgwing.com? Możesz to zrobić samodzielnie za pomocą [mail-tester.com](https://mail-tester.com/):

1. Utwórz darmowe konto SMTP na stronie [msgwing.com](https://msgwing.com)
2. Użyj naszego skryptu PowerShell: [SendEmailTest_mail-tester.com.ps1](SendEmailTest_mail-tester.com.ps1)
3. Wygeneruj losowy email na mail-tester.com i wyślij wiadomość testową z Twojego adresu @msgwing.com
4. Sprawdź wynik reputacji i szczegółową analizę

**✓ Poprawki Bezpieczeństwa**: Wdrożyliśmy kompleksowe ulepszeń bezpieczeństwa usługi msgwing.com, w tym ulepszony protokół autoryzacji, wzmocnione monitorowanie nadużyć i ulepszony bezpieczeństwo infrastruktury.

---

Jeśli masz pytania, napisz do nas: abuse@msgwing.com

Dobra dostarczalność • Losowa reputacja konta • Zero kosztów • Pełna prywatność • Działa z wszystkim

Zacznij wysyłać maile już dziś - całkowicie za darmo i bez żadnych ukrytych zasad!

Rejestracja odbywa się na stronie: https://msgwing.com

## Historia gwiazdek

[![GitHub stars](https://img.shields.io/github/stars/msgwing/ZeroSMTP?style=social)](https://star-history.com/#msgwing/ZeroSMTP&Date)
