require 'spec_helper'

describe Helium::Sensor, '#element' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:sensor) { client.sensor("5af6c914-4232-4fda-9e38-1e76597e539b") }
  let(:element) { sensor.element }

  use_cassette 'sensor/element'

  it 'returns fully formed element' do
    expect(element.id).to eq("cb9f0005-5c63-4571-bc46-209f65de9a1c")
    expect(element.mac).to eq("6081f9fffe0002f5")
    expect(element.name).to eq("Element 2")
  end
end

describe Helium::Sensor, '#to_json' do
  let(:client) { instance_double(Helium::Client) }
  let(:sensor) { described_class.new(client: client, params: SENSOR_PARAMS) }

  it 'is a JSON-encoded string representing the user' do
    decoded_json = JSON.parse(sensor.to_json)
    expect(decoded_json["id"]).to eq(sensor.id)
    expect(decoded_json["name"]).to eq(sensor.name)
  end
end

describe Helium::Sensor, '#labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:sensor) { client.sensor("01d53511-228d-4530-8eaf-74d43c17baa8") }
  let(:labels) { sensor.labels }

  use_cassette 'sensor/labels'

  it 'returns all labels assigned to a sensor' do
    expect(labels.count).to eq(2)
  end

  it 'returns fully formed labels' do
    label = labels.first
    expect(label.id).to eq("273dc59b-5a69-4247-8675-2970f1f095c6")
    expect(label.type).to eq("label")
    expect(label.name).to eq("Label Ladel")
  end
end

describe Helium::Sensor, '#add_labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context "with a single label" do
    use_cassette 'sensor/add_single_label'
    it 'adds a single label to a sensor' do

      # create a sensor
      new_sensor = client.create_sensor(name: "Test Sensor A")

      # create a new label
      new_label_a = client.create_label(name: "A Test Label")

      # add one label to sensor
      new_sensor.add_labels(new_label_a)

      # expect the label to be assigned to the label
      all_label_ids = [new_label_a.id]
      expect(new_sensor.labels.map(&:id)).to contain_exactly(*all_label_ids)

      # clean up
      [new_sensor, new_label_a].each(&:destroy)
    end
  end

  context "with multiple labels" do
    use_cassette 'sensor/add_multiple_labels'
    it 'adds multiple labels to a sensor' do

      # create a sensor
      new_sensor = client.create_sensor(name: "Test Sensor A")

      # create new labels
      new_label_a = client.create_label(name: "A Test Label")
      new_label_b = client.create_label(name: "B Test Label")

      # add labels to sensor
      new_sensor.add_labels([new_label_a, new_label_b])

      # expect the label to be assigned to the label
      all_label_ids = [new_label_a.id, new_label_b.id]
      expect(new_sensor.labels.map(&:id)).to contain_exactly(*all_label_ids)

      # clean up
      [new_sensor, new_label_a, new_label_b].each(&:destroy)
    end
  end
end

describe Helium::Sensor, '#replace_labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context "with a single label" do
    use_cassette 'sensor/replace_single_label'
    it 'replaces a single label associated with a sensor' do

      # create a sensor
      new_sensor = client.create_sensor(name: "Test Sensor A")

      # create new labels
      new_label_a = client.create_label(name: "A Test Label")
      new_label_b = client.create_label(name: "B Test Label")

      # add one label to sensor
      new_sensor.add_labels(new_label_a)

      # replace the sensor's label
      new_sensor.replace_labels(new_label_b)

      # expect the label to be assigned to the label
      all_label_ids = [new_label_b.id]
      expect(new_sensor.labels.map(&:id)).to contain_exactly(*all_label_ids)

      # clean up
      [new_sensor, new_label_a, new_label_b].each(&:destroy)
    end
  end

  context "with multiple labels" do
    use_cassette 'sensor/replace_multiple_labels'
    it 'replaces multiple labels associated with a sensor' do

      # create a sensor
      new_sensor = client.create_sensor(name: "Test Sensor A")

      # create new labels
      new_label_a = client.create_label(name: "A Test Label")
      new_label_b = client.create_label(name: "B Test Label")
      new_label_c = client.create_label(name: "C Test Label")

      # add label to sensor
      new_sensor.add_labels(new_label_a)
      # Replace with labels
      new_sensor.replace_labels([new_label_b, new_label_c])

      # expect the labels to be assigned to the label
      all_label_ids = [new_label_b.id, new_label_c.id]
      expect(new_sensor.labels.map(&:id)).to contain_exactly(*all_label_ids)

      # clean up
      [new_sensor, new_label_a, new_label_b, new_label_c].each(&:destroy)
    end
  end
end

describe Helium::Sensor, '#remove_labels' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context "with a single label" do
    use_cassette 'sensor/remove_single_label'
    it 'removes a single label to a sensor' do

      # create a sensor
      new_sensor = client.create_sensor(name: "Test Sensor A")

      # create new labels
      new_label_a = client.create_label(name: "A Test Label")
      new_label_b = client.create_label(name: "B Test Label")

      # add labels to sensor
      new_sensor.add_labels([new_label_a, new_label_b])

      # delete one of the sensor's label
      new_sensor.remove_labels(new_label_a)

      # expect the label to be assigned to the label
      all_label_ids = [new_label_b.id]
      expect(new_sensor.labels.map(&:id)).to contain_exactly(*all_label_ids)

      # clean up
      [new_sensor, new_label_a, new_label_b].each(&:destroy)
    end
  end

  context "with multiple labels" do
    use_cassette 'sensor/remove_multiple_labels'
    it 'removes multiple labels associated with a sensor' do

      # create a sensor
      new_sensor = client.create_sensor(name: "Test Sensor A")

      # create new labels
      new_label_a = client.create_label(name: "A Test Label")
      new_label_b = client.create_label(name: "B Test Label")
      new_label_c = client.create_label(name: "C Test Label")

      # add label to sensor
      new_sensor.add_labels([new_label_a, new_label_b, new_label_c])
      # Remove labels
      new_sensor.remove_labels([new_label_b, new_label_c])

      # expect the labels to be assigned to the label
      all_label_ids = [new_label_a.id]
      expect(new_sensor.labels.map(&:id)).to contain_exactly(*all_label_ids)

      # clean up
      [new_sensor, new_label_a, new_label_b, new_label_c].each(&:destroy)
    end
  end
end

describe Helium::Sensor, '#device_configuration' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:sensor) { client.sensor("aba370be-837d-4b41-bee5-686b0069d874") }

  use_cassette 'sensor/device_configuration'

  it 'gets a DeviceConfiguration for a Sensor' do
    dc = sensor.device_configuration
    expect(dc.id).to eq("efb8b88b-0837-42e6-91ba-18ed38d16bbe")
    expect(dc).to be_a(Helium::DeviceConfiguration)
  end
end

describe Helium::Sensor, '#virtual?' do
  subject { sensor.virtual? }

  let(:sensor) {
    Helium::Sensor.new(client: nil, params: {
      'meta' => {
        'mac' => mac
      }
    })
  }

  context 'when mac is present' do
    let(:mac) { A_MAC_ADDRESS }

    it { is_expected.to eq(false) }
  end

  context 'when mac is not present' do
    let(:mac) { nil }

    it { is_expected.to eq(true) }
  end

end
