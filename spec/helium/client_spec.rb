require 'spec_helper'

describe Helium::Client do
  API_KEY = 'not_a_real_api_key'

  let(:client) { Helium::Client.new(api_key: API_KEY) }

  it 'has an api key' do
    expect(client.api_key).to eq(API_KEY)
  end
end
