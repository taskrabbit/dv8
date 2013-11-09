# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dv8/version'

Gem::Specification.new do |gem|
  gem.name          = "dv8"
  gem.version       = Dv8::VERSION
  gem.authors       = ["Mike Nelson"]
  gem.email         = ["mike@mikeonrails.com"]
  gem.description   = %q{DV8 provides a low level cache layer using Rails.cache that keeps a copy of each record found}
  gem.summary       = %q{Low level activerecord cache layer}
  gem.homepage      = "http://www.github.com/taskrabbit/dv8"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activerecord', '>= 4.0.0'
end
