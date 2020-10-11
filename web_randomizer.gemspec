# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'web_randomizer'
  s.version     = '0.2.0'
  s.date        = '2020-10-11'
  s.summary     = 'WebRandomizer - gem for randomizing div classes and color styles for static sites'
  s.description = 'Gem for randomizing div classes and color styles for static sites.'
  s.author      = 'Timur Sobolev'
  s.email       = 'timur.sobolev@gmail.com'
  s.homepage    = 'https://github.com/sobolevtimur/web-randomizer'
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")
  s.add_dependency('yaml')
end
