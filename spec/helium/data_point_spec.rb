require 'spec_helper'

describe Helium::DataPoint, 'equality' do
  it 'is equal to another data point if their ids match' do
    data_point_a = Helium::DataPoint.new(client: nil, params: {'id' => 'an_id'})
    data_point_b = Helium::DataPoint.new(client: nil, params: {'id' => 'an_id'})
    expect(data_point_a).to eq(data_point_b)
  end

  it 'is not equal to another data point if their ids do not match' do
    data_point_a = Helium::DataPoint.new(client: nil, params: {'id' => 'an_id'})
    data_point_b = Helium::DataPoint.new(client: nil, params: {'id' => 'diff_id'})
    expect(data_point_a).not_to eq(data_point_b)
  end
end

describe Helium::DataPoint, '#aggregate?' do
  let(:client) { instance_double(Helium::Client) }

  subject { data_point.aggregate? }

  context 'when the data point has aggregate values' do
    let(:data_point) {
      described_class.new(client: client, params: AGG_DATA_POINT_PARAMS)
    }

    it { is_expected.to eq(true) }
  end

  context 'when the data point has a singular value' do
    let(:data_point) {
      described_class.new(client: client, params: DATA_POINT_PARAMS)
    }

    it { is_expected.to eq(false) }
  end
end

describe Helium::DataPoint, '#to_json' do
  let(:client) { instance_double(Helium::Client) }

  context 'when aggregate' do
    let(:data_point) {
      described_class.new(client: client, params: AGG_DATA_POINT_PARAMS)
    }

    it 'is a JSON-encoded string representing the data point' do
      decoded_json = JSON.parse(data_point.to_json)
      expect(decoded_json["id"]).to eq(data_point.id)
    end

    it 'has a max' do
      decoded_json = JSON.parse(data_point.to_json)
      expect(decoded_json["max"]).to eq(data_point.max)
    end

    it 'has a min' do
      decoded_json = JSON.parse(data_point.to_json)
      expect(decoded_json["min"]).to eq(data_point.min)
    end

    it 'has an avg' do
      decoded_json = JSON.parse(data_point.to_json)
      expect(decoded_json["avg"]).to eq(data_point.avg)
    end
  end

  context 'when singular' do
    let(:data_point) {
      described_class.new(client: client, params: DATA_POINT_PARAMS)
    }

    it 'is a JSON-encoded string representing the data point' do
      decoded_json = JSON.parse(data_point.to_json)
      expect(decoded_json["id"]).to eq(data_point.id)
    end

    it 'has a value' do
      decoded_json = JSON.parse(data_point.to_json)
      expect(decoded_json["value"]).to eq(data_point.value)
    end
  end
end
