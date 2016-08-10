module Helpers
  def use_cassette(name)
    around(:each) do |spec|
      VCR.use_cassette name do
        spec.run
      end
    end
  end
end
