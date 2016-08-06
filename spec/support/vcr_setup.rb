VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :typhoeus
  c.filter_sensitive_data('<API KEY>') { ENV['HELIUM_API_KEY'] }
end
