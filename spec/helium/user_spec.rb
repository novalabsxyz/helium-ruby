require 'spec_helper'

describe Helium::User, '#to_json' do
  let(:client) { instance_double(Helium::Client) }
  let(:user) { described_class.new(client: client, params: USER_PARAMS) }

  it 'is a JSON-encoded string representing the user' do
    decoded_json = JSON.parse(user.to_json)
    expect(decoded_json["id"]).to eq(user.id)
    expect(decoded_json["name"]).to eq(user.name)
    expect(decoded_json["type"]).to eq(user.type)
    expect(decoded_json["email"]).to eq(user.email)
  end
end
