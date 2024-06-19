# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

Gem::Specification.new do |spec|
  spec.name        = 'pronto-eslinter'
  spec.version     = '0.1.3'
  spec.authors     = ['Kristupas Gaidys', 'Ugnius Pacauskas', 'Andrius Prudnikovas']
  spec.email       = ['kristupas.gaidys@vinted.com', 'ugnius.pacauskas@vinted.com']
  spec.summary     = 'Eslint runner for Pronto'
  spec.description = 'Eslint runner for Pronto which generates code change suggestions based on eslint errors.'
  spec.homepage    = 'https://github.com/kristupas-g/pronto-eslinter'
  spec.license     = 'MIT'

  spec.files = Dir['lib/**/*', 'README.md', 'LICENSE']

  spec.required_ruby_version = '>= 3.0.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.require_paths = ['lib']
end
