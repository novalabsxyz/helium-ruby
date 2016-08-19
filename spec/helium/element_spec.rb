require 'spec_helper'

describe Helium::Client, '#elements' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:elements) { client.elements }

  use_cassette 'elements/index'

  it 'is an array' do
    expect(elements).to be_an(Array)
  end

  it 'returns all elements associated with the current org' do
    expect(elements.count).to eq(18)
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

  it 'has versions' do
    expect(element.versions).to eq({"element"=>"3050900"})
  end
end

describe Helium::Element do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:element) { client.elements.last }

  use_cassette 'elements/index'

  it 'has an id' do
    expect(element.id).to eq("ebcdb767-a307-4d26-a067-de1243ea7e38")
  end

  it 'has a name' do
    expect(element.name).to eq("SF Office")
  end

  it 'has a mac' do
    expect(element.mac).to eq("6081f9fffe000333")
  end

  it 'has a created_at timestamp' do
    expect(element.created_at).to eq(DateTime.parse("2015-08-12T23:19:53.271232Z"))
  end

  it 'has an updated_at timestamp' do
    expect(element.updated_at).to eq(DateTime.parse("2015-08-12T23:19:53.270124Z"))
  end

  it 'has versions' do
    expect(element.versions).to eq(nil)
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
