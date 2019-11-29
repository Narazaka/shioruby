# coding: utf-8
lib = File.expand_path('../lib', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "shioruby"
  spec.version       = "0.0.3"
  spec.authors       = ["Narazaka"]
  spec.email         = ["info@narazaka.net"]

  spec.summary       = %q{SHIORI Protocol Parser / Builder}
  spec.description   = %q{Ukagaka SHIORI Protocol Request Parser / Response Builder}
  spec.homepage      = "https://github.com/Narazaka/shioruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.metadata["yard.run"] = "yri"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", "~> 13"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "simplecov", "~> 0.17"
  spec.add_development_dependency "codecov", "~>0.1"
end
