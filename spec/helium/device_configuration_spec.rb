require 'spec_helper'

describe Helium::DeviceConfiguration, '#to_json' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:dc) { client.device_configuration("605f7acd-ca93-42e1-8041-eff548db5116") }

  use_cassette 'device_configuration/to_json'

  it 'is a JSON-encoded string representing the device_configuration' do
    decoded_json = JSON.parse(dc.to_json)
    expect(decoded_json["id"]).to eq(dc.id)
    expect(decoded_json["type"]).to eq(dc.type)
    expect(decoded_json["loaded"]).to eq (dc.loaded)
  end
end
