Gem::Specification.new do |s|
  s.name          = 'kele'
  s.version       = '0.0.2'
  s.date          = '2016-06-30'
  s.summary       = 'Kele API Client'
  s.description   = 'A client for the Bloc API'
  s.authors       = ['Igor Irianto']
  s.email         = 'igoririanto@rocketmail.com'
  s.files         = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.homepage      =
    'http://rubygems.org/gems/kele'
  s.license       = 'MIT'
  s.add_runtime_dependency 'httparty', '~> 0.13'
end
