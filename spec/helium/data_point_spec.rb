require 'spec_helper'

describe Helium::DataPoint do
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
