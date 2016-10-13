require 'spec_helper'

describe Helium::Sensor, '#element' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:sensor) { client.sensor("5af6c914-4232-4fda-9e38-1e76597e539b") }
  let(:element) { sensor.element }

  use_cassette 'sensor/element'

  it 'returns fully formed element' do
    expect(element.id).to eq("cb9f0005-5c63-4571-bc46-209f65de9a1c")
    expect(element.mac).to eq("6081f9fffe0002f5")
    expect(element.name).to eq("Element 2")
  end
end

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
