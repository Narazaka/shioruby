# [Shioruby](https://github.com/Narazaka/shioruby)

[![Gem](https://img.shields.io/gem/v/shioruby.svg)](https://rubygems.org/gems/shioruby)
[![Gem](https://img.shields.io/gem/dtv/shioruby.svg)](https://rubygems.org/gems/shioruby)
[![Build Status](https://travis-ci.org/Narazaka/shioruby.svg)](https://travis-ci.org/Narazaka/shioruby)
[![codecov.io](https://codecov.io/github/Narazaka/shioruby/coverage.svg?branch=master)](https://codecov.io/github/Narazaka/shioruby?branch=master)
[![Code Climate](https://codeclimate.com/github/Narazaka/shioruby/badges/gpa.svg)](https://codeclimate.com/github/Narazaka/shioruby)

SHIORI Protocol Parser / Builder for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shioruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shioruby

## Usage

```ruby
require 'shioruby'

p Shioruby.parse_request(<<-EOS
GET SHIORI/3.0
Charset: UTF-8
Sender: ikagaka
ID: OnClose
Reference0: user

EOS
)
#<OpenStruct method="GET", version="3.0", Charset="UTF-8", Sender="ikagaka", ID="OnClose", Reference0="user">

p Shioruby.build_response(OpenStruct.new({
  code: 200,
  version: '3.0',
  Value: '\h\s[0]\e',
  Charset: 'UTF-8',
  Sender: 'shioruby',
}))
#"SHIORI/3.0 200 OK\nValue: \\h\\s[0]\\e\nCharset: UTF-8\nSender: shioruby\n\n"

request = Shioruby.parse_request(<<-EOS
GET SHIORI/3.0
Charset: UTF-8
Sender: ikagaka
ID: otherghostname
Reference0: sakura\x010\x0110

EOS
)
p request.Reference0.separated
#["sakura", "0", "10"]

# sakura.recommendsites etc.
sites = [
  ['Shioruby', 'https://github.com/Narazaka/shioruby', '', '\h\s[0]This is Shioruby site.\e'],
  ['ShioriJK', 'https://github.com/Narazaka/shiorijk', '', '\h\s[0]This is ShioriJK site.\e'],
]
response_str = Shioruby.build_response(OpenStruct.new({
  code: 200,
  version: '3.0',
  Value: sites.combined2,
  Charset: 'UTF-8',
  Sender: 'shioruby',
}))
p response_str
#"SHIORI/3.0 200 OK\nValue: Shioruby\u0001https://github.com/Narazaka/shioruby\u0001\u0001\\h\\s[0]This is Shioruby site.\\e\u0002ShioriJK\u0001https://github.com/Narazaka/shiorijk\u0001\u0001\\h\\s[0]This is ShioriJK site.\\e\nCharset: UTF-8\nSender: shioruby\n\n"
```

## API

[API Document](https://narazaka.github.io/shioruby/index.html)

## License

This is released under [MIT License](http://narazaka.net/license/MIT?2016).
