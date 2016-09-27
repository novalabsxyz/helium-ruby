require 'spec_helper'

describe 'Element#timeseries' do
  let(:client)      { Helium::Client.new(api_key: API_KEY) }
  let(:element)     { client.element("78b6a9f4-9c39-4673-9946-72a16c35a422") }
  let(:data_points) { element.timeseries }
  let(:data_point)  { data_points.first }

  use_cassette 'element/timeseries'

  it 'is a Cursor' do
    expect(data_points).to be_a(Helium::Cursor)
  end

  it 'has an id' do
    expect(data_point.id).to eq("038095dd-aca0-4f84-91d7-e97cf064817d")
  end

  it 'has a timestamp' do
    expect(data_point.timestamp).to eq(DateTime.parse("2016-07-28T04:50:05Z"))
  end

  it 'has a port' do
    expect(data_point.port).to eq("_se")
  end

  context 'when filtering by time' do
    let(:start_time)  { DateTime.parse('2016-06-01') }
    let(:end_time)    { DateTime.parse('2016-06-30') }
    let(:data_points) { element.timeseries(start_time: start_time, end_time: end_time) }
    let(:timestamps)  { data_points.collect(&:timestamp) }

    use_cassette 'element/timeseries_by_time'

    it 'returns DataPoints after the start time' do
      expect(timestamps).to all(be_after start_time)
    end

    it 'returns DataPoints before the end time' do
      expect(timestamps).to all(be_before end_time)
    end
  end
end

describe 'Element#create_timeseries' do
  let(:client)  { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.element("78b6a9f4-9c39-4673-9946-72a16c35a422") }
  let(:a_time)  { DateTime.parse('2016-09-01') }

  use_cassette 'element/create_timeseries'

  it 'creates a data point' do
    data_point = element.create_timeseries(
      port: "power level",
      value: "over 9000",
      timestamp: a_time
    )

    expect(data_point).to be_a(Helium::DataPoint)
    expect(data_point.port).to eq("power level")
    expect(data_point.value).to eq("over 9000")
    expect(data_point.timestamp).to eq(a_time)

    # grab it out of timeseries just to be sure
    data_point = element.timeseries.first

    expect(data_point).to be_a(Helium::DataPoint)
    expect(data_point.port).to eq("power level")
    expect(data_point.value).to eq("over 9000")
    expect(data_point.timestamp).to eq(a_time)
  end
end
