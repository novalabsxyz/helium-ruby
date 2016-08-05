require 'spec_helper'

describe Helium::Client do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  it 'has an api key' do
    expect(client.api_key).to eq(API_KEY)
  end
end
