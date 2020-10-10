$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'web_randomizer'
  s.version     = '0.1.0'
  s.date        = '2020-10-10'
  s.summary     = 'WebRandomizer - gem for randomizing div classes and color styles for static sites'
  s.description = 'Gem for randomizing div classes and color styles for static sites.'
  s.author      = 'Timur Sobolev'
  s.email       = 'timur.sobolev@gmail.com'
  s.homepage    = 'https://github.com/TEFlash/web-randomizer'
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")
  s.add_dependency('yaml')
end