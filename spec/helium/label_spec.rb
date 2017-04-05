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

  it 'has a type' do
    expect(label.type).to eq("label")
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
  let(:label) { client.labels[3] }
  let(:sensors) { label.sensors }

  use_cassette 'labels/sensors'

  it 'returns all sensors associated with a label' do
    expect(sensors.count).to eq(1)
  end

  it 'returns fully formed sensors' do
    sensor = sensors.first
    expect(sensor.id).to eq("11b5a9e9-e098-4d57-9c10-ddb08f81ecfa")
    expect(sensor.name).to eq("weather-94945")
    expect(sensor.mac).to eq(nil)
    expect(sensor.ports).to eq(["t", "h", "p", "test", "X"])
  end
end


describe Helium::Label, '#add_elements' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'with a single element' do
    use_cassette 'labels/add_elements_individually'

    it "adds a element to a label without overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # grab some elements
      element_a = client.elements[0]
      element_b = client.elements[1]

      # add both elements to label
      new_label.add_elements(element_a)
      new_label.add_elements(element_b)

      # expect both elements to be in the label
      all_element_ids = [element_a.id, element_b.id]
      expect(new_label.elements.map(&:id)).to contain_exactly(*all_element_ids)

      # clean up
      [new_label].each(&:destroy)
    end
  end

  context 'with multiple elements' do
    use_cassette 'labels/add_elements_multiple'

    it "adds mulitple elements to a label" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # grab some elements
      element_a = client.elements[0]
      element_b = client.elements[1]
      element_c = client.elements[2]

      # add one element to label
      new_label.add_elements(element_a)

      # add the other two at the same time
      new_label.add_elements([element_c, element_b])

      # expect all elements to be in the label
      all_element_ids = [element_a.id, element_b.id, element_c.id] 
      expect(new_label.elements.map(&:id)).to contain_exactly(*all_element_ids)

      # clean up
      [new_label].each(&:destroy)
    end
  end
end

describe Helium::Label, '#replace_elements' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'with a single element' do
    use_cassette 'labels/replace_elements_individually'

    it "replaces a element to a label overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # grab some elements
      element_a = client.elements[0]
      element_b = client.elements[1]

      # add one element to label
      new_label.add_elements(element_a)

      # replace the element with the other
      new_label.replace_elements(element_b)

      # expect the second element to be in the label
      all_element_ids = [element_b.id]
      expect(new_label.elements.map(&:id)).to contain_exactly(*all_element_ids)

      # clean up
      [new_label].each(&:destroy)
    end
  end

  context 'with multiple elements' do
    use_cassette 'labels/replace_elements_multiple'

    it "replaces mulitple elements in a label" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some elements
      element_a = client.elements[0]
      element_b = client.elements[1]
      element_c = client.elements[2]

      # add one element to label
      new_label.add_elements(element_a)

      # replace the element with the other
      new_label.replace_elements([element_b, element_c])

      # expect the latter elements to be in the label
      all_element_ids = [element_b.id, element_c.id]
      expect(new_label.elements.map(&:id)).to contain_exactly(*all_element_ids)

      # clean up
      [new_label].each(&:destroy)
    end
  end
end

describe Helium::Label, '#remove_elements' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'with a single element' do
    use_cassette 'labels/remove_elements_individually'

    it "removes a element from a label without overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # grab some elements
      element_a = client.elements[0]
      element_b = client.elements[1]

      # add both elements to label
      new_label.add_elements([element_a, element_b])

      # remove one element from the label
      new_label.remove_elements(element_b)

      # expect the other element to be in the label
      all_element_ids = [element_a.id]
      expect(new_label.elements.map(&:id)).to contain_exactly(*all_element_ids)

      # clean up
      [new_label].each(&:destroy)
    end
  end

  context 'with mulitple sensors' do
    use_cassette 'labels/remove_elements_multiple'

    it "removes elements from a label without overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some elements
      element_a = client.elements[0]
      element_b = client.elements[1]
      element_c = client.elements[2]

      # add all elements to label
      new_label.add_elements([element_a, element_b, element_c])

      # remove two elements from the label
      new_label.remove_elements([element_b, element_c])

      # expect the other element to be in the label
      all_sensor_ids = [element_a.id]
      expect(new_label.elements.map(&:id)).to contain_exactly(*all_sensor_ids)

      # clean up
      [new_label].each(&:destroy)
    end
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

describe Helium::Label, '#replace_sensors' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'with a single sensor' do
    use_cassette 'labels/replace_sensors_individually'

    it "replaces a sensor to a label overriding existing relationships" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.create_sensor(name: "Test Sensor A")
      new_sensor_b = client.create_sensor(name: "Test Sensor B")

      # add one sensors to label
      new_label.add_sensors(new_sensor_a)

      # replace the sensor with the other
      new_label.replace_sensors(new_sensor_b)

      # expect the second sensor to be in the label
      all_sensor_ids = [new_sensor_b.id]
      expect(new_label.sensors.map(&:id)).to contain_exactly(*all_sensor_ids)

      # clean up
      [new_label, new_sensor_a, new_sensor_b].each(&:destroy)
    end
  end

  context 'with multiple sensors' do
    use_cassette 'labels/replace_sensors_multiple'

    it "replaces mulitple sensors in a label" do
      # create a new label
      new_label = client.create_label(name: "A Test Label")

      # create some sensors
      new_sensor_a = client.create_sensor(name: "Test Sensor A")
      new_sensor_b = client.create_sensor(name: "Test Sensor B")
      new_sensor_c = client.create_sensor(name: "Test Sensor C")

      # add one sensor to label
      new_label.add_sensors(new_sensor_a)

      # replace the sensor with the other
      new_label.replace_sensors([new_sensor_b, new_sensor_c])

      # expect the latter sensors to be in the label
      all_sensor_ids = [new_sensor_b.id, new_sensor_c.id]
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
