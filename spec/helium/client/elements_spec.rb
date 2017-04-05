require 'spec_helper'

describe Helium::Client, '#elements' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:elements) { client.elements }

  use_cassette 'elements/index'

  it 'is a collection' do
    expect(elements).to be_a(Helium::Collection)
  end

  it 'returns all elements associated with the current org' do
    expect(elements.count).to eq(6)
  end
end

describe Helium::Client, "#element" do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.element("78b6a9f4-9c39-4673-9946-72a16c35a422") }

  use_cassette 'elements/show'

  it 'is an Element' do
    expect(element).to be_a(Helium::Element)
  end

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

  it 'has a last_seen timestamp' do
    expect(element.last_seen).to eq(DateTime.parse("2016-07-28T04:50:08.413857Z"))
  end
end
