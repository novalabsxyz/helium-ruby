require 'spec_helper'

describe Helium::Collection do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:collection) { client.sensors }

  use_cassette 'collection/sensors'

  it 'can use [] to access elements of the collection' do
    expect(collection[0]).to eq(collection.first)
  end
end

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

describe Helium::Collection, 'array queries' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:collection) { client.sensors }

  it 'turns filter criteria into an array when the same key is chained' do
    new_collection = collection
      .where(departments: 'facilities')
      .where(departments: 'it')

    expected_criteria = {
      departments: ['facilities', 'it']
    }

    expect(new_collection.filter_criteria).to eq(expected_criteria)
  end

  it 'merges array queries when chained' do
    new_collection = collection
      .where(departments: ['facilities', 'it'])
      .where(departments: 'engineering')

    expected_criteria = {
      departments: ['facilities', 'it', 'engineering']
    }

    expect(new_collection.filter_criteria).to eq(expected_criteria)
  end

  it 'leaves single values alone' do
    new_collection = collection.where(departments: 'facilities')

    expected_criteria = {
      departments: 'facilities'
    }

    expect(new_collection.filter_criteria).to eq(expected_criteria)
  end
end
