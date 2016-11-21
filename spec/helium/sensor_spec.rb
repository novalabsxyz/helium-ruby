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
  let(:labels) { sensor.labels }

  use_cassette 'sensor/labels'

  it 'returns all labels assigned to a sensor' do
    expect(labels.length).to eq(2)
  end

  it 'returns fully formed labels' do
    label = labels.first
    expect(label.id).to eq("273dc59b-5a69-4247-8675-2970f1f095c6")
    expect(label.type).to eq("label")
    expect(label.name).to eq("Label Ladel")
  end
end

describe Helium::Sensor, '#device_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:sensor) { client.sensor("aba370be-837d-4b41-bee5-686b0069d874") }

  use_cassette 'sensor/device_configuration'

  it 'gets a DeviceConfiguration for a Sensor' do
    dc = sensor.device_configuration
    expect(dc.id).to eq("efb8b88b-0837-42e6-91ba-18ed38d16bbe")
    expect(dc).to be_a(Helium::DeviceConfiguration)
  end
end
