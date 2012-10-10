# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rbNFA/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Łukasz Dubiel"]
  gem.email         = ["bambucha14@gmail.com"]
  gem.description   = "Thomson NFA regexp algorithm"
  gem.summary       = "Regular rexpresion"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rbNFA"
  gem.require_paths = ["lib"]
  gem.version       = RbNFA::VERSION
end
