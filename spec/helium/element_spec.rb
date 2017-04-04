require 'spec_helper'

describe Helium::Element do
  let(:client) { instance_double(Helium::Client) }
  let(:element) { described_class.new(client: client, params: ELEMENT_PARAMS) }

  it 'has an id' do
    expect(element.id).to eq("78b6a9f4-9c39-4673-9946-72a16c35a422")
  end

  it 'has a name' do
    expect(element.name).to eq("SF Office")
  end

  it 'has a mac' do
    expect(element.mac).to eq("6081f9fffe0002a8")
  end

  it 'has a type' do
    expect(element.type).to eq("element")
  end

  it 'has a created_at timestamp' do
    expect(element.created_at).to eq(DateTime.parse("2015-08-12T23:10:40.537762Z"))
  end

  it 'has an updated_at timestamp' do
    expect(element.updated_at).to eq(DateTime.parse("2015-08-12T23:10:40.536644Z"))
  end

end

describe Helium::Element, '#update' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.element("19d493bc-7599-4b95-ac68-31e01d97c345") }

  use_cassette 'elements/patch'

  it "updates the element's name" do
    expect(element.name).to eq("Another Element")
    updated_element = element.update(name: "Updated Element")
    expect(updated_element.name).to eq("Updated Element")
  end
end

describe Helium::Element, '#labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.element("6fa2f914-450e-447a-8aa3-0e277cda9690") }

  let(:labels) { element.labels }

  use_cassette 'elements/labels'

  it 'returns all labels attached to a element' do
    expect(labels.count).to eq(1)
  end

  it 'returns fully formed labels' do
    label = labels.first
    expect(label.name).to eq("test")

  end
end

describe Helium::Element, '#sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.element("2c59f726-5316-49a7-857a-33ae63b126a4") }
  let(:sensors) { element.sensors }

  use_cassette 'elements/sensors'

  it 'returns all sensors attached to a element' do
    expect(sensors.count).to eq(3)
  end

  it 'returns fully formed sensors' do
    sensor = sensors.first
    expect(sensor.id).to eq("47da7cef-f0c5-43fb-85e0-b4b23d3ddb05")
    expect(sensor.mac).to eq("6081f9fffe00068d")
    expect(sensor.name).to eq("TC Suite")
    expect(sensor.ports).to eq(["_se","_b","b","m","l","p","h","t"])
  end
end

describe Helium::Element, '#device_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.element("56618098-5145-445c-a6db-805eaf37ff51") }

  use_cassette 'element/device_configuration'

  it 'gets a DeviceConfiguration for a Element' do
    dc = element.device_configuration
    expect(dc.id).to eq("85a9bbf9-0ff7-4678-b071-03342b6c7f91")
    expect(dc).to be_a(Helium::DeviceConfiguration)
  end
end

describe Helium::Element, '#to_json' do
  let(:client) { instance_double(Helium::Client) }
  let(:element) { described_class.new(client: client, params: ELEMENT_PARAMS) }

  it 'is a JSON-encoded string representing the user' do
    decoded_json = JSON.parse(element.to_json)
    expect(decoded_json["id"]).to eq(element.id)
    expect(decoded_json["name"]).to eq(element.name)
  end
end
