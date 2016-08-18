require 'spec_helper'

describe Helium::Sensor do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'Client#sensors' do
    use_cassette 'sensor/list'

    it 'is an array of Sensors' do
      sensors = client.sensors
      expect(sensors).to be_an(Array)
      expect(sensors.first).to be_a(Helium::Sensor)
    end

    it 'returns correctly instantiated sensors' do
      sensor = client.sensors.first
      expect(sensor.id).to eq("08bab58b-d095-4c7c-912c-1f8024d91d95")
    end
  end

  context 'Client#sensor' do
    let(:sensor) { client.sensor("aba370be-837d-4b41-bee5-686b0069d874") }

    use_cassette 'sensor/get'

    it 'is a Sensor' do
      expect(sensor).to be_a(Helium::Sensor)
    end

    it 'has an id' do
      expect(sensor.id).to eq("aba370be-837d-4b41-bee5-686b0069d874")
    end

    it 'has a name' do
      expect(sensor.name).to eq("SF Office Brick1 1 (on Marc's desk)")
    end

    it 'has a mac address' do
      expect(sensor.mac).to eq("6081f9fffe000478")
    end

    it 'has ports' do
      # TODO Port will be an object
      expect(sensor.ports).to eq(["_se","lr","l","p","h","m","_e.info","t","b"])
    end

    it 'has a created_at datetime' do
      expect(sensor.created_at).to eq(DateTime.parse("2016-03-30T20:52:26.314159Z"))
    end

    it 'has an updated_at datetime' do
      expect(sensor.updated_at).to eq(DateTime.parse("2016-04-08T23:33:05.719843Z"))
    end
  end

  context 'Client#new_sensor' do
    use_cassette 'sensor/post'

    it 'creates a new virtual sensor' do
      new_sensor = client.new_sensor(name: "A Test Sensor")
      expect(new_sensor).to be_a(Helium::Sensor)
      expect(new_sensor.name).to eq("A Test Sensor")

      # verify it's now in the org's sensors
      all_sensors = client.sensors
      new_sensors = all_sensors.select{ |s| s.name == "A Test Sensor" }
      expect(new_sensors.count).to eq(1)
    end
  end

  context 'Client#update_sensor' do
    use_cassette 'sensor/patch'

    it 'updates a virtual sensor' do
      # create a new sensor to update
      new_sensor = client.new_sensor(name: "A Test Sensor")

      updated_sensor = new_sensor.update(name: "An Updated Sensor")
      expect(updated_sensor.name).to eq("An Updated Sensor")

      # fetch it again just to make sure
      fetched_sensor = client.sensor(new_sensor.id)
      expect(fetched_sensor.name).to eq("An Updated Sensor")
    end
  end

  context 'Client#delete_sensor' do
    use_cassette 'sensor/delete'

    it 'destroys a virtual sensor' do
      # create a new sensor to destroy
      new_sensor = client.new_sensor(name: "A Test Sensor")

      # make sure it's in the org sensors first
      all_sensors = client.sensors
      new_sensors = all_sensors.select{ |s| s.name == "A Test Sensor" }

      expect(new_sensors.count).to eq(1)
      sensor = new_sensors.first

      # deleting should return 204 code
      expect(sensor.destroy).to eq(true)

      # verify it's no longer in the org's sensors
      all_sensors = client.sensors
      new_sensors = all_sensors.select{ |s| s.name == "A Test Sensor" }
      expect(new_sensors.count).to eq(0)
    end
  end
end
