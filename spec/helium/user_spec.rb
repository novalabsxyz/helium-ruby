require 'spec_helper'

describe Helium::User do
  let(:client) { Helium::Client.new(api_key: API_KEY) }

  context 'Client#user' do
    let(:user) { client.user }

    use_cassette 'user/get'

    it 'returns a user object' do
      expect(user).to be_a(Helium::User)
    end

    it 'has an id' do
      expect(user.id).to eq('dev-accounts@helium.co')
    end

    it 'has a name' do
      expect(user.name).to eq('HeliumDevAccount Demo')
    end

    it 'has an email' do
      expect(user.email).to eq('dev-accounts@helium.co')
    end

    it 'has a created_at datetime' do
      expect(user.created_at).to eq(DateTime.parse("2014-10-29T21:38:52Z"))
    end

    it 'has an updated_at datetime' do
      expect(user.updated_at).to eq(DateTime.parse("2015-08-06T18:21:32.186374Z"))
    end
  end
end
