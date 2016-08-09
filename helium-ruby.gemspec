# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'helium/version'

Gem::Specification.new do |spec|
  spec.name          = "helium-ruby"
  spec.version       = Helium::VERSION
  spec.authors       = ["Andrew Allen"]
  spec.email         = ["allenan@helium.com"]

  spec.summary       = %q{A Ruby gem for building applications with the Helium API}
  spec.description   = %q{A Ruby gem for building applications with the Helium API}
  spec.homepage      = "https://github.com/helium/helium-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "typhoeus", "~> 1.1.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 3.0.3"
  spec.add_development_dependency "coveralls", "~> 0.8.2"
  spec.add_development_dependency "pry", "~> 0.10.4"
  spec.add_development_dependency "awesome_print", "~> 1.7.0"
end
