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
  let(:client) { instance_double(Helium::Client) }
  let(:element) { described_class.new(client: client, params: ELEMENT_PARAMS) }

  it "updates the element's name" do
    allow(client).to receive(:update_element)
    element.update(name: "Updated Element")
    expect(client).to have_received(:update_element).with(element, name: "Updated Element")
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
