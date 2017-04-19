module Helpers
  def use_cassette(name)
    around(:each) do |spec|
      VCR.use_cassette(name, :allow_playback_repeats => true) do
        spec.run
      end
    end
  end
end
