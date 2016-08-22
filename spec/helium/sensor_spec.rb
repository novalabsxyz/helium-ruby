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
