# helium-ruby

[![Build Status](https://travis-ci.org/helium/helium-ruby.svg?branch=master)](https://travis-ci.org/helium/helium-ruby)
[![Coverage Status](https://coveralls.io/repos/github/helium/helium-ruby/badge.svg?branch=master)](https://coveralls.io/github/helium/helium-ruby?branch=master)
[![Code Climate](https://codeclimate.com/github/helium/helium-ruby/badges/gpa.svg)](https://codeclimate.com/github/helium/helium-ruby)

A Ruby gem for building applications with the Helium API. [Helium](https://www.helium.com/) is an integrated platform of smart sensors, communication, edge and cloud compute that enables numerous sensing applications. For more information about the underlying REST API, check out [the Helium docs](https://docs.helium.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helium-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install helium-ruby

## Usage

### Setup

```ruby
require 'helium'

client = Helium::Client.new(api_key: '<Your API Key>')
```

### Users

```ruby
client.user
# => #<Helium::User:0x007fd58198d9e8 @id="dev-accounts@helium.co", @name="HeliumDevAccount Demo", @email="dev-accounts@helium.co", @created_at="2014-10-29T21:38:52Z", @updated_at="2015-08-06T18:21:32.186374Z">
```

### Sensors

#### Get all Sensors
```ruby
client.sensors
# => [#<Helium::Sensor:0x007f89acdd1318 @id="08bab58b-d095-4c7c-912c-1f8024d91d95", @name="Marc's Isotope", @mac="6081f9fffe00019b", @ports=["t", "b"], @created_at="2015-08-06T17:28:11.614107Z", @updated_at="2016-05-30T22:36:50.810716Z">, ...]
```

#### Get a Sensor by id
```ruby
client.sensor("08bab58b-d095-4c7c-912c-1f8024d91d95")
# => #<Helium::Sensor:0x007f89acdb1b58 @id="08bab58b-d095-4c7c-912c-1f8024d91d95", @name="Marc's Isotope", @mac="6081f9fffe00019b", @ports=["t", "b"], @created_at="2015-08-06T17:28:11.614107Z", @updated_at="2016-05-30T22:36:50.810716Z">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/helium/helium-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
