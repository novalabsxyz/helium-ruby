require 'spec_helper'

describe Helium::Organization, '#to_json' do
  let(:client) { instance_double(Helium::Client) }
  let(:org) { described_class.new(client: client, params: ORG_PARAMS) }

  it 'is a JSON-encoded string representing the user' do
    decoded_json = JSON.parse(org.to_json)
    expect(decoded_json["id"]).to eq(org.id)
    expect(decoded_json["name"]).to eq(org.name)
  end
end
