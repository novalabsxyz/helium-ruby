require 'spec_helper'

describe Helium::Timeseries, 'Sensor#timeseries' do
  let(:client)      { Helium::Client.new(api_key: API_KEY) }
  let(:sensor)      { client.sensor("aba370be-837d-4b41-bee5-686b0069d874") }
  let(:data_points) { sensor.timeseries }
  let(:data_point)  { data_points.first }

  use_cassette 'sensor/timeseries'

  it 'is a Timeseries' do
    expect(data_points).to be_a(Helium::Timeseries)
  end

  it 'has an id' do
    expect(data_point.id).to eq("d418d9d3-8c2c-4100-b9c1-e30fa793381c")
  end

  it 'has a timestamp' do
    expect(data_point.timestamp).to eq(DateTime.parse("2016-08-07T14:00:29.918Z"))
  end

  it 'has a value' do
    expect(data_point.value).to eq(20.670208)
  end

  it 'has a port' do
    expect(data_point.port).to eq("t")
  end

  context 'when not filtering' do
    it 'returns DataPoints' do
      expect(data_points).to all( be_a(Helium::DataPoint) )
    end

    it 'returns 1000 DataPoints' do
      expect(data_points.length).to eq(1000)
    end

    it 'returns all ports' do
      all_ports = ['t', 'h', 'p', 'l', 'b', '_se']
      expect(data_points.collect(&:port).uniq).to contain_exactly(*all_ports)
    end
  end

  context 'when filtering by Port' do
    let(:data_points) { sensor.timeseries(port: 't') }

    use_cassette 'sensor/timeseries_by_port'

    it 'returns DataPoints of the given port' do
      expect(data_points.collect(&:port)).to all(eq('t'))
    end
  end

  context 'when filtering by time' do
    let(:start_time)  { DateTime.parse('2016-08-02') }
    let(:end_time)    { DateTime.parse('2016-08-04') }
    let(:data_points) { sensor.timeseries(start_time: start_time, end_time: end_time) }
    let(:timestamps)  { data_points.collect(&:timestamp) }

    use_cassette 'sensor/timeseries_by_time'

    it 'returns DataPoints after the start time' do
      expect(timestamps).to all(be_after start_time)
    end

    it 'returns DataPoints before the end time' do
      expect(timestamps).to all(be_before end_time)
    end
  end

  context 'paging to previous' do
    use_cassette 'sensor/timeseries_paging'

    it 'returns a new Timeseries object' do
      expect(data_points.previous).to be_a(Helium::Timeseries)
    end

    it 'returns data_points older than those in the current timeseries' do
      expect(data_points.last.timestamp).to be_more_recent_than data_points.previous.first.timestamp
    end

    it 'returns false if there are no previous data points' do
      data_points = Helium::Timeseries.new(client: nil)
      expect(data_points.previous).to eq(false)
    end
  end

  context 'paging to next' do
    use_cassette 'sensor/timeseries_paging_next'

    it 'returns data points newer than those in the current timeseries' do
      previous_data_points  = data_points.previous
      next_timestamp        = previous_data_points.next.first.timestamp
      previous_timestamp    = previous_data_points.first.timestamp
      expect(next_timestamp).to be_more_recent_than(previous_timestamp)
    end

    it 'returns false if there are no next data points' do
      expect(data_points.next).to eq(false)
    end
  end

  context 'when setting size' do
    let(:data_points) { sensor.timeseries(size: 100) }

    use_cassette 'sensor/timeseries_by_size'

    it 'returns the requested number of DataPoints' do
      expect(data_points.length).to eq(100)
    end
  end

  context 'aggregations' do
    let(:data_points) { sensor.timeseries(aggtype: 'min,max,avg', aggsize: '1d') }

    use_cassette 'sensor/timeseries_aggregations'

    it 'returns aggregated data points with min, max and avg' do
      data_point = data_points.first
      expect(data_point.max).to eq(45)
      expect(data_point.min).to eq(18)
      expect(data_point.avg).to eq(30.8214285714286)
    end

  end
end
