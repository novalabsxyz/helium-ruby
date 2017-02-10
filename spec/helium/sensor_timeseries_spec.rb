require 'spec_helper'

describe 'Sensor#timeseries' do
  let(:client)      { Helium::Client.new(api_key: API_KEY) }
  let(:sensor)      { client.sensor("aba370be-837d-4b41-bee5-686b0069d874") }
  let(:data_points) { sensor.timeseries }
  let(:data_point)  { data_points.first }

  use_cassette 'sensor/timeseries'

  it 'is a Cursor' do
    expect(data_points).to be_a(Helium::Cursor)
  end

  it 'has an id' do
    expect(data_point.id).to eq("16ee35a6-64b3-498c-a032-886414f6db21")
  end

  it 'has a timestamp' do
    expect(data_point.timestamp).to eq(DateTime.parse("2016-08-17T19:56:12.792Z"))
  end

  it 'has a value' do
    expect(data_point.value).to eq(true)
  end

  it 'has a port' do
    expect(data_point.port).to eq("m")
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

    it 'returns all ports' do
      all_ports = ['t', 'h', 'p', 'l', 'b', '_se', 'm']
      expect(data_points.collect(&:port).uniq).to contain_exactly(*all_ports)
    end
  end

  context 'when filtering by Port' do
    let(:start_time)  { DateTime.parse('2016-08-02') }
    let(:end_time)    { DateTime.parse('2016-08-04') }
    let(:data_points) { sensor.timeseries(port: 't', start_time: start_time, end_time: end_time) }

    use_cassette 'sensor/timeseries_by_port'

    it 'returns DataPoints of the given port' do
      expect(data_points.collect(&:port)).to all(eq('t'))
    end
  end


  context 'aggregations' do
    let(:start_time)  { DateTime.parse('2016-08-01') }
    let(:end_time)    { DateTime.parse('2016-08-15') }
    let(:data_points) {
      sensor.timeseries(aggtype: 'min,max,avg', aggsize: '1d', port: 't', start_time: start_time, end_time: end_time)
    }
    let(:data_point) { data_points.first }

    use_cassette 'sensor/timeseries_aggregations'

    it 'returns aggregated data points with min' do
      expect(data_point.min).to eq(21.931545)
    end

    it 'returns aggregated data points with max' do
      expect(data_point.max).to eq(23.44619)
    end

    it 'returns aggregated data points with avg' do
      expect(data_point.avg).to eq(22.6003919791667)
    end
  end

  context '#to_json' do
    let(:start_time)  { DateTime.parse('2016-08-02') }
    let(:end_time)    { DateTime.parse('2016-08-04') }
    let(:data_points) { sensor.timeseries(start_time: start_time, end_time: end_time) }

    use_cassette 'sensor/timeseries_by_time'

    it 'returns a JSON-encoded string representing the Timeseries' do
      decoded_json = JSON.parse(data_points.to_json)
      expect(decoded_json.count).to eq(2480)

      decoded_point = decoded_json.first
      expect(decoded_point["id"]).to eq(data_points.first.id)
      expect(decoded_point["value"]).to eq(data_points.first.value)
    end
  end
end

describe 'Timeseries#create' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:sensor) { client.create_sensor(name: "A Test Sensor") }
  let(:a_time) { DateTime.parse('2016-09-01') }

  use_cassette 'sensor/create_timeseries'

  after { sensor.destroy }

  it 'creates a new data point' do
    data_point = sensor.timeseries.create(
      port: "power level",
      value: "over 9000",
      timestamp: a_time
    )

    expect(data_point).to be_a(Helium::DataPoint)
    expect(data_point.port).to eq("power level")
    expect(data_point.value).to eq("over 9000")
    expect(data_point.timestamp).to eq(a_time)

    # grab it out of timeseries just to be sure
    data_point = sensor.timeseries.first

    expect(data_point).to be_a(Helium::DataPoint)
    expect(data_point.port).to eq("power level")
    expect(data_point.value).to eq("over 9000")
    expect(data_point.timestamp).to eq(a_time)
  end

end

describe 'Sensor#live_timeseries' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let!(:sensor) { client.create_sensor(name: "A Test Sensor") }
  use_cassette 'sensor/live_timeseries'

  # after { sensor.destroy }

  it 'streams live timeseries data from a sensor' do
    response = double(:response, code: 200)
    request = double(:request, response: response)
    allow(request).to receive(:on_body) { |&block| @on_body = block }
    allow(request).to receive(:run) do
      @on_body.call "event: sensor\ndata: {\"data\":{\"attributes\":{\"value\":93.0,\"timestamp\":\"2017-02-09T22:39:41Z\",\"port\":\"h\"},\"relationships\":{\"sensor\":{\"data\":{\"id\":\"11b5a9e9-e098-4d57-9c10-ddb08f81ecfa\",\"type\":\"sensor\"}}},\"id\":\"d5ebee85-398a-4efb-903a-e4bbe9d4bded\",\"meta\":{\"created\":\"2017-02-09T22:39:41.574898Z\"},\"type\":\"data-point\"}}"
    end
    allow(Typhoeus::Request).to receive(:new).and_return(request)

    sensor.live_timeseries do |data_point|
      expect(data_point.value).to eq(93.0)
      :abort
    end
  end
end
