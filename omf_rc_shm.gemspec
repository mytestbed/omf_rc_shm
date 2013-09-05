# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omf_rc_shm/version'

Gem::Specification.new do |spec|
  spec.name          = "omf_rc_shm"
  spec.version       = OmfRcShm::VERSION
  spec.authors     = ["NICTA"]
  spec.email       = ["omf-user@lists.nicta.com.au"]
  spec.summary       = "OMF resource proxy extension for SHM project"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "omf_rc", "~> 6.0.5"
  spec.add_runtime_dependency "json-jwt"
  spec.add_runtime_dependency "cronedit"
  spec.add_runtime_dependency "listen"
end
