# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tax_code/version'

Gem::Specification.new do |gem|
  gem.name          = 'tax_code'
  gem.version       = TaxCode::VERSION
  gem.authors       = ['Eugene Kalenkovich']
  gem.email         = ['rubify@softover.com']
  gem.description   = 'TaxCode scans git commit history and calculates maintenance tax for each file'
  gem.summary       = 'Calculates maintenance taxes for your git repo'
  gem.homepage      = 'https://github.com/UncleGene/tax_code'
  gem.license       = 'MIT' 

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
