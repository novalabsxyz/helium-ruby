require 'spec_helper'

describe Helium::Client, '#device_configurations' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'device_configurations/list'

  it 'is an array of Device Configurations' do
    device_configurations = client.device_configurations
    expect(device_configurations).to be_an(Array)
    expect(device_configurations.first).to be_a(Helium::DeviceConfiguration)
  end

  it 'returns correctly instantiated device_configurations' do
    sensor = client.device_configurations.first
    expect(sensor.id).to eq("605f7acd-ca93-42e1-8041-eff548db5116")
  end
end

describe Helium::Client, '#device_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:device_configuration) { client.device_configuration("605f7acd-ca93-42e1-8041-eff548db5116") }

  use_cassette 'device_configuration/get'

  it 'is a DeviceConfiguration' do
    expect(device_configuration).to be_a(Helium::DeviceConfiguration)
  end

  it 'has a type' do
    expect(device_configuration.type).to eq("device-configuration")
  end
end

describe Helium::Client, '#device_configuration_device_element' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:device_configuration) { client.device_configuration("605f7acd-ca93-42e1-8041-eff548db5116") }

  use_cassette 'device_configuration/device_element'

  it 'has a device attached' do
    device = device_configuration.device
    expect(device.id).to eq('d89ed12c-c7bb-4205-a48a-9fe59c96c459')
    expect(device).to be_a(Helium::Element)
  end
end

describe Helium::Client, '#device_configuration_device_sensor' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:device_configuration) { client.device_configuration("efb8b88b-0837-42e6-91ba-18ed38d16bbe") }

  use_cassette 'device_configuration/device_sensor'

  it 'has a device attached' do
    device = device_configuration.device
    expect(device.id).to eq('aba370be-837d-4b41-bee5-686b0069d874')
    expect(device).to be_a(Helium::Sensor)
  end
end

describe Helium::Client, '#device_configuration_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:device_configuration) { client.device_configuration("605f7acd-ca93-42e1-8041-eff548db5116") }

  use_cassette 'device_configuration/configuration'

  it 'has a configuration attached' do
    configuration = device_configuration.configuration
    expect(configuration.id).to eq('b9dc998e-1926-42ad-a3e0-ba36eea55b45')
    expect(configuration).to be_a(Helium::Configuration)
  end
end

describe Helium::Client, '#new_device_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:configuration) { client.configuration("deb753c7-c7ff-4202-8426-a864d4bd9624")}
  let(:device) { client.sensor("f928df8f-9cda-4313-9cf7-cffee5d57050") }

  use_cassette 'device_configuration/create'

  it 'creates a new device_configuration' do
    new_device_configuration = client.create_device_configuration(device, configuration)
    expect(new_device_configuration).to be_a(Helium::DeviceConfiguration)

    # verify it's now in the org's device_configurations
    all_device_configurations = client.device_configurations
    new_device_configurations = all_device_configurations.select{ |s| s.id == new_device_configuration.id }
    expect(new_device_configurations.count).to eq(1)
  end
end
