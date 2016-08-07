require 'spec_helper'

describe Helium::DataPoint, 'Sensor#timeseries' do
  let(:client)      { Helium::Client.new(api_key: API_KEY) }
  let(:sensor)      { client.sensor("aba370be-837d-4b41-bee5-686b0069d874") }
  let(:data_points) { sensor.timeseries }
  let(:data_point)  { data_points.first }

  around(:each) do |spec|
    VCR.use_cassette 'sensor/timeseries' do
      spec.run
    end
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
    it 'returns an array of DataPoints' do
      expect(data_points).to be_an(Array)
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

    around(:each) do |spec|
      VCR.use_cassette 'sensor/timeseries_by_port' do
        spec.run
      end
    end

    it 'returns DataPoints of the given port' do
      expect(data_points.collect(&:port)).to all(eq('t'))
    end
  end

  context 'when filtering by time' do
    let(:start_time)  { DateTime.parse('2016-08-02') }
    let(:end_time)    { DateTime.parse('2016-08-04') }
    let(:data_points) { sensor.timeseries(start_time: start_time, end_time: end_time) }
    let(:timestamps)  { data_points.collect(&:timestamp) }

    around(:each) do |spec|
      VCR.use_cassette 'sensor/timeseries_by_time' do
        spec.run
      end
    end

    it 'returns DataPoints after the start time' do
      expect(timestamps).to all(be >= start_time)
    end

    it 'returns DataPoints before the end time' do
      expect(timestamps).to all(be < end_time)
    end
  end

  context 'paging' do
    # TODO Helium::Timeseries#next
  end

  context 'when setting size' do
    let(:data_points) { sensor.timeseries(size: 100) }

    around(:each) do |spec|
      VCR.use_cassette 'sensor/timeseries_by_size' do
        spec.run
      end
    end

    it 'returns the requested number of DataPoints' do
      expect(data_points.length).to eq(100)
    end
  end
end
