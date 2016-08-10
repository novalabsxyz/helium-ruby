guard 'rspec', cmd: "bundle exec rspec" do
  # watch /lib/ files
  watch(%r{^lib/(.+).rb$}) do |m|
    "spec"
  end

  # watch /spec/ files
  watch(%r{^spec/(.+).rb$}) do |m|
    "spec/#{m[1]}.rb"
  end
end
