require 'spec_helper'

describe Helium::Client, '#configurations' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'configurations/list'

  it 'is an array of Configurations' do
    configurations = client.configurations
    expect(configurations).to be_an(Array)
    expect(configurations.first).to be_a(Helium::Configuration)
  end

  it 'returns correctly instantiated configurations' do
    sensor = client.configurations.first
    expect(sensor.id).to eq("15c93189-575c-4f26-99a5-bd2991ec89eb")
  end
end

describe Helium::Client, '#configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:configuration) { client.configuration("b9dc998e-1926-42ad-a3e0-ba36eea55b45") }

  use_cassette 'configuration/get'

  it 'is a Configuration' do
    expect(configuration).to be_a(Helium::Configuration)
  end

  it 'has a type' do
    expect(configuration.type).to eq("configuration")
  end

  it 'has settings of proper value' do
    expect(configuration.settings['somenumber']).to eq(10)
    expect(configuration.settings['wifipasswd']).to eq("123456789")
    expect(configuration.settings['jaredtest']).to eq(true)
  end


end

describe Helium::Client, '#configuration_device_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:configuration) { client.configuration("b9dc998e-1926-42ad-a3e0-ba36eea55b45") }

  use_cassette 'configuration/device-configuration'

  it 'has device_configurations attached' do
    dc = configuration.device_configurations
    expect(dc).to be_an(Array)
    expect(dc.first.id).to eq("605f7acd-ca93-42e1-8041-eff548db5116")
  end
end

describe Helium::Client, '#new_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'configuration/create'

  it 'creates a new configuration' do
    new_map = {"rake_test" => true,
               "a rather large number" => 983247381239812364819233123896123948 }
    new_configuration = client.create_configuration(new_map)
    expect(new_configuration).to be_a(Helium::Configuration)
    expect(new_configuration.settings['rake_test']).to eq(true)
    expect(new_configuration.settings['a rather large number']).to eq(983247381239812364819233123896123948)

    # verify it's now in the org's configurations
    all_configurations = client.configurations
    new_configurations = all_configurations.select{ |s| s.id == new_configuration.id }
    expect(new_configurations.count).to eq(1)
  end
end
