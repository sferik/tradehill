# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tradehill/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'tradehill'
  gem.version     = TradeHill::VERSION
  gem.author      = "Erik Michaels-Ober"
  gem.email       = 'sferik@gmail.com'
  gem.homepage    = 'https://github.com/sferik/tradehill'
  gem.summary     = %q{Ruby wrapper for the TradeHill API}
  gem.description = %q{Ruby wrapper for the TradeHill API. TradeHill is a Bitcoin exchange that supports 26 currencies.}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.require_paths = ['lib']

  gem.add_development_dependency 'ZenTest', '~> 4.5'
  gem.add_development_dependency 'maruku', '~> 0.6'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'webmock', '~> 1.6'
  gem.add_development_dependency 'yard', '~> 0.7'

  gem.add_runtime_dependency 'faraday', '~> 0.6.1'
  gem.add_runtime_dependency 'faraday_middleware', '~> 0.6.3'
  gem.add_runtime_dependency 'hashie', '~> 1.0.0'
  gem.add_runtime_dependency 'multi_json', '~> 1.0.3'
  gem.add_runtime_dependency 'rash', '~> 0.3.0'
end
