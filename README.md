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

#### Create a Virtual Sensor
```ruby
sensor = client.new_sensor(name: "A New Sensor")
# => #<Helium::Sensor:0x007f89acdb1b58 @id="08bab58b-d095-4c7c-912c-1f8024d91d95", @name="A New Sensor", @mac="6081f9fffe00019b", @ports=["t", "b"], @created_at="2015-08-06T17:28:11.614107Z", @updated_at="2016-05-30T22:36:50.810716Z">
```

#### Update a Sensor
```ruby
sensor.update(name: "An Updated Sensor")
# => #<Helium::Sensor:0x007f89acdb1b58 @id="08bab58b-d095-4c7c-912c-1f8024d91d95", @name="A New Sensor", @mac="6081f9fffe00019b", @ports=["t", "b"], @created_at="2015-08-06T17:28:11.614107Z", @updated_at="2016-05-30T22:36:50.810716Z">
```

#### Delete a Sensor
```ruby
sensor.destroy
# => true
```

### Timeseries

#### Get Timeseries data for a sensor

Timeseries data is paginated by the Helium API which by default, returns pages of 1000 data points. When you call `.timeseries` on a sensor, you get back a `Helium::Cursor` object, which is an `Enumerable` object that handles paging through this data automatically.

```ruby
sensor = client.sensor("08bab58b-d095-4c7c-912c-1f8024d91d95")
timeseries = sensor.timeseries(port: 't', start_time: DateTime.parse('2016-08-01'), end_time: DateTime.parse('2016-08-16'))
# => #<Helium::Cursor:0x007f9b02a25798 @path="/sensor/aba370be-837d-4b41-bee5-686b0069d874/timeseries", @klass=Helium::DataPoint, @options={"page[size]"=>1000, "filter[port]"=>"t", "filter[start]"=>"2016-08-01T00:00:00Z", "filter[end]"=>"2016-08-16T00:00:00Z"}, @collection=[], @next_link=nil, @is_last=false>
```

#### Working with data points
A `Helium::Cursor` is a collection of `Helium::DataPoint`s which can iterated over using the usual `Object#Enumerable` methods:

```ruby
sensor = client.sensor("08bab58b-d095-4c7c-912c-1f8024d91d95")

sensor.timeseries.take(1000).each do |data_point|
  puts data_point.id
  puts data_point.timestamp
  puts data_point.value
  puts data_point.port
end

sensor.timeseries.first
# => #<Helium::DataPoint:0x007f9b0407f340 @id="6c115c10-323e-4756-ae1c-fc69982eb397", @timestamp="2016-08-15T23:55:42.2Z", @value=22.590084, @port="t">
```

Since pagination happens automatically, **it's strongly recommended to define a start and end time,** otherwise enumerating over the collection may take a very long time.

#### Filtering Timeseries data
Timeseries data can be filtered by port type and start/end time:

```ruby
sensor.timeseries.take(1000).collect(&:port).uniq
# => [
#  [0] "b",
#  [1] "l",
#  [2] "h",
#  [3] "p",
#  [4] "t",
#  [5] "_se",
#  [6] "m"
# ]

sensor.timeseries(port: 't').take(1000).collect(&:port).uniq
# => [
#   [0] "t"
# ]

sensor.timeseries(start_time: DateTime.parse("2016-08-01"), end_time: DateTime.parse("2016-08-02")).take(1000).collect(&:timestamp)
# => [
#  [0] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,802000000n),+0s,2299161j)>,
#  [1] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,61000000n),+0s,2299161j)>,
#  [2] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,60000000n),+0s,2299161j)>,
#  [3] #<DateTime: 2016-08-01T23:55:29+00:00 ((2457602j,86129s,59000000n),+0s,2299161j)>,
#  [4] #<DateTime: 2016-08-01T23:54:45+00:00 ((2457602j,86085s,544000000n),+0s,2299161j)>,
```

#### Timeseries Aggregations

In addition to returning the raw data points, Helium can return timeseries data aggregated into buckets.

For example, if you wanted to display a graph of a sensor's temperature min, max and average readings grouped by day, you could do the following:

```ruby
data_points = sensor.timeseries(port: 't', aggtype: 'min,max,avg', aggsize: '1d')
# => #<Helium::Cursor:0x007f9b0413a708 @path="/sensor/aba370be-837d-4b41-bee5-686b0069d874/timeseries", @klass=Helium::DataPoint, @options={"page[size]"=>1000, "filter[port]"=>"t", "agg[type]"=>"min,max,avg", "agg[size]"=>"1d"}, @collection=[], @next_link=nil, @is_last=false>

data_points.first.min
# => 21.47564

data_points.first.max
# => 24.145264

data_points.first.avg
# => 22.2916633036437
```

A full list of aggregation types and sizes can be found here: https://docs.helium.com/docs/timeseries#aggregations.

### Elements

#### Get all Elements

```ruby
client.elements
# => [#<Helium::Element:0x007faf732c11e8 @id="78b6a9f4-9c39-4673-9946-72a16c35a422", @name="SF Office", @mac="6081f9fffe0002a8", @created_at="2015-08-12T23:10:40.537762Z", @updated_at="2015-08-12T23:10:40.536644Z", @versions={"element"=>"3050900"}>,...]
```

#### Get an Element by id
```ruby
client.element("1b686e82-bd4a-4aac-9d7b-9bdbe1e9a7de")
# => #<Helium::Element:0x007faf732c2548 @id="1b686e82-bd4a-4aac-9d7b-9bdbe1e9a7de", @name="SF Office", @mac="6081f9fffe00033f", @created_at="2015-08-12T23:19:34.175932Z", @updated_at="2015-08-12T23:19:34.174828Z", @versions=nil>
```

#### Update an Element
```ruby
element.update(name: "A New Name")
# => #<Helium::Element:0x007faf732c2548 @id="1b686e82-bd4a-4aac-9d7b-9bdbe1e9a7de", @name="A New Name", @mac="6081f9fffe00033f", @created_at="2015-08-12T23:19:34.175932Z", @updated_at="2015-08-12T23:19:34.174828Z", @versions=nil>
```

### Labels

Sensors can be grouped together under a named label.

#### Create a Label
```ruby
client.new_label(name: 'A New Label')
# => #<Helium::Label:0x007ffd80f2be28 @id="409d9394-60d5-436a-b8cb-7160d466fc5a", @name="A New Label", @created_at="2016-08-22T18:58:34.415862Z", @updated_at="2016-08-22T18:58:34.415862Z">
```

#### List all Labels
```ruby
client.labels
# => [#<Helium::Label:0x007ffd80f2be28 @id="409d9394-60d5-436a-b8cb-7160d466fc5a", @name="A New Label", @created_at="2016-08-22T18:58:34.415862Z", @updated_at="2016-08-22T18:58:34.415862Z">, ...]
```

#### Find a Label by id
```ruby
label = client.label("409d9394-60d5-436a-b8cb-7160d466fc5a")
# => #<Helium::Label:0x007ffd80f2be28 @id="409d9394-60d5-436a-b8cb-7160d466fc5a", @name="A New Label", @created_at="2016-08-22T18:58:34.415862Z", @updated_at="2016-08-22T18:58:34.415862Z">
```

#### Update a Label
```ruby
label.update(name: 'An Updated Label')
# => #<Helium::Label:0x007ffd80d41680 @id="409d9394-60d5-436a-b8cb-7160d466fc5a", @name="An Updated Label", @created_at="2016-08-22T18:58:34.415862Z", @updated_at="2016-08-22T18:58:34.415862Z">
```

#### Add Sensors to a Label
```ruby
label.add_sensors(a_sensor)
# Or
label.add_sensors([sensor_1, sensor_2])
```

#### View a Label's Sensors
```ruby
label.sensors
# => [
#  [0] #<Helium::Sensor:0x007ffd81147450 @id="08bab58b-d095-4c7c-912c-1f8024d91d95", @name="Marc's Isotope", @mac="6081f9fffe00019b", @ports=["b", "t"], @created_at="2015-08-06T17:28:11.614107Z", @updated_at="2016-05-30T22:36:50.810716Z">
# ]
```

#### Remove Sensors from a Label
```ruby
label.remove_sensors(a_sensor)
# Or
label.remove_sensors([sensor_1, sensor_2])
```

#### Destroy a Label
```ruby
label.destroy
# => true
```

### JSON
All objects and collections of objects have a JSON representation. Simply call `.to_json`:

```ruby
client.sensors.first.to_json
# => "{\"id\":\"08bab58b-d095-4c7c-912c-1f8024d91d95\",\"created_at\":\"2015-08-06T17:28:11+00:00\",\"updated_at\":\"2016-05-30T22:36:50+00:00\",\"name\":\"Marc's Isotope\",\"mac\":\"6081f9fffe00019b\",\"ports\":[\"b\",\"t\"]}"
```

## Source Documentation
Documentation for the gem's source can be found here: https://helium.github.io/helium-ruby/


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Roadmap

We're working toward a v1.0.0 release, which will represent a feature-complete implementation of the Helium API. You can check the progress here: https://github.com/helium/helium-ruby/milestone/1.

Until the v1.0.0 release, the functionality of this gem is subject to change. To prevent breaking changes, you should use the pessimistic version constraint operator (`~>`) in your Gemfile to lock your helium-ruby version to the current minor release. This will allow updates to patch versions.

## Contributing

We value contributions from the community and will do everything we can go get them reviewed in a timely fashion. If you have code to send our way or a bug to report:

* Contributing Code: If you have new code or a bug fix, fork this repo, create a logically-named branch, and submit a PR against this repo. Include a write up of the PR with details on what it does.

* Reporting Bugs: Open an issue against this repo with as much detail as you can. At the very least you'll include steps to reproduce the problem.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) Code of Conduct.

Above all, thank you for taking the time to be a part of the Helium community.

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

The gem is available as open source under the terms of the [BSD License](https://github.com/helium/helium-ruby/blob/master/LICENSE.txt).
