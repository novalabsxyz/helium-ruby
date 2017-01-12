require 'spec_helper'

describe Helium::Metadata do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'sensors/metadata'

  it 'can fetch and update metadata for a sensor' do
    # Create a virtual sensor
    new_sensor = client.create_sensor(name: "A Test Sensor")

    # Fetch the metadata object
    metadata = new_sensor.metadata
    expect(metadata).to be_a(Helium::Metadata)
    expect(metadata.properties).to eq({})
    expect(metadata.respond_to?(:location)).to eq(false)

    # Update the metadata
    metadata = metadata.update(location: 'Building B')
    expect(metadata.location).to eq('Building B')
    expect(metadata.respond_to?(:location)).to eq(true)

    # fetch again to be sure
    metadata = new_sensor.metadata
    expect(metadata.location).to eq('Building B')

    # clean up
    new_sensor.destroy
  end
end

describe Helium::Metadata, 'filtering' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'sensors/metadata_filtering'

  it 'can filter sensors by their metadata properties' do
    # Create some virtual sensors with metadata
    new_sensor_1 = client.create_sensor(name: "A Test Sensor")
    new_sensor_1.metadata.update(location: 'Building A')

    new_sensor_2 = client.create_sensor(name: "A Test Sensor")
    new_sensor_2.metadata.update(location: 'Building B')

    # Fetch sensors matching criteria
    matching_sensors = client.sensors.where(location: 'Building A')

    matching_sensors.each do |matching_sensor|
      expect(matching_sensor.metadata.location).to eq('Building A')
    end

    # clean up
    new_sensor_1.destroy
    new_sensor_2.destroy
  end
end

describe Helium::Metadata, 'subset filtering' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'metadata/array_query'

  it 'returns a matching subset of sensors' do
    # Create some virtual sensors with metadata
    new_sensor_1 = client.create_sensor(name: "A Test Sensor")
    new_sensor_1.metadata.update(departments: ['facilities'])

    new_sensor_2 = client.create_sensor(name: "a test sensor")
    new_sensor_2.metadata.update(departments: ['facilities', 'it'])

    new_sensor_3 = client.create_sensor(name: "a test sensor")
    new_sensor_3.metadata.update(departments: ['facilities', 'it', 'engineering'])

    # Fetch sensors matching criteria
    matching_sensors = client.sensors.where(departments: ['facilities'])
    expect(matching_sensors).to eq([new_sensor_1, new_sensor_2, new_sensor_3])

    # Fetch sensors matching criteria
    matching_sensors = client.sensors.where(departments: ['facilities', 'it'])
    expect(matching_sensors).to eq([new_sensor_2, new_sensor_3])

    # Fetch sensors matching criteria
    matching_sensors = client.sensors.where(departments: ['facilities', 'it', 'engineering'])
    expect(matching_sensors).to eq([new_sensor_3])

    # clean up
    new_sensor_1.destroy
    new_sensor_2.destroy
    new_sensor_3.destroy
  end
end

describe Helium::Metadata, 'inspect' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'sensors/metadata_inspect'

  it 'shows the properties when inspecting' do
    # Create a virtual sensor
    new_sensor = client.create_sensor(name: "A Test Sensor")

    # Fetch the metadata object
    metadata = new_sensor.metadata

    # Update the metadata
    metadata = metadata.update(location: 'Building B')

    expect(metadata.inspect).to include("properties=")
    expect(metadata.inspect).to include("Building B")

    # clean up
    new_sensor.destroy
  end

end
