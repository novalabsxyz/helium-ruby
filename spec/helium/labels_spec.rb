require 'spec_helper'

describe Helium::Client, '#labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:labels) { client.labels }

  use_cassette 'labels/index'

  it 'is an Array' do
    expect(labels).to be_an(Array)
  end

  it 'returns all labels associated with the current org' do
    expect(labels.count).to eq(9)
  end
end

describe Helium::Client, "#label" do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:label) { client.label("d85ae875-1d02-4ed1-84f3-c5949bcda1d9") }

  use_cassette 'labels/show'

  it 'is a Label' do
    expect(label).to be_a(Helium::Label)
  end

  it 'has an id' do
    expect(label.id).to eq("d85ae875-1d02-4ed1-84f3-c5949bcda1d9")
  end

  it 'has a name' do
    expect(label.name).to eq("The Isotopes")
  end
end

describe Helium::Label do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:label) { client.labels.first }

  use_cassette 'labels/index'

  it 'has an id' do
    expect(label.id).to eq("d85ae875-1d02-4ed1-84f3-c5949bcda1d9")
  end

  it 'has a name' do
    expect(label.name).to eq("The Isotopes")
  end

  it 'has a created_at timestamp' do
    expect(label.created_at).to eq(DateTime.parse("2016-03-04T16:14:16.090864Z"))
  end

  it 'has an updated_at timestamp' do
    expect(label.updated_at).to eq(DateTime.parse("2016-03-04T16:14:16.090864Z"))
  end
end



describe Helium::Label, '#sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:label) { client.labels.first }

  use_cassette 'labels/sensors'
end
