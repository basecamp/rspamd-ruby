# Ruby client for Rspamd’s HTTP API

## Usage

Initialize a client with the host and port of an Rspamd controller process:

```ruby
client = Rspamd::Client.new(host: "localhost", port: 11334)
```

Check a message:

```ruby
result = client.check(<<~MIME)
  Date: Tue, 21 Jan 2020 21:04:42 +0000
  From: Alice <alice@example.com>
  To: Bob <bob@example.com>
  Message-ID: <975bad33-2e76-40c3-89aa-7fe1edcbe7ce@example.com>
  Subject: Hello
  Mime-Version: 1.0
  Content-Type: text/plain; charset=UTF-8
  Content-Transfer-Encoding: quoted-printable
  Delivered-To: bob@example.com

  Hi Bob!

  -Alice
MIME

result.spam? # => false
result.ham? # => true

result.score # => 1.2
result.required_score # => 15
result.action # => "no action"
```

Report a message as spam:

```ruby
client.spam!(<<~MIME)
  Date: Tue, 21 Jan 2020 21:04:42 +0000
  From: Spammer <spammer@example.com>
  To: Bob <bob@example.com>
  Message-ID: <975bad33-2e76-40c3-89aa-7fe1edcbe7ce@example.com>
  Subject: Hello
  Mime-Version: 1.0
  Content-Type: text/plain; charset=UTF-8
  Content-Transfer-Encoding: quoted-printable
  Delivered-To: bob@example.com

  Buy some stuff?
MIME
```

Report a message as ham:

```ruby
client.ham!(<<~MIME)
  Date: Tue, 21 Jan 2020 21:04:42 +0000
  From: Alice <alice@example.com>
  To: Bob <bob@example.com>
  Message-ID: <975bad33-2e76-40c3-89aa-7fe1edcbe7ce@example.com>
  Subject: Hello
  Mime-Version: 1.0
  Content-Type: text/plain; charset=UTF-8
  Content-Transfer-Encoding: quoted-printable
  Delivered-To: bob@example.com

  Hi Bob!

  -Alice
MIME
```
