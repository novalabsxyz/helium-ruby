# helium-ruby

[![Build Status](https://travis-ci.org/helium/helium-ruby.svg?branch=master)](https://travis-ci.org/helium/helium-ruby)
[![Coverage Status](https://coveralls.io/repos/github/helium/helium-ruby/badge.svg?branch=master)](https://coveralls.io/github/helium/helium-ruby?branch=master)
[![Code Climate](https://codeclimate.com/github/helium/helium-ruby/badges/gpa.svg)](https://codeclimate.com/github/helium/helium-ruby)
[![Gem Version](https://badge.fury.io/rb/helium-ruby.svg)](https://badge.fury.io/rb/helium-ruby)

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

### Organizations

#### Get the current organization

```ruby
client.organization
# => #<Helium::Organization:0x007fd3d94b1b08 @client=<Helium::Client @debug=true>, @id="dev-accounts@helium.co", @name="dev-accounts@helium.co", @timezone="UTC", @created_at="2015-09-10T20:50:18.183896Z", @updated_at="2015-09-10T20:50:18.183896Z">
```

#### Get all users associated with the current organization

```ruby
client.organization.users
# => [
#   [0] #<Helium::User:0x007fd3d9449490 @client=<Helium::Client @debug=true>, @id="tom@helium.com", @name="Tom Santero", @email="tom@helium.com", @created_at="2015-01-21T16:39:31.397048Z", @updated_at="2015-02-12T20:42:22.674452Z">,
#   [1] #<Helium::User:0x007fd3d94492d8 @client=<Helium::Client @debug=true>, @id="dev-accounts@helium.co", @name="HeliumDevAccount Demo", @email="dev-accounts@helium.co", @created_at="2014-10-29T21:38:52Z", @updated_at="2015-08-06T18:21:32.186374Z">
# ]
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

### Timeseries

#### Get Timeseries data for a sensor
```ruby
sensor = client.sensor("08bab58b-d095-4c7c-912c-1f8024d91d95")
sensor.timeseries
# => #<Helium::Timeseries:0x007ff9dd92efa8 @data_points=[#<Helium::DataPoint:0x007ff9dd92ee18 @id="a4107e78-f15e-4c31-aab3-497bbfe3e33c", @timestamp="2015-08-11T18:50:04Z", @value=-40.125, @port="t">, ...
```

#### Working with data points
A `Helium::Timeseries` is a collection of `Helium::DataPoint`s which can be accessed by calling `.data_points`, or iterated over using the usual `Object#Enumerable` methods:

```ruby
sensor.timeseries.each do |data_point|
  puts data_point.id
  puts data_point.timestamp
  puts data_point.value
  puts data_point.port
end
```

#### Filtering Timeseries data
Timeseries data can be filtered by port type and start/end time:

```ruby
sensor.timeseries.collect(&:port).uniq
# => [
#  [0] "b",
#  [1] "l",
#  [2] "h",
#  [3] "p",
#  [4] "t",
#  [5] "_se",
#  [6] "m"
# ]

sensor.timeseries(port: 't').collect(&:port).uniq
# => [
#   [0] "t"
# ]

sensor.timeseries(start_time: DateTime.parse("2016-08-01"), end_time: DateTime.parse("2016-08-02")).collect(&:timestamp)
# => [
#  [0] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,802000000n),+0s,2299161j)>,
#  [1] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,61000000n),+0s,2299161j)>,
#  [2] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,60000000n),+0s,2299161j)>,
#  [3] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,59000000n),+0s,2299161j)>,
#  [4] #<DateTime: 2016-08-01T23:54:45+00:00 ((2457602j,86085s,544000000n),+0s,2299161j)>,
```

#### Paging through Timeseries data
Timeseries data is paginated at the API level. By default, 1000 data points are returned. This amount can be increased up to 10,000:

```ruby
sensor.timeseries(size: 10_000).length
# => 10000
```

The data points are sorted from most recent, to least recent. The `.previous` method on a `Helium::Timeseries` object will return a new `Helium::Timeseries` object with the previous page of Timeseries data. Similarly, the `.next` method on a `Helium::Timeseries` object will return the next page of timeseries data, if it exists. If not, it will return `false`.

```ruby
timeseries = sensor.timeseries
# => #<Helium::Timeseries:0x007ff9e10d2c48 @data_points=[#<Helium::DataPoint:0x007ff9e10d2568 @id="3595e562-c065-442e-a3af-c6f43ddb1500", @timestamp="2016-08-10T13:21:49.866Z", @value=27, @port="l">, ...

previous_timeseries = timeseries.previous
# => #<Helium::Timeseries:0x007ff9dc141008 @data_points=[#<Helium::DataPoint:0x007ff9dc140f68 @id="1e4062cf-361d-415e-8c05-cd04954424d1", @timestamp="2016-08-10T13:11:49.353Z", @value=99804.15, @port="p">, ...

previous_timeseries.next
# =>
```

If no previous data exists, the `.previous` method will return `false`.

```ruby
sensor.timeseries.previous
# => false
```

#### Timeseries Aggregations

In addition to returning the raw data points, Helium can return timeseries data aggregated into buckets.


For example, if you wanted to display a graph of a sensor's temperature min, max and average readings grouped by day, you could do the following:

```ruby
data_points = sensor.timeseries(port: 't', aggtype: 'min,max,avg', aggsize: '1d')
# => #<Helium::Timeseries:0x007fe7038c2d18 @data_points=[#<Helium::DataPoint:0x007fe7038c2c00 @client=<Helium::Client @debug=true>, @id="a93e47f4-2fb2-4336-84c0-20f83ee2988e", @timestamp="2016-08-16T00:00:00Z", @value={"max"=>22.579952, "avg"=>22.1155383392857, "min"=>21.774511}, @port="agg(t)">, ...

data_points.first.min
# => 21.774511

data_points.first.max
# => 22.579952

data_points.first.avg
# => 22.1155383392857
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Roadmap
- [X] Timeseries Aggregations
- [ ] POST/PUT/DELETE users, orgs, sensors, timeseries
- [ ] Ports
- [ ] Labels
- [ ] Elements

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/helium/helium-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Running specs with Guard

To receive system notifications of test status, install `terminal-notifier`:
```
$ brew install terminal-notifier
```

Then run Guard with:
```
$ bundle exec guard
```

When you modify any of the files in `lib/`, all specs will run. When you modify a spec file, just that file will be run. You can press `Enter` at the guard prompt to run all tests as well.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
