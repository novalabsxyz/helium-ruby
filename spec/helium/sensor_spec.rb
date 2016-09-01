require 'spec_helper'

describe Helium::Sensor, '#to_json' do
  let(:client) { instance_double(Helium::Client) }
  let(:sensor) { described_class.new(client: client, params: SENSOR_PARAMS) }

  it 'is a JSON-encoded string representing the user' do
    decoded_json = JSON.parse(sensor.to_json)
    expect(decoded_json["id"]).to eq(sensor.id)
    expect(decoded_json["name"]).to eq(sensor.name)
  end
end

describe Helium::Sensor, '#labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:sensor) { client.sensor("01d53511-228d-4530-8eaf-74d43c17baa8") }

  use_cassette 'sensor/labels'

  # NOTE: labels returned currently just have id populated
  it 'shows labels associated with the sensor' do
    a_label_id = "f4b9f955-8032-4a03-9c20-10b940137158"
    expect(sensor.labels.map(&:id)).to include(a_label_id)
  end
end
