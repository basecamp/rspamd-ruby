
# rspamd-ruby

![CI](https://github.com/basecamp/rspamd-ruby/actions/workflows/ci.yml/badge.svg)
[![Gem Version](https://img.shields.io/gem/v/rspamd-ruby.svg)](https://rubygems.org/gems/rspamd-ruby)

Ruby client for [Rspamd’s HTTP API](https://rspamd.com/doc/architecture/protocol.html)

## Get started

To install the latest version using [Bundler][bundler]:

```ruby
gem "rspamd-ruby"
```

To manually install `rspamd-ruby` via [Rubygems][rubygems] simply gem install:

```bash
gem install rspamd-ruby
```

If you're not using [Bundler][bundler], you'll need to add `require "rspamd-ruby"` to your Ruby file.

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

## Acknowledgments

rspamd-ruby is [MIT-licensed](MIT-LICENSE) open-source software from [37signals](https://37signals.com/), the creators of [Ruby on Rails](https://rubyonrails.org).

---

© 2023 37signals, LLC.

[bundler]: https://bundler.io
[rubygems]: https://rubygems.org
