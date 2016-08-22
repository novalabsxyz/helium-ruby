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

describe Helium::Client, '#new_label' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  use_cassette 'labels/create'

  it 'creates a new label' do
    new_label = client.new_label(name: "A Test Label")
    expect(new_label).to be_a(Helium::Label)
    expect(new_label.name).to eq("A Test Label")

    # verify it's now in the org's labels
    all_labels = client.labels
    new_labels = all_labels.select{ |s| s.name == "A Test Label" }
    expect(new_labels.count).to eq(1)
  end
end

describe Helium::Client, '#update_label' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  use_cassette 'labels/update'

  it 'updates a label' do
    # create a new label to update
    new_label = client.new_label(name: "A Test Label")

    updated_label = new_label.update(name: "An Updated Label")
    expect(updated_label.name).to eq("An Updated Label")

    # fetch it again just to make sure
    fetched_label = client.label(new_label.id)
    expect(fetched_label.name).to eq("An Updated Label")
  end
end

describe Helium::Client, '#delete_label' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  use_cassette 'labels/destroy'

  it 'destroys a label' do
    # create a new label to destroy
    new_label = client.new_label(name: "A Test Label")

    # make sure it's in the org labels first
    all_labels = client.labels
    new_labels = all_labels.select{ |s| s.name == "A Test Label" }

    expect(new_labels.count).to eq(1)
    label = new_labels.first

    # deleting should return 204 code
    expect(label.destroy).to eq(true)

    # verify it's no longer in the org's labels
    all_labels = client.labels
    new_labels = all_labels.select{ |s| s.name == "A Test Label" }
    expect(new_labels.count).to eq(0)
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

describe Helium::Client, '#update_label_sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  use_cassette 'labels/sensors_update'

  it "updates the label's sensor relationship" do
    # create a new label
    new_label = client.new_label(name: "A Test Label")

    # create a new sensor
    new_sensor = client.new_sensor(name: "A Test Sensor")

    # add sensor to label
    response = client.update_label_sensors(new_label, sensors: new_sensor)

    # response should include new sensor
    expect(response.map(&:id)).to include(new_sensor.id)

    # verify sensor is present in label's relationships
    expect(new_label.sensors.map(&:id)).to include(new_sensor.id)

    # clean up
    new_label.destroy
    new_sensor.destroy
  end
end

describe Helium::Label, '#add_sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'with a single sensor' do
    use_cassette 'labels/add_sensors_individually'

    it "adds a sensor to a label without overriding existing relationships" do
      # create a new label
      new_label = client.new_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.new_sensor(name: "Test Sensor A")
      new_sensor_b = client.new_sensor(name: "Test Sensor B")

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
      new_label = client.new_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.new_sensor(name: "Test Sensor A")
      new_sensor_b = client.new_sensor(name: "Test Sensor B")
      new_sensor_c = client.new_sensor(name: "Test Sensor C")

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
      new_label = client.new_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.new_sensor(name: "Test Sensor A")
      new_sensor_b = client.new_sensor(name: "Test Sensor B")

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
      new_label = client.new_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.new_sensor(name: "Test Sensor A")
      new_sensor_b = client.new_sensor(name: "Test Sensor B")
      new_sensor_c = client.new_sensor(name: "Test Sensor C")

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
