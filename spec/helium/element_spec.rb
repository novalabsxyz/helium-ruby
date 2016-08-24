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

  it 'has a created_at timestamp' do
    expect(element.created_at).to eq(DateTime.parse("2015-08-12T23:10:40.537762Z"))
  end

  it 'has an updated_at timestamp' do
    expect(element.updated_at).to eq(DateTime.parse("2015-08-12T23:10:40.536644Z"))
  end

  it 'has versions' do
    expect(element.versions).to eq({"element"=>"3050900"})
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

describe Helium::Element, '#sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.element("3482ce9f-599c-4982-bcb9-e94df65b1cb2") }
  let(:sensors) { element.sensors }

  use_cassette 'elements/sensors'

  it 'returns all sensors attached to a element' do
    expect(sensors.length).to eq(2)
  end

  it 'returns fully formed sensors' do
    sensor = sensors.first
    expect(sensor.id).to eq("94683401-4959-42c7-a38a-92c39a25f34c")
    expect(sensor.mac).to eq("6081f9fffe000665")
    expect(sensor.name).to eq("Mobile Demo Green 3")
    expect(sensor.ports).to eq(["_b", "_se", "b", "h", "l", "m", "p", "t"])
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
