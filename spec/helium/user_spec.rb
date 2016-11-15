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

describe Helium::User, '#update' do
  let(:client) { Helium::Client.new(api_key: API_KEY) }
  let(:user) { client.user }

  use_cassette 'user/update'

  it 'updates a username and sets it back' do
    new_name = "Ruby Test Name"
    old_name = user.name
    updated_user = user.update(name: new_name)
    expect(updated_user.name).to eq(new_name)
    # Set it back
    updated_user = user.update(name: old_name)
    expect(updated_user.name).to eq(old_name)
  end
end
