# encoding: utf-8
require File.expand_path('../lib/tradehill/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'faraday', '~> 0.7'
  gem.add_dependency 'faraday_middleware', '~> 0.7'
  gem.add_dependency 'multi_json', '~> 1.0'
  gem.add_development_dependency 'json'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdiscount'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'yard'
  gem.author      = "Erik Michaels-Ober"
  gem.description = %q{Ruby wrapper for the TradeHill API. TradeHill is a Bitcoin exchange that supports 26 currencies.}
  gem.email       = 'sferik@gmail.com'
  gem.files       = `git ls-files`.split("\n")
  gem.homepage    = 'https://github.com/sferik/tradehill'
  gem.name        = 'tradehill'
  gem.require_paths = ['lib']
  gem.summary     = %q{Ruby wrapper for the TradeHill API}
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version     = TradeHill::VERSION.dup
end
