require 'spec_helper'

describe Helium::Collection, 'inspect' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:collection) { client.sensors }

  use_cassette 'sensors/collection'

  it 'displays the collection when inspecting' do
    expect(collection.inspect.first).to be_a(Helium::Sensor)
  end
end

describe Helium::Collection, 'to_json' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:collection) { client.sensors }

  use_cassette 'sensors/collection'

  it 'returns the collection in json format' do
    json = collection.to_json

    parsed_json = JSON.parse(json)

    expect(parsed_json.first["name"]).to eq("weather-94945")
  end
end
