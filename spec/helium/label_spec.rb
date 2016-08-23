require 'spec_helper'

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
  let(:sensors) { label.sensors }

  use_cassette 'labels/sensors'

  it 'returns all sensors associated with a label' do
    expect(sensors.length).to eq(3)
  end

  it 'returns fully formed sensors' do
    sensor = sensors.first
    expect(sensor.id).to eq("08bab58b-d095-4c7c-912c-1f8024d91d95")
    expect(sensor.name).to eq("Marc's Isotope")
    expect(sensor.mac).to eq("6081f9fffe00019b")
    expect(sensor.ports).to eq(["b", "t"])
  end
end

describe Helium::Label, '#add_sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'with a single sensor' do
    use_cassette 'labels/add_sensors_individually'

    it "adds a sensor to a label without overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.create_sensor(name: "Test Sensor A")
      new_sensor_b = client.create_sensor(name: "Test Sensor B")

      # add both sensors to label
      new_label.add_sensors(new_sensor_a)
      new_label.add_sensors(new_sensor_b)

      # expect both sensors to be in the label
      all_sensor_ids = [new_sensor_a.id, new_sensor_b.id]
      expect(new_label.sensors.map(&:id)).to contain_exactly(*all_sensor_ids)

      # clean up
      [new_label, new_sensor_a, new_sensor_b].each(&:destroy)
    end
  end

  context 'with multiple sensors' do
    use_cassette 'labels/add_sensors_multiple'

    it "adds mulitple sensors to a label" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.create_sensor(name: "Test Sensor A")
      new_sensor_b = client.create_sensor(name: "Test Sensor B")
      new_sensor_c = client.create_sensor(name: "Test Sensor C")

      # add one sensor to label
      new_label.add_sensors(new_sensor_a)

      # add the other two at the same time
      new_label.add_sensors([new_sensor_b, new_sensor_c])

      # expect all sensors to be in the label
      all_sensor_ids = [new_sensor_a.id, new_sensor_b.id, new_sensor_c.id]
      expect(new_label.sensors.map(&:id)).to contain_exactly(*all_sensor_ids)

      # clean up
      [new_label, new_sensor_a, new_sensor_b, new_sensor_c].each(&:destroy)
    end
  end
end

describe Helium::Label, '#remove_sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'with a single sensor' do
    use_cassette 'labels/remove_sensors_individually'

    it "removes a sensor from a label without overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.create_sensor(name: "Test Sensor A")
      new_sensor_b = client.create_sensor(name: "Test Sensor B")

      # add both sensors to label
      new_label.add_sensors([new_sensor_a, new_sensor_b])

      # remove one sensor from the label
      new_label.remove_sensors(new_sensor_b)

      # expect the other sensor to be in the label
      all_sensor_ids = [new_sensor_a.id]
      expect(new_label.sensors.map(&:id)).to contain_exactly(*all_sensor_ids)

      # clean up
      [new_label, new_sensor_a, new_sensor_b].each(&:destroy)
    end
  end

  context 'with mulitple sensors' do
    use_cassette 'labels/remove_sensors_multiple'

    it "removes sensors from a label without overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.create_sensor(name: "Test Sensor A")
      new_sensor_b = client.create_sensor(name: "Test Sensor B")
      new_sensor_c = client.create_sensor(name: "Test Sensor C")

      # add all sensors to label
      new_label.add_sensors([new_sensor_a, new_sensor_b, new_sensor_c])

      # remove two sensors from the label
      new_label.remove_sensors([new_sensor_b, new_sensor_c])

      # expect the other sensor to be in the label
      all_sensor_ids = [new_sensor_a.id]
      expect(new_label.sensors.map(&:id)).to contain_exactly(*all_sensor_ids)

      # clean up
      [new_label, new_sensor_a, new_sensor_b, new_sensor_c].each(&:destroy)
    end
  end
end

describe Helium::Label, '#to_json' do
  let(:client) { instance_double(Helium::Client) }
  let(:label) { described_class.new(client: client, params: LABEL_PARAMS) }

  it 'is a JSON-encoded string representing the user' do
    decoded_json = JSON.parse(label.to_json)
    expect(decoded_json["id"]).to eq(label.id)
    expect(decoded_json["name"]).to eq(label.name)
  end
end
