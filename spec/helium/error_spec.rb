require 'spec_helper'

describe Helium::Error, '.from_response' do
  context 'when code is undefined' do
    let(:body) {
      JSON.generate({
        errors: [
          {
            detail: 'Something crazy happened'
          }
        ]
      })
    }
    let(:response) { instance_double(Typhoeus::Response, code: '600', body: body) }

    it 'returns an instance of Error' do
      expect(Helium::Error.from_response(response)).to be_a(Helium::Error)
    end
  end

  context 'when response body is empty' do
    let(:response) { instance_double(Typhoeus::Response, code: '600', body: '') }

    it 'returns an instance of Error' do
      expect(Helium::Error.from_response(response)).to be_a(Helium::Error)
    end
  end
end
